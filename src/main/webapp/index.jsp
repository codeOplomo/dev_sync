<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.User" %>
<html>
<head>
    <title>Welcome Menu</title>
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
            max-width: 800px;
            width: 100%;
            text-align: center;
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

        .action-buttons a {
            text-decoration: none;
            color: #007BFF;
            margin-right: 10px;
        }

        .action-buttons a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Welcome Menu</h2>
    <a href="userForm.jsp" class="menu-option">Add User</a>

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
                <button onclick="openEditModal(<%= user.getId() %>, '<%= user.getName() %>', '<%= user.getEmail() %>', '<%= user.getRole() %>')" style="background-color: #4CAF50; color: white; border: none; padding: 8px 12px; cursor: pointer; border-radius: 4px;">Edit</button>
                <button onclick="openDeleteModal(<%= user.getId() %>)" style="background-color: #f44336; color: white; border: none; padding: 8px 12px; cursor: pointer; border-radius: 4px;">Delete</button>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p>No users available to display.</p>
    <% } %>
</div>

<!-- Edit Modal -->
<div id="editModal" style="display:none; position:fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow:auto; background-color: rgba(0,0,0,0.4);">
    <div style="background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 80%;">
        <span onclick="closeEditModal()" style="color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
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

<!-- Confirmation Modal -->
<div id="deleteModal" style="display:none; position:fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow:auto; background-color: rgba(0,0,0,0.4);">
    <div style="background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 80%; text-align: center;">
        <span onclick="closeDeleteModal()" style="color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
        <h2>Are you sure you want to delete this user?</h2>
        <p>This action cannot be undone.</p>
        <button id="confirmDelete" style="background-color: #f44336; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px;">Delete</button>
        <button onclick="closeDeleteModal()" style="background-color: #4CAF50; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px;">Cancel</button>
    </div>
</div>

<script>
    let userIdToDelete; // Global variable to store the ID of the user to delete

    function openEditModal(id, name, email, role) {
        document.getElementById('userId').value = id;
        document.getElementById('name').value = name;
        document.getElementById('email').value = email;
        document.getElementById('role').value = role;
        document.getElementById('editModal').style.display = "block"; // Show the edit modal
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = "none"; // Hide the edit modal
    }

    function openDeleteModal(userId) {
        userIdToDelete = userId; // Store the user ID
        document.getElementById('deleteModal').style.display = "block"; // Show the modal
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = "none"; // Hide the modal
    }

    document.getElementById('confirmDelete').onclick = function() {
        // Create a form dynamically to submit the delete request
        const form = document.createElement('form');
        form.method = 'post';
        form.action = 'userForms'; // Change to the correct servlet if necessary

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = userIdToDelete; // Set the user ID to delete

        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete'; // Set action to delete

        form.appendChild(input);
        form.appendChild(actionInput);
        document.body.appendChild(form); // Append the form to the body
        form.submit(); // Submit the form

        closeDeleteModal(); // Close the modal after submitting
    }
</script>
</body>

</html>
