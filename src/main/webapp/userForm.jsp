<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.User" %><%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 04/10/2024
  Time: 13:40
  To change this template use File | Settings | File Templates.
--%>
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
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .container {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      max-width: 400px;
      width: 100%;
    }

    h2 {
      text-align: center;
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
      padding: 8px;
      margin-bottom: 15px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    input[type="submit"] {
      background-color: #4CAF50;
      color: white;
      padding: 10px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }

    input[type="submit"]:hover {
      background-color: #45a049;
    }

    .back-link {
      display: block;
      text-align: center;
      margin-top: 10px;
      text-decoration: none;
      color: #007BFF;
    }

    .back-link:hover {
      text-decoration: underline;
    }

    ul {
      padding: 0;
      list-style-type: none;
    }

    li {
      background: #e0e0e0;
      margin: 5px 0;
      padding: 10px;
      border-radius: 4px;
    }
  </style>
</head>
<body>
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
  <a href="index.jsp" class="back-link">Back</a>
</div>
</body>
</html>



