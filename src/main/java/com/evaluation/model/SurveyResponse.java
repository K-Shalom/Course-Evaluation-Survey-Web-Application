package com.evaluation.model;

import java.time.LocalDateTime;

/**
 * Maps to the `survey_responses` table.
 * One row = one answer to one question within one submission.
 * The `submissionId` (UUID) groups all rows from a single form submission.
 */
public class SurveyResponse {

    private int           id;
    private int           surveyId;
    private int           respondentId;
    private Respondent    respondent;
    private int           questionId;
    private SurveyQuestion question;
    private Integer       optionId;       // null for free-text answers
    private SurveyOption  option;
    private String        answerText;     // used when optionId is null
    private String        submissionId;   // UUID groups one full submission
    private LocalDateTime submittedAt;
    private boolean       confirmationSent;

    public SurveyResponse() {}

    public int  getId()                 { return id; }
    public void setId(int id)           { this.id = id; }

    public int  getSurveyId()           { return surveyId; }
    public void setSurveyId(int surveyId){ this.surveyId = surveyId; }

    public int  getRespondentId()               { return respondentId; }
    public void setRespondentId(int respondentId){ this.respondentId = respondentId; }

    public Respondent getRespondent()                     { return respondent; }
    public void       setRespondent(Respondent respondent){ this.respondent = respondent; }

    public int  getQuestionId()               { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    public SurveyQuestion getQuestion()                       { return question; }
    public void           setQuestion(SurveyQuestion question){ this.question = question; }

    public Integer getOptionId()              { return optionId; }
    public void    setOptionId(Integer optionId){ this.optionId = optionId; }

    public SurveyOption getOption()                   { return option; }
    public void         setOption(SurveyOption option){ this.option = option; }

    public String getAnswerText()                  { return answerText; }
    public void   setAnswerText(String answerText) { this.answerText = answerText; }

    public String getSubmissionId()                    { return submissionId; }
    public void   setSubmissionId(String submissionId) { this.submissionId = submissionId; }

    public LocalDateTime getSubmittedAt()                        { return submittedAt; }
    public void          setSubmittedAt(LocalDateTime submittedAt){ this.submittedAt = submittedAt; }

    public boolean isConfirmationSent()                        { return confirmationSent; }
    public void    setConfirmationSent(boolean confirmationSent){ this.confirmationSent = confirmationSent; }
}
