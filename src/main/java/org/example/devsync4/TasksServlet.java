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
import org.example.devsync4.repositories.TaskRepository;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.services.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "tasks", value = "/tasks")
public class TasksServlet extends HttpServlet {
    private final TaskService taskService = new TaskService();
    private final UserService userService = new UserService();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        User loggedInUser = (User) request.getSession().getAttribute("user");

        List<Task> tasks = taskService.findTasksByCreator(loggedInUser);
        request.setAttribute("tasks", tasks);

        List<User> developers = userService.findByRole(Role.DEVELOPER);
        request.setAttribute("developers", developers);

        RequestDispatcher dispatcher = request.getRequestDispatcher("tasks.jsp");
        dispatcher.forward(request, response);
    }
}

