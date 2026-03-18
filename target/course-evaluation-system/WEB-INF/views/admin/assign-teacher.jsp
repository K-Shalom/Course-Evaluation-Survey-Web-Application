<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Assign Teacher — ${course.code} — Admin — CES</title>
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
      <a href="${pageContext.request.contextPath}/admin/courses" class="nav-item active"><span class="nav-icon"><i class="fas fa-book"></i></span> Courses</a>
      <a href="${pageContext.request.contextPath}/admin/users" class="nav-item"><span class="nav-icon"><i class="fas fa-users"></i></span> Users</a>
    </nav>
    <div class="sidebar-footer">
      <form action="${pageContext.request.contextPath}/logout" method="post">
        <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
      </form>
    </div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <span class="header-title">Assign Teacher — ${course.code}: ${course.name}</span>
      <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline btn-sm">← Back</a>
      </div>
    </header>

    <div class="page-body">
      <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
      <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">

        <!-- ADD TEACHER FORM -->
        <div class="card">
          <div class="card-header">
            <span class="card-title"><i class="fas fa-user-plus" style="color:var(--success);margin-right:8px;"></i>Assign Teacher</span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty teachers}">
                <div class="alert alert-warning">
                  <i class="fas fa-exclamation-triangle"></i>
                  No approved teachers available. Approve teacher accounts first.
                </div>
              </c:when>
              <c:otherwise>
                <form action="${pageContext.request.contextPath}/admin/courses/${course.id}/assign-teacher" method="post">
                  <div class="form-group">
                    <label class="form-label">Select Teacher</label>
                    <select name="teacherUserId" class="form-control" required>
                      <option value="">-- Choose Teacher --</option>
                      <c:forEach var="t" items="${teachers}">
                        <option value="${t.id}">${t.fullName} (${t.email})</option>
                      </c:forEach>
                    </select>
                  </div>
                  <button type="submit" class="btn btn-success w-100">
                    <i class="fas fa-user-plus"></i> Assign to Course
                  </button>
                </form>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- CURRENTLY ASSIGNED TEACHERS -->
        <div class="card">
          <div class="card-header">
            <span class="card-title"><i class="fas fa-chalkboard-teacher" style="color:var(--primary-light);margin-right:8px;"></i>
            Assigned Teachers (${assigned.size()})</span>
          </div>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Name</th><th>Email</th><th>Action</th></tr></thead>
              <tbody>
                <c:forEach var="t" items="${assigned}">
                  <tr>
                    <td>${t.user.fullName}</td>
                    <td style="font-size:12px;">${t.user.email}</td>
                    <td>
                      <form action="${pageContext.request.contextPath}/teachers/${t.id}/unassign" method="post" style="display:inline;">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Remove this teacher from the course?')">
                          <i class="fas fa-user-minus"></i>
                        </button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty assigned}">
                  <tr><td colspan="3" class="text-center text-muted" style="padding:24px;">No teachers assigned yet.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

