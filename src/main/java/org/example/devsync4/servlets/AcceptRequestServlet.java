package org.example.devsync4.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Request;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.services.RequestService;
import org.example.devsync4.services.UserService;
import org.example.devsync4.utils.InputValidator;

import java.io.IOException;
import java.util.List;

@WebServlet(value = "/acceptRequest", name = "acceptRequest")
public class AcceptRequestServlet extends HttpServlet {
    private RequestService requestService = new RequestService();
    private UserService userService = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestIdStr = request.getParameter("id");

        // Validate requestId
        if (!InputValidator.isValidId(requestIdStr)) {
            response.sendRedirect("homeDash?error=Invalid+request+ID");
            return; // Exit early if validation fails
        }

        Long requestId = Long.parseLong(requestIdStr);
        User currentUser = (User) request.getSession().getAttribute("loggedInManager");

        // Check if user is logged in and has the role of MANAGER
        if (currentUser != null && Role.MANAGER.equals(currentUser.getRole())) {
            boolean isAccepted = requestService.acceptRequest(requestId, currentUser.getId());

            if (isAccepted) {
                // Store task and developer info in the session
                Request requestEntity = requestService.findRequestById(requestId); // Assuming you have this method
                if (requestEntity != null && requestEntity.getTask() != null) {
                    request.getSession().setAttribute("unassignedTaskId", requestEntity.getTask().getId());
                    request.getSession().setAttribute("previousDeveloperId", requestEntity.getRequestedBy().getId());

                    // Fetch available developers excluding the previous developer
                    List<User> availableDevelopers = userService.getAllDevelopersExcluding(requestEntity.getRequestedBy().getId());
                    request.getSession().setAttribute("availableDevelopers", availableDevelopers);
                } else {
                    response.sendRedirect("homeDash?error=Request+not+found");
                    return; // Exit early if the request entity is not found
                }

                // Redirect to task assignment page
                response.sendRedirect("homeDash?success=Request+accepted");
            } else {
                response.sendRedirect("homeDash?error=Insufficient+tokens+for+the+developer");
            }
        } else {
            response.sendRedirect("homeDash?error=Unauthorized+access");
        }
    }
}


