package org.example.devsync4.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Tag;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.exceptions.InvalidDateException;
import org.example.devsync4.exceptions.InvalidInputException;
import org.example.devsync4.exceptions.TaskNotFoundException;
import org.example.devsync4.services.TagService;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.services.UserService;
import org.example.devsync4.utils.InputValidator;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "taskForms", value = "/taskForms")
public class TaskFormsServlet extends HttpServlet {

    private TaskService taskService;
    private UserService userService;
    private TagService tagService;

    public TaskFormsServlet() {
        this.taskService = new TaskService();
        this.userService = new UserService();
        this.tagService = new TagService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {

            String action = request.getParameter("action");
            String id = request.getParameter("id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String assignedToId = request.getParameter("assignedTo");
            String startDateString = request.getParameter("startDate");
            String endDateString = request.getParameter("endDate");

            User currentUser = (User) request.getSession().getAttribute("user");

            // Validate input
            if (!InputValidator.isValidName(title) || !InputValidator.isValidName(description)) {
                throw new InvalidInputException("Title and description cannot be empty.");
            }

            LocalDate startDate = null;
            LocalDate endDate = null;

            // Validate start and end dates
            try {
                startDate = LocalDate.parse(startDateString);
                endDate = LocalDate.parse(endDateString);
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid date format.");
                request.getRequestDispatcher("error-page.jsp").forward(request, response);
                return;
            }

            if (startDate.isBefore(LocalDate.now().plusDays(3))) {
                throw new InvalidDateException("Start date must be at least 3 days from today.");
            }
            if (endDate.isBefore(startDate.plusDays(1))) {
                throw new InvalidDateException("End date must be at least one day after the start date.");
            }

            String selectedTagIdsParam = request.getParameter("selectedTagIds");
            Long[] selectedTagIds = null;

            if (selectedTagIdsParam != null && !selectedTagIdsParam.isEmpty()) {
                // Split the string into an array of strings
                String[] selectedTagIdsStr = selectedTagIdsParam.split(",");

                // Convert the string array to a Long array
                selectedTagIds = new Long[selectedTagIdsStr.length];
                for (int i = 0; i < selectedTagIdsStr.length; i++) {
                    selectedTagIds[i] = Long.parseLong(selectedTagIdsStr[i].trim()); // Convert each string to Long
                }
            }

            if ("update".equals(action) && id != null) {
                taskService.handleTaskUpdate(id, title, description, assignedToId, startDate, endDate, currentUser, selectedTagIds);
            } else if ("delete".equals(action) && id != null) {
                taskService.handleTaskDeletion(id, currentUser);
            } else {
                taskService.handleTaskAddition(title, description, assignedToId, startDate, endDate, currentUser, selectedTagIds);
            }

            if (Role.MANAGER.equals(currentUser.getRole())) {
                response.sendRedirect("tasks?action=" + action + "&message=Success");
            } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
                response.sendRedirect("devDash");
            }
        } catch (InvalidInputException | InvalidDateException | TaskNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("your-error-page.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> developers = userService.findByRole(Role.DEVELOPER);
        request.setAttribute("developers", developers);

        TaskStatus[] taskStatuses = TaskStatus.values();
        request.setAttribute("taskStatuses", taskStatuses);

        List<Tag> tags = tagService.findAll();
        request.setAttribute("tags", tags);

        request.getRequestDispatcher("addTaskForm.jsp").forward(request, response);
    }
}


