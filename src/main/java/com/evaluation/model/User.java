package com.evaluation.model;

import java.time.LocalDateTime;

public class User {

    public enum Status { PENDING, ACTIVE, REJECTED, SUSPENDED }

    private int id;
    private String username;
    private String email;
    private String password;
    private String firstName;
    private String lastName;
    private int roleId;
    private Role role;
    private Status status;
    private boolean emailVerified;
    private String verificationToken;
    private LocalDateTime tokenExpiry;
    private String resetToken;
    private LocalDateTime resetTokenExpiry;
    private String profileImage;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient fields for forms
    private String confirmPassword;

    public User() {}

    // ======= Getters & Setters =======

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getFullName() {
        return (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
    }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public boolean isEmailVerified() { return emailVerified; }
    public void setEmailVerified(boolean emailVerified) { this.emailVerified = emailVerified; }

    public String getVerificationToken() { return verificationToken; }
    public void setVerificationToken(String verificationToken) { this.verificationToken = verificationToken; }

    public LocalDateTime getTokenExpiry() { return tokenExpiry; }
    public void setTokenExpiry(LocalDateTime tokenExpiry) { this.tokenExpiry = tokenExpiry; }

    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }

    public LocalDateTime getResetTokenExpiry() { return resetTokenExpiry; }
    public void setResetTokenExpiry(LocalDateTime resetTokenExpiry) { this.resetTokenExpiry = resetTokenExpiry; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    public boolean isAdmin()       { return role != null && "ADMIN".equals(role.getName()); }
    public boolean isInitiator()   { return role != null && "INITIATOR".equals(role.getName()); }
    public boolean isTeacher()     { return role != null && "TEACHER".equals(role.getName()); }
    public boolean isRespondent()  { return role != null && "RESPONDENT".equals(role.getName()); }
    public boolean isActive()      { return Status.ACTIVE.equals(status); }
    public boolean isPending()     { return Status.PENDING.equals(status); }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', email='" + email + "', status=" + status + "}";
    }
}
