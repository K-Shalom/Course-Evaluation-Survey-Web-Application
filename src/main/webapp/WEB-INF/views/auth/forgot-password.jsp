<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en"><head>
  <meta charset="UTF-8">
  <title>Forgot Password — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container">
    <div class="auth-logo">
      <div class="icon"><i class="fas fa-key"></i></div>
      <h1>Forgot Password</h1>
      <p>Enter your email and we'll send a reset link.</p>
    </div>
    <div class="auth-card">
      <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
      <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>
      <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <div class="form-group">
          <label class="form-label">Email Address</label>
          <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
        </div>
        <button type="submit" class="btn btn-primary w-100"><i class="fas fa-paper-plane"></i> Send Reset Link</button>
      </form>
      <p class="text-center mt-2" style="font-size:13px;">
        <a href="${pageContext.request.contextPath}/login">← Back to Login</a>
      </p>
    </div>
  </div>
</div>
</body></html>

