<%@ page import="org.example.devsync4.entities.enumerations.Role" %><%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 15:52
  To change this template use File | Settings | File Templates.
--%>
<!-- sidebar.jsp -->


<%
    User currentUser = (User) session.getAttribute("user");
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous">

<div class="sidebar d-flex flex-column bg-dark text-white" style="width: 200px; height: 100vh; position: fixed; top: 0; left: 0; padding: 20px;">
    <ul class="nav flex-column">
        <% if (currentUser.getRole() != null && Role.MANAGER.equals(currentUser.getRole())) { %>
        <li class="nav-item">
            <a href="homeDash.jsp" class="nav-link <%= request.getRequestURI().contains("homeDash.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i> Home
            </a>
        </li>
        <li class="nav-item">
            <a href="users" class="nav-link <%= request.getRequestURI().contains("users") ? "active" : "" %>">
                <i class="fas fa-users"></i> Users
            </a>
        </li>
        <li class="nav-item">
            <a href="tasks" class="nav-link <%= request.getRequestURI().contains("tasks") ? "active" : "" %>">
                <i class="fas fa-tasks"></i> Tasks
            </a>
        </li>
        <li class="nav-item">
            <a href="tags" class="nav-link <%= request.getRequestURI().contains("tags") ? "active" : "" %>">
                <i class="fas fa-tags"></i> Tags
            </a>
        </li>
        <% } else if (currentUser.getRole() != null && Role.DEVELOPER.equals(currentUser.getRole())) { %>
        <li class="nav-item">
            <a href="devDash" class="nav-link <%= request.getRequestURI().contains("devDash") ? "active" : "" %>">
                <i class="fas fa-laptop-code"></i> Dev Dashboard
            </a>
        </li>
        <% } %>
        <li class="nav-item">
            <a href="logout" class="nav-link <%= request.getRequestURI().contains("logout") ? "active" : "" %>">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </li>
    </ul>
</div>

<!-- Include Font Awesome for icons -->

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous">


