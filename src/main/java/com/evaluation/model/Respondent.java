package com.evaluation.model;

import java.time.LocalDateTime;

/**
 * Maps to the `respondents` table.
 * A respondent is either:
 *   - an authenticated STUDENT (user_id is set)
 *   - a GUEST who provided an email (user_id is null)
 */
public class Respondent {

    public enum RespondentType { STUDENT, GUEST }

    private int            id;
    private Integer        userId;       // null for guests
    private User           user;
    private String         email;
    private String         displayName;
    private RespondentType respondentType;
    private LocalDateTime  createdAt;

    public Respondent() {
        this.respondentType = RespondentType.GUEST;
    }

    public int           getId()                      { return id; }
    public void          setId(int id)                { this.id = id; }

    public Integer       getUserId()                  { return userId; }
    public void          setUserId(Integer userId)    { this.userId = userId; }

    public User          getUser()                    { return user; }
    public void          setUser(User user)           { this.user = user; }

    public String        getEmail()                   { return email; }
    public void          setEmail(String email)       { this.email = email; }

    public String        getDisplayName()                    { return displayName; }
    public void          setDisplayName(String displayName)  { this.displayName = displayName; }

    public RespondentType getRespondentType()                            { return respondentType; }
    public void           setRespondentType(RespondentType respondentType){ this.respondentType = respondentType; }

    public LocalDateTime getCreatedAt()                       { return createdAt; }
    public void          setCreatedAt(LocalDateTime createdAt){ this.createdAt = createdAt; }

    public boolean isGuest()   { return RespondentType.GUEST.equals(respondentType); }
    public boolean isStudent() { return RespondentType.STUDENT.equals(respondentType); }

    /** Returns the best display name available */
    public String getEffectiveDisplayName() {
        if (user != null && user.getFullName() != null && !user.getFullName().isBlank()) {
            return user.getFullName();
        }
        if (displayName != null && !displayName.isBlank()) return displayName;
        if (email != null && !email.isBlank()) return email;
        return "Anonymous";
    }
}
