<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — CES</title>
  <meta name="description" content="Administrator dashboard for Course Evaluation System">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">

  <!-- SIDEBAR -->
  <aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon"><i class="fas fa-graduation-cap"></i></div>
      <div class="logo-text">Course <span>Evaluation</span><br>System</div>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-section">Main</div>
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active">
        <span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard
      </a>
      <div class="nav-section">User Management</div>
      <a href="${pageContext.request.contextPath}/admin/users/pending" class="nav-item">
        <span class="nav-icon"><i class="fas fa-user-clock"></i></span> Pending Approvals
        <c:if test="${pendingCount > 0}"><span class="nav-badge">${pendingCount}</span></c:if>
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
        <button type="submit" class="btn btn-outline w-100">
          <i class="fas fa-sign-out-alt"></i> Logout
        </button>
      </form>
    </div>
  </aside>

  <!-- MAIN -->
  <div class="main-content">
    <header class="top-header">
      <span class="header-title">Admin Dashboard</span>
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

      <!-- STAT CARDS -->
      <div class="stats-grid">
        <div class="stat-card" style="--stat-color:#4f46e5;--stat-bg:rgba(79,70,229,0.15);">
          <div class="stat-icon"><i class="fas fa-users" style="color:#4f46e5;"></i></div>
          <div>
            <div class="stat-value">${totalUsers}</div>
            <div class="stat-label">Total Users</div>
          </div>
        </div>
        <div class="stat-card" style="--stat-color:#f59e0b;--stat-bg:rgba(245,158,11,0.15);">
          <div class="stat-icon"><i class="fas fa-user-clock" style="color:#f59e0b;"></i></div>
          <div>
            <div class="stat-value">${pendingCount}</div>
            <div class="stat-label">Pending Approvals</div>
          </div>
        </div>
        <div class="stat-card" style="--stat-color:#10b981;--stat-bg:rgba(16,185,129,0.15);">
          <div class="stat-icon"><i class="fas fa-book" style="color:#10b981;"></i></div>
          <div>
            <div class="stat-value">${courseCount}</div>
            <div class="stat-label">Total Courses</div>
          </div>
        </div>
        <div class="stat-card" style="--stat-color:#7c3aed;--stat-bg:rgba(124,58,237,0.15);">
          <div class="stat-icon"><i class="fas fa-poll" style="color:#7c3aed;"></i></div>
          <div>
            <div class="stat-value">${surveyCount}</div>
            <div class="stat-label">Total Surveys</div>
          </div>
        </div>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">

        <!-- PENDING USERS -->
        <div class="card">
          <div class="card-header">
            <span class="card-title"><i class="fas fa-user-clock" style="color:#f59e0b;margin-right:8px;"></i>Pending Approvals</span>
            <a href="${pageContext.request.contextPath}/admin/users/pending" class="btn btn-outline btn-sm">View All</a>
          </div>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Name</th><th>Role</th><th>Actions</th></tr></thead>
              <tbody>
                <c:forEach var="u" items="${pendingUsers}" end="4">
                  <tr>
                    <td>
                      <div>${u.fullName}</div>
                      <div style="font-size:12px;color:var(--text-muted);">${u.email}</div>
                    </td>
                    <td><span class="badge badge-${u.role.name.toLowerCase()}">${u.role.name}</span></td>
                    <td>
                      <form action="${pageContext.request.contextPath}/admin/users/${u.id}/approve" method="post" style="display:inline;">
                        <button class="btn btn-success btn-sm" title="Approve"><i class="fas fa-check"></i></button>
                      </form>
                      <form action="${pageContext.request.contextPath}/admin/users/${u.id}/reject" method="post" style="display:inline;">
                        <button class="btn btn-danger btn-sm" title="Reject"><i class="fas fa-times"></i></button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty pendingUsers}">
                  <tr><td colspan="3" class="text-center text-muted" style="padding:24px;">No pending approvals 🎉</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>

        <!-- RECENT SURVEYS -->
        <div class="card">
          <div class="card-header">
            <span class="card-title"><i class="fas fa-poll" style="color:#7c3aed;margin-right:8px;"></i>Recent Surveys</span>
            <a href="${pageContext.request.contextPath}/admin/surveys" class="btn btn-outline btn-sm">View All</a>
          </div>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Survey</th><th>Course</th><th>Status</th></tr></thead>
              <tbody>
                <c:forEach var="s" items="${recentSurveys}">
                  <tr>
                    <td style="font-size:13px;">${s.title}</td>
                    <td><span style="font-size:12px;color:var(--primary-light);">${s.course.code}</span></td>
                    <td><span class="badge badge-${s.status.name().toLowerCase()}">${s.status}</span></td>
                  </tr>
                </c:forEach>
                <c:if test="${empty recentSurveys}">
                  <tr><td colspan="3" class="text-center text-muted" style="padding:24px;">No surveys yet</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- QUICK ACTIONS -->
      <div class="card mt-3">
        <div class="card-header">
          <span class="card-title">Quick Actions</span>
        </div>
        <div class="card-body">
          <div style="display:flex;gap:12px;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary">
              <i class="fas fa-plus"></i> Add Course
            </a>
            <a href="${pageContext.request.contextPath}/admin/users/pending" class="btn btn-warning">
              <i class="fas fa-user-check"></i> Review Pending Users
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-info">
              <i class="fas fa-users"></i> Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/admin/surveys" class="btn btn-outline">
              <i class="fas fa-poll"></i> View All Surveys
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

