<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 08/10/2024
  Time: 21:27
  To change this template use File | Settings | File Templates.
--%>
<%
  if (session.getAttribute("user") == null) {
    response.sendRedirect("login");
  }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.example.devsync4.entities.User" %>
<html>
<head>
  <title>Add Tag</title>
  <!-- Add Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>

<div class="content" style="margin-left: 220px; padding: 40px;">
  <div class="container">
    <!-- Page Title -->
    <h2 class="mb-4">Add Tag</h2>

    <!-- Form -->
    <form action="tagForms" method="post" class="needs-validation" novalidate>

      <!-- Tag Name Input -->
      <div class="mb-3">
        <label for="name" class="form-label">Tag Name:</label>
        <input type="text" id="name" name="name" class="form-control" required>
        <div class="invalid-feedback">Please enter a tag name.</div>
      </div>

      <!-- Submit Button -->
      <button type="submit" class="btn btn-success">Add Tag</button>

    </form>

    <!-- Back Link -->
    <a href="tags" class="d-inline-block mt-3 text-decoration-none">Back</a>
  </div>
</div>

<!-- Bootstrap JS & Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

