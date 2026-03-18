package com.evaluation.dao;

import com.evaluation.model.User;
import com.evaluation.model.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;
import java.util.Optional;

@Repository
public class UserDao {

    @Autowired
    private JdbcTemplate jdbc;

    private final RowMapper<User> userMapper = (rs, rowNum) -> {
        User u = new User();
        u.setId(rs.getInt("u_id"));
        u.setUsername(rs.getString("u_username"));
        u.setEmail(rs.getString("u_email"));
        u.setPassword(rs.getString("u_password"));
        u.setFirstName(rs.getString("u_first_name"));
        u.setLastName(rs.getString("u_last_name"));
        u.setRoleId(rs.getInt("u_role_id"));
        String status = rs.getString("u_status");
        if (status != null) u.setStatus(User.Status.valueOf(status.toUpperCase()));
        u.setEmailVerified(rs.getBoolean("u_email_verified"));
        u.setVerificationToken(rs.getString("u_verification_token"));
        Timestamp tokenExpiry = rs.getTimestamp("u_token_expiry");
        if (tokenExpiry != null) u.setTokenExpiry(tokenExpiry.toLocalDateTime());
        u.setResetToken(rs.getString("u_reset_token"));
        Timestamp resetExpiry = rs.getTimestamp("u_reset_token_expiry");
        if (resetExpiry != null) u.setResetTokenExpiry(resetExpiry.toLocalDateTime());
        Timestamp createdAt = rs.getTimestamp("u_created_at");
        if (createdAt != null) u.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("u_updated_at");
        if (updatedAt != null) u.setUpdatedAt(updatedAt.toLocalDateTime());

        // Role
        Role role = new Role();
        role.setId(rs.getInt("r_id"));
        role.setName(rs.getString("r_name"));
        role.setDescription(rs.getString("r_description"));
        u.setRole(role);

        return u;
    };

    private static final String BASE_SELECT =
        "SELECT u.id u_id, u.username u_username, u.email u_email, " +
        "u.password u_password, u.first_name u_first_name, u.last_name u_last_name, " +
        "u.role_id u_role_id, u.status u_status, u.email_verified u_email_verified, " +
        "u.verification_token u_verification_token, u.token_expiry u_token_expiry, " +
        "u.reset_token u_reset_token, u.reset_token_expiry u_reset_token_expiry, " +
        "u.created_at u_created_at, u.updated_at u_updated_at, " +
        "r.id r_id, r.name r_name, r.description r_description " +
        "FROM users u JOIN roles r ON u.role_id = r.id ";

