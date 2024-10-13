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
<%@ page import="org.example.devsync4.entities.enumerations.TaskStatus" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous">
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
                    <th>Task ID</th>
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
                %>
                <tr>
                    <td><%= task.getId() %></td>
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
                    <td><%= "N/A" %></td>
                    <td>
                        <a href="taskUpdateForm?taskId=<%= task.getId() %>" class="btn btn-sm btn-warning" title="Update">
                            <i class="fa-solid fa-pen"></i>
                        </a>
                        <form action="deleteTask" method="post" style="display:inline;">
                            <input type="hidden" name="taskId" value="<%= task.getId() %>">
                            <button type="submit" class="btn btn-sm btn-danger" title="Delete">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </form>
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
                    <th>Task ID</th>
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
                    <td><%= task.getId() %></td>
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

<script>
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

<!-- Task Modal -->
<div id="taskModal" class="modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Task Title</h5>
                <button type="button" class="close" onclick="closeTaskModal()" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p><strong>Description:</strong> <span id="modalDescription"></span></p>
                <p><strong>Status:</strong> <span id="modalStatus"></span></p>
                <p><strong>Created By:</strong> <span id="modalCreatedBy"></span></p>
                <p><strong>Due Date:</strong> <span id="modalDueDate"></span></p>
            </div>
        </div>
    </div>
</div>
</body>

</html>


