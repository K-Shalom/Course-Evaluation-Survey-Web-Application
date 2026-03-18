<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${empty course.id || course.id == 0 ? 'Add Course' : 'Edit Course'} — Admin — CES</title>
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
      <span class="header-title">${empty course.id || course.id == 0 ? 'Add New Course' : 'Edit Course'}</span>
      <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline btn-sm">← Back</a>
      </div>
    </header>

    <div class="page-body">
      <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

      <div class="card" style="max-width:680px;">
        <div class="card-header">
          <span class="card-title"><i class="fas fa-book" style="color:var(--primary-light);margin-right:8px;"></i>
          Course Details</span>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/admin/courses/save" method="post">
            <input type="hidden" name="courseId" value="${course.id}">

            <div class="form-row">
              <div class="form-group">
                <label class="form-label" for="code">Course Code *</label>
                <input id="code" name="code" type="text" class="form-control"
                       placeholder="e.g. CS101" required value="${course.code}">
              </div>
              <div class="form-group">
                <label class="form-label" for="credits">Credits</label>
                <input id="credits" name="credits" type="number" class="form-control"
                       min="1" max="12" value="${empty course.credits ? 3 : course.credits}">
              </div>
            </div>

            <div class="form-group">
              <label class="form-label" for="name">Course Name *</label>
              <input id="name" name="name" type="text" class="form-control"
                     placeholder="e.g. Introduction to Computer Science" required value="${course.name}">
            </div>

            <div class="form-group">
              <label class="form-label" for="department">Department</label>
              <input id="department" name="department" type="text" class="form-control"
                     placeholder="e.g. Computer Science" value="${course.department}">
            </div>

            <div class="form-group">
              <label class="form-label" for="description">Description</label>
              <textarea id="description" name="description" class="form-control"
                        placeholder="Course description...">${course.description}</textarea>
            </div>

            <div class="form-group">
              <label class="form-check">
                <input type="checkbox" name="active" value="true"
                       ${empty course.id || course.id == 0 || course.active ? 'checked' : ''}>
                Active (visible and available for surveys)
              </label>
            </div>

            <div style="display:flex;gap:12px;">
              <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i>
                ${empty course.id || course.id == 0 ? 'Create Course' : 'Update Course'}
              </button>
              <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

