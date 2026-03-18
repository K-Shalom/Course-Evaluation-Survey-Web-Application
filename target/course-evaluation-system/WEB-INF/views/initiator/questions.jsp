<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Questions — ${survey.title} — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .option-input-row { display:flex;gap:8px;margin-bottom:8px;align-items:center; }
    .option-input-row input { flex:1; }
    #options-container .remove-option { background:none;border:none;color:var(--danger);cursor:pointer;font-size:16px; }
  </style>
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-clipboard-list"></i></div><div class="logo-text">Survey <span>Initiator</span><br>Portal</div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/initiator/dashboard"   class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/initiator/surveys"     class="nav-item"><span class="nav-icon"><i class="fas fa-poll"></i></span> My Surveys</a>
      <a href="${pageContext.request.contextPath}/initiator/surveys/new" class="nav-item"><span class="nav-icon"><i class="fas fa-plus-circle"></i></span> Create Survey</a>
    </nav>
    <div class="sidebar-footer"><form action="${pageContext.request.contextPath}/logout" method="post">
      <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </form></div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <span class="header-title">Questions: ${survey.title}</span>
      <div class="header-right">
        <span class="badge badge-${survey.status.name().toLowerCase()}">${survey.status}</span>
        <c:if test="${survey.status.name() == 'DRAFT'}">
          <form action="${pageContext.request.contextPath}/initiator/surveys/${survey.id}/publish" method="post" style="display:inline;">
            <button class="btn btn-primary btn-sm"><i class="fas fa-rocket"></i> Publish Survey</button>
          </form>
        </c:if>
        <a href="${pageContext.request.contextPath}/initiator/surveys" class="btn btn-outline btn-sm">← Back</a>
      </div>
    </header>

    <div class="page-body">
      <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
      <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

      <div style="display:grid;grid-template-columns:1fr 1.4fr;gap:24px;">

        <!-- ADD QUESTION FORM -->
        <div class="card" style="align-self:start;">
          <div class="card-header">
            <span class="card-title"><i class="fas fa-plus" style="color:var(--success);margin-right:8px;"></i>Add Question</span>
          </div>
          <div class="card-body">
            <form id="addQuestionForm" action="${pageContext.request.contextPath}/initiator/surveys/${survey.id}/questions/add" method="post">
              <div class="form-group">
                <label class="form-label">Question Text *</label>
                <textarea name="questionText" class="form-control" rows="3"
                          placeholder="Enter your question here..." required></textarea>
              </div>
              <div class="form-group">
                <label class="form-label">Question Type</label>
                <select name="questionType" id="questionType" class="form-control" onchange="toggleOptions(this.value)">
                  <option value="SINGLE_CHOICE">Single Choice (Radio)</option>
                  <option value="MULTIPLE_CHOICE">Multiple Choice (Checkbox)</option>
                  <option value="TEXT">Text Answer</option>
                  <option value="RATING">Rating (1-5)</option>
                  <option value="YES_NO">Yes / No</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-check">
                  <input type="checkbox" name="isRequired" value="true" checked>
                  Required question
                </label>
              </div>

              <!-- Dynamic options section -->
              <div id="options-section">
                <div class="form-group">
                  <label class="form-label">Answer Options *</label>
                  <div id="options-container">
                    <div class="option-input-row">
                      <input type="text" name="options[]" class="form-control" placeholder="Option 1">
                      <button type="button" class="remove-option" onclick="removeOption(this)"><i class="fas fa-times"></i></button>
                    </div>
                    <div class="option-input-row">
                      <input type="text" name="options[]" class="form-control" placeholder="Option 2">
                      <button type="button" class="remove-option" onclick="removeOption(this)"><i class="fas fa-times"></i></button>
                    </div>
                  </div>
                  <button type="button" class="btn btn-outline btn-sm mt-1" onclick="addOption()">
                    <i class="fas fa-plus"></i> Add Option
                  </button>
                </div>
              </div>

              <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-plus-circle"></i> Add Question
              </button>
            </form>
          </div>
        </div>

        <!-- CURRENT QUESTIONS LIST -->
        <div>
          <c:choose>
            <c:when test="${empty survey.questions}">
              <div class="card">
                <div class="card-body text-center" style="padding:40px;">
                  <i class="fas fa-question-circle" style="font-size:48px;color:var(--text-light);margin-bottom:16px;display:block;"></i>
                  <p class="text-muted">No questions yet. Add your first question!</p>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach var="q" items="${survey.questions}" varStatus="status">
                <div class="question-item">
                  <div style="display:flex;align-items:flex-start;gap:10px;margin-bottom:10px;">
                    <span class="question-num">${status.index + 1}</span>
                    <div style="flex:1;">
                      <span class="question-text">${q.questionText}</span>
                      <span class="question-type-badge">${q.questionType}</span>
                      <c:if test="${q.required}"><span class="question-type-badge" style="background:rgba(239,68,68,0.15);color:#fca5a5;">REQUIRED</span></c:if>
                    </div>
                    <form action="${pageContext.request.contextPath}/initiator/questions/${q.id}/delete" method="post" style="flex-shrink:0;">
                      <input type="hidden" name="surveyId" value="${survey.id}">
                      <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Remove this question?')">
                        <i class="fas fa-trash"></i>
                      </button>
                    </form>
                  </div>
                  <c:if test="${not empty q.options}">
                    <ul class="option-list">
                      <c:forEach var="opt" items="${q.options}">
                        <li>${opt.optionText}</li>
                      </c:forEach>
                    </ul>
                  </c:if>
                </div>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
function toggleOptions(type) {
  var section = document.getElementById('options-section');
  var noOptions = ['TEXT'];
  if (noOptions.includes(type)) {
    section.style.display = 'none';
  } else if (type === 'YES_NO') {
    section.style.display = 'none'; // auto-options
  } else if (type === 'RATING') {
    section.style.display = 'none'; // rating 1-5 auto
  } else {
    section.style.display = 'block';
  }
}

function addOption() {
  var container = document.getElementById('options-container');
  var row = document.createElement('div');
  row.className = 'option-input-row';
  var count = container.children.length + 1;
  row.innerHTML = '<input type="text" name="options[]" class="form-control" placeholder="Option ' + count + '">' +
    '<button type="button" class="remove-option" onclick="removeOption(this)"><i class="fas fa-times"></i></button>';
  container.appendChild(row);
}

function removeOption(btn) {
  var container = document.getElementById('options-container');
  if (container.children.length > 1) btn.parentElement.remove();
}
</script>
</body>
</html>

