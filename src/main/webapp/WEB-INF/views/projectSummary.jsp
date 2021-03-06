<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="inspector" tagdir="/WEB-INF/tags/inspector" %>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table" %>

<%-- Breadcrumb for navigation --%>
<%-- PRIDE > PRIDE Archive > Accession--%>
<div class="grid_23 clearfix">
    <nav id="breadcrumb">
        <p>
            <spring:url var="prideUrl" value="//www.ebi.ac.uk/pride"/>
            <spring:url var="priderUrl" value="/"/>
            <a href="${prideUrl}"><fmt:message key="pride"/></a> &gt; <a href="${priderUrl}"><fmt:message
                key="prider"/></a>
            &gt; ${projectSummary.accession}
        </p>
    </nav>
</div>

<%-- Project header including accession and download options--%>
<div class="grid_23 clearfix project-title">
    <div class="grid_18 alpha">
        <h2><fmt:message key="project"/> ${projectSummary.accession}
            <c:if test="${fn:containsIgnoreCase(projectSummary.submissionType, 'COMPLETE')}">
                <spring:url var="searchCompleteSubmissionUrl"
                            value="/simpleSearch?q=&submissionTypeFilters={submissionTypeFilter}">
                    <spring:param name="submissionTypeFilter" value="COMPLETE"/>
                </spring:url>
                <a title="Complete Submission" style="font-size: smaller" class="icon icon-functional no_visual_link" data-icon="/" href="${searchCompleteSubmissionUrl}"></a>
            </c:if>
        </h2>

        <%-- pride internal tags--%>
        <c:if test="${not empty projectSummary.internalTags or projectSummary.highlighted == true}">
            <div style="display: block">
                <h6 style="display: inline"><fmt:message key="project.pride.tag"/>:</h6>
                <c:if test="${not empty projectSummary.internalTags}">
                    <c:forEach var="internalTag" items="${projectSummary.internalTags}">
                        <spring:url var="searchTagUrl"
                                    value="/simpleSearch?q=&projectTagFilters={projectTagFilter}">
                            <spring:param name="tag" value="${internalTag.tag}"/>
                            <spring:param name="projectTagFilter" value="${internalTag.tag}"/>
                        </spring:url>

                    <a class="${fn:toLowerCase(internalTag.tag)}"
                             href="${searchTagUrl}">${internalTag.tag} <fmt:message key="project.dataset"/></a>
                    </c:forEach>
                </c:if>

                <c:if test="${projectSummary.highlighted == true}">
                    <spring:url var="searchTagUrl"
                                value="/simpleSearch?q=&projectTagFilters={projectTagFilter}">
                        <spring:param name="tag" value="Highlighted"/>
                        <spring:param name="projectTagFilter" value="Highlighted"/>
                    </spring:url>

                    <a class="highlighted" href="${searchTagUrl}"><fmt:message key="project.highlighted"/></a>
                </c:if>
            </div>
        </c:if>

        <%--parent project tags--%>
        <c:if test="${not empty projectSummary.parentProjectTags}">
            <div style="display: block">
                <h6 style="display: inline"><fmt:message key="project.parent.tag"/>:</h6>
                <c:forEach var="parentProjectTag" items="${projectSummary.parentProjectTags}">
                    <spring:url var="searchTagUrl"
                                value="/simpleSearch?q=&projectTagFilters={projectTagFilter}">
                        <spring:param name="tag" value="${parentProjectTag.tag}"/>
                        <spring:param name="projectTagFilter" value="${parentProjectTag.tag}"/>
                    </spring:url>

                    <a class="other" href="${searchTagUrl}">${parentProjectTag.tag}</a>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <div class="grid_6 omega right-justify">

        <!-- TODO: Move this to a jsp tag because it is common to project and assays -->
        <%-- download project files--%>
        <spring:url var="projectFileUrl" value="/projects/{accession}/files">
            <spring:param name="accession" value="${projectSummary.accession}"/>
        </spring:url>
        <fmt:message key="project.file.download.title" var="projectDownloadTitle"/>
        <h5>
            <a href="${projectFileUrl}" class="icon icon-functional" data-icon="=" title="${projectDownloadTitle}">
                ${projectDownloadTitle}
            </a>
        </h5>
        <c:if test="${fn:toLowerCase(projectSummary.submissionType) != 'partial'}">
            <c:choose>
                <c:when test="${projectSummary.indexProteinCount gt 0 and projectSummary.publicProject}">
                    <spring:url var="projectProteinsUrl" value="/projects/{accession}/proteins">
                        <spring:param name="accession" value="${projectSummary.accession}"/>
                    </spring:url>
                    <fmt:message key="project.proteins.table" var="projectProteinsTable"/>
                    <h5>
                        <a href="${projectProteinsUrl}" class="icon icon-functional" data-icon="4" title="${projectProteinsTable}">
                            ${projectProteinsTable}
                        </a>
                    </h5>
                </c:when>
                <c:otherwise>
                    <h5>
                        <span class="icon icon-functional disable" data-icon="4" title="Protein table currently not available">
                            <fmt:message key="project.proteins.table"/>
                        </span>
                    </h5>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${projectSummary.indexPsmCount gt 0 and projectSummary.publicProject}">
                    <spring:url var="projectPsmsUrl" value="/projects/{accession}/psms">
                        <spring:param name="accession" value="${projectSummary.accession}"/>
                    </spring:url>
                    <fmt:message key="project.psms.table" var="projectPsmTable"/>
                    <h5>
                        <a href="${projectPsmsUrl}" class="icon icon-functional" data-icon="4" title="${projectPsmTable}">
                            ${projectPsmTable}
                        </a>
                    </h5>
                </c:when>
                <c:otherwise>
                    <h5>
                        <span class="icon icon-functional disable" data-icon="4" title="PSM table currently not available">
                            <fmt:message key="project.psms.table"/>
                        </span>
                    </h5>
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${fn:toLowerCase(projectSummary.submissionType) != 'partial'}">
            <%-- open pride inspector --%>
            <fmt:message key="pride.inspector.title" var="inspectorTitle"/>
            <h5>
                <span id="inspector-confirm" class="inspector_window icon icon-functional" data-icon="1" title="${inspectorTitle}">
                     ${inspectorTitle}
                </span>
            </h5>
            <inspector:inspectorDialog accession="${projectSummary.accession}"/>
        </c:if>
    </div>
