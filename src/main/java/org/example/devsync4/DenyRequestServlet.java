package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.services.RequestService;

import java.io.IOException;

@WebServlet(value = "/denyRequest", name = "denyRequest")
public class DenyRequestServlet extends HttpServlet {
    private RequestService requestService = new RequestService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long requestId = Long.parseLong(request.getParameter("id"));
        User currentUser = (User) request.getSession().getAttribute("loggedInManager");

        if (currentUser != null && currentUser.getRole() == Role.MANAGER) {
            boolean isDenied = requestService.denyRequest(requestId, currentUser.getId());

            if (isDenied) {
                // Redirect to dashboard with a success message
                response.sendRedirect("homeDash?message=Request+denied+successfully");
            } else {
                // Redirect to dashboard with an error message
                response.sendRedirect("homeDash?error=Unable+to+deny+the+request");
            }
        }
    }
}

