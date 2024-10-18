package org.example.devsync4.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.services.TagService;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.services.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "tasks", value = "/tasks")
public class TasksServlet extends HttpServlet {
    private final TaskService taskService = new TaskService();
    private final UserService userService = new UserService();
    private final TagService tagService = new TagService();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        User loggedInUser = (User) request.getSession().getAttribute("loggedInManager");

        // Get the selected tagId from the request
        String tagIdParam = request.getParameter("tagId");
        List<Task> tasks;

        if (tagIdParam != null && !tagIdParam.isEmpty()) {
            Long tagId = Long.parseLong(tagIdParam);
            tasks = taskService.findTasksByTagAndCreator(tagId, loggedInUser); // Fetch tasks by selected tag
        } else {
            tasks = taskService.findTasksByCreator(loggedInUser); // Fetch all tasks if no tag selected
        }

        request.setAttribute("tasksList", tasks);
        request.setAttribute("developers", userService.findByRole(Role.DEVELOPER));
        request.setAttribute("tagsList", tagService.findAll());

        RequestDispatcher dispatcher = request.getRequestDispatcher("tasks.jsp");
        dispatcher.forward(request, response);
    }
}

