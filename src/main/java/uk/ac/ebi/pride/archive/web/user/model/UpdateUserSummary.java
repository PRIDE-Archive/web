package uk.ac.ebi.pride.archive.web.user.model;

import uk.ac.ebi.pride.archive.dataprovider.person.UserAuthority;
import uk.ac.ebi.pride.archive.repo.user.service.UserSummary;

import java.util.HashSet;

/**
 * Models an updated user summary.
 */
public class UpdateUserSummary extends UserSummary {

    private String existingEmail;
    private String existingPassword;

    /**
     * This constructor is needed by spring framework
     */
    public UpdateUserSummary() {
    }

    /**
     * Constructor, based of an existing user summary.
     * @param userSummary the user summary to update with
     */
    public UpdateUserSummary(UserSummary userSummary) {
        this.setId(userSummary.getId());
        this.setEmail(userSummary.getEmail());
        this.setExistingEmail(userSummary.getEmail());
        this.setPassword(userSummary.getPassword());
        this.setTitle(userSummary.getTitle());
        this.setFirstName(userSummary.getFirstName());
        this.setLastName(userSummary.getLastName());
        this.setAffiliation(userSummary.getAffiliation());
        this.setCreateAt(userSummary.getCreateAt());
        this.setUpdateAt(userSummary.getUpdateAt());
        this.setUserAuthorities(new HashSet<>(userSummary.getUserAuthorities()));
        this.setCountry(userSummary.getCountry());
        this.setOrcid(userSummary.getOrcid());
        this.setAcceptedTermsOfUse(userSummary.getAcceptedTermsOfUse());
    }

    public String getExistingEmail() {
        return existingEmail;
    }

    public void setExistingEmail(String existingEmail) {
        this.existingEmail = existingEmail;
    }

    public String getExistingPassword() {
        return existingPassword;
    }

    public void setExistingPassword(String existingPassword) {
        this.existingPassword = existingPassword;
    }
}
