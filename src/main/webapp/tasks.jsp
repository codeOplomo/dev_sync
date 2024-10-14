<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 16:33
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
<%@ page import="org.example.devsync4.entities.Task" %>
<%@ page import="org.example.devsync4.entities.Tag" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="com.google.gson.Gson" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Manage Tasks</title>
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

        /* Modal Styles */
        .modal {
            display: none; /* Keep this to control visibility */
            position: fixed;
            top: 0;
            right: -100%; /* Start hidden off the right side */
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            transition: right 0.3s ease; /* Transition for sliding effect */
        }

        .modal.show {
            display: block; /* Show the modal */
            right: 0; /* Slide into view */
        }

        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 60%;
            position: relative;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            right: 20px;
            top: 10px;
            cursor: pointer;
        }

        .close:hover {
            color: black;
        }

        /* Clickable row styling */
        tr.clickable-row {
            cursor: pointer;
        }

        tr.clickable-row:hover {
            background-color: #f0f0f0;
        }

        .tags-container span {
            background-color: #17a2b8;
            color: white;
            padding: 5px;
            border-radius: 4px;
            margin-right: 5px;
        }
    </style>
</head>
<body class="d-flex">
<div id="sidebar" style="width: 250px; height: 100vh;">
    <%@ include file="layout/sidebar.jsp" %>
</div>

<div class="content flex-grow-1 p-4" style="overflow-x: auto;">
    <div class="container bg-white p-4 rounded shadow">
        <h2 class="text-center">Manage Tasks</h2>
        <a href="taskForms" class="btn btn-primary mb-3">Add Task</a>

        <table class="table table-bordered table-striped">
            <thead class="thead-light">
            <tr>
                <th>Title</th>
                <th>Status</th>
                <th>Assigned To</th>
                <th>Created By</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Actions</th> <!-- New Actions Column -->
            </tr>
            </thead>
            <tbody>
            <%
                List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                if (tasks != null && !tasks.isEmpty()) {
                    for (Task task : tasks) {
                        String tags = task.getTags().stream().map(Tag::getName).collect(Collectors.joining(", "));
            %>
            <tr>
                <td><%= task.getTitle() %></td>
                <td><%= task.getStatus().name() %></td>
                <td><%= task.getAssignedTo() != null ? task.getAssignedTo().getName() : "Unassigned" %></td>
                <td><%= task.getCreatedBy().getName() %></td>
                <td><%= task.getStartDate() != null ? task.getStartDate().toString() : "Not set" %></td>
                <td><%= task.getEndDate() != null ? task.getEndDate().toString() : "Not set" %></td>
                <td>
                    <button class="btn btn-info btn-sm" onclick="showTaskDetailsModal('<%= task.getTitle().replace("\"", "&quot;") %>',
                            '<%= task.getDescription().replace("\"", "&quot;") %>',
                            '<%= task.getStatus().name() %>',
                            '<%= task.getAssignedTo() != null ? task.getAssignedTo().getName().replace("\"", "&quot;") : "Unassigned" %>',
                            '<%= task.getCreatedBy().getName().replace("\"", "&quot;") %>',
                            '<%= task.getStartDate() != null ? task.getStartDate().toString() : "Not set" %>',
                            '<%= task.getEndDate() != null ? task.getEndDate().toString() : "Not set" %>',
                            '<%= tags.replace("\"", "&quot;") %>'
                            )">Details</button>
                    <button class="btn btn-warning btn-sm" onclick="editTask('<%= task.getTitle().replace("\"", "&quot;") %>',
                            '<%= task.getDescription().replace("\"", "&quot;") %>',
                            '<%= task.getStatus().name() %>',
                            '<%= task.getAssignedTo() != null ? task.getAssignedTo().getName().replace("\"", "&quot;") : "Unassigned" %>',
                            '<%= task.getCreatedBy().getName().replace("\"", "&quot;") %>',
                            '<%= task.getStartDate() != null ? task.getStartDate().toString() : "Not set" %>',
                            '<%= task.getEndDate() != null ? task.getEndDate().toString() : "Not set" %>',
                            '<%= tags.replace("\"", "&quot;") %>'
                            )">Edit</button>
                    <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= task.getId() %>)">Delete</button>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="7" class="text-center">No tasks available</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

    </div>
</div>

<!-- Task Details Modal -->
<div id="taskDetailsModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTaskDetailsModal()">&times;</span>
        <h2 id="detailsModalTitle">Task Details</h2>
        <p><strong>Description:</strong> <span id="detailsModalDescription"></span></p>
        <p><strong>Status:</strong> <span id="detailsModalStatus"></span></p>
        <p><strong>Assigned To:</strong> <span id="detailsModalAssignedTo"></span></p>
        <p><strong>Created By:</strong> <span id="detailsModalCreatedBy"></span></p>
        <p><strong>Start Date:</strong> <span id="detailsModalStartDate"></span></p>
        <p><strong>End Date:</strong> <span id="detailsModalEndDate"></span></p>
        <p><strong>Tags:</strong> <span id="detailsModalTags"></span></p>
        <button class="btn btn-secondary" onclick="closeTaskDetailsModal()">Close</button>
    </div>
