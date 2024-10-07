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
import java.util.List;

@WebServlet(name = "userForms", value = "/userForms")
public class UserFormsServlet extends HttpServlet {

    // Constants for response messages and URLs
    private static final String SUCCESS_MESSAGE = "User added successfully!";
    private static final String ERROR_MESSAGE_PREFIX = "Error adding user: ";
    private static final String ADD_USER_FORM_URL = "userForm.jsp";
    private static final String HOME_URL = "hello-servlet";

    private final UserRepository userRepository = new UserRepository();


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if ("update".equals(action) && id != null) {
            User user = new User();
            user.setId(Long.parseLong(id));
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setRole(Role.valueOf(role));

            userRepository.update(user);
            response.sendRedirect("users?action=update&message=User updated successfully");

        } else if ("delete".equals(action) && id != null) {
            userRepository.delete(Long.parseLong(id));
            response.sendRedirect("users?action=delete&message=User deleted successfully");

        } else {
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setRole(Role.valueOf(role));
            userRepository.save(user);
            response.sendRedirect("users?action=add&message=User added successfully");
        }
    }
}
