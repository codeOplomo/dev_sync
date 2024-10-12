package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the current session and remove the user
        HttpSession session = request.getSession(false); // Get the current session, do not create if it doesn't exist

        if (session != null) {
            session.invalidate(); // Invalidate the session
        }

        // Redirect to the login page after logout
        response.sendRedirect("index.jsp");
    }
}