</div>

<!-- Task Update Modal -->
<div id="taskModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTaskModal()">&times;</span>
        <h2 id="modalTitle">Edit Task</h2>
        <input type="text" id="modalEditTitle" placeholder="Title" />
        <textarea id="modalEditDescription" placeholder="Description"></textarea>
        <select id="modalEditStatus">
            <option value="PENDING">Pending</option>
            <option value="IN_PROGRESS">In Progress</option>
            <option value="COMPLETED">Completed</option>
        </select>
        <p><strong>Assigned To:</strong> <span id="modalAssignedTo"></span></p>
        <p><strong>Created By:</strong> <span id="modalCreatedBy"></span></p>
        <p><strong>Start Date:</strong> <span id="modalStartDate"></span></p>
        <p><strong>End Date:</strong> <span id="modalEndDate"></span></p>
        <p><strong>Tags:</strong> <span id="modalTags" class="tags-container"></span></p>
        <button id="saveTaskBtn" class="btn btn-primary" onclick="saveTask()">Save</button>
    </div>
</div>

<!-- Confirmation Delete Modal -->
<div id="confirmDeleteModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteModal()">&times;</span>
        <h2>Confirm Deletion</h2>
        <p>Are you sure you want to delete this task?</p>
        <button id="confirmDeleteBtn" class="btn btn-danger">Delete</button>
        <button class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
    </div>
</div>

<script>

    let deleteTaskId = null; // Store task ID for deletion

    function showTaskDetailsModal(title, description, status, assignedTo, createdBy, startDate, endDate, tags) {
        document.getElementById('detailsModalTitle').textContent = title;
        document.getElementById('detailsModalDescription').textContent = description;
        document.getElementById('detailsModalStatus').textContent = status;
        document.getElementById('detailsModalAssignedTo').textContent = assignedTo;
        document.getElementById('detailsModalCreatedBy').textContent = createdBy;
        document.getElementById('detailsModalStartDate').textContent = startDate;
        document.getElementById('detailsModalEndDate').textContent = endDate;
        document.getElementById('detailsModalTags').textContent = tags;

        // Show the modal
        const modal = document.getElementById('taskDetailsModal');
        modal.style.display = 'block';
    }

    // Close the task details modal
    function closeTaskDetailsModal() {
        document.getElementById('taskDetailsModal').style.display = 'none';
    }

    function showTaskModal(taskId, title, description, status, assignedTo, createdBy, startDate, endDate, tags) {
        // Set the modal title and input field values for editing
        document.getElementById('modalTitle').textContent = "Edit Task";
        document.getElementById('modalEditTitle').value = title;
        document.getElementById('modalEditDescription').value = description;
        document.getElementById('modalEditStatus').value = status;

        // Static values
        document.getElementById('modalAssignedTo').textContent = assignedTo;
        document.getElementById('modalCreatedBy').textContent = createdBy;
        document.getElementById('modalStartDate').textContent = startDate;
        document.getElementById('modalEndDate').textContent = endDate;

        // Handle the case where tags might be undefined or empty
        const tagContainer = document.getElementById('modalTags');
        tagContainer.innerHTML = '';

        // Check if tags are defined and not empty, then split
        if (tags && tags.trim() !== '') {
            tags.split(', ').forEach(tag => {
                const tagSpan = document.createElement('span');
                tagSpan.textContent = tag;
                tagContainer.appendChild(tagSpan);
            });
        } else {
            // Handle case when there are no tags
            const noTagsSpan = document.createElement('span');
            noTagsSpan.textContent = 'No tags';
            tagContainer.appendChild(noTagsSpan);
        }

        // Show the modal
        const modal = document.getElementById('taskModal');
        modal.style.display = 'block';
    }

    function closeTaskModal() {
        document.getElementById('taskModal').style.display = 'none'; // Hide the edit modal
    }

    function confirmDelete(taskId) {
        // Set the ID of the task to delete and show the delete confirmation modal
        deleteTaskId = taskId;
        const modal = document.getElementById('confirmDeleteModal');
        modal.style.display = 'block';
    }

    function closeDeleteModal() {
        document.getElementById('confirmDeleteModal').style.display = 'none'; // Hide the delete confirmation modal
    }

    function editTask(taskId, title, description, status, assignedTo, createdBy, startDate, endDate, tags) {
        console.log('Edit button clicked for task: ', title); // Check if this logs correctly
        showTaskModal(taskId, title, description, status, assignedTo, createdBy, startDate, endDate, tags);
    }


    // Close modals when the user clicks outside of them
    window.onclick = function (event) {
        const detailsModal = document.getElementById('taskDetailsModal');
        const editModal = document.getElementById('taskModal');
        const deleteModal = document.getElementById('confirmDeleteModal');

        if (event.target === detailsModal) closeTaskDetailsModal();
        if (event.target === editModal) closeTaskModal();
        if (event.target === deleteModal) closeDeleteModal();
    };

</script>
</body>




</html>

