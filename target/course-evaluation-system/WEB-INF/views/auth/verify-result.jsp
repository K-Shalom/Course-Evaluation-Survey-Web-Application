<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en"><head>
  <meta charset="UTF-8">
  <title>Email Verified — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container">
    <div class="auth-card text-center">
      <c:choose>
        <c:when test="${not empty success}">
          <div style="font-size:56px;margin-bottom:16px;">✅</div>
          <h2 style="font-size:22px;font-weight:700;margin-bottom:8px;">Email Verified!</h2>
          <p class="text-muted">${success}</p>
        </c:when>
        <c:otherwise>
          <div style="font-size:56px;margin-bottom:16px;">❌</div>
          <h2 style="font-size:22px;font-weight:700;margin-bottom:8px;">Verification Failed</h2>
          <p class="text-muted">${error}</p>
        </c:otherwise>
      </c:choose>
      <a href="${pageContext.request.contextPath}/login" class="btn btn-primary mt-3">
        <i class="fas fa-sign-in-alt"></i> Go to Login
      </a>
    </div>
  </div>
</div>
</body></html>

