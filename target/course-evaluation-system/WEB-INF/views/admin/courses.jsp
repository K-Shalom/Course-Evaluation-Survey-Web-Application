<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Courses — Admin — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon"><i class="fas fa-graduation-cap"></i></div>
      <div class="logo-text">Course <span>Evaluation</span><br>System</div>
    </div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/admin/users/pending" class="nav-item"><span class="nav-icon"><i class="fas fa-user-clock"></i></span> Pending Approvals</a>
      <a href="${pageContext.request.contextPath}/admin/users" class="nav-item"><span class="nav-icon"><i class="fas fa-users"></i></span> All Users</a>
      <a href="${pageContext.request.contextPath}/admin/courses" class="nav-item active"><span class="nav-icon"><i class="fas fa-book"></i></span> Courses</a>
      <a href="${pageContext.request.contextPath}/admin/surveys" class="nav-item"><span class="nav-icon"><i class="fas fa-poll"></i></span> Surveys</a>
    </nav>
    <div class="sidebar-footer">
      <form action="${pageContext.request.contextPath}/logout" method="post">
        <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
      </form>
    </div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <span class="header-title">Course Management</span>
      <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary btn-sm">
          <i class="fas fa-plus"></i> Add Course
        </a>
        <div class="header-user">
          <div class="header-avatar">A</div>
          <span class="header-username"><sec:authentication property="name"/></span>
          <span class="header-role">ADMIN</span>
        </div>
      </div>
    </header>

    <div class="page-body">
      <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
      <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

      <div class="card">
        <div class="card-header">
          <span class="card-title">All Courses (${courses.size()})</span>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr><th>Code</th><th>Name</th><th>Department</th><th>Credits</th><th>Teachers</th><th>Surveys</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <c:forEach var="c" items="${courses}">
                <tr>
                  <td><strong style="color:var(--primary-light);">${c.code}</strong></td>
                  <td>${c.name}</td>
                  <td style="color:var(--text-muted);">${c.department}</td>
                  <td style="text-align:center;">${c.credits}</td>
                  <td style="text-align:center;">${c.teacherCount}</td>
                  <td style="text-align:center;">${c.surveyCount}</td>
                  <td>
                    <span class="badge ${c.active ? 'badge-active' : 'badge-closed'}">
                      ${c.active ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                  <td>
                    <a href="${pageContext.request.contextPath}/admin/courses/${c.id}/edit" class="btn btn-info btn-sm" title="Edit">
                      <i class="fas fa-edit"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/courses/${c.id}/assign-teacher" class="btn btn-success btn-sm" title="Assign Teacher">
                      <i class="fas fa-user-plus"></i>
                    </a>
                    <form action="${pageContext.request.contextPath}/admin/courses/${c.id}/delete" method="post" style="display:inline;"
                          onsubmit="return confirm('Delete course ${c.code}?')">
                      <button class="btn btn-danger btn-sm" title="Delete"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty courses}">
                <tr><td colspan="8" class="text-center text-muted" style="padding:40px;">No courses yet. <a href="${pageContext.request.contextPath}/admin/courses/new">Add one</a></td></tr>
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

