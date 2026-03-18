<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Results — ${survey.title} — Teacher — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-chalkboard-teacher"></i></div><div class="logo-text">Teacher <span>Portal</span><br>&nbsp;</div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/teacher/surveys"   class="nav-item active"><span class="nav-icon"><i class="fas fa-poll"></i></span> My Course Surveys</a>
    </nav>
    <div class="sidebar-footer"><form action="${pageContext.request.contextPath}/logout" method="post">
      <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </form></div>
  </aside>
  <div class="main-content">
    <header class="top-header">
      <span class="header-title"><i class="fas fa-chart-bar" style="color:var(--success);margin-right:8px;"></i>Survey Results</span>
      <div class="header-right">
        <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-outline btn-sm">← Back</a>
      </div>
    </header>
    <div class="page-body">
      <div class="card mb-3" style="margin-bottom:24px;">
        <div class="card-body">
          <div style="display:grid;grid-template-columns:1fr auto;gap:16px;align-items:start;">
            <div>
              <h2 style="font-size:20px;font-weight:700;margin-bottom:6px;">${survey.title}</h2>
              <p style="color:var(--text-muted);font-size:14px;">${survey.description}</p>
              <p style="margin-top:8px;">
                <span class="badge badge-${survey.status.name().toLowerCase()}">${survey.status}</span>
                <span style="color:var(--primary-light);font-size:13px;margin-left:8px;">${survey.course.code} — ${survey.course.name}</span>
              </p>
            </div>
            <div style="text-align:right;">
              <div style="font-size:40px;font-weight:800;color:var(--success);">${totalResp}</div>
              <div style="color:var(--text-muted);font-size:13px;">Total Responses</div>
            </div>
          </div>
        </div>
      </div>

      <c:forEach var="q" items="${survey.questions}" varStatus="status">
        <div class="card mb-3" style="margin-bottom:20px;">
          <div class="card-header">
            <span class="card-title"><span class="question-num">${status.index + 1}</span> ${q.questionText}</span>
            <span class="question-type-badge">${q.questionType}</span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${q.questionType.name() == 'TEXT'}">
                <p class="text-muted" style="font-size:13px;font-style:italic;">Free-text answers — view in detailed responses.</p>
              </c:when>
              <c:otherwise>
                <c:forEach var="opt" items="${q.options}">
                  <div class="result-option">
                    <div class="result-label">${opt.optionText}</div>
                    <div class="result-bar-wrap">
                      <c:set var="pct" value="${totalResp > 0 ? (opt.responseCount * 100 / totalResp) : 0}"/>
                      <div class="result-bar" style="width:${pct}%;"></div>
                    </div>
                    <div class="result-count">${opt.responseCount} <span style="font-size:11px;color:var(--text-muted);">(${pct}%)</span></div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>
</body>
</html>

