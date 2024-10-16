package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Request;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.RequestStatus;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.RequestService;
import org.example.devsync4.services.TaskService;

import java.io.IOException;

@WebServlet(value = "/unassignmentRequest", name = "unassignmentRequest")
public class RequestServlet extends HttpServlet {
    private RequestService requestService = new RequestService();
    private TaskService taskService = new TaskService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long taskId = Long.parseLong(request.getParameter("unassigneTaskId"));
        User currentUser = (User) request.getSession().getAttribute("loggedInDeveloper");
        String reason = request.getParameter("reason");

        if (currentUser != null && currentUser.getRole() == Role.DEVELOPER) {
            // Fetch the task to check its status
            Task task = taskService.findById(taskId);

            if (task != null && task.getStatus() == TaskStatus.PENDING) {
                // Check if there is already a pending unassignment request for this task by the developer
                boolean hasPendingRequest = requestService.hasRequestForTask(taskId, currentUser.getId());

                if (!hasPendingRequest) {
                    // Create the unassignment request
                    Request unassignmentRequest = new Request();
                    unassignmentRequest.setTask(task);
                    unassignmentRequest.setRequestedBy(currentUser);
                    unassignmentRequest.setReason(reason);
                    unassignmentRequest.setStatus(RequestStatus.PENDING);

                    // Save the request
                    requestService.createRequest(unassignmentRequest);

                    // Redirect the developer back to the tasks page
                    response.sendRedirect("devDash");
                } else {
                    // Handle the case where the user already has a pending request
                    request.setAttribute("errorMessage", "You already have a pending request for this task.");
                    request.getRequestDispatcher("errorPage.jsp").forward(request, response); // Redirect to an error page
                }
            } else {
                // Handle the case where the task is not pending
                request.setAttribute("errorMessage", "Task is not in a pending state.");
                request.getRequestDispatcher("errorPage.jsp").forward(request, response); // Redirect to an error page
            }
        }
    }
}

