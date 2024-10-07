package org.example.devsync4;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.repositories.UserRepository;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "users", value = "/users")
public class UsersServlet extends HttpServlet {

    private final UserRepository userRepository = new UserRepository();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<User> users = userRepository.findAll();
        request.setAttribute("users", users);
        RequestDispatcher dispatcher = request.getRequestDispatcher("users.jsp");
        dispatcher.forward(request, response);
    }
}
