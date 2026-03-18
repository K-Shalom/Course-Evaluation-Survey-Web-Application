package com.evaluation.dao;

import com.evaluation.model.Course;
import com.evaluation.model.User;
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
public class CourseDao {

    @Autowired
    private JdbcTemplate jdbc;

    private final RowMapper<Course> courseMapper = (rs, rowNum) -> {
        Course c = new Course();
        c.setId(rs.getInt("c_id"));
        c.setCode(rs.getString("c_code"));
        c.setName(rs.getString("c_name"));
        c.setDescription(rs.getString("c_description"));
        c.setCredits(rs.getInt("c_credits"));
        c.setDepartment(rs.getString("c_department"));
        c.setActive(rs.getBoolean("c_is_active"));
        c.setCreatedBy(rs.getInt("c_created_by"));
        Timestamp createdAt = rs.getTimestamp("c_created_at");
        if (createdAt != null) c.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("c_updated_at");
        if (updatedAt != null) c.setUpdatedAt(updatedAt.toLocalDateTime());

        // Count columns (may not exist in all queries)
        try { c.setTeacherCount(rs.getInt("teacher_count")); } catch (SQLException ignored) {}
        try { c.setSurveyCount(rs.getInt("survey_count")); }  catch (SQLException ignored) {}
        return c;
    };

    private static final String BASE_SELECT =
        "SELECT c.id c_id, c.code c_code, c.name c_name, c.description c_description, " +
        "c.credits c_credits, c.department c_department, c.is_active c_is_active, " +
        "c.created_by c_created_by, c.created_at c_created_at, c.updated_at c_updated_at ";

    // ── CREATE ─────────────────────────────────────────────────
    public int save(Course course) {
        String sql = "INSERT INTO courses (code, name, description, credits, department, is_active, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, course.getCode());
            ps.setString(2, course.getName());
            ps.setString(3, course.getDescription());
            ps.setInt(4, course.getCredits());
            ps.setString(5, course.getDepartment());
            ps.setBoolean(6, course.isActive());
            ps.setInt(7, course.getCreatedBy());
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    // ── READ ───────────────────────────────────────────────────
    public Optional<Course> findById(int id) {
        try {
            String sql = BASE_SELECT + "FROM courses c WHERE c.id=?";
            return Optional.ofNullable(jdbc.queryForObject(sql, courseMapper, id));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public List<Course> findAll() {
        String sql = BASE_SELECT +
            ", (SELECT COUNT(*) FROM teachers t WHERE t.course_id=c.id) teacher_count" +
            ", (SELECT COUNT(*) FROM surveys s WHERE s.course_id=c.id) survey_count " +
            "FROM courses c ORDER BY c.name";
        return jdbc.query(sql, courseMapper);
    }

    public List<Course> findActive() {
        String sql = BASE_SELECT + "FROM courses c WHERE c.is_active=1 ORDER BY c.name";
        return jdbc.query(sql, courseMapper);
    }

    /** Find all courses assigned to a particular teacher */
    public List<Course> findByTeacher(int teacherUserId) {
        String sql = BASE_SELECT +
            "FROM courses c " +
            "JOIN teachers t ON c.id = t.course_id " +
            "WHERE t.user_id = ? ORDER BY c.name";
        return jdbc.query(sql, courseMapper, teacherUserId);
    }

    // ── UPDATE ─────────────────────────────────────────────────
    public void update(Course course) {
        jdbc.update("UPDATE courses SET code=?, name=?, description=?, credits=?, " +
                    "department=?, is_active=?, updated_at=NOW() WHERE id=?",
                course.getCode(), course.getName(), course.getDescription(),
                course.getCredits(), course.getDepartment(), course.isActive(), course.getId());
    }

    // ── DELETE ─────────────────────────────────────────────────
    public void delete(int courseId) {
        jdbc.update("DELETE FROM courses WHERE id=?", courseId);
    }

    // ── UTILITY ────────────────────────────────────────────────
    public boolean existsByCode(String code) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM courses WHERE code=?", Integer.class, code);
        return count != null && count > 0;
    }

    public boolean existsByCodeExcluding(String code, int excludeId) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM courses WHERE code=? AND id!=?", Integer.class, code, excludeId);
        return count != null && count > 0;
    }

    public long count() {
        Long count = jdbc.queryForObject("SELECT COUNT(*) FROM courses", Long.class);
        return count != null ? count : 0L;
    }
}
