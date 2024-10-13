<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 15:42
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
  <title>Add User</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>

<div class="content" style="margin-left: 220px; padding: 40px;"> <!-- Adjust margin to match sidebar width -->
  <div class="container">
    <h2 class="mb-4">Add User</h2>

    <form action="userForms" method="post">
      <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" class="form-control" id="name" name="name" required>
      </div>

      <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" class="form-control" id="email" name="email" required>
      </div>

      <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" class="form-control" id="password" name="password" required>
      </div>

      <div class="form-group">
        <label for="role">Role:</label>
        <select class="form-control" id="role" name="role" required>
          <option value="DEVELOPER">DEVELOPER</option>
          <option value="MANAGER">MANAGER</option>
        </select>
      </div>

      <button type="submit" class="btn btn-success btn-block">Add User</button>
    </form>

    <a href="users" class="btn btn-link mt-3">Back</a>
  </div>
</div>

<!-- Include Bootstrap JS for interactivity (Optional) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


