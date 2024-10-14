package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Tag;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.TagService;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.services.UserService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
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
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String assignedToId = request.getParameter("assignedTo");
        String startDateString = request.getParameter("startDate");
        String endDateString = request.getParameter("endDate");

        User currentUser = (User) request.getSession().getAttribute("user");

        // Retrieve the selected tag IDs from the request
        String selectedTagIdsParam = request.getParameter("selectedTagIds");
        Long[] selectedTagIds = null;

        // Check if the selectedTagIdsParam is not null or empty
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
            Task task = taskService.findById(Long.parseLong(id));
            LocalDate endDate = LocalDate.parse(endDateString);
            if (endDate.isBefore(task.getStartDate().plusDays(1))) {
                request.setAttribute("errorMessage", "End date must be at least one day after the start date.");
                request.getRequestDispatcher("your-error-page.jsp").forward(request, response);
                return;
            }
            task.setTitle(title);
            task.setDescription(description);
            task.setEndDate(endDate);

            if (Role.MANAGER.equals(currentUser.getRole())) {
                // If the user is a manager, use the selected assignedToId
                if (assignedToId != null && !assignedToId.isEmpty()) {
                    User assignedTo = userService.findById(Long.parseLong(assignedToId));
                    task.setAssignedTo(assignedTo);
                }
            } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
                // If the user is a developer, assign the task to themselves
                task.setAssignedTo(currentUser);
            }

            if (selectedTagIds != null) {
                List<Long> selectedTagIdsList = Arrays.asList(selectedTagIds);
                List<Tag> tags = tagService.findByIds(selectedTagIdsList);
                task.getTags().clear();
                task.setTags(tags);
            }

            taskService.update(task);

            if (Role.MANAGER.equals(currentUser.getRole())) {
                response.sendRedirect("tasks?action=update&message=Task updated successfully");
            } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
                response.sendRedirect("devDash");
            }
        } else if ("delete".equals(action) && id != null) {

            taskService.delete(Long.parseLong(id));

            if (Role.MANAGER.equals(currentUser.getRole())) {
                response.sendRedirect("tasks?action=delete&message=Task deleted successfully");
            } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
                response.sendRedirect("devDash");
            }

        } else {
            // Validate dates
            LocalDate today = LocalDate.now();
            LocalDate startDate = LocalDate.parse(startDateString);
            LocalDate endDate = LocalDate.parse(endDateString);

            if (startDate.isBefore(today.plusDays(3))) {
                request.setAttribute("errorMessage", "Start date must be at least 3 days from today.");
                request.getRequestDispatcher("your-error-page.jsp").forward(request, response);
                return;
            }

            if (endDate.isBefore(startDate.plusDays(1))) {
                request.setAttribute("errorMessage", "End date must be at least one day after the start date.");
                request.getRequestDispatcher("your-error-page.jsp").forward(request, response);
                return;
            }
            // Add new task logic
            Task task = new Task();
            task.setTitle(title);
            task.setDescription(description);
            task.setStatus(TaskStatus.PENDING);
            task.setStartDate(startDate);
            task.setEndDate(endDate);

            if (Role.MANAGER.equals(currentUser.getRole())) {
                // If the user is a manager, use the assignedToId
                if (assignedToId != null && !assignedToId.isEmpty()) {
                    User assignedTo = userService.findById(Long.parseLong(assignedToId));
                    task.setAssignedTo(assignedTo);
                }
            } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
                task.setAssignedTo(currentUser);
            }

            task.setCreatedBy(currentUser);
            task.setCreatedAt(LocalDateTime.now());

            if (selectedTagIds != null) {

                List<Long> selectedTagIdsList = Arrays.asList(selectedTagIds);
                List<Tag> tags = tagService.findByIds(selectedTagIdsList);
                task.setTags(tags);
            }

            taskService.save(task);

            if (Role.MANAGER.equals(currentUser.getRole())) {
                response.sendRedirect("tasks?action=add&message=Task added successfully");
            } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
                response.sendRedirect("devDash");
            }
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


