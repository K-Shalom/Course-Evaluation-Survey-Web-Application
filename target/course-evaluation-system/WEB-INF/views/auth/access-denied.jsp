<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en"><head>
  <meta charset="UTF-8">
  <title>Access Denied — CES</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container">
    <div class="auth-card text-center">
      <div style="font-size:72px;margin-bottom:16px;">🚫</div>
      <h1 style="font-size:24px;font-weight:800;margin-bottom:8px;">Access Denied</h1>
      <p class="text-muted" style="margin-bottom:24px;">
        You don't have permission to view this page.<br>
        Your account may require admin approval, or you may be accessing a restricted area.
      </p>
      <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/home"  class="btn btn-outline"><i class="fas fa-home"></i> Home</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary"><i class="fas fa-sign-in-alt"></i> Login</a>
      </div>
    </div>
  </div>
</div>
</body></html>

