<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${survey.title} — Take Survey — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .survey-form-wrap { max-width:760px; margin:0 auto; padding:40px 24px 80px; }
    .survey-header-card {
      background: linear-gradient(135deg, rgba(79,70,229,0.2), rgba(124,58,237,0.15));
      border: 1px solid rgba(79,70,229,0.3);
      border-radius: var(--radius-lg);
      padding: 32px;
      margin-bottom: 28px;
    }
    .question-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 24px;
      margin-bottom: 18px;
      transition: var(--transition);
    }
    .question-card:focus-within { border-color: var(--primary); }
    .option-label {
      display: flex; align-items: center; gap: 12px;
      padding: 12px 16px;
      border-radius: var(--radius);
      cursor: pointer;
      transition: var(--transition);
      border: 1px solid transparent;
    }
    .option-label:hover { background: rgba(79,70,229,0.1); border-color: rgba(79,70,229,0.3); }
    .option-label input[type=radio],
    .option-label input[type=checkbox] { accent-color: var(--primary); width:16px; height:16px; }
    .rating-stars { display:flex; gap:8px; margin-top:8px; }
    .rating-option { display:none; }
    .rating-label {
      width:44px; height:44px;
      border-radius:var(--radius);
      background: var(--bg-card2);
      border: 1px solid var(--border);
      display:flex; align-items:center; justify-content:center;
      font-size:16px; font-weight:700;
      cursor:pointer;
      transition: var(--transition);
    }
    .rating-option:checked + .rating-label {
      background: linear-gradient(135deg, var(--primary), var(--accent));
      border-color: transparent; color:#fff;
    }
  </style>
