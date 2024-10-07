package org.example.devsync4;


import jakarta.servlet.http.HttpSession;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.repositories.UserRepository;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.services.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class IndexServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userService.authenticateUser(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if (Role.MANAGER.equals(user.getRole())) {
                response.sendRedirect("homeDash.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
