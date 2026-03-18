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
public class SurveyDao {

    @Autowired
    private JdbcTemplate jdbc;

    private final RowMapper<Survey> surveyMapper = (rs, rowNum) -> {
        Survey s = new Survey();
        s.setId(rs.getInt("s_id"));
        s.setTitle(rs.getString("s_title"));
        s.setDescription(rs.getString("s_description"));
        s.setCourseId(rs.getInt("s_course_id"));
        s.setCreatedBy(rs.getInt("s_created_by"));
        String status = rs.getString("s_status");
        if (status != null) s.setStatus(Survey.Status.valueOf(status));
        String accessType = rs.getString("s_access_type");
        if (accessType != null) s.setAccessType(Survey.AccessType.valueOf(accessType));
        s.setRequireEmail(rs.getBoolean("s_require_email"));
        s.setSendConfirmation(rs.getBoolean("s_send_confirmation"));
        s.setAllowAnonymous(rs.getBoolean("s_allow_anonymous"));
        Timestamp start = rs.getTimestamp("s_start_date");
        if (start != null) s.setStartDate(start.toLocalDateTime());
        Timestamp end = rs.getTimestamp("s_end_date");
        if (end != null) s.setEndDate(end.toLocalDateTime());
        Timestamp created = rs.getTimestamp("s_created_at");
        if (created != null) s.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("s_updated_at");
        if (updated != null) s.setUpdatedAt(updated.toLocalDateTime());

        // Course info
        Course c = new Course();
        c.setId(rs.getInt("c_id"));
        c.setCode(rs.getString("c_code"));
        c.setName(rs.getString("c_name"));
        s.setCourse(c);

        // Creator info
        User creator = new User();
        creator.setId(rs.getInt("u_id"));
        creator.setFirstName(rs.getString("u_first_name"));
        creator.setLastName(rs.getString("u_last_name"));
        s.setCreator(creator);

        // Response count
        try { s.setResponseCount(rs.getInt("response_count")); } catch (SQLException ignored) {}

        return s;
    };

    private static final String BASE_SELECT =
        "SELECT s.id s_id, s.title s_title, s.description s_description, " +
        "s.course_id s_course_id, s.created_by s_created_by, s.status s_status, " +
        "s.access_type s_access_type, s.require_email s_require_email, " +
        "s.send_confirmation s_send_confirmation, s.allow_anonymous s_allow_anonymous, " +
        "s.start_date s_start_date, s.end_date s_end_date, " +
        "s.created_at s_created_at, s.updated_at s_updated_at, " +
        "c.id c_id, c.code c_code, c.name c_name, " +
        "u.id u_id, u.first_name u_first_name, u.last_name u_last_name, " +
        "(SELECT COUNT(DISTINCT sr.submission_id) FROM survey_responses sr WHERE sr.survey_id = s.id) response_count " +
        "FROM surveys s " +
        "JOIN courses c ON s.course_id = c.id " +
        "JOIN users u ON s.created_by = u.id ";

    // ── CREATE ─────────────────────────────────────────────────
    public int save(Survey survey) {
        String sql = "INSERT INTO surveys (title, description, course_id, created_by, status, " +
                     "access_type, require_email, send_confirmation, allow_anonymous, start_date, end_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, survey.getTitle());
            ps.setString(2, survey.getDescription());
            ps.setInt(3, survey.getCourseId());
            ps.setInt(4, survey.getCreatedBy());
            ps.setString(5, survey.getStatus().name());
            ps.setString(6, survey.getAccessType().name());
            ps.setBoolean(7, survey.isRequireEmail());
            ps.setBoolean(8, survey.isSendConfirmation());
            ps.setBoolean(9, survey.isAllowAnonymous());
            if (survey.getStartDate() != null)
                ps.setTimestamp(10, Timestamp.valueOf(survey.getStartDate()));
            else ps.setNull(10, Types.TIMESTAMP);
            if (survey.getEndDate() != null)
                ps.setTimestamp(11, Timestamp.valueOf(survey.getEndDate()));
            else ps.setNull(11, Types.TIMESTAMP);
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    // ── READ ───────────────────────────────────────────────────
    public Optional<Survey> findById(int id) {
        try {
            String sql = BASE_SELECT + "WHERE s.id = ?";
            return Optional.ofNullable(jdbc.queryForObject(sql, surveyMapper, id));
        } catch (EmptyResultDataAccessException e) { return Optional.empty(); }
    }

    public List<Survey> findAll() {
        String sql = BASE_SELECT + "ORDER BY s.created_at DESC";
        return jdbc.query(sql, surveyMapper);
    }

    public List<Survey> findByInitiator(int userId) {
        String sql = BASE_SELECT + "WHERE s.created_by = ? ORDER BY s.created_at DESC";
        return jdbc.query(sql, surveyMapper, userId);
    }

    /** Find surveys for courses a teacher teaches */
    public List<Survey> findByTeacher(int teacherUserId) {
        String sql = BASE_SELECT +
            "JOIN teachers t ON s.course_id = t.course_id " +
            "WHERE t.user_id = ? ORDER BY s.created_at DESC";
        return jdbc.query(sql, surveyMapper, teacherUserId);
    }

    public List<Survey> findActive() {
        String sql = BASE_SELECT +
            "WHERE s.status='ACTIVE' " +
            "AND (s.start_date IS NULL OR s.start_date <= NOW()) " +
            "AND (s.end_date IS NULL OR s.end_date >= NOW()) " +
            "ORDER BY s.created_at DESC";
        return jdbc.query(sql, surveyMapper);
    }

    // ── UPDATE ─────────────────────────────────────────────────
    public void update(Survey survey) {
        jdbc.update("UPDATE surveys SET title=?, description=?, course_id=?, status=?, " +
                    "access_type=?, require_email=?, send_confirmation=?, allow_anonymous=?, " +
                    "start_date=?, end_date=?, updated_at=NOW() WHERE id=?",
                survey.getTitle(), survey.getDescription(), survey.getCourseId(),
                survey.getStatus().name(), survey.getAccessType().name(),
                survey.isRequireEmail(), survey.isSendConfirmation(), survey.isAllowAnonymous(),
                survey.getStartDate() != null ? Timestamp.valueOf(survey.getStartDate()) : null,
                survey.getEndDate()   != null ? Timestamp.valueOf(survey.getEndDate())   : null,
                survey.getId());
    }

    public void updateStatus(int surveyId, String status) {
        jdbc.update("UPDATE surveys SET status=?, updated_at=NOW() WHERE id=?", status, surveyId);
    }

    // ── DELETE ─────────────────────────────────────────────────
    public void delete(int surveyId) {
        jdbc.update("DELETE FROM surveys WHERE id=?", surveyId);
    }

    // ── UTILITY ────────────────────────────────────────────────
    public long countAll() {
        Long c = jdbc.queryForObject("SELECT COUNT(*) FROM surveys", Long.class);
        return c != null ? c : 0L;
    }

    public long countByInitiator(int userId) {
        Long c = jdbc.queryForObject("SELECT COUNT(*) FROM surveys WHERE created_by=?", Long.class, userId);
        return c != null ? c : 0L;
    }
}
