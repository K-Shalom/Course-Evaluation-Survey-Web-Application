<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — Course Evaluation System</title>
  <meta name="description" content="Sign in to the Course Evaluation Survey System">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container">
    <div class="auth-logo">
      <div class="icon"><i class="fas fa-graduation-cap"></i></div>
      <h1>Welcome Back</h1>
      <p>Sign in to your CES account</p>
    </div>

    <div class="auth-card">
      <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
      </c:if>

      <form id="login-form" action="${pageContext.request.contextPath}/login-process" method="post">
        <div class="form-group">
          <label class="form-label" for="username">Username or Email</label>
          <input id="username" name="username" type="text" class="form-control"
                 placeholder="Enter your username" required autocomplete="username">
        </div>
        <div class="form-group">
          <label class="form-label" for="password">Password</label>
          <div style="position:relative;">
            <input id="password" name="password" type="password" class="form-control"
                   placeholder="Enter your password" required autocomplete="current-password"
                   style="padding-right:44px;">
            <button type="button" id="toggle-pwd"
                    style="position:absolute;right:12px;top:50%;transform:translateY(-50%);
                           background:none;border:none;color:var(--text-muted);cursor:pointer;font-size:15px;">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>

        <div style="display:flex;justify-content:flex-end;margin-bottom:20px;">
          <a href="${pageContext.request.contextPath}/forgot-password" style="font-size:13px;">
            Forgot password?
          </a>
        </div>

        <button type="submit" id="login-btn" class="btn btn-primary w-100 btn-lg">
          <i class="fas fa-sign-in-alt"></i> Sign In
        </button>
      </form>

      <div class="auth-divider"><span>New to CES?</span></div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
        <a href="${pageContext.request.contextPath}/register/initiator" class="btn btn-outline" style="justify-content:center;font-size:12px;">
          <i class="fas fa-user-plus"></i> As Initiator
        </a>
        <a href="${pageContext.request.contextPath}/register/teacher" class="btn btn-outline" style="justify-content:center;font-size:12px;">
          <i class="fas fa-chalkboard-teacher"></i> As Teacher
        </a>
        <a href="${pageContext.request.contextPath}/register/respondent" class="btn btn-outline" style="grid-column:1/-1;justify-content:center;font-size:12px;">
          <i class="fas fa-graduation-cap"></i> As Student (Respondent)
        </a>
      </div>
      <div class="text-center mt-2">
        <a href="${pageContext.request.contextPath}/home" style="font-size:12px;color:var(--text-light);">
          ← Back to Homepage
        </a>
      </div>
    </div>
  </div>
</div>

<script>
  document.getElementById('toggle-pwd').addEventListener('click', function(){
    var pwd = document.getElementById('password');
    var icon = this.querySelector('i');
    if (pwd.type === 'password') {
      pwd.type = 'text';
      icon.className = 'fas fa-eye-slash';
    } else {
      pwd.type = 'password';
      icon.className = 'fas fa-eye';
    }
  });
</script>
</body>
</html>

