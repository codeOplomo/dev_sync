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
  <!-- Bootstrap CSS -->
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="layout/sidebar.jsp" %>

<div class="container-fluid">
  <div class="row">
    <div class="col-md-10 offset-md-2 mt-4">
      <div class="container">
        <h2 class="card-title mb-4">Add Task</h2>

        <form action="taskForms" method="post">
          <!-- Title input -->
          <div class="form-group">
            <label for="title">Title:</label>
            <input type="text" class="form-control" id="title" name="title" required>
          </div>

          <!-- Description textarea -->
          <div class="form-group">
            <label for="description">Description:</label>
            <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
          </div>

          <%
            Role userRole = (Role) session.getAttribute("userRole");
            boolean isManager = Role.MANAGER.equals(userRole);
          %>

          <% if (isManager) { %>
          <!-- Assign To dropdown (for Manager) -->
          <div class="form-group">
            <label for="assignedTo">Assign To:</label>
            <select class="form-control" id="assignedTo" name="assignedTo">
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
          </div>
          <% } %>

          <!-- Start Date picker -->
          <div class="form-group">
            <label for="startDate">Start Date:</label>
            <input type="date" class="form-control" id="startDate" name="startDate" required>
          </div>

          <!-- End Date picker -->
          <div class="form-group">
            <label for="endDate">End Date:</label>
            <input type="date" class="form-control" id="endDate" name="endDate" required>
          </div>

          <!-- Tags checkboxes -->
          <div class="form-group">
            <label>Tags:</label>
            <div id="tags">
              <%
                List<Tag> tags = (List<Tag>) request.getAttribute("tags");
                if (tags != null) {
                  for (Tag tag : tags) {
              %>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="tag_<%= tag.getId() %>" name="tags" value="<%= tag.getId() %>">
                <label class="form-check-label" for="tag_<%= tag.getId() %>"><%= tag.getName() %></label>
              </div>
              <%
                  }
                }
              %>
            </div>
          </div>

          <!-- Submit button -->
          <button type="submit" class="btn btn-success btn-lg">Add Task</button>
        </form>

        <!-- Back link -->
        <a href="tasks" class="btn btn-link mt-3">Back</a>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const today = new Date();
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    endDateInput.disabled = true;

    const formatDate = (date) => date.toISOString().split('T')[0];

    const minStartDate = new Date(today);
    minStartDate.setDate(today.getDate() + 3);
    startDateInput.setAttribute('min', formatDate(minStartDate));

    startDateInput.addEventListener('change', function () {
      const selectedStartDate = new Date(startDateInput.value);
      endDateInput.disabled = false;
      const minEndDate = new Date(selectedStartDate);
      minEndDate.setDate(selectedStartDate.getDate() + 1);
      endDateInput.setAttribute('min', formatDate(minEndDate));
      if (endDateInput.value && new Date(endDateInput.value) <= minEndDate) {
        endDateInput.value = '';
      }
    });
  });
</script>

</body>
</html>

