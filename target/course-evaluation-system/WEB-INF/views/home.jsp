<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Evaluation System</title>
  <meta name="description" content="A comprehensive web-based course evaluation survey system for academic institutions.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="home-hero">
  <div class="hero-bg"></div>

  <!-- NAV -->
  <nav class="home-nav">
    <div class="logo">CES <span>Platform</span></div>
    <div style="display:flex;gap:12px;">
      <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Login</a>
    </div>
  </nav>

  <!-- HERO -->
  <div class="hero-content">
    <div class="hero-tag">🎓 Academic Course Evaluation Platform</div>
    <h1 class="hero-title">
      Collect Feedback That<br>
      <span class="highlight">Drives Excellence</span>
    </h1>
    <p class="hero-desc">
      A powerful platform for creating course evaluation surveys, collecting student feedback,
      and gaining insights to improve the quality of academic programs.
    </p>
    <div class="hero-actions">
      <a href="${pageContext.request.contextPath}/respondent/surveys" class="btn btn-primary btn-lg">
        <i class="fas fa-poll"></i> Take a Survey
      </a>
      <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-lg">
        <i class="fas fa-sign-in-alt"></i> Sign In
      </a>
    </div>
  </div>

</div>
</body>
</html>