</head>
<body style="background:var(--bg);">

  <!-- MINI NAV -->
  <nav style="display:flex;align-items:center;justify-content:space-between;padding:14px 40px;
              background:var(--bg-card);border-bottom:1px solid var(--border);">
    <a href="${pageContext.request.contextPath}/respondent/surveys" style="font-size:16px;font-weight:700;color:var(--text);">
      ← CES Platform
    </a>
    <sec:authorize access="isAuthenticated()">
      <span style="color:var(--text-muted);font-size:13px;">
        <i class="fas fa-user-circle"></i> <sec:authentication property="name"/>
      </span>
    </sec:authorize>
  </nav>

  <div class="survey-form-wrap">
    <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

    <!-- Already submitted -->
    <c:if test="${alreadySubmitted}">
      <div class="alert alert-info">
        <i class="fas fa-check-circle"></i>
        You have already submitted a response to this survey. Thank you!
      </div>
    </c:if>

    <!-- Survey Header -->
    <div class="survey-header-card">
      <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:16px;">
        <div>
          <div style="font-size:12px;font-weight:600;color:var(--primary-light);margin-bottom:8px;text-transform:uppercase;letter-spacing:.08em;">
            <i class="fas fa-book"></i> ${survey.course.code} — ${survey.course.name}
          </div>
          <h1 style="font-size:24px;font-weight:800;margin-bottom:10px;">${survey.title}</h1>
          <p style="color:var(--text-muted);font-size:14px;">${survey.description}</p>
        </div>
        <div style="text-align:right;flex-shrink:0;">
          <div style="font-size:28px;font-weight:800;color:var(--primary-light);">${survey.questions.size()}</div>
          <div style="font-size:12px;color:var(--text-muted);">Questions</div>
        </div>
      </div>
    </div>

    <c:if test="${!alreadySubmitted}">
    <form id="surveyForm" action="${pageContext.request.contextPath}/respondent/surveys/${survey.id}/submit" method="post">

      <!-- GUEST INFO (shown when not logged in or survey allows guests) -->
      <sec:authorize access="isAnonymous()">
        <div class="card mb-3" style="margin-bottom:20px;">
          <div class="card-header">
            <span class="card-title"><i class="fas fa-user" style="color:var(--primary-light);margin-right:8px;"></i>Your Information</span>
          </div>
          <div class="card-body">
            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Your Name</label>
                <input type="text" name="guestName" class="form-control" placeholder="Enter your name">
              </div>
              <div class="form-group">
                <label class="form-label">Email Address ${survey.requireEmail ? '*' : '(optional)'}</label>
                <input type="email" name="guestEmail" class="form-control"
                       placeholder="your@email.com"
                       ${survey.requireEmail ? 'required' : ''}>
                <c:if test="${survey.sendConfirmation}">
                  <small style="color:var(--success);font-size:12px;">
                    <i class="fas fa-envelope"></i> You'll receive a confirmation email.
                  </small>
                </c:if>
              </div>
            </div>
          </div>
        </div>
      </sec:authorize>

      <!-- QUESTIONS -->
      <c:forEach var="q" items="${survey.questions}" varStatus="qStatus">
        <div class="question-card">
          <div style="display:flex;align-items:flex-start;gap:12px;margin-bottom:16px;">
            <span class="question-num">${qStatus.index + 1}</span>
            <div>
              <p style="font-size:15px;font-weight:600;line-height:1.5;">
                ${q.questionText}
                <c:if test="${q.required}"><span style="color:var(--danger);margin-left:4px;">*</span></c:if>
              </p>
              <span class="question-type-badge">${q.questionType}</span>
            </div>
          </div>

          <c:choose>
            <c:when test="${q.questionType.name() == 'TEXT'}">
              <!-- TEXT -->
              <textarea name="answer_text_${q.id}" class="form-control"
                        rows="4" placeholder="Write your answer here..."
                        ${q.required ? 'required' : ''}></textarea>
            </c:when>

            <c:when test="${q.questionType.name() == 'YES_NO'}">
              <!-- YES/NO -->
              <label class="option-label">
                <input type="radio" name="answer_option_${q.id}" value="${q.options[0].id}" ${q.required ? 'required' : ''}>
                Yes
              </label>
              <c:if test="${q.options.size() > 1}">
              <label class="option-label">
                <input type="radio" name="answer_option_${q.id}" value="${q.options[1].id}">
                No
              </label>
              </c:if>
            </c:when>

            <c:when test="${q.questionType.name() == 'RATING'}">
              <!-- RATING -->
              <div class="rating-stars">
                <c:forEach var="opt" items="${q.options}">
                  <input type="radio" name="answer_option_${q.id}" value="${opt.id}"
                         id="rating_${q.id}_${opt.id}" class="rating-option"
                         ${q.required ? 'required' : ''}>
                  <label for="rating_${q.id}_${opt.id}" class="rating-label">${opt.optionText}</label>
                </c:forEach>
              </div>
              <small style="color:var(--text-muted);font-size:12px;">Select a rating</small>
            </c:when>

            <c:when test="${q.questionType.name() == 'SINGLE_CHOICE'}">
              <!-- SINGLE CHOICE -->
              <c:forEach var="opt" items="${q.options}">
                <label class="option-label">
                  <input type="radio" name="answer_option_${q.id}" value="${opt.id}" ${q.required ? 'required' : ''}>
                  ${opt.optionText}
                </label>
              </c:forEach>
            </c:when>

            <c:when test="${q.questionType.name() == 'MULTIPLE_CHOICE'}">
              <!-- MULTIPLE CHOICE -->
              <c:forEach var="opt" items="${q.options}">
                <label class="option-label">
                  <input type="checkbox" name="answer_multi_${q.id}" value="${opt.id}">
                  ${opt.optionText}
                </label>
              </c:forEach>
            </c:when>
          </c:choose>
        </div>
      </c:forEach>

      <!-- SUBMIT -->
      <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:12px;">
        <a href="${pageContext.request.contextPath}/respondent/surveys" class="btn btn-outline btn-lg">Cancel</a>
        <button type="submit" id="submit-btn" class="btn btn-primary btn-lg">
          <i class="fas fa-paper-plane"></i> Submit Survey
        </button>
      </div>
    </form>
    </c:if>
  </div>

<script>
document.getElementById('surveyForm')?.addEventListener('submit', function() {
  var btn = document.getElementById('submit-btn');
  btn.disabled = true;
  btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
});
</script>
</body>
</html>

