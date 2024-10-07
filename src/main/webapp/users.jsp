<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.User" %>
<html>
<head>
    <title>Dashboard - Manage Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
        }


        .content {
            margin-left: 260px;
            padding: 20px;
            width: calc(100% - 260px);
        }

        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 1000px;
            width: 100%;
            text-align: center;
            margin: auto;
        }

        .menu-option {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }

        .menu-option:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .action-buttons button {
            padding: 8px 12px;
            margin-right: 10px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
        }

        .edit-button {
            background-color: #4CAF50;
            color: white;
        }

        .delete-button {
            background-color: #f44336;
            color: white;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: black;
        }
    </style>
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>
<!-- Content -->
<div class="content">
    <div class="container">
        <h2>Manage Users</h2>
        <a href="addUserForm.jsp" class="menu-option">Add User</a>

        <% List<User> users = (List<User>) request.getAttribute("users"); %>
        <% if (users != null) { %>
        <table>
            <thead>
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
                <td class="action-buttons">
                    <button class="edit-button" onclick="openEditModal(<%= user.getId() %>, '<%= user.getName() %>', '<%= user.getEmail() %>', '<%= user.getRole() %>')">Edit</button>
                    <button class="delete-button" onclick="openDeleteModal(<%= user.getId() %>)">Delete</button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>No users available to display.</p>
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