</div>

<div class="grid_23 project-summary">
<%-- Summary title--%>
<h4><fmt:message key="summary"/></h4>

<div class="grid_16 left-column">
    <%-- project title--%>
    <h5><fmt:message key="title"/></h5>

    <p>
        ${projectSummary.title}
    </p>

    <%-- project description --%>
    <h5><fmt:message key="project.description"/></h5>

    <p class="longtext">
        ${projectSummary.projectDescription}
    </p>

    <%-- sample processing protocol --%>
    <h5><fmt:message key="project.sample.processing.protocol"/></h5>
    <c:set var="sampleProcessingProtocol" value="${projectSummary.sampleProcessingProtocol}"/>
    <c:choose>
        <c:when test="${not fn:containsIgnoreCase(sampleProcessingProtocol, 'not available')}">
            <p class="longtext">
                    ${sampleProcessingProtocol}
            </p>
        </c:when>
        <c:otherwise>
            <c:set var="publications" value="${projectSummary.references}"/>
            <c:choose>
                <c:when test="${not empty publications}">
                    <p>
                        <fmt:message key="view.reference.detail"/> :
                        <c:forEach var="publication" items="${publications}">
                            <c:if test="${publication.pubmedId gt 0}">
                                <%-- pubmed url--%>
                            <spring:url var="pubmedIdUrl" value="http://europepmc.org/abstract/MED/{pubmedId}">
                                <spring:param name="pubmedId" value="${publication.pubmedId}"/>
                            </spring:url>

                            <a href="${pubmedIdUrl}" target="_blank">${publication.pubmedId}</a>
                            </c:if>
                            <c:if test="${publication.pubmedId eq 0}">
                                <%-- doi url--%>
                                <spring:url var="doiUrl" value="http://dx.doi.org/{doi}">
                                    <spring:param name="doi" value="${publication.doi}"/>
                                </spring:url>
                            <a href="${doiUrl}" target="_blank">${publication.doi}</a>
                            </c:if>
                        </c:forEach>
                    </p>
                </c:when>
                <c:otherwise>
                    <p><fmt:message key="not.available"/></p>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>

    <%-- data processing protocol --%>
    <h5><fmt:message key="project.data.processing.protocol"/></h5>
    <c:set var="dataProcessingProtocol" value="${projectSummary.dataProcessingProtocol}"/>
    <c:choose>
        <c:when test="${not fn:containsIgnoreCase(dataProcessingProtocol, 'not available')}">
            <p class="longtext">
                    ${dataProcessingProtocol}
            </p>
        </c:when>
        <c:otherwise>
            <c:set var="publications" value="${projectSummary.references}"/>
            <c:choose>
                <c:when test="${not empty publications}">
                    <p>
                        <fmt:message key="view.reference.detail"/> :
                        <c:forEach var="publication" items="${publications}">
                            <c:if test="${publication.pubmedId gt 0}">
                                <%-- pubmed url--%>
                                <spring:url var="pubmedIdUrl" value="http://europepmc.org/abstract/MED/{pubmedId}">
                                    <spring:param name="pubmedId" value="${publication.pubmedId}"/>
                                </spring:url>

                                <a href="${pubmedIdUrl}" target="_blank">${publication.pubmedId}</a>
                            </c:if>
                            <c:if test="${publication.pubmedId eq 0}">
                                <%-- doi url--%>
                                <spring:url var="doiUrl" value="http://dx.doi.org/{doi}">
                                    <spring:param name="doi" value="${publication.doi}"/>
                                </spring:url>
                                <a href="${doiUrl}" target="_blank">${publication.doi}</a>
                            </c:if>
                        </c:forEach>
                    </p>
                </c:when>
                <c:otherwise>
                    <p><fmt:message key="not.available"/></p>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>

    <%-- submitter contact and lab heads --%>
    <h5><fmt:message key="contact"/></h5>

    <p>
        <%-- submitter --%>
        <a href="mailto:${projectSummary.submitter.email}">${projectSummary.submitter.firstName} ${projectSummary.submitter.lastName}</a>, ${projectSummary.submitter.affiliation}

        <%-- lab heads --%>
        <c:if test="${not empty projectSummary.labHeads}">
            <c:forEach var="labHead" items="${projectSummary.labHeads}">
                <br/>
                <a href="mailto:${labHead.email}">${labHead.firstName} ${labHead.lastName}</a>, ${labHead.affiliation} (
                <fmt:message key="project.labhead"/> )
            </c:forEach>
        </c:if>
    </p>

    <%-- submission date --%>
    <h5><fmt:message key="submission.date"/></h5>

    <p>
        <fmt:formatDate value="${projectSummary.submissionDate}" pattern="dd/MM/yyyy"/>
    </p>

    <%-- publication date --%>
    <h5><fmt:message key="publication.date"/></h5>

    <p>
        <fmt:formatDate value="${projectSummary.publicationDate}" pattern="dd/MM/yyyy"/>
    </p>

    <%-- other omics link --%>
    <c:if test="${not empty projectSummary.otherOmicsLink}">
    <h5><fmt:message key="otheromicslinks"/></h5>
    <p>
        <c:forTokens items="${projectSummary.otherOmicsLink}" delims="," var="otheromics" varStatus="otheromicsloopstatus">
            <c:set var = "otheromics" value = "${fn:trim(otheromics)}" />
            <c:choose>
                <c:when test="${fn:startsWith(otheromics, 'GSE') || fn:startsWith(otheromics, 'GPL')}">
                    <a href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=${otheromics}">${otheromics}</a> (GEO, NCBI)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'E-MTAB')}">
                    <a href="http://www.ebi.ac.uk/arrayexpress/experiments/${otheromics}/">${otheromics}</a> (ArrayExpress, EMBL-EBI)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'IM-')}">
                    <a href="http://www.ebi.ac.uk/intact/imex/main.xhtml?query=${otheromics}">${otheromics}</a> (IntAct, IMEx)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'PXD')}">
                    <a href="http://proteomecentral.proteomexchange.org/cgi/GetDataset?ID=${otheromics}">${otheromics}</a> (ProteomeXchange)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'SRP') || fn:startsWith(otheromics, 'SRX')}">
                    <a href="http://www.ebi.ac.uk/ena/data/view/${otheromics}">${otheromics}</a> (Sequence Read Archive, ENA, EMBL-EBI)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'PRJN')}">
                    <a href="http://www.ebi.ac.uk/ena/data/view/${otheromics}">${otheromics}</a> (BioProject, ENA, EMBL-EBI)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'SAME') || fn:startsWith(otheromics, 'PRJ')}">
                    <a href="http://www.ebi.ac.uk/ena/data/view/${otheromics}">${otheromics}</a> (ENA, EMBL-EBI)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'mgm')}">
                    <a href="http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=${otheromics}">${otheromics}</a> (MG-RAST)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'PASS')}">
                    <a href="http://www.peptideatlas.org/PASS/${otheromics}">${otheromics}</a> (PeptideAtlas)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'MSV')}">
                    <a href="http://massive.ucsd.edu/ProteoSAFe/datasets.jsp#%7B%22main.dataset_input%22%3A%22${otheromics}%22%7D">${otheromics}</a> (MassIVE)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'Gs')}">
                    <a href="https://gold.jgi.doe.gov/study?id=${otheromics}">${otheromics}</a> (Genomes OnLine Database)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'GCA') || fn:startsWith(otheromics, 'GCF')}">
                    <a href="https://www.ncbi.nlm.nih.gov/assembly/${otheromics}">${otheromics}</a> (Assembly, NCBI)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'IMG/ER-genome:')}">
                    <a href="https://img.jgi.doe.gov/cgi-bin/m/main.cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=${fn:substring(otheromics, 14, fn:length(otheromics))}">${fn:substring(otheromics, 14, fn:length(otheromics))}</a> (Integrated Microbial Genomes)
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'http')}">
                    <a href="${otheromics}">${otheromics}</a>
                </c:when>
                <c:when test="${fn:startsWith(otheromics, 'PPV')}">
                    <%-- Do nothing, see MS-Viewer section below --%>
                </c:when>
                <c:otherwise>
                    ${otheromics}
                </c:otherwise>
            </c:choose>
            <c:if test="${!otheromicsloopstatus.last && !fn:startsWith(otheromics, 'PPV')}">
                <br />
            </c:if>
        </c:forTokens>
    </p>
    </c:if>
    <%-- MS-Viewer links --%>
    <c:if test="${not empty projectSummary.otherOmicsLink && fn:contains(projectSummary.otherOmicsLink, 'PPV')}">
        <h5><fmt:message key="visualizationlinks"/></h5>
        <p>
        <c:forTokens items="${projectSummary.otherOmicsLink}" delims="," var="otheromicslinks" varStatus="ootheromicslinksloopstatus">
        <c:set var = "otheromicslinks" value = "${fn:trim(otheromicslinks)}" />
            <c:choose>
                <c:when test="${fn:startsWith(otheromicslinks, 'PPV')}">
                    <a href="http://msviewer.ucsf.edu/prospector/cgi-bin/mssearch.cgi?search_name=msviewrep&report_title=MS-Viewer Repository&ms_viewer_accession=${otheromicslinks}">${otheromicslinks}</a> (MS-Viewer)
                    <c:if test="${!ootheromicslinksloopstatus.last}">
                        <br />
                    </c:if>
                </c:when>
                <c:otherwise>
                    <%-- Do nothing--%>
              </c:otherwise>
            </c:choose>
        </c:forTokens>
        </p>
    </c:if>
