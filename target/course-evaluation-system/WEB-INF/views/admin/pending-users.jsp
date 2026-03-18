<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pending Approvals — Admin — CES</title>
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
      <div class="nav-section">Main</div>
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
        <span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard
      </a>
      <div class="nav-section">User Management</div>
      <a href="${pageContext.request.contextPath}/admin/users/pending" class="nav-item active">
        <span class="nav-icon"><i class="fas fa-user-clock"></i></span> Pending Approvals
      </a>
      <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
        <span class="nav-icon"><i class="fas fa-users"></i></span> All Users
      </a>
      <div class="nav-section">Academic</div>
      <a href="${pageContext.request.contextPath}/admin/courses" class="nav-item">
        <span class="nav-icon"><i class="fas fa-book"></i></span> Courses
      </a>
      <div class="nav-section">Surveys</div>
      <a href="${pageContext.request.contextPath}/admin/surveys" class="nav-item">
        <span class="nav-icon"><i class="fas fa-poll"></i></span> All Surveys
      </a>
    </nav>
    <div class="sidebar-footer">
      <form action="${pageContext.request.contextPath}/logout" method="post">
        <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
      </form>
    </div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <span class="header-title">Pending User Approvals</span>
      <div class="header-right">
        <div class="header-user">
          <div class="header-avatar">A</div>
          <span class="header-username"><sec:authentication property="name"/></span>
          <span class="header-role">ADMIN</span>
        </div>
      </div>
    </header>

    <div class="page-body">
      <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
      </c:if>

      <div class="alert alert-info">
        <i class="fas fa-info-circle"></i>
        Users below have verified their email and are waiting for your approval.
        Approval emails are sent automatically.
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Users Awaiting Approval (${users.size()})</span>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Username</th>
                <th>Email</th>
                <th>Role Requested</th>
                <th>Registered</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="u" items="${users}">
                <tr>
                  <td><strong>${u.fullName}</strong></td>
                  <td style="color:var(--text-muted);">${u.username}</td>
                  <td>${u.email}</td>
                  <td><span class="badge badge-${u.role.name.toLowerCase()}">${u.role.name}</span></td>
                  <td style="color:var(--text-muted);font-size:12px;">${u.createdAt}</td>
                  <td>
                    <form action="${pageContext.request.contextPath}/admin/users/${u.id}/approve" method="post" style="display:inline;">
                      <button type="submit" class="btn btn-success btn-sm">
                        <i class="fas fa-check"></i> Approve
                      </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/users/${u.id}/reject" method="post" style="display:inline;">
                      <button type="submit" class="btn btn-danger btn-sm"
                              onclick="return confirm('Reject this registration?')">
                        <i class="fas fa-times"></i> Reject
                      </button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty users}">
                <tr>
                  <td colspan="6" class="text-center" style="padding:40px;color:var(--text-muted);">
                    <i class="fas fa-check-circle" style="font-size:32px;color:var(--success);display:block;margin-bottom:12px;"></i>
                    No pending approvals. All caught up!
                  </td>
                </tr>
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

