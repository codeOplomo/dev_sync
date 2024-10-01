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
</head>
<body>
<h2>Add User</h2>
<% List<User> users = (List<User>) request.getAttribute("users");%>
<% if (users != null) { %>
<li><%= users %> </li>
<% } %>


<input type="hidden" name="action" value="add">

        <form action="addUser" method="post">
  <label for="name">Name:</label><br>
  <input type="text" id="name" name="name" required><br><br>

  <label for="email">Email:</label><br>
  <input type="email" id="email" name="email" required><br><br>

  <label for="password">Password:</label><br>
  <input type="password" id="password" name="password" required><br><br>

  <label for="role">Role:</label><br>
  <select id="role" name="role" required>
    <option value="DEVELOPER">DEVELOPER</option>
    <option value="MANAGER">MANAGER</option>
  </select><br><br>

  <input type="submit" value="Add User">
</form>
<a href="hello-servlet">Back</a>
</body>
</html>


