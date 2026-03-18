package com.evaluation.dao;

import com.evaluation.model.*;
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
public class TeacherDao {

    @Autowired
    private JdbcTemplate jdbc;

    private final RowMapper<Teacher> teacherMapper = (rs, rowNum) -> {
        Teacher t = new Teacher();
        t.setId(rs.getInt("t_id"));
        t.setUserId(rs.getInt("t_user_id"));
        t.setCourseId(rs.getInt("t_course_id"));
        t.setAssignedBy(rs.getInt("t_assigned_by"));
        Timestamp at = rs.getTimestamp("t_assigned_at");
        if (at != null) t.setAssignedAt(at.toLocalDateTime());

        // User info
        User u = new User();
        u.setId(rs.getInt("u_id"));
        u.setFirstName(rs.getString("u_first_name"));
        u.setLastName(rs.getString("u_last_name"));
        u.setEmail(rs.getString("u_email"));
        t.setUser(u);

        // Course info
        Course c = new Course();
        c.setId(rs.getInt("c_id"));
        c.setCode(rs.getString("c_code"));
        c.setName(rs.getString("c_name"));
        t.setCourse(c);

        return t;
    };

    private static final String BASE_SELECT =
        "SELECT t.id t_id, t.user_id t_user_id, t.course_id t_course_id, " +
        "t.assigned_by t_assigned_by, t.assigned_at t_assigned_at, " +
        "u.id u_id, u.first_name u_first_name, u.last_name u_last_name, u.email u_email, " +
        "c.id c_id, c.code c_code, c.name c_name " +
        "FROM teachers t " +
        "JOIN users u ON t.user_id = u.id " +
        "JOIN courses c ON t.course_id = c.id ";

    // ── CREATE ─────────────────────────────────────────────────
    public int assign(int teacherUserId, int courseId, int assignedBy) {
        String sql = "INSERT INTO teachers (user_id, course_id, assigned_by) VALUES (?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, teacherUserId);
            ps.setInt(2, courseId);
            ps.setInt(3, assignedBy);
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    // ── READ ───────────────────────────────────────────────────
    public List<Teacher> findAll() {
        return jdbc.query(BASE_SELECT + "ORDER BY c.name, u.last_name", teacherMapper);
    }

    public List<Teacher> findByCourse(int courseId) {
        return jdbc.query(BASE_SELECT + "WHERE t.course_id=? ORDER BY u.last_name", teacherMapper, courseId);
    }

    public List<Teacher> findByTeacher(int teacherUserId) {
        return jdbc.query(BASE_SELECT + "WHERE t.user_id=? ORDER BY c.name", teacherMapper, teacherUserId);
    }

    public Optional<Teacher> findById(int id) {
        try {
            return Optional.ofNullable(
                jdbc.queryForObject(BASE_SELECT + "WHERE t.id=?", teacherMapper, id));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    // ── CHECK ──────────────────────────────────────────────────
    public boolean isAssigned(int teacherUserId, int courseId) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM teachers WHERE user_id=? AND course_id=?",
            Integer.class, teacherUserId, courseId);
        return count != null && count > 0;
    }

    // ── DELETE ─────────────────────────────────────────────────
    public void unassign(int id) {
        jdbc.update("DELETE FROM teachers WHERE id=?", id);
    }

    public void unassignByUserAndCourse(int teacherUserId, int courseId) {
        jdbc.update("DELETE FROM teachers WHERE user_id=? AND course_id=?", teacherUserId, courseId);
    }
}
