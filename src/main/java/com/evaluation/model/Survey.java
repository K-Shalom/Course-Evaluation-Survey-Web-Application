package com.evaluation.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Survey {

    public enum Status   { DRAFT, ACTIVE, CLOSED, ARCHIVED }
    public enum AccessType { AUTHENTICATED, GUEST, BOTH }

    private int id;
    private String title;
    private String description;
    private int courseId;
    private Course course;
    private int createdBy;
    private User creator;
    private Status status;
    private AccessType accessType;
    private boolean requireEmail;
    private boolean sendConfirmation;
    private boolean allowAnonymous;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private List<SurveyQuestion> questions = new ArrayList<>();
    private int responseCount;
    private int questionCount;

    public Survey() {
        this.status = Status.DRAFT;
        this.accessType = AccessType.BOTH;
        this.requireEmail = true;
        this.sendConfirmation = true;
        this.allowAnonymous = false;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public User getCreator() { return creator; }
    public void setCreator(User creator) { this.creator = creator; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public AccessType getAccessType() { return accessType; }
    public void setAccessType(AccessType accessType) { this.accessType = accessType; }

    public boolean isRequireEmail() { return requireEmail; }
    public void setRequireEmail(boolean requireEmail) { this.requireEmail = requireEmail; }

    public boolean isSendConfirmation() { return sendConfirmation; }
    public void setSendConfirmation(boolean sendConfirmation) { this.sendConfirmation = sendConfirmation; }

    public boolean isAllowAnonymous() { return allowAnonymous; }
    public void setAllowAnonymous(boolean allowAnonymous) { this.allowAnonymous = allowAnonymous; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public List<SurveyQuestion> getQuestions() { return questions; }
    public void setQuestions(List<SurveyQuestion> questions) { this.questions = questions; }

    public int getResponseCount() { return responseCount; }
    public void setResponseCount(int responseCount) { this.responseCount = responseCount; }

    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }

    public boolean isActive()   { return Status.ACTIVE.equals(status); }
    public boolean isDraft()    { return Status.DRAFT.equals(status); }
    public boolean isClosed()   { return Status.CLOSED.equals(status); }

    public boolean isOpen() {
        if (!isActive()) return false;
        LocalDateTime now = LocalDateTime.now();
        if (startDate != null && now.isBefore(startDate)) return false;
        if (endDate   != null && now.isAfter(endDate))    return false;
        return true;
    }
}
