<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Teacher Dashboard — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-chalkboard-teacher"></i></div><div class="logo-text">Teacher <span>Portal</span><br>&nbsp;</div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-item active"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/teacher/surveys"   class="nav-item"><span class="nav-icon"><i class="fas fa-poll"></i></span> My Course Surveys</a>
    </nav>
    <div class="sidebar-footer"><form action="${pageContext.request.contextPath}/logout" method="post">
      <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </form></div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <span class="header-title">Teacher Dashboard</span>
      <div class="header-right">
        <div class="header-user"><div class="header-avatar">T</div>
          <span class="header-username"><sec:authentication property="name"/></span>
          <span class="header-role">TEACHER</span></div>
      </div>
    </header>

    <div class="page-body">
      <div class="alert alert-info">
        <i class="fas fa-info-circle"></i>
        Below are all surveys created for your assigned courses. Encourage your students to complete them!
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Surveys for My Courses (${surveys.size()})</span>
        </div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>Survey</th><th>Course</th><th>Status</th><th>Responses</th><th>Access</th><th>Actions</th></tr></thead>
            <tbody>
              <c:forEach var="s" items="${surveys}">
                <tr>
                  <td><strong>${s.title}</strong></td>
                  <td><span style="color:var(--primary-light);">${s.course.code}</span><br>
                    <small style="color:var(--text-muted);">${s.course.name}</small></td>
                  <td><span class="badge badge-${s.status.name().toLowerCase()}">${s.status}</span></td>
                  <td style="text-align:center;">${s.responseCount}</td>
                  <td style="font-size:12px;color:var(--text-muted);">${s.accessType}</td>
                  <td>
                    <a href="${pageContext.request.contextPath}/teacher/surveys/${s.id}/results"     class="btn btn-success btn-sm" title="Results"><i class="fas fa-chart-bar"></i> Results</a>
                    <a href="${pageContext.request.contextPath}/teacher/surveys/${s.id}/respondents" class="btn btn-info btn-sm"    title="Respondents"><i class="fas fa-users"></i></a>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty surveys}">
                <tr><td colspan="6" class="text-center text-muted" style="padding:40px;">
                  No surveys for your courses yet.
                </td></tr>
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