</div>

<div class="grid_7 right-column">

<div class="grid_24">
    <div class="grid_12 alpha">
        <c:set var="species" value="${projectSummary.species}"/>
        <h5><fmt:message key="species"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty species}">
                    <c:forEach var="singleSpecies" items="${species}">
                        <spring:url var="searchSpeciesUrl"
                                    value="/simpleSearch?q={species}">
                            <spring:param name="species" value="${singleSpecies.name}"/>
                        </spring:url>

                        <a href="${searchSpeciesUrl}">${singleSpecies.name}</a>
                        <br/>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="grid_12 omega clearfix">
        <c:set var="tissues" value="${projectSummary.tissues}"/>
        <h5><fmt:message key="tissue"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty tissues}">
                    <c:forEach var="tissue" items="${tissues}">
                        <spring:url var="searchTissueUrl"
                                    value="/simpleSearch?q={tissue}">
                            <spring:param name="tissue" value="${tissue.name}"/>
                        </spring:url>

                        <a href="${searchTissueUrl}">${tissue.name}</a>
                        <br/>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>
</div>


<div class="grid_24">
    <c:set var="cellTypes" value="${projectSummary.cellTypes}"/>
    <div class="grid_12 alpha">
        <c:if test="${not empty cellTypes}">
            <h5><fmt:message key="celltype"/></h5>

            <p>
                <c:forEach var="cellType" items="${cellTypes}">
                    <spring:url var="searchCellTypeUrl"
                                value="/simpleSearch?q={cellType}">
                        <spring:param name="cellType" value="${cellType.name}"/>
                    </spring:url>

                    <a href="${searchCellTypeUrl}">${cellType.name}</a>
                    <br/>
                </c:forEach>
            </p>
        </c:if>
    </div>


    <c:set var="diseases" value="${projectSummary.diseases}"/>
    <div class="grid_12 omega clearfix">
        <c:if test="${not empty diseases}">
            <h5><fmt:message key="disease"/></h5>

            <p>
                <c:forEach var="disease" items="${diseases}">
                    <spring:url var="searchDiseaseUrl"
                                value="/simpleSearch?q={disease}">
                        <spring:param name="disease" value="${disease.name}"/>
                    </spring:url>

                    <a href="${searchDiseaseUrl}">${disease.name}</a>
                    <br/>
                </c:forEach>
            </p>
        </c:if>
    </div>
