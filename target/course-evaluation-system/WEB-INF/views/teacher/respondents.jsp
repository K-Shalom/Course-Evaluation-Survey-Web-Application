<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Respondents — ${survey.title} — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-chalkboard-teacher"></i></div><div class="logo-text">Teacher <span>Portal</span></div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/teacher/surveys"   class="nav-item active"><span class="nav-icon"><i class="fas fa-poll"></i></span> Course Surveys</a>
    </nav>
    <div class="sidebar-footer"><form action="${pageContext.request.contextPath}/logout" method="post">
      <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </form></div>
  </aside>
  <div class="main-content">
    <header class="top-header">
      <span class="header-title"><i class="fas fa-users" style="color:var(--primary-light);margin-right:8px;"></i>Respondents — ${survey.title}</span>
      <div class="header-right">
        <span style="font-size:14px;color:var(--text-muted);">Total: <strong style="color:var(--text);">${totalResp}</strong> responses</span>
        <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-outline btn-sm">← Back</a>
      </div>
    </header>
    <div class="page-body">
      <div class="card">
        <div class="table-wrap">
          <table>
            <thead><tr><th>Respondent</th><th>Email</th><th>Type</th><th>Question</th><th>Answer</th><th>Submitted</th></tr></thead>
            <tbody>
              <c:forEach var="r" items="${responses}">
                <tr>
                  <td>${r.respondent.effectiveDisplayName}</td>
                  <td style="font-size:12px;color:var(--text-muted);">${r.respondent.email}</td>
                  <td><span class="badge badge-${r.respondent.respondentType.name().toLowerCase()}">${r.respondent.respondentType}</span></td>
                  <td style="font-size:13px;max-width:200px;overflow:hidden;text-overflow:ellipsis;">${r.question.questionText}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty r.option}">${r.option.optionText}</c:when>
                      <c:otherwise>${r.answerText}</c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-size:12px;color:var(--text-muted);">${r.submittedAt}</td>
                </tr>
              </c:forEach>
              <c:if test="${empty responses}">
                <tr><td colspan="6" class="text-center text-muted" style="padding:40px;">No responses yet.</td></tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

