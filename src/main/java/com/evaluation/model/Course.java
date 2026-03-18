package com.evaluation.model;

import java.time.LocalDateTime;

public class Course {
    private int id;
    private String code;
    private String name;
    private String description;
    private int credits;
    private String department;
    private boolean active;
    private int createdBy;
    private User creator;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // transient helper
    private int teacherCount;
    private int surveyCount;

    public Course() { this.credits = 3; this.active = true; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public User getCreator() { return creator; }
    public void setCreator(User creator) { this.creator = creator; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public int getTeacherCount() { return teacherCount; }
    public void setTeacherCount(int teacherCount) { this.teacherCount = teacherCount; }

    public int getSurveyCount() { return surveyCount; }
    public void setSurveyCount(int surveyCount) { this.surveyCount = surveyCount; }
}
