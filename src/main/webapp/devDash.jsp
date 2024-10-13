<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 11/10/2024
  Time: 10:38
  To change this template use File | Settings | File Templates.
--%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login");
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.Task" %>
<%@ page import="org.example.devsync4.entities.User" %>
<%@ page import="org.example.devsync4.entities.Tag" %>
<%@ page import="org.example.devsync4.entities.enumerations.TaskStatus" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.stream.Collectors" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <title>Developer Dashboard</title>
    <style>
        body {
            background-color: #f0f0f0;
        }

        .content {
            margin-left: 260px;
            padding: 20px;
        }

        .modal-content {
            border-radius: 8px;
        }

        .my-tasks {
            background-color: #e6f7ff; /* Light blue for My Tasks */
            border-left: 5px solid #007bff; /* Blue border */
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .assigned-tasks {
            background-color: #fff3cd; /* Light yellow for Assigned Tasks */
            border-left: 5px solid #ffc107; /* Yellow border */
            padding: 15px;
            border-radius: 8px;
        }

        h2 {
            margin-bottom: 20px;
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
<%@ include file="layout/sidebar.jsp" %>

<div class="content">
    <div class="container mt-4 bg-white p-4 rounded shadow">

        <div class="my-tasks">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2><i class="fas fa-tasks"></i> My Tasks</h2>
                <a href="taskForms" class="btn btn-primary">Add Task</a>
            </div>

            <table class="table table-bordered">
                <thead class="thead-light">
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Due Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Task> developerTasks = (List<Task>) request.getAttribute("developerTasks");
                    if (developerTasks != null && !developerTasks.isEmpty()) {
                        for (Task task : developerTasks) {
                            String tags = task.getTags().stream().map(Tag::getName).collect(Collectors.joining(", "));
                %>
                <tr>
                    <td><%= task.getTitle() %></td>
                    <td><%= task.getDescription() %></td>
                    <td>
                        <select name="status" class="form-control"
                                <%= task.getStatus() == TaskStatus.PENDING ? "disabled" : "" %>
                                onchange="updateTaskStatus('<%= task.getId() %>', this.value)">
                            <option value="PENDING" <%= task.getStatus() == TaskStatus.PENDING ? "selected" : "" %> disabled>Pending</option>
                            <option value="IN_PROGRESS" <%= task.getStatus() == TaskStatus.IN_PROGRESS ? "selected" : "" %>>In Progress</option>
                            <option value="COMPLETED" <%= task.getStatus() == TaskStatus.COMPLETED ? "selected" : "" %>>Completed</option>
                            <option value="OVERDUE" <%= task.getStatus() == TaskStatus.OVERDUE ? "selected" : "" %>>Overdue</option>
                        </select>
                    </td>
                    <td><%= task.getEndDate() != null ? task.getEndDate() : "N/A" %></td>
                    <td>
                        <button type="button" class="btn btn-sm btn-warning" title="Update"
                                data-bs-toggle="modal" data-bs-target="#updateTaskModal"
                                onclick="loadTaskData('<%= task.getId() %>', '<%= task.getTitle() %>', '<%= task.getDescription() %>', '<%= task.getEndDate() %>', '<%= tags %>')">
                            <i class="fa-solid fa-pen"></i>
                        </button>
                        <button type="button" class="btn btn-sm btn-danger" title="Delete"
                                data-bs-toggle="modal" data-bs-target="#deleteTaskModal"
                                onclick="setTaskToDelete('<%= task.getId() %>')">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center">No tasks created by you (developer).</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <div class="assigned-tasks">
            <h2><i class="fas fa-user-tie"></i> Tasks Assigned by Manager</h2>
            <table class="table table-bordered">
                <thead class="thead-light">
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Due Date</th>
                    <th>Assigned By</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Task> managerTasks = (List<Task>) request.getAttribute("managersTasks");
                    if (managerTasks != null && !managerTasks.isEmpty()) {
                        for (Task task : managerTasks) {
                %>
                <tr>
                    <td><%= task.getTitle() %></td>
                    <td><%= task.getDescription() %></td>
                    <td>
                        <select name="status" class="form-control"
                                <%= task.getStatus() == TaskStatus.PENDING ? "disabled" : "" %>
                                onchange="updateTaskStatus('<%= task.getId() %>', this.value)">
                            <option value="PENDING" <%= task.getStatus() == TaskStatus.PENDING ? "selected" : "" %> disabled>Pending</option>
                            <option value="IN_PROGRESS" <%= task.getStatus() == TaskStatus.IN_PROGRESS ? "selected" : "" %> >In Progress</option>
                            <option value="COMPLETED" <%= task.getStatus() == TaskStatus.COMPLETED ? "selected" : "" %> >Completed</option>
                            <option value="OVERDUE" <%= task.getStatus() == TaskStatus.OVERDUE ? "selected" : "" %> >Overdue</option>
                        </select>
                    </td>
                    <td><%= task.getEndDate() != null ? task.getEndDate() : "N/A" %></td>
                    <td><%= task.getCreatedBy().getName() %></td>
                    <td>
                        <form action="requestUnassignTask" method="post">
                            <input type="hidden" name="taskId" value="<%= task.getId() %>">
                            <button type="submit" class="btn btn-secondary btn-sm">Request Unassignment</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7" class="text-center">No tasks assigned by a manager.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="updateTaskModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="updateTaskModalLabel" aria-hidden="true">
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

                    <div class="mb-3">
                        <label for="taskTitle" class="form-label">Title</label>
                        <input type="text" class="form-control" id="taskTitle" name="title" required>
                    </div>

                    <div class="mb-3">
                        <label for="taskDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="taskDescription" name="description" rows="3" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="endDate" class="form-label">End Date</label>
                        <input type="date" class="form-control" id="endDate" name="endDate" required>
                    </div>

                    <div class="mb-3">
                        <label for="modalTags" class="form-label">Tags</label>
                        <!-- Tags will be dynamically populated here as badges -->
                        <div id="modalTags" class="tags-container"></div>
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

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteTaskModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="deleteTaskModalLabel" aria-hidden="true">
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


<script>
    function setTaskToDelete(taskId) {
        document.getElementById('deleteTaskId').value = taskId;
    }

    function loadTaskData(id, title, description, endDate, tags) {
        document.getElementById('taskId').value = id;
        document.getElementById('taskTitle').value = title;
        document.getElementById('taskDescription').value = description;
        document.getElementById('endDate').value = endDate;

        var tagsContainer = document.getElementById('modalTags');
        tagsContainer.innerHTML = '';

        var tagsArray = tags.split(',');
        tagsArray.forEach(function(tag) {
            var badge = document.createElement('span');
            badge.classList.add('tag-badge');
            badge.innerText = tag.trim();
            tagsContainer.appendChild(badge);
        });
    }

    function updateTaskStatus(taskId, status) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "updateTaskStatus", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        var params = "taskId=" + taskId + "&status=" + status;

        // Handle the response from the server
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                console.log("Task status updated successfully");
            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                console.error("Failed to update task status");
            }
        };

        xhr.send(params);
    }
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

</body>

</html>


