package com.evaluation.model;

public class SurveyOption {
    private int id;
    private int questionId;
    private String optionText;
    private int orderIndex;

    // transient: how many times this option was chosen (for results view)
    private int responseCount;

    public SurveyOption() {}

    public SurveyOption(int questionId, String optionText, int orderIndex) {
        this.questionId  = questionId;
        this.optionText  = optionText;
        this.orderIndex  = orderIndex;
    }

    public int    getId()           { return id; }
    public void   setId(int id)     { this.id = id; }

    public int    getQuestionId()              { return questionId; }
    public void   setQuestionId(int questionId){ this.questionId = questionId; }

    public String getOptionText()                  { return optionText; }
    public void   setOptionText(String optionText) { this.optionText = optionText; }

    public int    getOrderIndex()              { return orderIndex; }
    public void   setOrderIndex(int orderIndex){ this.orderIndex = orderIndex; }

    public int    getResponseCount()                 { return responseCount; }
    public void   setResponseCount(int responseCount){ this.responseCount = responseCount; }
}
