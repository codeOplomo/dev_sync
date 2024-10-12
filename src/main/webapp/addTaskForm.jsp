<%
  if (session.getAttribute("user") == null) {
    response.sendRedirect("login");
  }
%>
<%@ page import="org.example.devsync4.entities.User" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.enumerations.TaskStatus" %>
<%@ page import="org.example.devsync4.entities.Tag" %>
<%@ page import="org.example.devsync4.entities.enumerations.Role" %><%--
  Created by IntelliJ IDEA.
  User: Youcode
  Date: 07/10/2024
  Time: 16:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Add Task</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f0f0;
      margin: 0;
      padding: 0;
      display: flex;
    }

    .content {
      margin-left: 220px; /* Adjust to match sidebar width */
      padding: 40px;
      width: calc(100% - 220px);
    }

    .container {
      background-color: #fff;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      max-width: 800px; /* Increased max-width for larger form */
      width: 80%; /* Use a larger width to fit more space */
      margin: 0 auto;
    }

    h2 {
      text-align: left; /* Align title to the left for better layout consistency */
      margin-bottom: 20px;
    }

    form {
      display: flex;
      flex-direction: column;
    }

    label {
      margin-bottom: 5px;
      font-weight: bold;
    }

    input[type="text"],
    input[type="datetime-local"],
    select,
    textarea {
      padding: 10px;
      margin-bottom: 20px; /* Increased space between fields */
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 16px;
    }

    input[type="submit"] {
      background-color: #4CAF50;
      color: white;
      padding: 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 18px; /* Make the submit button more prominent */
    }

    input[type="submit"]:hover {
      background-color: #45a049;
    }

    .back-link {
      display: inline-block;
      margin-top: 20px;
      text-decoration: none;
      color: #007BFF;
      font-size: 16px;
    }

    .back-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>

<div class="content">
  <div class="container">
    <h2>Add Task</h2>

    <form action="taskForms" method="post">
      <label for="title">Title:</label>
      <input type="text" id="title" name="title" required>

      <label for="description">Description:</label>
      <textarea id="description" name="description" rows="4" required></textarea>

      <%
        Role userRole = (Role) session.getAttribute("userRole");
        boolean isManager = Role.MANAGER.equals(userRole);
      %>

      <% if (isManager) { %>
      <label for="assignedTo">Assign To:</label>
      <select id="assignedTo" name="assignedTo">
        <option value="">Unassigned</option>
        <%
          List<User> developers = (List<User>) request.getAttribute("developers");
          if (developers != null) {
            for (User developer : developers) {
        %>
        <option value="<%= developer.getId() %>"><%= developer.getName() %></option>
        <%
            }
          }
        %>
      </select>
      <% } %>

      <!-- Start Date Picker -->
      <label for="startDate">Start Date:</label>
      <input type="date" id="startDate" name="startDate" required>

      <!-- End Date Picker -->
      <label for="endDate">End Date:</label>
      <input type="date" id="endDate" name="endDate" required>

      <label>Tags:</label>
      <div id="tags">
        <%
          List<Tag> tags = (List<Tag>) request.getAttribute("tags");
          if (tags != null) {
            for (Tag tag : tags) {
        %>
        <div class="tag-badge">
          <input type="checkbox" id="tag_<%= tag.getId() %>" name="tags" value="<%= tag.getId() %>">
          <label for="tag_<%= tag.getId() %>"><%= tag.getName() %></label>
        </div>
        <%
            }
          }
        %>
      </div>

      <input type="submit" value="Add Task">
    </form>
    <a href="tasks" class="back-link">Back</a>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const today = new Date();

    // Set the date picker values
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');

    // Initially disable the end date input
    endDateInput.disabled = true;

    // Helper function to format date as 'YYYY-MM-DD'
    const formatDate = (date) => {
      return date.toISOString().split('T')[0];
    };

    // Set the minimum date for start date to today + 3 days
    const minStartDate = new Date(today);
    minStartDate.setDate(today.getDate() + 3);
    startDateInput.setAttribute('min', formatDate(minStartDate));

    // Handle start date change event
    startDateInput.addEventListener('change', function () {
      const selectedStartDate = new Date(startDateInput.value);

      // Enable the end date input after selecting a start date
      endDateInput.disabled = false;

      // Set the minimum end date to be one day after the selected start date
      const minEndDate = new Date(selectedStartDate);
      minEndDate.setDate(selectedStartDate.getDate() + 1);
      endDateInput.setAttribute('min', formatDate(minEndDate));

      // Clear any previously selected end date if it's invalid
      if (endDateInput.value && new Date(endDateInput.value) <= minEndDate) {
        endDateInput.value = '';
      }
    });
  });
</script>

</body>

</html>
