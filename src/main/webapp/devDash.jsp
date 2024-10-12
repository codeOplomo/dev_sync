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
<html>
<head>
    <title>Developer Dashboard</title>
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

        .task-table {
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
        <h2>My Tasks</h2>
        <a href="taskForms" class="menu-option">Add Task</a>
        <table class="task-table">
            <thead>
            <tr>
                <th>Task ID</th>
                <th>Title</th>
                <th>Description</th>
                <th>Status</th>
                <th>Due Date</th>
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
                <td><%= task.getStatus() %></td>
                <td><%=  "N/A" %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5">No tasks created by you (developer).</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <h2>Tasks Assigned by Manager</h2>
        <table class="task-table">
            <thead>
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
                    <form action="updateTaskStatus" method="post">
                        <input type="hidden" name="taskId" value="<%= task.getId() %>">
                        <select name="status" <%= task.getStatus() == TaskStatus.PENDING ? "disabled" : "" %> >
                            <option value="PENDING" <%= task.getStatus() == TaskStatus.PENDING ? "selected" : "" %> disabled>Pending</option>
                            <option value="IN_PROGRESS" <%= task.getStatus() == TaskStatus.IN_PROGRESS ? "selected" : "" %> >In Progress</option>
                            <option value="COMPLETED" <%= task.getStatus() == TaskStatus.COMPLETED ? "selected" : "" %> >Completed</option>
                            <option value="OVERDUE" <%= task.getStatus() == TaskStatus.OVERDUE ? "selected" : "" %> >Overdue</option>
                        </select>
                        <button type="submit" class="save-btn">Save</button>
                    </form>
                </td>
                <td><%= task.getEndDate() != null ? task.getEndDate() : "N/A" %></td>
                <td><%= task.getCreatedBy().getName() %></td>
                <td>
                    <!-- Button to request unassignment -->
                    <form action="requestUnassignTask" method="post">
                        <input type="hidden" name="taskId" value="<%= task.getId() %>">
                        <button type="submit" class="unassign-btn">Request Unassignment</button>
                    </form>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="7">No tasks assigned by a manager.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>



    </div>

</div>

<!-- Task Modal -->
<div id="taskModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTaskModal()">&times;</span>
        <h2 id="modalTitle">Task Title</h2>
        <p><strong>Description:</strong> <span id="modalDescription"></span></p>
        <p><strong>Status:</strong> <span id="modalStatus"></span></p>
        <p><strong>Created By:</strong> <span id="modalCreatedBy"></span></p>
        <p><strong>Due Date:</strong> <span id="modalDueDate"></span></p>
    </div>
</div>

<script>
    var currentTaskId;

    function showTaskModal(id, title, description, status, createdBy, dueDate) {
        currentTaskId = id;
        document.getElementById('modalTitle').innerText = title;
        document.getElementById('modalDescription').innerText = description;
        document.getElementById('modalStatus').innerText = status;
        document.getElementById('modalCreatedBy').innerText = createdBy;
        document.getElementById('modalDueDate').innerText = dueDate;

        // Show modal
        var modal = document.getElementById('taskModal');
        modal.style.display = 'block';
    }

    function closeTaskModal() {
        var modal = document.getElementById('taskModal');
        modal.style.display = 'none';
    }
</script>

</body>
</html>

