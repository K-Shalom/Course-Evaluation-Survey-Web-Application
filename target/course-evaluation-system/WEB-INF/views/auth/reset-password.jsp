<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en"><head>
  <meta charset="UTF-8">
  <title>Reset Password — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container">
    <div class="auth-logo">
      <div class="icon"><i class="fas fa-lock"></i></div>
      <h1>Set New Password</h1>
      <p>Choose a strong password for your account.</p>
    </div>
    <div class="auth-card">
      <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>
      <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetForm">
        <input type="hidden" name="token" value="${token}">
        <div class="form-group">
          <label class="form-label">New Password</label>
          <input id="newPassword" type="password" name="newPassword" class="form-control"
                 placeholder="Min. 8 characters" required minlength="8">
        </div>
        <div class="form-group">
          <label class="form-label">Confirm Password</label>
          <input id="confirmPassword" type="password" name="confirmPassword" class="form-control"
                 placeholder="Repeat your password" required>
        </div>
        <div id="pwd-mismatch" class="alert alert-danger" style="display:none;">
          <i class="fas fa-exclamation-circle"></i> Passwords do not match.
        </div>
        <button type="submit" class="btn btn-primary w-100"><i class="fas fa-save"></i> Set New Password</button>
      </form>
    </div>
  </div>
</div>
<script>
document.getElementById('resetForm').addEventListener('submit', function(e) {
  var p = document.getElementById('newPassword').value;
  var c = document.getElementById('confirmPassword').value;
  if (p !== c) { e.preventDefault(); document.getElementById('pwd-mismatch').style.display='flex'; }
});
</script>
</body></html>

