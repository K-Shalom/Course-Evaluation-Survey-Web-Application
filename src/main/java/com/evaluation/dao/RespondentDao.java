package com.evaluation.dao;

import com.evaluation.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;
import java.util.Optional;

@Repository
public class RespondentDao {

    @Autowired
    private JdbcTemplate jdbc;

    private final RowMapper<Respondent> mapper = (rs, rowNum) -> {
        Respondent r = new Respondent();
        r.setId(rs.getInt("id"));
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) r.setUserId(userId);
        r.setEmail(rs.getString("email"));
        r.setDisplayName(rs.getString("display_name"));
        String type = rs.getString("respondent_type");
        if (type != null) r.setRespondentType(Respondent.RespondentType.valueOf(type));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) r.setCreatedAt(ca.toLocalDateTime());
        return r;
    };

    public int save(Respondent respondent) {
        String sql = "INSERT INTO respondents (user_id, email, display_name, respondent_type) VALUES (?, ?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            if (respondent.getUserId() != null) ps.setInt(1, respondent.getUserId());
            else ps.setNull(1, Types.INTEGER);
            ps.setString(2, respondent.getEmail());
            ps.setString(3, respondent.getDisplayName());
            ps.setString(4, respondent.getRespondentType().name());
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    public Optional<Respondent> findByUserId(int userId) {
        try {
            return Optional.ofNullable(jdbc.queryForObject(
                "SELECT * FROM respondents WHERE user_id=?", mapper, userId));
        } catch (Exception e) { return Optional.empty(); }
    }

    public Optional<Respondent> findById(int id) {
        try {
            return Optional.ofNullable(jdbc.queryForObject(
                "SELECT * FROM respondents WHERE id=?", mapper, id));
        } catch (Exception e) { return Optional.empty(); }
    }

    public List<Respondent> findBySurvey(int surveyId) {
        String sql = "SELECT DISTINCT r.* FROM respondents r " +
                     "JOIN survey_responses sr ON r.id = sr.respondent_id " +
                     "WHERE sr.survey_id=? ORDER BY sr.submitted_at DESC";
        return jdbc.query(sql, mapper, surveyId);
    }

    public long countBySurvey(int surveyId) {
        Long count = jdbc.queryForObject(
            "SELECT COUNT(DISTINCT respondent_id) FROM survey_responses WHERE survey_id=?",
            Long.class, surveyId);
        return count != null ? count : 0L;
    }
}
