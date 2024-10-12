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

<div class="sidebar <%= currentUser.getRole() != null && Role.DEVELOPER.equals(currentUser.getRole()) ? "developer" : "manager" %>">
    <ul>
        <% if (currentUser.getRole() != null && Role.MANAGER.equals(currentUser.getRole())) { %>
        <li>
            <a href="homeDash.jsp" class="<%= request.getRequestURI().contains("homeDash.jsp") ? "active" : "" %>">Home</a>
        </li>
        <li>
            <a href="users" class="<%= request.getRequestURI().contains("users") ? "active" : "" %>">Users</a>
        </li>
        <li>
            <a href="tasks" class="<%= request.getRequestURI().contains("tasks") ? "active" : "" %>">Tasks</a>
        </li>
        <li>
            <a href="tags" class="<%= request.getRequestURI().contains("tags") ? "active" : "" %>">Tags</a>
        </li>
        <% } else if (currentUser.getRole() != null && Role.DEVELOPER.equals(currentUser.getRole())) { %>
        <li>
            <a href="devDash" class="<%= request.getRequestURI().contains("devDash") ? "active" : "" %>">Dev Dashboard</a>
        </li>
        <% } %>
        <li>
            <a href="logout" class="<%= request.getRequestURI().contains("logout") ? "active" : "" %>">Logout</a>
        </li>
    </ul>
</div>

<style>
    .sidebar {
        width: 200px;
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        padding: 20px;
    }

    .manager {
        background-color: #333;
    }

    .developer {
        background-color: #2c3e50; /* Different color for developers */
    }

    .sidebar ul {
        list-style-type: none;
        padding: 0;
    }

    .sidebar li {
        margin: 10px 0;
    }

    .sidebar a {
        padding: 15px;
        text-decoration: none;
        font-size: 18px;
        color: #f8f9fa;
        display: block;
    }

    .sidebar a:hover {
        background-color: #495057;
    }

    .sidebar a.active {
        background-color: #007BFF;
        color: white;
    }
</style>