</div>

<%-- Instruments --%>
<div class="grid_24">
    <div class="grid_12">
        <c:set var="instruments" value="${projectSummary.instruments}"/>
        <h5><fmt:message key="instrument"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty instruments}">
                    <c:forEach var="instrument" items="${instruments}">
                        <c:choose>
                            <c:when test="${empty instrument.value}">
                                <spring:url var="searchInstrumentUrl"
                                            value="/simpleSearch?q={instrument}">
                                    <spring:param name="instrument" value="${instrument.name}"/>
                                </spring:url>

                                <a href="${searchInstrumentUrl}">${instrument.name}</a>
                                <br/>
                            </c:when>
                            <c:otherwise>
                                <spring:url var="searchInstrumentUrl"
                                            value="/simpleSearch?q={instrument}">
                                    <spring:param name="instrument" value="${instrument.value}"/>
                                </spring:url>

                                <a href="${searchInstrumentUrl}">${instrument.value}</a>
                                <br/>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <%-- software --%>
    <div class="grid_12">
        <c:set var="software" value="${projectSummary.software}"/>
        <h5><fmt:message key="software"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty software}">
                    <c:forEach var="singleSoftware" items="${software}">
                        <c:choose>
                            <c:when test="${not fn:containsIgnoreCase(singleSoftware.value, 'unknown')}">
                                <spring:url var="searchSoftwareUrl"
                                            value="/simpleSearch?q={software}">
                                    <spring:param name="software" value="${singleSoftware.value}"/>
                                </spring:url>

                                <a href="${searchSoftwareUrl}">${singleSoftware.value}</a>
                                <br/>
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="unknown"/>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>
</div>

