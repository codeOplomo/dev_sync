package org.example.devsync4.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Request;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.RequestService;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.services.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet(value = "/homeDash", name = "homeDash")
public class HomeServlet extends HttpServlet {
    private RequestService requestService = new RequestService();
    private TaskService taskService = new TaskService();
    private UserService userService = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User loggedInUser = (User) request.getSession().getAttribute("loggedInManager");
        Long managerId = loggedInUser.getId();

        // Fetch statistics
        List<Request> unassignmentRequests = requestService.getPendingRequests(managerId);
        List<Task> tasksCreatedByManager = taskService.findTasksByCreator(loggedInUser);
        long totalTasks = tasksCreatedByManager.size();
        long pendingTasks = tasksCreatedByManager.stream().filter(task -> task.getStatus() == TaskStatus.PENDING).count();
        long reassignedTasks = tasksCreatedByManager.stream().filter(task -> task.isReassigned()).count();
        long availableDevelopersCount = userService.getAllDevelopersExcluding(loggedInUser.getId()).size();

        // Set attributes for JSP
        request.setAttribute("unassignmentRequests", unassignmentRequests);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pendingTasks", pendingTasks);
        request.setAttribute("reassignedTasks", reassignedTasks);
        request.setAttribute("availableDevelopersCount", availableDevelopersCount);

        request.getRequestDispatcher("homeDash.jsp").forward(request, response);
    }

}

