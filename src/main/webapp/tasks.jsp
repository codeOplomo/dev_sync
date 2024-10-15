<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 16:33
  To change this template use File | Settings | File Templates.
--%>
<%
    if (session.getAttribute("user") == null || session.getAttribute("loggedInManager") == null) {
        session.invalidate();
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

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


        .text-wrap {
            word-wrap: break-word; /* Allows long words to break */
            word-break: break-word; /* Forces the word to break at the container edge */
            white-space: normal;    /* Ensures the text wraps normally */
        }

        .tag-badge {
            display: inline-block;
            padding: 5px 10px;
            margin: 3px;
            border-radius: 12px;
            background-color: #f0f0f0;
            cursor: pointer;
            border: 1px solid #ccc;
            color: #000000;
        }

        .tag-badge.selected {
            background-color: #17a2b8;
            color: white;
            margin-right: 5px;
            display: inline-block;
            cursor: pointer;
            border: 1px solid #ccc;
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
                <td><%= task.getStartDate() != null ? task.getStartDate().toString() : "Not set" %></td>
                <td><%= task.getEndDate() != null ? task.getEndDate().toString() : "Not set" %></td>
                <td>
                    <button type="button" class="btn btn-sm btn-warning" title="Details"
                            data-bs-toggle="modal" data-bs-target="#taskDetailsModal"
                            onclick="taskDetailsModal('<%= task.getTitle() %>','<%= task.getDescription() %>', '<%= task.getStatus()%>',
                                    '<%= (task.getAssignedTo() != null) ? task.getAssignedTo().getName() : "Unassigned" %>', '<%= task.getStartDate() %>',
                                    '<%= task.getEndDate() %>', '<%= tags %>')">
                        <i class="fa-solid fa-circle-info"></i>
                    </button>

                    <button type="button" class="btn btn-sm btn-warning" title="Update"
                            data-bs-toggle="modal" data-bs-target="#taskModal"
                            onclick="updateTaskModal('<%= task.getId() %>', '<%= task.getTitle() %>', '<%= task.getDescription() %>', '<%= task.getEndDate() %>', '<%= tags %>', '<%= (task.getAssignedTo() != null) ? task.getAssignedTo().getId() : "" %>')">
                        <i class="fa-solid fa-pen"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-danger" title="Delete"
                            data-bs-toggle="modal" data-bs-target="#confirmDeleteModal"
                            onclick="managerSetTaskToDelete('<%= task.getId() %>')">
                        <i class="fa-solid fa-trash"></i>
                    </button>
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

        <%
            List<Tag> allTags = (List<Tag>) request.getAttribute("tagsList");
        %>
    </div>
</div>

<!-- Task Update Modal -->
<div class="modal fade" id="taskModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="updateTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateTaskModalLabel">Update Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateTaskForm" action="taskForms" method="post">
                    <input type="hidden" name="id" id="taskId">
                    <input type="hidden" name="action" value="update" >
                    <input type="hidden" name="selectedTagIds" id="selectedTagIds">

                    <div class="mb-3">
                        <label for="modalEditTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="modalEditTitle" name="title" required>
                    </div>

                    <div class="mb-3">
                        <label for="modalEditDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="modalEditDescription" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="modalAssignedTo" class="form-label">Assigned To</label>
                        <select class="form-select" id="modalAssignedTo" name="assignedTo" required>
                            <option value="">Unassigned</option> <!-- Default "Unassigned" option -->
                            <% List<User> users = (List<User>) request.getAttribute("developers");
                                if (users != null) {
                                    for (User user : users) { %>
                            <option value="<%= user.getId() %>"><%= user.getName() %></option>
                            <% } } %>
                        </select>
                    </div>


                    <div class="mb-3">
                        <label for="modalEndDate" class="form-label">End Date</label>
                        <input type="date" class="form-control" id="modalEndDate" name="endDate" required>
                    </div>

                    <div class="mb-3">
                        <label for="modalTags" class="form-label">Tags</label>
                        <div id="modalTags" class="tags-container"></div>
                        <input type="hidden" name="selectedTags" id="selectedTags">
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Update Task</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Delete Modal -->
<div class="modal fade" id="confirmDeleteModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="deleteTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteTaskModalLabel">Confirm Task Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this task?
            </div>
            <div class="modal-footer">
                <form id="deleteTaskForm" action="taskForms" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="deleteTaskId">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Task Details Modal -->
<div class="modal fade" id="taskDetailsModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="taskDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="taskDetailsModalLabel">Task Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label"><strong>Title:</strong></label>
                    <div id="detailTitle" class="text-wrap"></div>
                </div>

                <div class="mb-3">
                    <label class="form-label"><strong>Description:</strong></label>
                    <div id="detailDescription" class="text-wrap"></div>
                </div>

                <!-- Assigned To and Status side by side -->
                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label"><strong>Assigned To:</strong></label>
                        <div id="detailAssignedTo" class="text-wrap"></div>
                    </div>
                    <div class="col">
                        <label class="form-label"><strong>Status:</strong></label>
                        <div id="detailStatus" class="text-wrap"></div>
                    </div>
                </div>

                <!-- Start Date and End Date side by side -->
                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label"><strong>Start Date:</strong></label>
                        <div id="detailStartDate" class="text-wrap"></div>
                    </div>
                    <div class="col">
                        <label class="form-label"><strong>End Date:</strong></label>
                        <div id="detailEndDate" class="text-wrap"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label"><strong>Tags:</strong></label>
                    <div id="detailTags" class="tags-container text-wrap"></div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


<script>
    const allTags = [
        <%
            for (int i = 0; i < allTags.size(); i++) {
                Tag tag = allTags.get(i); // Assuming Tag has getId() and getName()
        %>
        { "id": <%= tag.getId() %>, "name": "<%= tag.getName() %>" }<% if (i < allTags.size() - 1) { %>, <% } %>
        <%
            }
        %>
    ];


    function updateTaskModal(id, title, description, endDate, taskTags, assignedToId) {
        // Set task details in the modal
        document.getElementById('taskId').value = id;
        document.getElementById('modalEditTitle').value = title;
        document.getElementById('modalEditDescription').value = description;
        document.getElementById('modalEndDate').value = endDate;

        // Assign the selected developer
        const assignedToSelect = document.getElementById('modalAssignedTo');
        if (assignedToId) {
            for (let option of assignedToSelect.options) {
                if (option.value === assignedToId) {
                    option.selected = true;
                    break;
                }
            }
        }

        // Prepare the tags section
        const tagsContainer = document.getElementById('modalTags');
        tagsContainer.innerHTML = ''; // Clear previous content

        // Split the associated tags for the task
        const selectedTags = taskTags.split(',').map(tag => tag.trim());
        const selectedTagIds = selectedTags.map(tag => {
            const foundTag = allTags.find(t => t.name === tag);
            return foundTag ? foundTag.id : null;
        }).filter(id => id !== null); // Filter out nulls if any tag was not found

        // Loop through all tags and create badges
        allTags.forEach(function(tag) {
            const badge = document.createElement('span');
            badge.classList.add('tag-badge');
            badge.innerText = tag.name; // Use tag name

            // If the tag is associated with the task, mark it as selected
            if (selectedTags.includes(tag.name)) {
                badge.classList.add('selected'); // Add a different color class for selected tags
            }

            // Add click event to select/unselect tags
            badge.onclick = function() {
                badge.classList.toggle('selected'); // Toggle the 'selected' class
                updateSelectedTags();
            };

            tagsContainer.appendChild(badge);
        });

        // Update the hidden input with the currently selected tags and IDs
        function updateSelectedTags() {
            const selectedBadges = document.querySelectorAll('.tag-badge.selected');
            const selectedTagNames = Array.from(selectedBadges).map(badge => badge.innerText);
            document.getElementById('selectedTags').value = selectedTagNames.join(',');

            // Update selected tag IDs
            const selectedTagIds = selectedTagNames.map(name => {
                const tag = allTags.find(t => t.name === name);
                return tag ? tag.id : null;
            }).filter(id => id !== null);

            // Set the selected tag IDs to the hidden input
            document.getElementById('selectedTagIds').value = selectedTagIds.join(',');
        }

        // Initialize the selected tags input field
        updateSelectedTags();
    }

    function taskDetailsModal(title, description, status, assignedTo, startDate, endDate, tags)  {
        document.getElementById('detailTitle').textContent = title;
        document.getElementById('detailDescription').textContent = description;
        document.getElementById('detailStatus').textContent = status;
        document.getElementById('detailAssignedTo').textContent = assignedTo ? assignedTo : 'Unassigned';
        document.getElementById('detailStartDate').textContent = startDate ? startDate : 'Not set';
        document.getElementById('detailEndDate').textContent = endDate ? endDate : 'Not set';

        var tagsContainer = document.getElementById('detailTags');
        tagsContainer.innerHTML = ''; // Clear any previous tags

        var tagsArray = tags.split(',');
        tagsArray.forEach(function(tag) {
            var badge = document.createElement('span');
            badge.classList.add('tag-badge');
            badge.innerText = tag.trim();
            tagsContainer.appendChild(badge);
        });
    }

    function managerSetTaskToDelete(taskId) {
        document.getElementById('deleteTaskId').value = taskId;
    }
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

</body>

</html>

