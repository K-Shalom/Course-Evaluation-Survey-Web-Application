<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>All Users — Admin — CES</title>
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
      <a href="${pageContext.request.contextPath}/admin/users" class="nav-item active"><span class="nav-icon"><i class="fas fa-users"></i></span> All Users</a>
      <a href="${pageContext.request.contextPath}/admin/courses" class="nav-item"><span class="nav-icon"><i class="fas fa-book"></i></span> Courses</a>
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
      <span class="header-title">User Management</span>
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

      <!-- Filter Bar -->
      <div class="card mb-3" style="margin-bottom:20px;">
        <div class="card-body" style="padding:16px 24px;">
          <form method="get" style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap;">
            <div class="form-group" style="margin:0;min-width:160px;">
              <label class="form-label">Filter by Role</label>
              <select name="role" class="form-control">
                <option value="ALL" ${selectedRole=='ALL'?'selected':''}>All Roles</option>
                <option value="ADMIN"     ${selectedRole=='ADMIN'?'selected':''}>Admin</option>
                <option value="INITIATOR" ${selectedRole=='INITIATOR'?'selected':''}>Initiator</option>
                <option value="TEACHER"   ${selectedRole=='TEACHER'?'selected':''}>Teacher</option>
                <option value="RESPONDENT"${selectedRole=='RESPONDENT'?'selected':''}>Respondent</option>
              </select>
            </div>
            <button type="submit" class="btn btn-primary">Filter</button>
          </form>
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">All Users (${users.size()})</span>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Verified</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <c:forEach var="u" items="${users}">
                <tr>
                  <td>
                    <strong>${u.fullName}</strong>
                    <div style="font-size:12px;color:var(--text-muted);">@${u.username}</div>
                  </td>
                  <td style="font-size:13px;">${u.email}</td>
                  <td><span class="badge badge-${u.role.name.toLowerCase()}">${u.role.name}</span></td>
                  <td><span class="badge badge-${u.status.name().toLowerCase()}">${u.status}</span></td>
                  <td>
                    <c:choose>
                      <c:when test="${u.emailVerified}"><i class="fas fa-check-circle" style="color:var(--success);"></i></c:when>
                      <c:otherwise><i class="fas fa-clock" style="color:var(--warning);"></i></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:if test="${u.status.name() == 'ACTIVE'}">
                      <form action="${pageContext.request.contextPath}/admin/users/${u.id}/suspend" method="post" style="display:inline;">
                        <button class="btn btn-warning btn-sm" title="Suspend"><i class="fas fa-ban"></i></button>
                      </form>
                    </c:if>
                    <c:if test="${u.status.name() == 'SUSPENDED'}">
                      <form action="${pageContext.request.contextPath}/admin/users/${u.id}/activate" method="post" style="display:inline;">
                        <button class="btn btn-success btn-sm" title="Activate"><i class="fas fa-play"></i></button>
                      </form>
                    </c:if>
                    <c:if test="${u.role.name != 'ADMIN'}">
                      <form action="${pageContext.request.contextPath}/admin/users/${u.id}/delete" method="post" style="display:inline;"
                            onsubmit="return confirm('Delete user ${u.username}?')">
                        <button class="btn btn-danger btn-sm" title="Delete"><i class="fas fa-trash"></i></button>
                      </form>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

