<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 15:52
  To change this template use File | Settings | File Templates.
--%>
<!-- sidebar.jsp -->
<div class="sidebar">
    <ul>
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
            <a href="tags" class="" >Tags</a>
        </li>
        <li>
            <a href="logout" class="<%= request.getRequestURI().contains("logout") ? "active" : "" %>">Logout</a>
        </li>
    </ul>
</div>

<style>
    .sidebar {
        width: 200px;
        background-color: #333;
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        padding: 20px;
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


