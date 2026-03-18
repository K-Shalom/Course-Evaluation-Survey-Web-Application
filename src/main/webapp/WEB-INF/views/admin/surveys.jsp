<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All Surveys — Admin — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-graduation-cap"></i></div><div class="logo-text">Course <span>Evaluation</span><br>System</div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/admin/users/pending" class="nav-item"><span class="nav-icon"><i class="fas fa-user-clock"></i></span> Pending Approvals</a>
      <a href="${pageContext.request.contextPath}/admin/users" class="nav-item"><span class="nav-icon"><i class="fas fa-users"></i></span> All Users</a>
      <a href="${pageContext.request.contextPath}/admin/courses" class="nav-item"><span class="nav-icon"><i class="fas fa-book"></i></span> Courses</a>
      <a href="${pageContext.request.contextPath}/admin/surveys" class="nav-item active"><span class="nav-icon"><i class="fas fa-poll"></i></span> All Surveys</a>
    </nav>
    <div class="sidebar-footer">
      <form action="${pageContext.request.contextPath}/logout" method="post">
        <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
      </form>
    </div>
  </aside>
  <div class="main-content">
    <header class="top-header">
      <span class="header-title">All Surveys</span>
      <div class="header-right">
        <div class="header-user"><div class="header-avatar">A</div>
          <span class="header-username"><sec:authentication property="name"/></span>
          <span class="header-role">ADMIN</span></div>
      </div>
    </header>
    <div class="page-body">
      <div class="card">
        <div class="card-header"><span class="card-title">Surveys (${surveys.size()})</span></div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>Title</th><th>Course</th><th>Initiator</th><th>Status</th><th>Responses</th><th>Access</th></tr></thead>
            <tbody>
              <c:forEach var="s" items="${surveys}">
                <tr>
                  <td><strong>${s.title}</strong></td>
                  <td><span style="color:var(--primary-light);font-size:13px;">${s.course.code}</span><br><small style="color:var(--text-muted);">${s.course.name}</small></td>
                  <td style="font-size:13px;">${s.creator.fullName}</td>
                  <td><span class="badge badge-${s.status.name().toLowerCase()}">${s.status}</span></td>
                  <td style="text-align:center;">${s.responseCount}</td>
                  <td><span class="badge badge-info">${s.accessType}</span></td>
                </tr>
              </c:forEach>
              <c:if test="${empty surveys}">
                <tr><td colspan="6" class="text-center text-muted" style="padding:40px;">No surveys yet.</td></tr>
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

