<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Surveys — Initiator — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-clipboard-list"></i></div><div class="logo-text">Survey <span>Initiator</span><br>Portal</div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/initiator/dashboard"   class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/initiator/surveys"     class="nav-item active"><span class="nav-icon"><i class="fas fa-poll"></i></span> My Surveys</a>
      <a href="${pageContext.request.contextPath}/initiator/surveys/new" class="nav-item"><span class="nav-icon"><i class="fas fa-plus-circle"></i></span> Create Survey</a>
    </nav>
    <div class="sidebar-footer"><form action="${pageContext.request.contextPath}/logout" method="post">
      <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </form></div>
  </aside>
  <div class="main-content">
    <header class="top-header">
      <span class="header-title">My Surveys</span>
      <div class="header-right">
        <a href="${pageContext.request.contextPath}/initiator/surveys/new" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> New Survey</a>
        <div class="header-user"><div class="header-avatar">I</div>
          <span class="header-username"><sec:authentication property="name"/></span>
          <span class="header-role">INITIATOR</span></div>
      </div>
    </header>
    <div class="page-body">
      <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
      <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

      <div class="card">
        <div class="card-header"><span class="card-title">All My Surveys (${surveys.size()})</span></div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>Title</th><th>Course</th><th>Status</th><th>Responses</th><th>Access</th><th>Actions</th></tr></thead>
            <tbody>
              <c:forEach var="s" items="${surveys}">
                <tr>
                  <td><strong>${s.title}</strong><br><small style="color:var(--text-muted);">${s.description}</small></td>
                  <td><span style="color:var(--primary-light);">${s.course.code}</span><br><small style="color:var(--text-muted);">${s.course.name}</small></td>
                  <td><span class="badge badge-${s.status.name().toLowerCase()}">${s.status}</span></td>
                  <td style="text-align:center;">${s.responseCount}</td>
                  <td style="font-size:12px;color:var(--text-muted);">${s.accessType}</td>
                  <td>
                    <a href="${pageContext.request.contextPath}/initiator/surveys/${s.id}/questions" class="btn btn-info btn-sm" title="Questions"><i class="fas fa-list-ol"></i></a>
                    <a href="${pageContext.request.contextPath}/initiator/surveys/${s.id}/results"   class="btn btn-success btn-sm" title="Results"><i class="fas fa-chart-bar"></i></a>
                    <a href="${pageContext.request.contextPath}/initiator/surveys/${s.id}/edit"      class="btn btn-outline btn-sm" title="Edit"><i class="fas fa-edit"></i></a>
                    <c:if test="${s.status.name() == 'DRAFT'}">
                      <form action="${pageContext.request.contextPath}/initiator/surveys/${s.id}/publish" method="post" style="display:inline;">
                        <button class="btn btn-primary btn-sm" title="Publish"><i class="fas fa-rocket"></i></button>
                      </form>
                    </c:if>
                    <c:if test="${s.status.name() == 'ACTIVE'}">
                      <form action="${pageContext.request.contextPath}/initiator/surveys/${s.id}/close" method="post" style="display:inline;">
                        <button class="btn btn-warning btn-sm" title="Close"><i class="fas fa-stop"></i></button>
                      </form>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/initiator/surveys/${s.id}/delete" method="post" style="display:inline;"
                          onsubmit="return confirm('Delete this survey and all its data?')">
                      <button class="btn btn-danger btn-sm"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty surveys}">
                <tr><td colspan="6" class="text-center text-muted" style="padding:40px;">
                  No surveys yet. <a href="${pageContext.request.contextPath}/initiator/surveys/new">Create your first survey!</a>
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

