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
            flex-direction: row;
            overflow: hidden;
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

        /* Modal Styling */
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

        /* Badges Styling */
        .tags-container {
            margin-top: 10px;
        }

        .tag-badge:hover {
            background-color: #0056b3;
        }

        tr:hover {
            background-color: #f1f1f1;
            cursor: pointer;
        }

        .tag-badge {
            background-color: #f0f0f0;
            padding: 5px 10px;
            border-radius: 4px;
            margin-right: 5px;
            display: inline-block;
        }

        #modalAssignedTo {
            display: inline; /* Default display for the text */
        }

        #developerDropdown {
            display: none; /* Hidden by default */
            width: 50%; /* Set to 50% or any percentage you want */
            padding: 5px;
            font-size: 16px; /* Match the text's font size */
            margin: 0;
        }
    </style>
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>
<!-- Content -->
<div class="content">
    <div class="container">
        <h2>Manage Tasks</h2>
        <a href="taskForms" class="menu-option">Add Task</a>

        <!-- Task Table -->
        <table border="1" cellpadding="10" cellspacing="0" style="width:100%; margin-top: 20px; border-collapse: collapse;">
            <thead>
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
                <td colspan="6" style="text-align:center;">No tasks available</td>
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
        <p><strong>Start Date:</strong> <span id="modalStartDate"></span></p> <!-- New start date display -->
        <p><strong>End Date:</strong> <span id="modalEndDate"></span></p> <!-- New end date display -->
        <p><strong>Tags:</strong> <div id="modalTags" class="tags-container"></div></p>

        <!-- Placeholder for Update/Cancel buttons -->
        <div id="modalButtons" style="display:none; margin-top: 20px; text-align: right;">
            <button id="updateButton" onclick="updateAssignedTo()">Update</button>
            <button id="cancelButton" onclick="cancelUpdate()">Cancel</button>
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

        // Check if the click was outside the "Assigned To" section and the buttons are not visible
        if (dropdown.style.display === 'inline-block' && !assignedToText.contains(event.target) && !dropdown.contains(event.target)) {
            // Check if the buttons are not displayed
            if (modalButtons.style.display === 'none') {
                cancelUpdate();
            }
        }
    });

    function showTaskModal(id, title, description, status, assignedTo, createdBy, startDate, endDate, tags) {
        console.log("Modal triggered for:", title);

        currentTaskId = id;
        // Populate modal with task info
        document.getElementById('modalTitle').innerText = title;
        document.getElementById('modalDescription').innerText = description;
        document.getElementById('modalStatus').innerText = status;
        document.getElementById('modalAssignedTo').innerText = assignedTo;
        document.getElementById('modalCreatedBy').innerText = createdBy;
        document.getElementById('modalStartDate').innerText = startDate; // Set start date in modal
        document.getElementById('modalEndDate').innerText = endDate; // Set end date in modal

        // Clear the current tags
        var tagsContainer = document.getElementById('modalTags');
        tagsContainer.innerHTML = '';

        // Split tags by commas and create badges for each tag
        var tagsArray = tags.split(',');
        tagsArray.forEach(function(tag) {
            var badge = document.createElement('span');
            badge.classList.add('tag-badge');
            badge.innerText = tag.trim();
            tagsContainer.appendChild(badge);
        });

        // Fetch the developers list from the server-side code
        var developers = <%= new Gson().toJson((List<User>) request.getAttribute("developers")) %>;
        var dropdown = document.getElementById('developerDropdown');
        dropdown.innerHTML = ''; // Clear the dropdown

        // Populate the dropdown and preselect the current assigned developer
        developers.forEach(function(developer) {
            var option = document.createElement('option');
            option.value = developer.id;
            option.text = developer.name;

            // Check if this developer is the current assignedTo, and preselect it
            if (developer.name === assignedTo) {
                option.selected = true;
            }

            dropdown.appendChild(option);
        });

        // Set the assignedTo field text
        document.getElementById('modalAssignedTo').innerText = assignedTo;

        // Slide-in the modal smoothly
        var modal = document.getElementById('taskModal');
        modal.style.display = 'block';

        // Force a reflow to ensure the transition works
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

        dropdown.style.width = '50%';

        assignedTo.style.display = 'none';
        dropdown.style.display = 'inline-block';
    }

    function showUpdateCancelButtons() {
        // Show the Update/Cancel buttons
        document.getElementById('modalButtons').style.display = 'block';
    }

    function cancelUpdate() {
        // Reset the dropdown to the originally assigned developer
        var assignedToText = document.getElementById('modalAssignedTo').innerText;
        var dropdown = document.getElementById('developerDropdown');

        for (var i = 0; i < dropdown.options.length; i++) {
            if (dropdown.options[i].text === assignedToText) {
                dropdown.selectedIndex = i;
                break;
            }
        }

        // Hide the Update/Cancel buttons
        document.getElementById('modalButtons').style.display = 'none';

        // Hide the dropdown and show the assignedTo text
        dropdown.style.display = 'none';
        document.getElementById('modalAssignedTo').style.display = 'inline';
    }

    function updateAssignedTo() {
        var dropdown = document.getElementById('developerDropdown');
        var selectedDeveloperId = dropdown.value;

        // Send AJAX request to update the task
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/updateAssignedDeveloper", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById('modalAssignedTo').innerText = dropdown.options[dropdown.selectedIndex].text; // Update the field
                document.getElementById('modalAssignedTo').style.display = 'inline'; // Show the field
                dropdown.style.display = 'none'; // Hide the dropdown

                // Hide the Update/Cancel buttons
                document.getElementById('modalButtons').style.display = 'none';
            }
        };
        xhr.send("taskId=" + currentTaskId + "&developerId=" + selectedDeveloperId);
    }

</script>
</body>
</html>
