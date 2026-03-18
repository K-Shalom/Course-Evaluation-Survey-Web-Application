package com.evaluation.model;

import java.time.LocalDateTime;

/**
 * Maps to the `teachers` table.
 * Represents the assignment of a teacher (User with role=TEACHER)
 * to a Course, managed by the Administrator.
 */
public class Teacher {

    private int           id;
    private int           userId;
    private User          user;
    private int           courseId;
    private Course        course;
    private LocalDateTime assignedAt;
    private int           assignedBy;
    private User          assignedByUser;

    public Teacher() {}

    public int  getId()           { return id; }
    public void setId(int id)     { this.id = id; }

    public int  getUserId()               { return userId; }
    public void setUserId(int userId)     { this.userId = userId; }

    public User getUser()                 { return user; }
    public void setUser(User user)        { this.user = user; }

    public int  getCourseId()             { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public Course getCourse()             { return course; }
    public void   setCourse(Course course){ this.course = course; }

    public LocalDateTime getAssignedAt()                          { return assignedAt; }
    public void          setAssignedAt(LocalDateTime assignedAt)  { this.assignedAt = assignedAt; }

    public int  getAssignedBy()               { return assignedBy; }
    public void setAssignedBy(int assignedBy) { this.assignedBy = assignedBy; }

    public User getAssignedByUser()                       { return assignedByUser; }
    public void setAssignedByUser(User assignedByUser)    { this.assignedByUser = assignedByUser; }
}
