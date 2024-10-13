<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 08/10/2024
  Time: 21:24
  To change this template use File | Settings | File Templates.
--%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login");
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.Tag" %>
<%@ page import="org.example.devsync4.entities.User" %>
<html>
<head>
    <title>Dashboard - Manage Tags</title>
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
<body class="d-flex">
<div id="sidebar" style="width: 250px; height: 100vh;">
    <%@ include file="layout/sidebar.jsp" %>
</div>
<!-- Content -->
<div class="content flex-grow-1 p-4" style="overflow-x: auto;">
    <div class="container bg-white p-4 rounded shadow">
        <h2 class="text-center">Manage Tags</h2>
        <a href="addTagForm.jsp" class="btn btn-primary mb-3">Add Tag</a>

        <% List<Tag> tags = (List<Tag>) request.getAttribute("tags"); %>
        <% if (tags != null) { %>
            <table class="table table-bordered table-striped">
                <thead class="thead-light">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Tag tag : tags) { %>
                <tr>
                    <td><%= tag.getId() %></td>
                    <td><%= tag.getName() %></td>
                    <td>
                        <button class="btn btn-success btn-sm" onclick="openEditModal(<%= tag.getId() %>, '<%= tag.getName() %>')">Edit</button>
                        <button class="btn btn-danger btn-sm" onclick="openDeleteModal(<%= tag.getId() %>)">Delete</button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        <% } else { %>
        <p class="text-muted">No tags available to display.</p>
        <% } %>
    </div>
</div>


<!-- Bootstrap and jQuery Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let tagIdToDelete;

    function openEditModal(id, name) {
        document.getElementById('tagId').value = id;
        document.getElementById('tagName').value = name;
        document.getElementById('editModal').style.display = "block";
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = "none";
    }

    function openDeleteModal(tagId) {
        tagIdToDelete = tagId;
        document.getElementById('deleteModal').style.display = "block";
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = "none";
    }

    document.getElementById('confirmDelete').onclick = function() {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = 'tagForms';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = tagIdToDelete;

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
