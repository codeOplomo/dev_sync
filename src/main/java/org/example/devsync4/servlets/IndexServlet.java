package org.example.devsync4.servlets;


import jakarta.servlet.http.HttpSession;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.exceptions.UserAuthenticationException;
import org.example.devsync4.exceptions.UserAuthorizationException;
import org.example.devsync4.exceptions.UserNotFoundException;
import org.example.devsync4.services.UserService;
import org.example.devsync4.utils.InputValidator;

import java.io.IOException;

@WebServlet("/login")
public class IndexServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Input validation using InputValidator
        if (!InputValidator.isValidEmail(email) || !InputValidator.isValidPassword(password)) {
            request.setAttribute("errorMessage", "Invalid email or password format");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Authenticate and authorize user
            User user = userService.authenticateAndAuthorizeUser(email, password);

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userRole", user.getRole());

            if (Role.MANAGER.equals(user.getRole())) {
                session.setAttribute("loggedInManager", user);
            } else if (Role.DEVELOPER.equals(user.getRole())) {
                session.setAttribute("loggedInDeveloper", user);
            }

            // Redirect based on user role
            String redirectPage = userService.getRedirectPageForUser(user);
            response.sendRedirect(redirectPage);

        } catch (UserAuthenticationException | UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (UserAuthorizationException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}

