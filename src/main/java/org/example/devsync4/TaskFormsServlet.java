package org.example.devsync4;

import jakarta.servlet.RequestDispatcher;
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
import org.example.devsync4.repositories.TaskRepository;
import org.example.devsync4.repositories.UserRepository;
import org.example.devsync4.services.TagService;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.services.UserService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "taskForms", value = "/taskForms")
public class TaskFormsServlet extends HttpServlet {

    private TaskService taskService;
    private UserService userService;
    private TagService tagService; // Add TagService to handle tags

    public TaskFormsServlet() {
        this.taskService = new TaskService();
        this.userService = new UserService();
        this.tagService = new TagService(); // Initialize TagService
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> developers = userService.findByRole(Role.DEVELOPER);
        request.setAttribute("developers", developers);

        TaskStatus[] taskStatuses = TaskStatus.values();
        request.setAttribute("taskStatuses", taskStatuses);

        List<Tag> tags = tagService.findAll(); // Retrieve all tags from the database
        request.setAttribute("tags", tags);

        request.getRequestDispatcher("addTaskForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String assignedToId = request.getParameter("assignedTo");

        String[] selectedTagIds = request.getParameterValues("tags"); // Get selected tags

        User currentManager = (User) request.getSession().getAttribute("loggedInManager");

        if ("update".equals(action) && id != null) {
            // Update task
            Task task = taskService.findById(Long.parseLong(id));
            task.setTitle(title);
            task.setDescription(description);
            task.setStatus(TaskStatus.valueOf(status));

            if (assignedToId != null && !assignedToId.isEmpty()) {
                User assignedTo = userService.findById(Long.parseLong(assignedToId));
                task.setAssignedTo(assignedTo);
            }

            // Handle tags
            if (selectedTagIds != null) {
                List<Tag> tags = tagService.findByIds(selectedTagIds);
                task.setTags(tags);
            }

            taskService.update(task);
            response.sendRedirect("tasks?action=update&message=Task updated successfully");

        } else if ("delete".equals(action) && id != null) {
            // Delete task
            taskService.delete(Long.parseLong(id));
            response.sendRedirect("tasks?action=delete&message=Task deleted successfully");

        } else {
            // Add new task
            Task task = new Task();
            task.setTitle(title);
            task.setDescription(description);
            task.setStatus(TaskStatus.valueOf(status));

            if (assignedToId != null && !assignedToId.isEmpty()) {
                User assignedTo = userService.findById(Long.parseLong(assignedToId));
                task.setAssignedTo(assignedTo);
            }

            task.setCreatedBy(currentManager);
            task.setCreatedAt(LocalDateTime.now());

            // Handle tags
            if (selectedTagIds != null) {
                List<Tag> tags = tagService.findByIds(selectedTagIds);
                task.setTags(tags);
            }

            taskService.save(task);
            response.sendRedirect("tasks?action=add&message=Task added successfully");
        }
    }
}


