package com.evaluation.model;

import java.util.ArrayList;
import java.util.List;

public class SurveyQuestion {

    public enum QuestionType { SINGLE_CHOICE, MULTIPLE_CHOICE, TEXT, RATING, YES_NO }

    private int id;
    private int surveyId;
    private String questionText;
    private QuestionType questionType;
    private boolean required;
    private int orderIndex;
    private List<SurveyOption> options = new ArrayList<>();

    public SurveyQuestion() {
        this.questionType = QuestionType.SINGLE_CHOICE;
        this.required = true;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSurveyId() { return surveyId; }
    public void setSurveyId(int surveyId) { this.surveyId = surveyId; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public QuestionType getQuestionType() { return questionType; }
    public void setQuestionType(QuestionType questionType) { this.questionType = questionType; }

    public boolean isRequired() { return required; }
    public void setRequired(boolean required) { this.required = required; }

    public int getOrderIndex() { return orderIndex; }
    public void setOrderIndex(int orderIndex) { this.orderIndex = orderIndex; }

    public List<SurveyOption> getOptions() { return options; }
    public void setOptions(List<SurveyOption> options) { this.options = options; }

    public boolean isTextBased() {
        return QuestionType.TEXT.equals(questionType);
    }

    public boolean hasOptions() {
        return QuestionType.SINGLE_CHOICE.equals(questionType)
            || QuestionType.MULTIPLE_CHOICE.equals(questionType)
            || QuestionType.YES_NO.equals(questionType)
            || QuestionType.RATING.equals(questionType);
    }
}