<%-- Modifications --%>
<div class="grid_24">
    <div class="grid_12">
        <c:set var="ptms" value="${projectSummary.ptms}"/>
        <h5><fmt:message key="modification"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty ptms}">
                    <c:forEach var="ptm" items="${ptms}">
                        <spring:url var="searchPTMUrl"
                                    value="/simpleSearch?q={ptm}">
                            <spring:param name="ptm" value="${ptm.name}"/>
                        </spring:url>

                        <a href="${searchPTMUrl}">${ptm.name}</a>
                        <br/>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <%-- quantification --%>
    <div class="grid_12">
        <c:set var="quantificationMethods" value="${projectSummary.quantificationMethods}"/>
        <h5><fmt:message key="quantification.method"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty quantificationMethods}">
                    <c:forEach var="quantificationMethod" items="${quantificationMethods}">
                        <spring:url var="searchQuantificationUrl"
                                    value="/simpleSearch?q={quantification}">
                            <spring:param name="quantification" value="${quantificationMethod.name}"/>
                        </spring:url>

                        <a href="${searchQuantificationUrl}">${quantificationMethod.name}</a>
                        <br/>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>
</div>

<div class="grid_24">
    <div class="grid_12">
        <c:set var="experimentTypes" value="${projectSummary.experimentTypes}"/>
        <h5><fmt:message key="experiment.type"/></h5>

        <p>
            <c:choose>
                <c:when test="${not empty experimentTypes}">
                    <c:forEach var="experimentType" items="${experimentTypes}">
                        <spring:url var="searchExperimentTypeUrl"
                                    value="/simpleSearch?q={experimentType}">
                            <spring:param name="experimentType" value="${experimentType.name}"/>
                        </spring:url>

                        <a href="${searchExperimentTypeUrl}">${experimentType.name}</a>
                        <br/>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <fmt:message key="not.available"/>
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="grid_12">
        <c:if test="${not empty page.content}">
            <h5><fmt:message key="assay.number"/></h5>

            <p>
                <a href="#assays">${page.totalElements}</a>
            </p>
        </c:if>
    </div>
</div>
</div>
</div>

