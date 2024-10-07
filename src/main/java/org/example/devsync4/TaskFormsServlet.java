package org.example.devsync4;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.repositories.TaskRepository;
import org.example.devsync4.repositories.UserRepository;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "taskForms", value = "/taskForms")
public class TaskFormsServlet extends HttpServlet {

    // Constants for response messages and URLs
    private static final String SUCCESS_MESSAGE = "Task added successfully!";
    private static final String ERROR_MESSAGE_PREFIX = "Error adding task: ";
    private static final String ADD_TASK_FORM_URL = "taskForm.jsp";
    private static final String HOME_URL = "taskList.jsp";

    private final TaskRepository taskRepository = new TaskRepository();
    private final UserRepository userRepository = new UserRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch developers from the database
        List<User> developers = userRepository.findByRole(Role.DEVELOPER);

        // Set the list of developers as a request attribute
        request.setAttribute("developers", developers);

        // Forward the request to the JSP page
        request.getRequestDispatcher(ADD_TASK_FORM_URL).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String assignedToId = request.getParameter("assignedTo");

        User currentManager = (User) request.getSession().getAttribute("loggedInManager");

        if ("update".equals(action) && id != null) {
            // Update an existing task
            Task task = taskRepository.findById(Long.parseLong(id));
            task.setTitle(title);
            task.setDescription(description);
            task.setStatus(TaskStatus.valueOf(status));

            User assignedTo = userRepository.findById(Long.parseLong(assignedToId));

            task.setAssignedTo(assignedTo);

            taskRepository.update(task);
            response.sendRedirect("tasks?action=update&message=Task updated successfully");

        } else if ("delete".equals(action) && id != null) {
            // Delete a task
            taskRepository.delete(Long.parseLong(id));
            response.sendRedirect("tasks?action=delete&message=Task deleted successfully");

        } else {
            // Add a new task
            Task task = new Task();
            task.setTitle(title);
            task.setDescription(description);
            task.setStatus(TaskStatus.valueOf(status));

            if (assignedToId != null && !assignedToId.isEmpty()) {
                User assignedTo = userRepository.findById(Long.parseLong(assignedToId));
                task.setAssignedTo(assignedTo);
            } else {
                task.setAssignedTo(null); // Leave unassigned if no developer is selected
            }

            task.setCreatedBy(currentManager);
            task.setCreatedAt(LocalDateTime.now());

            taskRepository.save(task);
            response.sendRedirect("tasks?action=add&message=Task added successfully");
        }
    }
}
