package uk.ac.ebi.pride.archive.web.assay.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import uk.ac.ebi.pride.archive.repo.assay.service.AssayService;
import uk.ac.ebi.pride.archive.repo.assay.service.AssaySummary;
import uk.ac.ebi.pride.archive.repo.file.service.FileService;
import uk.ac.ebi.pride.archive.repo.file.service.FileSummary;
import uk.ac.ebi.pride.archive.repo.project.service.ProjectService;
import uk.ac.ebi.pride.archive.repo.project.service.ProjectSummary;
import uk.ac.ebi.pride.archive.security.protein.ProteinIdentificationSecureSearchService;
import uk.ac.ebi.pride.archive.security.psm.PsmSecureSearchService;
import uk.ac.ebi.pride.archive.web.util.PageMaker;
import uk.ac.ebi.pride.archive.web.util.filter.EntityFilter;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

/**
 * @author Rui Wang
 * @author Jose A. Dianes
 * @version $Id$
 */
@Controller
public class AssaySummaryController {

    private static final Logger logger = LoggerFactory.getLogger(AssaySummaryController.class);

    @Autowired
    private AssayService assayServiceImpl;

    @Autowired
    private ProjectService projectServiceImpl;

    @Autowired
    private FileService fileServiceImpl;

    @Autowired
    private EntityFilter<AssaySummary> removeAssayDuplicateCvParamFilter;

    @Autowired
    private PageMaker pageMaker;

    @Autowired
    private ProteinIdentificationSecureSearchService proteinIdentificationSearchService;

    @Autowired
    private PsmSecureSearchService psmSecureSearchService;


    // ToDo: add sensible mapping for /assays

    @RequestMapping(value = "/assays/{assayAccession}", method = RequestMethod.GET)
    public ModelAndView getAssaySummary(@PathVariable String assayAccession) {
        logger.info("Direct assay access. Redirecting...");
        String projectAccession = getString(assayAccession);
        return new ModelAndView("redirect:/projects/" + projectAccession + "/assays/" + assayAccession);
    }

    @RequestMapping(value = "/projects/{projectAccession}/assays", method = RequestMethod.GET)
    public ModelAndView getProjectAssayRedirect(@PathVariable String projectAccession) {
        return new ModelAndView("redirect:/projects/" + projectAccession);
    }

    /**
     * Gets the project assay summary.
     * Uses default indexProteinCount and indexPsmCount 0 values in case we cannot retrieve real numbers from the Solr server.
     * We can still generate a project summary page, even if the protein/psm queries don't work,
     * the page will have to deal with the case that no protein/psm data is present
     * @param assayAccession the assay accession
     * @param projectAccession the project accession
     * @return the assay summary
     */
    @RequestMapping(value = "/projects/{projectAccession}/assays/{assayAccession}", method = RequestMethod.GET)
    public ModelAndView getProjectAssaySummary(@PathVariable String assayAccession, @PathVariable String projectAccession) {
        AssaySummary summary = assayServiceImpl.findByAccession(assayAccession);
        Collection<AssaySummary> filteredAssays = removeAssayDuplicateCvParamFilter.filter(Collections.singletonList(summary)); // filter assay
        summary = filteredAssays.iterator().next();
        Long indexProteinCount = 0L;
        Long indexPsmCount = 0L;
        try {
            indexProteinCount = proteinIdentificationSearchService.countByAssayAccession(assayAccession);
            indexPsmCount = psmSecureSearchService.countByAssayAccession(assayAccession);
        } catch (Exception e) {
            logger.error("Exception executing Solr query: ", e);
        }
        ProjectSummary projectSummary  = projectServiceImpl.findById(summary.getProjectId());
        boolean publicAssay = projectSummary.isPublicProject(); // required by client
        return pageMaker.createAssaySummary(new AssaySummaryAdapter(summary, indexProteinCount, indexPsmCount, publicAssay), projectAccession);
    }

    @RequestMapping(value = "/assays/{assayAccession}/files", method = RequestMethod.GET)
    public ModelAndView getAssayFiles(@PathVariable String assayAccession) {
        logger.info("Direct assay files access. Redirecting...");
        String projectAccession = getString(assayAccession);
        return new ModelAndView("redirect:/projects/" + projectAccession + "/assays/" + assayAccession + "/files");
    }

    @RequestMapping(value = "/projects/{projectAccession}/assays/{assayAccession}/files", method = RequestMethod.GET)
    public ModelAndView getProjectAssayFiles(@PathVariable String assayAccession, @PathVariable String projectAccession) {
        // get the file list
        Collection<FileSummary> fileList = fileServiceImpl.findAllByAssayAccession(assayAccession);

        return pageMaker.createAssayFileDownloadPage(fileList, assayAccession, projectServiceImpl.findByAccession(projectAccession));
    }

    private String getString(String assayAccession) {
        // find the assay record to retrieve the project ID
        AssaySummary assaySummary = assayServiceImpl.findByAccession(assayAccession);
        // find the project record to retrieve the project accession
        ProjectSummary projectSummary = projectServiceImpl.findById(assaySummary.getProjectId());
        return projectSummary.getAccession();
    }


}
