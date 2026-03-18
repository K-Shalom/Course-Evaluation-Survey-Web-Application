package com.evaluation.dao;

import com.evaluation.model.SurveyOption;
import com.evaluation.model.SurveyQuestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;

@Repository
public class SurveyQuestionDao {

    @Autowired
    private JdbcTemplate jdbc;

    private final RowMapper<SurveyQuestion> questionMapper = (rs, rowNum) -> {
        SurveyQuestion q = new SurveyQuestion();
        q.setId(rs.getInt("id"));
        q.setSurveyId(rs.getInt("survey_id"));
        q.setQuestionText(rs.getString("question_text"));
        String type = rs.getString("question_type");
        if (type != null) q.setQuestionType(SurveyQuestion.QuestionType.valueOf(type));
        q.setRequired(rs.getBoolean("is_required"));
        q.setOrderIndex(rs.getInt("order_index"));
        return q;
    };

    private final RowMapper<SurveyOption> optionMapper = (rs, rowNum) -> {
        SurveyOption o = new SurveyOption();
        o.setId(rs.getInt("id"));
        o.setQuestionId(rs.getInt("question_id"));
        o.setOptionText(rs.getString("option_text"));
        o.setOrderIndex(rs.getInt("order_index"));
        return o;
    };

    // ── QUESTIONS ──────────────────────────────────────────────

    public int saveQuestion(SurveyQuestion q) {
        String sql = "INSERT INTO survey_questions (survey_id, question_text, question_type, is_required, order_index) " +
                     "VALUES (?, ?, ?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, q.getSurveyId());
            ps.setString(2, q.getQuestionText());
            ps.setString(3, q.getQuestionType().name());
            ps.setBoolean(4, q.isRequired());
            ps.setInt(5, q.getOrderIndex());
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    public List<SurveyQuestion> findBySurvey(int surveyId) {
        List<SurveyQuestion> questions = jdbc.query(
            "SELECT * FROM survey_questions WHERE survey_id=? ORDER BY order_index",
            questionMapper, surveyId);
        // Attach options to each question
        questions.forEach(q -> q.setOptions(findOptionsByQuestion(q.getId())));
        return questions;
    }

    public void updateQuestion(SurveyQuestion q) {
        jdbc.update("UPDATE survey_questions SET question_text=?, question_type=?, is_required=?, order_index=? WHERE id=?",
                q.getQuestionText(), q.getQuestionType().name(), q.isRequired(), q.getOrderIndex(), q.getId());
    }

    public void deleteQuestion(int questionId) {
        jdbc.update("DELETE FROM survey_questions WHERE id=?", questionId);
    }

    public void deleteAllBySurvey(int surveyId) {
        jdbc.update("DELETE FROM survey_questions WHERE survey_id=?", surveyId);
    }

    // ── OPTIONS ───────────────────────────────────────────────

    public int saveOption(SurveyOption option) {
        String sql = "INSERT INTO survey_options (question_id, option_text, order_index) VALUES (?, ?, ?)";
        KeyHolder holder = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, option.getQuestionId());
            ps.setString(2, option.getOptionText());
            ps.setInt(3, option.getOrderIndex());
            return ps;
        }, holder);
        return holder.getKey().intValue();
    }

    public List<SurveyOption> findOptionsByQuestion(int questionId) {
        return jdbc.query(
            "SELECT * FROM survey_options WHERE question_id=? ORDER BY order_index",
            optionMapper, questionId);
    }

    public void deleteOption(int optionId) {
        jdbc.update("DELETE FROM survey_options WHERE id=?", optionId);
    }

    public void deleteAllOptionsByQuestion(int questionId) {
        jdbc.update("DELETE FROM survey_options WHERE question_id=?", questionId);
    }

    /** Result chart data: option text + how many times it was selected */
    public List<SurveyOption> findOptionsWithResponseCount(int questionId) {
        String sql =
            "SELECT o.id, o.question_id, o.option_text, o.order_index, " +
            "COUNT(sr.id) response_count " +
            "FROM survey_options o " +
            "LEFT JOIN survey_responses sr ON sr.option_id = o.id " +
            "WHERE o.question_id=? GROUP BY o.id ORDER BY o.order_index";
        return jdbc.query(sql, (rs, rowNum) -> {
            SurveyOption o = new SurveyOption();
            o.setId(rs.getInt("id"));
            o.setQuestionId(rs.getInt("question_id"));
            o.setOptionText(rs.getString("option_text"));
            o.setOrderIndex(rs.getInt("order_index"));
            o.setResponseCount(rs.getInt("response_count"));
            return o;
        }, questionId);
    }
}
