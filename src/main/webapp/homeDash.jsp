<%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 17:05
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
<%@ page import="org.example.devsync4.entities.Request" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Manage Users</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous">
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

<%
    // Fetch unassignment requests
    List<User> availableDevelopers = (List<User>) request.getSession().getAttribute("availableDevelopers");
    Long unassignedTaskId = (Long) request.getSession().getAttribute("unassignedTaskId");

%>
<!-- Content -->
<div class="content">
    <div class="container">
        <h2>DASHBOARD</h2>

        <div class="container mt-4">
            <div class="row">
                <div class="col-md-3">
                    <div class="card text-white bg-info mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Total Tasks</h5>
                            <p class="card-text"><%= request.getAttribute("totalTasks") %></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-white bg-warning mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Pending Tasks</h5>
                            <p class="card-text"><%= request.getAttribute("pendingTasks") %></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-white bg-success mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Reassigned Tasks</h5>
                            <p class="card-text"><%= request.getAttribute("reassignedTasks") %></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-white bg-secondary mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Available Developers</h5>
                            <p class="card-text"><%= request.getAttribute("availableDevelopersCount") %></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <table class="table">
            <thead>
            <tr>
                <th>Task ID</th>
                <th>Requested By</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Request> requests = (List<Request>) request.getAttribute("unassignmentRequests");
                if (requests != null && !requests.isEmpty()) {
                    for (Request unassignmentRequest : requests) {
            %>
            <tr>
                <td><%= unassignmentRequest.getId() %></td>
                <td><%= unassignmentRequest.getRequestedBy().getName() %></td>
                <td><%= unassignmentRequest.getReason() %></td>
                <td><%= unassignmentRequest.getStatus() %></td>
                <td>
                    <a href="acceptRequest?id=<%= unassignmentRequest.getId() %>" class="btn btn-success">Accept</a>
                    <a href="denyRequest?id=<%= unassignmentRequest.getId() %>" class="btn btn-danger">Deny</a>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="7" class="text-center">No requests available</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <!-- Trigger button for the modal, shown only if the previous developer ID and task ID are set -->
        <%
            if (availableDevelopers != null && !availableDevelopers.isEmpty() && unassignedTaskId != null) {
        %>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#assignDeveloperModal">
            Assign New Developer
        </button>
        <%
            }
        %>

    </div>
</div>

<!-- Modal for assigning new developer -->
<div class="modal fade" id="assignDeveloperModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="assignDeveloperLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="assignDeveloperLabel">Assign New Developer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="assignNewDeveloper" method="post">
                    <input type="hidden" name="taskId" value="<%= unassignedTaskId %>">
                    <label for="developerSelect">Select Developer:</label>
                    <select name="newDeveloperId" id="developerSelect" class="form-select">
                        <%
                            if (availableDevelopers != null) {
                                for (User developer : availableDevelopers) {
                        %>
                        <option value="<%= developer.getId() %>"><%= developer.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </form>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Assign Task</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


<script src="path/to/bootstrap.bundle.js"></script> <!-- Adjust the path as necessary -->
</body>
</html>
