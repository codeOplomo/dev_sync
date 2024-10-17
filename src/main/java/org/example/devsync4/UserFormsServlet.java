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
import org.example.devsync4.services.UserService;
import org.example.devsync4.utils.InputValidator;

import java.io.IOException;
import java.util.List;
@WebServlet(name = "userForms", value = "/userForms")
public class UserFormsServlet extends HttpServlet {

    private final UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Use InputValidator for validation
        if (!InputValidator.isValidName(name)) {
            response.sendRedirect("users?action=" + action + "&error=Name cannot be empty");
            return;
        }

        if (!InputValidator.isValidEmail(email)) {
            response.sendRedirect("users?action=" + action + "&error=Invalid email format");
            return;
        }

        if (!InputValidator.isValidPassword(password)) {
            response.sendRedirect("users?action=" + action + "&error=Password must be at least 6 characters long");
            return;
        }

        if (!InputValidator.isValidRole(role)) {
            response.sendRedirect("users?action=" + action + "&error=Invalid role");
            return;
        }

        if ("update".equals(action)) {
            if (!InputValidator.isValidId(id)) {
                response.sendRedirect("users?action=update&error=Invalid user ID");
                return;
            }

            User user = new User();
            user.setId(Long.parseLong(id));
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setRole(Role.valueOf(role));

            userService.update(user);
            response.sendRedirect("users?action=update&message=User updated successfully");

        } else if ("delete".equals(action)) {
            if (!InputValidator.isValidId(id)) {
                response.sendRedirect("users?action=delete&error=Invalid user ID");
                return;
            }

            userService.delete(Long.parseLong(id));
            response.sendRedirect("users?action=delete&message=User deleted successfully");

        } else {
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setRole(Role.valueOf(role));

            userService.save(user);
            response.sendRedirect("users?action=add&message=User added successfully");
        }
    }
}

