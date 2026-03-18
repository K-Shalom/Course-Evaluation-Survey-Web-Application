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
import java.util.Map;

@Repository
public class SurveyResponseDao {

    @Autowired
    private JdbcTemplate jdbc;

    // ── SAVE (one answer row at a time) ───────────────────────
    public int save(SurveyResponse response) {
        String sql = "INSERT INTO survey_responses " +
                     "(survey_id, respondent_id, question_id, option_id, answer_text, submission_id, confirmation_sent) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, response.getSurveyId());
            ps.setInt(2, response.getRespondentId());
            ps.setInt(3, response.getQuestionId());
            if (response.getOptionId() != null) ps.setInt(4, response.getOptionId());
            else ps.setNull(4, Types.INTEGER);
            ps.setString(5, response.getAnswerText());
            ps.setString(6, response.getSubmissionId());
            ps.setBoolean(7, response.isConfirmationSent());
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    public void saveAll(List<SurveyResponse> responses) {
        responses.forEach(this::save);
    }

    // ── READ ───────────────────────────────────────────────────

    /** All responses for a survey (for results view) */
    public List<SurveyResponse> findBySurvey(int surveyId) {
        String sql = "SELECT sr.*, sq.question_text, sq.question_type, " +
                     "so.option_text, r.email respondent_email, r.display_name respondent_name " +
                     "FROM survey_responses sr " +
                     "LEFT JOIN survey_questions sq ON sr.question_id = sq.id " +
                     "LEFT JOIN survey_options so ON sr.option_id = so.id " +
                     "LEFT JOIN respondents r ON sr.respondent_id = r.id " +
                     "WHERE sr.survey_id=? ORDER BY sr.submission_id, sr.id";
        return jdbc.query(sql, fullMapper, surveyId);
    }

    /** All answers for one submission */
    public List<SurveyResponse> findBySubmission(String submissionId) {
        return jdbc.query(
            "SELECT * FROM survey_responses WHERE submission_id=? ORDER BY id",
            baseMapper, submissionId);
    }

    /** Has this respondent already submitted this survey? */
    public boolean hasRespondentSubmitted(int surveyId, int respondentId) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM survey_responses WHERE survey_id=? AND respondent_id=?",
            Integer.class, surveyId, respondentId);
        return count != null && count > 0;
    }

    /** Distinct submission count for a survey */
    public long countSubmissions(int surveyId) {
        Long c = jdbc.queryForObject(
            "SELECT COUNT(DISTINCT submission_id) FROM survey_responses WHERE survey_id=?",
            Long.class, surveyId);
        return c != null ? c : 0L;
    }

    /** All distinct submission IDs for a survey (for listing individual submissions) */
    public List<String> findSubmissionIds(int surveyId) {
        return jdbc.queryForList(
            "SELECT DISTINCT submission_id FROM survey_responses WHERE survey_id=? ORDER BY MIN(submitted_at) DESC",
            String.class, surveyId);
    }

    /** Text answers for a question (for word-cloud / free-text results) */
    public List<String> findTextAnswers(int surveyId, int questionId) {
        return jdbc.queryForList(
            "SELECT answer_text FROM survey_responses WHERE survey_id=? AND question_id=? AND answer_text IS NOT NULL",
            String.class, surveyId, questionId);
    }

    /** Mark confirmation emails sent for a submission */
    public void markConfirmationSent(String submissionId) {
        jdbc.update("UPDATE survey_responses SET confirmation_sent=1 WHERE submission_id=?", submissionId);
    }

    // ── ROW MAPPERS ───────────────────────────────────────────

    private final RowMapper<SurveyResponse> baseMapper = (rs, rowNum) -> {
        SurveyResponse sr = new SurveyResponse();
        sr.setId(rs.getInt("id"));
        sr.setSurveyId(rs.getInt("survey_id"));
        sr.setRespondentId(rs.getInt("respondent_id"));
        sr.setQuestionId(rs.getInt("question_id"));
        int optId = rs.getInt("option_id");
        if (!rs.wasNull()) sr.setOptionId(optId);
        sr.setAnswerText(rs.getString("answer_text"));
        sr.setSubmissionId(rs.getString("submission_id"));
        Timestamp sub = rs.getTimestamp("submitted_at");
        if (sub != null) sr.setSubmittedAt(sub.toLocalDateTime());
        sr.setConfirmationSent(rs.getBoolean("confirmation_sent"));
        return sr;
    };

    private final RowMapper<SurveyResponse> fullMapper = (rs, rowNum) -> {
        SurveyResponse sr = baseMapper.mapRow(rs, rowNum);
        // Question snippet
        SurveyQuestion q = new SurveyQuestion();
        q.setId(sr.getQuestionId());
        try { q.setQuestionText(rs.getString("question_text")); } catch (SQLException ignored) {}
        try {
            String qType = rs.getString("question_type");
            if (qType != null) q.setQuestionType(SurveyQuestion.QuestionType.valueOf(qType));
        } catch (SQLException ignored) {}
        sr.setQuestion(q);
        // Option snippet
        if (sr.getOptionId() != null) {
            SurveyOption o = new SurveyOption();
            o.setId(sr.getOptionId());
            try { o.setOptionText(rs.getString("option_text")); } catch (SQLException ignored) {}
            sr.setOption(o);
        }
        // Respondent snippet
        try {
            Respondent respondent = new Respondent();
            respondent.setId(sr.getRespondentId());
            respondent.setEmail(rs.getString("respondent_email"));
            respondent.setDisplayName(rs.getString("respondent_name"));
            sr.setRespondent(respondent);
        } catch (SQLException ignored) {}
        return sr;
    };
}
