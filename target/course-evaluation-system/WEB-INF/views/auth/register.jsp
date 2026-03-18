<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <c:choose>
    <c:when test="${role == 'INITIATOR'}"><title>Register as Survey Initiator — CES</title></c:when>
    <c:when test="${role == 'TEACHER'}"><title>Register as Teacher — CES</title></c:when>
    <c:otherwise><title>Register as Student — CES</title></c:otherwise>
  </c:choose>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container" style="max-width:520px;">
    <div class="auth-logo">
      <div class="icon">
        <c:choose>
          <c:when test="${role == 'TEACHER'}"><i class="fas fa-chalkboard-teacher"></i></c:when>
          <c:when test="${role == 'INITIATOR'}"><i class="fas fa-clipboard-list"></i></c:when>
          <c:otherwise><i class="fas fa-graduation-cap"></i></c:otherwise>
        </c:choose>
      </div>
      <h1>
        <c:choose>
          <c:when test="${role == 'INITIATOR'}">Register as Survey Initiator</c:when>
          <c:when test="${role == 'TEACHER'}">Register as Teacher</c:when>
          <c:otherwise>Register as Student</c:otherwise>
        </c:choose>
      </h1>
      <p>Fill in your details. Admin approval required after email verification.</p>
    </div>

    <div class="auth-card">
      <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
      </c:if>

      <!-- Info box about approval flow -->
      <div class="alert alert-info">
        <i class="fas fa-info-circle"></i>
        <div>
          <strong>Registration Process:</strong><br>
          1. Fill in and submit this form<br>
          2. Verify your email address (check inbox)<br>
          3. Wait for Administrator approval<br>
          4. Receive an approval email and log in
        </div>
      </div>

      <c:choose>
        <c:when test="${role == 'INITIATOR'}">
          <form action="${pageContext.request.contextPath}/register/initiator" method="post">
        </c:when>
        <c:when test="${role == 'TEACHER'}">
          <form action="${pageContext.request.contextPath}/register/teacher" method="post">
        </c:when>
        <c:otherwise>
          <form action="${pageContext.request.contextPath}/register/respondent" method="post">
        </c:otherwise>
      </c:choose>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="firstName">First Name *</label>
            <input id="firstName" name="firstName" type="text" class="form-control"
                   placeholder="John" required value="${user.firstName}">
          </div>
          <div class="form-group">
            <label class="form-label" for="lastName">Last Name *</label>
            <input id="lastName" name="lastName" type="text" class="form-control"
                   placeholder="Doe" required value="${user.lastName}">
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="username">Username *</label>
          <input id="username" name="username" type="text" class="form-control"
                 placeholder="Choose a unique username" required value="${user.username}">
        </div>

        <div class="form-group">
          <label class="form-label" for="email">Email Address *</label>
          <input id="email" name="email" type="email" class="form-control"
                 placeholder="your@email.com" required value="${user.email}">
          <small style="color:var(--text-light);font-size:12px;">
            A verification link will be sent to this email.
          </small>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="password">Password *</label>
            <input id="password" name="password" type="password" class="form-control"
                   placeholder="Min. 8 characters" required minlength="8">
          </div>
          <div class="form-group">
            <label class="form-label" for="confirmPassword">Confirm Password *</label>
            <input id="confirmPassword" name="confirmPassword" type="password" class="form-control"
                   placeholder="Repeat password" required>
          </div>
        </div>

        <div id="pwd-mismatch" class="alert alert-danger" style="display:none;margin-bottom:16px;">
          <i class="fas fa-exclamation-circle"></i> Passwords do not match.
        </div>

        <button type="submit" id="register-btn" class="btn btn-primary w-100 btn-lg">
          <i class="fas fa-user-plus"></i> Create Account
        </button>
      </form>

      <p class="text-center mt-2" style="font-size:13px;color:var(--text-muted);">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login">Sign in</a>
      </p>
    </div>
  </div>
</div>

<script>
  document.querySelector('form').addEventListener('submit', function(e) {
    var pwd = document.getElementById('password').value;
    var cpwd = document.getElementById('confirmPassword').value;
    var mismatch = document.getElementById('pwd-mismatch');
    if (pwd !== cpwd) {
      e.preventDefault();
      mismatch.style.display = 'flex';
    } else {
      mismatch.style.display = 'none';
    }
  });
</script>
</body>
</html>

