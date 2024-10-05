package org.example.devsync4;


import org.example.devsync4.entities.User;
import org.example.devsync4.repositories.UserRepository;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {
    private final UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userRepository.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
