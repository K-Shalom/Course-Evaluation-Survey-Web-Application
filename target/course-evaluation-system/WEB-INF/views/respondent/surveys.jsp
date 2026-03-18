<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Available Surveys — CES</title>
  <meta name="description" content="Browse and take course evaluation surveys">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div style="min-height:100vh;background:var(--bg);">
  <!-- SIMPLE NAV -->
  <nav style="display:flex;align-items:center;justify-content:space-between;padding:16px 40px;
              background:var(--bg-card);border-bottom:1px solid var(--border);position:sticky;top:0;z-index:50;">
    <a href="${pageContext.request.contextPath}/home" style="font-size:18px;font-weight:800;color:var(--text);">
      CES <span style="color:var(--primary-light);">Platform</span>
    </a>
    <div style="display:flex;gap:12px;align-items:center;">
      <sec:authorize access="isAuthenticated()">
        <sec:authorize access="hasRole('RESPONDENT')">
          <span style="color:var(--text-muted);font-size:13px;">Hello, <sec:authentication property="name"/></span>
        </sec:authorize>
        <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline;">
          <button type="submit" class="btn btn-outline btn-sm"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </form>
      </sec:authorize>
      <sec:authorize access="isAnonymous()">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-sm">
          <i class="fas fa-sign-in-alt"></i> Login
        </a>
        <a href="${pageContext.request.contextPath}/register/respondent" class="btn btn-primary btn-sm">
          <i class="fas fa-user-plus"></i> Register
        </a>
      </sec:authorize>
    </div>
  </nav>

  <div style="max-width:1100px;margin:0 auto;padding:40px 24px;">
    <c:if test="${not empty success}">
      <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <div style="margin-bottom:32px;">
      <h1 style="font-size:28px;font-weight:800;">Available Surveys</h1>
      <p style="color:var(--text-muted);margin-top:4px;">Share your feedback and help improve academic programs.</p>
    </div>

    <c:choose>
      <c:when test="${empty surveys}">
        <div class="card">
          <div class="card-body text-center" style="padding:60px;">
            <i class="fas fa-poll" style="font-size:56px;color:var(--text-light);margin-bottom:20px;display:block;"></i>
            <h3 style="font-size:20px;margin-bottom:8px;">No Active Surveys</h3>
            <p class="text-muted">There are no active surveys at the moment. Check back later!</p>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="surveys-grid">
          <c:forEach var="s" items="${surveys}">
            <div class="survey-card">
              <div class="survey-card-header">
                <div>
                  <div class="survey-card-course"><i class="fas fa-book" style="margin-right:4px;"></i>${s.course.code} — ${s.course.name}</div>
                  <div class="survey-card-title">${s.title}</div>
                </div>
                <span class="badge badge-active">OPEN</span>
              </div>
              <div class="survey-card-body">
                <p class="survey-card-desc">${not empty s.description ? s.description : 'No description provided.'}</p>
                <div style="margin-top:12px;display:flex;gap:12px;font-size:12px;color:var(--text-muted);">
                  <span><i class="fas fa-question-circle"></i> ${s.questionCount} questions</span>
                  <span><i class="fas fa-users"></i> ${s.responseCount} responses</span>
                  <c:if test="${s.accessType.name() == 'BOTH' || s.accessType.name() == 'GUEST'}">
                    <span style="color:var(--success);"><i class="fas fa-user-slash"></i> Guests welcome</span>
                  </c:if>
                </div>
              </div>
              <div class="survey-card-footer">
                <div class="survey-meta">
                  <c:choose>
                    <c:when test="${s.accessType.name() == 'AUTHENTICATED'}">
                      <i class="fas fa-lock" style="color:var(--warning);"></i> Login required
                    </c:when>
                    <c:otherwise>
                      <i class="fas fa-lock-open" style="color:var(--success);"></i> Open to everyone
                    </c:otherwise>
                  </c:choose>
                </div>
                <a href="${pageContext.request.contextPath}/respondent/surveys/${s.id}" class="btn btn-primary btn-sm">
                  <i class="fas fa-pen"></i> Take Survey
                </a>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>

