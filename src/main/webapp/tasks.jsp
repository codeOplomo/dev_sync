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
        .modal {
            position: fixed;
            z-index: 1000;
            right: -400px;
            top: 0;
            width: 400px;
            height: 100%;
            background-color: rgba(255, 255, 255, 1);
            transition: right 0.8s ease;
        }
        .modal.show {
            right: 0;
        }
        .modal-content {
            padding: 20px;
            border-radius: 8px;
            height: 100%;
            overflow: auto;
        }
        .tag-badge {
            background-color: #f0f0f0;
            padding: 5px 10px;
            border-radius: 4px;
            margin-right: 5px;
            display: inline-block;
        }
    </style>
</head>
<body>
<div class="d-flex">
    <%-- Sidebar --%>
    <div id="sidebar" style="width: 250px; height: 100vh;">
        <%@ include file="layout/sidebar.jsp" %>
    </div>

<!-- Content -->
<div class="content flex-grow-1 p-4" style="overflow-x: auto;">
    <div class="container bg-white p-4 rounded shadow">
        <h2 class="text-center">Manage Tasks</h2>
        <a href="taskForms" class="btn btn-primary mb-3">Add Task</a>

        <!-- Task Table -->
        <table class="table table-bordered table-striped">
            <thead class="thead-light">
            <tr>
                <th>Title</th>
                <th>Status</th>
                <th>Assigned To</th>
                <th>Created By</th>
                <th>Start Date</th>
                <th>End Date</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                if (tasks != null && !tasks.isEmpty()) {
                    for (Task task : tasks) {
                        String tags = task.getTags().stream().map(Tag::getName).collect(Collectors.joining(", "));
            %>
            <tr onclick="showTaskModal('<%= task.getId() %>', '<%= task.getTitle() %>', '<%= task.getDescription() %>', '<%= task.getStatus().name() %>', '<%= task.getAssignedTo() != null ? task.getAssignedTo().getName() : "Unassigned" %>', '<%= task.getCreatedBy().getName() %>', '<%= task.getStartDate() != null ? task.getStartDate().toString() : "Not set" %>', '<%= task.getEndDate() != null ? task.getEndDate().toString() : "Not set" %>', '<%= tags %>')" stopPropagation>
                <td><%= task.getTitle() %></td>
                <td><%= task.getStatus().name() %></td>
                <td><%= task.getAssignedTo() != null ? task.getAssignedTo().getName() : "Unassigned" %></td>
                <td><%= task.getCreatedBy().getName() %></td>
                <td><%= task.getStartDate() != null ? task.getStartDate().toString() : "Not set" %></td>
                <td><%= task.getEndDate() != null ? task.getEndDate().toString() : "Not set" %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" class="text-center">No tasks available</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal -->
<div id="taskModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTaskModal()">&times;</span>
        <h2 id="modalTitle">Task Title</h2>
        <p><strong>Description:</strong> <span id="modalDescription"></span></p>
        <p><strong>Status:</strong> <span id="modalStatus"></span></p>
        <p><strong>Assigned To:</strong>
            <span id="modalAssignedTo" onclick="enableDropdown()">Unassigned</span>
            <select id="developerDropdown" style="display:none;" onchange="showUpdateCancelButtons()">
                <!-- Developers will be populated dynamically -->
            </select>
        </p>
        <p><strong>Created By:</strong> <span id="modalCreatedBy"></span></p>
        <p><strong>Start Date:</strong> <span id="modalStartDate"></span></p>
        <p><strong>End Date:</strong> <span id="modalEndDate"></span></p>
        <p><strong>Tags:</strong> <div id="modalTags" class="tags-container"></div></p>

        <!-- Placeholder for Update/Cancel buttons -->
        <div id="modalButtons" style="display:none; margin-top: 20px; text-align: right;">
            <button id="updateButton" class="btn btn-success" onclick="updateAssignedTo()">Update</button>
            <button id="cancelButton" class="btn btn-secondary" onclick="cancelUpdate()">Cancel</button>
        </div>
    </div>
</div>

<script>
    var currentTaskId;

    document.addEventListener('click', function(event) {
        var modal = document.getElementById('taskModal');
        var assignedToText = document.getElementById('modalAssignedTo');
        var dropdown = document.getElementById('developerDropdown');
        var modalButtons = document.getElementById('modalButtons');

        if (dropdown.style.display === 'inline-block' && !assignedToText.contains(event.target) && !dropdown.contains(event.target)) {
            if (modalButtons.style.display === 'none') {
                cancelUpdate();
            }
        }
    });

    function showTaskModal(id, title, description, status, assignedTo, createdBy, startDate, endDate, tags) {
        console.log("Modal triggered for:", title);

        currentTaskId = id;
        document.getElementById('modalTitle').innerText = title;
        document.getElementById('modalDescription').innerText = description;
        document.getElementById('modalStatus').innerText = status;
        document.getElementById('modalAssignedTo').innerText = assignedTo;
        document.getElementById('modalCreatedBy').innerText = createdBy;
        document.getElementById('modalStartDate').innerText = startDate;
        document.getElementById('modalEndDate').innerText = endDate;

        var tagsContainer = document.getElementById('modalTags');
        tagsContainer.innerHTML = '';

        var tagsArray = tags.split(',');
        tagsArray.forEach(function(tag) {
            var badge = document.createElement('span');
            badge.classList.add('tag-badge');
            badge.innerText = tag.trim();
            tagsContainer.appendChild(badge);
        });

        var developers = <%= new Gson().toJson((List<User>) request.getAttribute("developers")) %>;
        var dropdown = document.getElementById('developerDropdown');
        dropdown.innerHTML = '';

        developers.forEach(function(developer) {
            var option = document.createElement('option');
            option.value = developer.id;
            option.text = developer.name;

            if (developer.name === assignedTo) {
                option.selected = true;
            }

            dropdown.appendChild(option);
        });

        document.getElementById('modalAssignedTo').innerText = assignedTo;

        var modal = document.getElementById('taskModal');
        modal.style.display = 'block';
        setTimeout(function() {
            modal.classList.add('show');
        }, 10);
    }

    function closeTaskModal() {
        console.log("Modal closed.");
        var modal = document.getElementById('taskModal');
        modal.classList.remove('show');
        setTimeout(function() {
            modal.style.display = 'none';
        }, 300);
    }

    function enableDropdown() {
        var assignedTo = document.getElementById('modalAssignedTo');
        var dropdown = document.getElementById('developerDropdown');
        assignedTo.style.display = 'none';
        dropdown.style.display = 'inline-block';
    }

    function showUpdateCancelButtons() {
        document.getElementById('modalButtons').style.display = 'block';
    }

    function cancelUpdate() {
        var assignedToText = document.getElementById('modalAssignedTo');
        var dropdown = document.getElementById('developerDropdown');
        assignedToText.style.display = 'inline-block';
        dropdown.style.display = 'none';
        document.getElementById('modalButtons').style.display = 'none';
    }

    function updateAssignedTo() {
        console.log("Updating assigned to:", currentTaskId);

        var dropdown = document.getElementById('developerDropdown');
        var assignedToId = dropdown.value;

        // Send an AJAX request to update the assigned user
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "updateAssignedTo?id=" + currentTaskId + "&assignedTo=" + assignedToId, true);
        xhr.onload = function() {
            if (xhr.status === 200) {
                console.log("Update successful:", xhr.responseText);
                // Update UI accordingly
                closeTaskModal();
                location.reload(); // Reload to reflect changes
            } else {
                console.error("Error updating:", xhr.responseText);
            }
        };
        xhr.send();
    }
</script>
</body>
</html>