    // ── CREATE ─────────────────────────────────────────────────
    public int save(User user) {
        String sql = "INSERT INTO users (username, email, password, first_name, last_name, " +
                     "role_id, status, email_verified, verification_token, token_expiry) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFirstName());
            ps.setString(5, user.getLastName());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus() != null ? user.getStatus().name() : "PENDING");
            ps.setBoolean(8, user.isEmailVerified());
            ps.setString(9, user.getVerificationToken());
            if (user.getTokenExpiry() != null)
                ps.setTimestamp(10, Timestamp.valueOf(user.getTokenExpiry()));
            else ps.setNull(10, Types.TIMESTAMP);
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    // ── READ ───────────────────────────────────────────────────
    public Optional<User> findById(int id) {
        try {
            return Optional.ofNullable(
                jdbc.queryForObject(BASE_SELECT + "WHERE u.id = ?", userMapper, id));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public Optional<User> findByUsername(String username) {
        try {
            return Optional.ofNullable(
                jdbc.queryForObject(BASE_SELECT + "WHERE u.username = ?", userMapper, username));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public Optional<User> findByEmail(String email) {
        try {
            return Optional.ofNullable(
                jdbc.queryForObject(BASE_SELECT + "WHERE u.email = ?", userMapper, email));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public Optional<User> findByVerificationToken(String token) {
        try {
            return Optional.ofNullable(
                jdbc.queryForObject(BASE_SELECT + "WHERE u.verification_token = ?", userMapper, token));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public Optional<User> findByResetToken(String token) {
        try {
            return Optional.ofNullable(
                jdbc.queryForObject(BASE_SELECT + "WHERE u.reset_token = ?", userMapper, token));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public List<User> findAll() {
        return jdbc.query(BASE_SELECT + "ORDER BY u.created_at DESC", userMapper);
    }

    public List<User> findByRole(String roleName) {
        return jdbc.query(BASE_SELECT + "WHERE r.name = ? ORDER BY u.first_name", userMapper, roleName);
    }

    public List<User> findByRoleAndStatus(String roleName, String status) {
        return jdbc.query(BASE_SELECT + "WHERE r.name = ? AND u.status = ? ORDER BY u.first_name",
                userMapper, roleName, status);
    }

    public List<User> findPendingApprovals() {
        return jdbc.query(
            BASE_SELECT + "WHERE u.status = 'PENDING' AND r.name != 'ADMIN' ORDER BY u.created_at",
            userMapper);
    }

    // ── UPDATE ─────────────────────────────────────────────────
    public void update(User user) {
        jdbc.update("UPDATE users SET username=?, email=?, first_name=?, last_name=?, " +
                    "role_id=?, updated_at=NOW() WHERE id=?",
                user.getUsername(), user.getEmail(), user.getFirstName(),
                user.getLastName(), user.getRoleId(), user.getId());
    }

    public void updateStatus(int userId, String status) {
        jdbc.update("UPDATE users SET status=?, updated_at=NOW() WHERE id=?", status, userId);
    }

    public void updatePassword(int userId, String hashedPassword) {
        jdbc.update("UPDATE users SET password=?, reset_token=NULL, reset_token_expiry=NULL, " +
                    "updated_at=NOW() WHERE id=?", hashedPassword, userId);
    }

    public void verifyEmail(int userId) {
        jdbc.update("UPDATE users SET email_verified=1, verification_token=NULL, " +
                    "token_expiry=NULL, status='PENDING', updated_at=NOW() WHERE id=?", userId);
    }

    public void setVerificationToken(int userId, String token, Timestamp expiry) {
        jdbc.update("UPDATE users SET verification_token=?, token_expiry=?, updated_at=NOW() WHERE id=?",
                token, expiry, userId);
    }

    public void setResetToken(int userId, String token, Timestamp expiry) {
        jdbc.update("UPDATE users SET reset_token=?, reset_token_expiry=?, updated_at=NOW() WHERE id=?",
                token, expiry, userId);
    }

    // ── DELETE ─────────────────────────────────────────────────
    @org.springframework.transaction.annotation.Transactional
    public void delete(int userId) {
        // 1. Delete surveys created by this user
        jdbc.update("DELETE FROM surveys WHERE created_by=?", userId);
        
        // 2. Delete surveys for courses created by this user (to satisfy surveys_ibfk_1)
        jdbc.update("DELETE FROM surveys WHERE course_id IN (SELECT id FROM courses WHERE created_by=?)", userId);
        
        // 3. Delete courses created by this user
        jdbc.update("DELETE FROM courses WHERE created_by=?", userId);
        
        // 4. Delete teachers assigned by this user
        jdbc.update("DELETE FROM teachers WHERE assigned_by=?", userId);
        
        // 5. Finally delete the user
        jdbc.update("DELETE FROM users WHERE id=?", userId);
    }

    // ── UTILITY ────────────────────────────────────────────────
    public boolean existsByEmail(String email) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM users WHERE email=?", Integer.class, email);
        return count != null && count > 0;
    }

    public boolean existsByUsername(String username) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM users WHERE username=?", Integer.class, username);
        return count != null && count > 0;
    }

    public long countByRole(String roleName) {
        Long count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id=r.id WHERE r.name=?",
            Long.class, roleName);
        return count != null ? count : 0L;
    }

    public long countPending() {
        Long count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id=r.id " +
            "WHERE u.status='PENDING' AND r.name!='ADMIN'", Long.class);
        return count != null ? count : 0L;
    }
}
