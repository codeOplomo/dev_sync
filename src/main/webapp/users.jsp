<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login");
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.User" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Manage Users</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            overflow: hidden;
        }
        .content {
            padding: 20px;
        }
    </style>
</head>
<body class="d-flex">
<div id="sidebar" style="width: 250px; height: 100vh;">
    <%@ include file="layout/sidebar.jsp" %>
</div>

<!-- Content -->
<div class="content flex-grow-1 p-4" style="overflow-x: auto;">
    <div class="container bg-white p-4 rounded shadow">
        <h2 class="text-center">Manage Users</h2>
        <a href="addUserForm.jsp" class="btn btn-primary mb-3">Add User</a>

        <% List<User> users = (List<User>) request.getAttribute("users"); %>
        <% if (users != null && !users.isEmpty()) { %>
        <table class="table table-bordered table-striped">
            <thead class="thead-light">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% for (User user : users) { %>
            <tr>
                <td><%= user.getId() %></td>
                <td><%= user.getName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getRole() %></td>
                <td>
                    <button class="btn btn-success btn-sm mr-2" onclick="openEditModal(<%= user.getId() %>, '<%= user.getName() %>', '<%= user.getEmail() %>', '<%= user.getRole() %>')">Edit</button>
                    <button class="btn btn-danger btn-sm" onclick="openDeleteModal(<%= user.getId() %>)">Delete</button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p class="text-center">No users available to display.</p>
        <% } %>
    </div>
</div>
<!-- Edit Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span onclick="closeEditModal()" class="close">&times;</span>
        <h2>Edit User</h2>
        <form id="editForm" action="userForms" method="post">
            <input type="hidden" id="userId" name="id">
            <input type="hidden" name="action" value="update">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password">

            <label for="role">Role:</label>
            <select id="role" name="role" required>
                <option value="DEVELOPER">DEVELOPER</option>
                <option value="MANAGER">MANAGER</option>
            </select>

            <input type="submit" value="Update User">
        </form>
    </div>
</div>

<!-- Delete Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content" style="text-align: center;">
        <span onclick="closeDeleteModal()" class="close">&times;</span>
        <h2>Are you sure you want to delete this user?</h2>
        <p>This action cannot be undone.</p>
        <button id="confirmDelete" class="delete-button">Delete</button>
        <button onclick="closeDeleteModal()" class="edit-button">Cancel</button>
    </div>
</div>

<script>
    let userIdToDelete;

    function openEditModal(id, name, email, role) {
        document.getElementById('userId').value = id;
        document.getElementById('name').value = name;
        document.getElementById('email').value = email;
        document.getElementById('role').value = role;
        document.getElementById('editModal').style.display = "block";
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = "none";
    }

    function openDeleteModal(userId) {
        userIdToDelete = userId;
        document.getElementById('deleteModal').style.display = "block";
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = "none";
    }

    document.getElementById('confirmDelete').onclick = function() {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = 'userForms';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = userIdToDelete;

        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';

        form.appendChild(input);
        form.appendChild(actionInput);
        document.body.appendChild(form);
        form.submit();

        closeDeleteModal();
    }
</script>
</body>
</html>

