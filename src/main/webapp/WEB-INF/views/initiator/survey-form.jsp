<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${empty survey.id || survey.id == 0 ? 'Create Survey' : 'Edit Survey'} — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-wrapper">
  <aside class="sidebar">
    <div class="sidebar-logo"><div class="logo-icon"><i class="fas fa-clipboard-list"></i></div><div class="logo-text">Survey <span>Initiator</span><br>Portal</div></div>
    <nav class="sidebar-nav">
      <a href="${pageContext.request.contextPath}/initiator/dashboard"  class="nav-item"><span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
      <a href="${pageContext.request.contextPath}/initiator/surveys"    class="nav-item"><span class="nav-icon"><i class="fas fa-poll"></i></span> My Surveys</a>
      <a href="${pageContext.request.contextPath}/initiator/surveys/new" class="nav-item active"><span class="nav-icon"><i class="fas fa-plus-circle"></i></span> Create Survey</a>
    </nav>
    <div class="sidebar-footer">
      <form action="${pageContext.request.contextPath}/logout" method="post">
        <button type="submit" class="btn btn-outline w-100"><i class="fas fa-sign-out-alt"></i> Logout</button>
      </form>
    </div>
  </aside>

  <div class="main-content">
    <header class="top-header">
      <span class="header-title">${empty survey.id || survey.id == 0 ? 'Create New Survey' : 'Edit Survey'}</span>
      <div class="header-right">
        <a href="${pageContext.request.contextPath}/initiator/surveys" class="btn btn-outline btn-sm">← Back</a>
      </div>
    </header>

    <div class="page-body">
      <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

      <div class="card" style="max-width:760px;">
        <div class="card-header">
          <span class="card-title"><i class="fas fa-poll" style="color:var(--primary-light);margin-right:8px;"></i>Survey Details</span>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/initiator/surveys/save" method="post">
            <input type="hidden" name="id" value="${survey.id}">

            <div class="form-group">
              <label class="form-label" for="title">Survey Title *</label>
              <input id="title" name="title" type="text" class="form-control"
                     placeholder="e.g. End of Term Evaluation - CS101" required value="${survey.title}">
            </div>

            <div class="form-group">
              <label class="form-label" for="description">Description</label>
              <textarea id="description" name="description" class="form-control"
                        placeholder="Brief description of this survey...">${survey.description}</textarea>
            </div>

            <div class="form-group">
              <label class="form-label" for="courseId">Course *</label>
              <select id="courseId" name="courseId" class="form-control" required>
                <option value="">-- Select Course --</option>
                <c:forEach var="course" items="${courses}">
                  <option value="${course.id}" ${survey.courseId == course.id ? 'selected' : ''}>
                    ${course.code} — ${course.name}
                  </option>
                </c:forEach>
              </select>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label class="form-label" for="startDate">Start Date</label>
                <input id="startDate" name="startDate" type="datetime-local" class="form-control"
                       value="${survey.startDate}">
              </div>
              <div class="form-group">
                <label class="form-label" for="endDate">End Date</label>
                <input id="endDate" name="endDate" type="datetime-local" class="form-control"
                       value="${survey.endDate}">
              </div>
            </div>

            <!-- Access Settings -->
            <div class="card" style="margin-bottom:20px;background:var(--bg-card2);">
              <div class="card-header" style="padding:14px 20px;">
                <span class="card-title" style="font-size:14px;">
                  <i class="fas fa-lock" style="color:var(--primary-light);margin-right:8px;"></i>Access Settings
                </span>
              </div>
              <div class="card-body" style="padding:20px;">
                <div class="form-group">
                  <label class="form-label">Who can respond?</label>
                  <select name="accessType" class="form-control">
                    <option value="BOTH"          ${survey.accessType.name() == 'BOTH' ? 'selected' : ''}>
                      Both (Authenticated users & Guests)
                    </option>
                    <option value="AUTHENTICATED" ${survey.accessType.name() == 'AUTHENTICATED' ? 'selected' : ''}>
                      Authenticated Users Only (must log in)
                    </option>
                    <option value="GUEST"         ${survey.accessType.name() == 'GUEST' ? 'selected' : ''}>
                      Guests Only (no login required)
                    </option>
                  </select>
                </div>
                <div class="form-group">
                  <label class="form-check">
                    <input type="checkbox" name="requireEmail" value="true" ${survey.requireEmail ? 'checked' : ''}>
                    Require email address from guests
                  </label>
                </div>
                <div class="form-group">
                  <label class="form-check">
                    <input type="checkbox" name="sendConfirmation" value="true" ${survey.sendConfirmation ? 'checked' : ''}>
                    Send confirmation email to respondent
                  </label>
                </div>
                <div class="form-group">
                  <label class="form-check">
                    <input type="checkbox" name="allowAnonymous" value="true" ${survey.allowAnonymous ? 'checked' : ''}>
                    Allow anonymous responses (no email required)
                  </label>
                </div>
              </div>
            </div>

            <div style="display:flex;gap:12px;">
              <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i>
                ${empty survey.id || survey.id == 0 ? 'Create & Add Questions' : 'Save Changes'}
              </button>
              <a href="${pageContext.request.contextPath}/initiator/surveys" class="btn btn-outline">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>

