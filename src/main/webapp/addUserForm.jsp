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
<html>
<head>
  <title>Add User</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f0f0;
      margin: 0;
      padding: 0;
      display: flex;
    }

    .content {
      margin-left: 220px; /* Adjust to match sidebar width */
      padding: 40px;
      width: calc(100% - 220px);
    }

    .container {
      background-color: #fff;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      max-width: 800px; /* Increased max-width for larger form */
      width: 80%; /* Use a larger width to fit more space */
      margin: 0 auto;
    }

    h2 {
      text-align: left; /* Align title to the left for better layout consistency */
      margin-bottom: 20px;
    }

    form {
      display: flex;
      flex-direction: column;
    }

    label {
      margin-bottom: 5px;
      font-weight: bold;
    }

    input[type="text"],
    input[type="email"],
    input[type="password"],
    select {
      padding: 10px;
      margin-bottom: 20px; /* Increased space between fields */
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 16px;
    }

    input[type="submit"] {
      background-color: #4CAF50;
      color: white;
      padding: 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 18px; /* Make the submit button more prominent */
    }

    input[type="submit"]:hover {
      background-color: #45a049;
    }

    .back-link {
      display: inline-block;
      margin-top: 20px;
      text-decoration: none;
      color: #007BFF;
      font-size: 16px;
    }

    .back-link:hover {
      text-decoration: underline;
    }

  </style>
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>

<div class="content">
  <div class="container">
    <h2>Add User</h2>

    <form action="userForms" method="post">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" required>

      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required>

      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required>

      <label for="role">Role:</label>
      <select id="role" name="role" required>
        <option value="DEVELOPER">DEVELOPER</option>
        <option value="MANAGER">MANAGER</option>
      </select>

      <input type="submit" value="Add User">
    </form>
    <a href="users" class="back-link">Back</a>
  </div>
</div>
</body>
</html>