<%-- publications --%>
<div class="grid_23 clearfix publication">
    <h4><fmt:message key="publication"/></h4>
    <c:set var="publications" value="${projectSummary.references}"/>
    <c:choose>
        <c:when test="${not empty publications}">
            <ul>
                <c:forEach var="publication" items="${publications}">
                    <c:if test="${publication.pubmedId gt 0}">
                        <%-- pubmed url--%>
                        <spring:url var="pubmedIdUrl" value="http://europepmc.org/abstract/MED/{pubmedId}">
                            <spring:param name="pubmedId" value="${publication.pubmedId}"/>
                        </spring:url>
                        <p>
                            ${publication.referenceLine}
                            PubMed: <a href="${pubmedIdUrl}" target="_blank">${publication.pubmedId}</a>
                        </p>
                    </c:if>
                    <c:if test="${publication.pubmedId eq 0}">
                        <%-- doi url--%>
                        <spring:url var="doiUrl" value="http://dx.doi.org/{doi}">
                            <spring:param name="doi" value="${publication.doi}"/>
                        </spring:url>
                        <p>
                            No PubMed ID is available for this publication since this journal is not indexed in PubMed. However, a DOI is provided:
                            <a href="${doiUrl}" target="_blank">${publication.doi}</a>
                        </p>
                    </c:if>
                </c:forEach>
            </ul>
        </c:when>
        <c:otherwise>
            <fmt:message key="publication.pending"/>
        </c:otherwise>
    </c:choose>
</div>

<%-- assay summaries --%>
<c:if test="${not empty page.content}">
    <div id="assays" class="grid_23 clearfix assay">
        <h4><fmt:message key="assay.list.title"/></h4>


        <table:paginator page="${page}"/>
        <table id="assayTable" class="summary-table footable table">
            <thead>
            <tr>
                <th><strong>#</strong></th>
                <th>
                    <fmt:message key="assay.accession"/>
                </th>
                <th>
                    <fmt:message key="assay.title"/>
                </th>
                <th>
                    <fmt:message key="assay.protein.count"/>
                </th>
                <th>
                    <fmt:message key="assay.peptide.count"/>
                </th>
                <th>
                    <fmt:message key="assay.unique.peptide.count"/>
                </th>
                <th>
                    <fmt:message key="assay.spectrum.count"/>
                </th>
                <th>
                    <fmt:message key="assay.identified.spectrum.count"/>
                </th>
                <th>
                    <fmt:message key="assay.reactome.link"/>
                </th>
            </tr>
            </thead>
            <tbody>
            <c:set var="first" value="${page.size * page.number}"/>
            <c:forEach var="assay" items="${page.content}" varStatus="status">
                <tr>
                    <td style="white-space: nowrap;">${first + status.count}</td>
                    <td>
                        <spring:url var="showUrl" value="/projects/{projectAccession}/assays/{assayAccession}">
                            <spring:param name="projectAccession" value="${projectSummary.accession}"/>
                            <spring:param name="assayAccession" value="${assay.accession}"/>
                        </spring:url>
                        <a href="${showUrl}" class="icon icon-functional" data-icon="4">${assay.accession}</a>
                    </td>
                    <td>
                        ${assay.title}
                    </td>
                    <td>
                        ${assay.proteinCount}
                    </td>
                    <td>
                        ${assay.peptideCount}
                    </td>
                    <td>
                        ${assay.uniquePeptideCount}
                    </td>
                    <td>
                        ${assay.totalSpectrumCount}
                    </td>
                    <td>
                        ${assay.identifiedSpectrumCount}
                    </td>
                    <td>
                        <div>
                            <c:choose>
                                <c:when test="${projectSummary.indexProteinCount gt 0 }">
                                    <button title="Analyse the protein set in Reactome" onclick="reactomeAnalysis(this,'${pageContext.request.contextPath}', ${assay.accession}, false)" class="reactome-analyse">
                                        Analyse
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button title="Protein set currently not available for analysis" class="reactome-analyse-disabled">
                                        Analyse
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <%--<reactome-analysis-url value="http://wwwdev.ebi.ac.uk/pride/ws/archive/protein/list/assay/${assay.accession}.acc" project="false" size="12"></reactome-analysis-url>--%>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>

<spring:url var="readMoreJavascriptUrl" value="/resources/javascript/readmore.min.js"/>
<script src="${readMoreJavascriptUrl}"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $(".longtext").readmore({
            maxHeight: 100,
            moreLink: '<p> <a href="#">Read more</a></p>',
            lessLink: '<p> <a href="#">Close</a> </p>'
        });
    });
</script>
