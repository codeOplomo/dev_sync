package org.example.devsync4.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Tag;
import org.example.devsync4.services.TagService;
import org.example.devsync4.utils.InputValidator;

import java.io.IOException;

@WebServlet(name = "tagForms", value = "/tagForms")
public class TagFormsServlet extends HttpServlet {

    private final TagService tagService = new TagService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String name = request.getParameter("tagName");

        // Use InputValidator for validation
        if (!InputValidator.isValidName(name)) {
            response.sendRedirect("tags?action=" + action + "&error=Tag name cannot be empty");
            return;
        }

        if ("update".equals(action)) {
            if (!InputValidator.isValidId(id)) {
                response.sendRedirect("tags?action=update&error=Invalid tag ID");
                return;
            }

            Tag tag = new Tag();
            tag.setId(Long.parseLong(id));
            tag.setName(name);

            tagService.update(tag);
            response.sendRedirect("tags?action=update&message=Tag updated successfully");

        } else if ("delete".equals(action)) {
            if (!InputValidator.isValidId(id)) {
                response.sendRedirect("tags?action=delete&error=Invalid tag ID");
                return;
            }

            tagService.delete(Long.parseLong(id));
            response.sendRedirect("tags?action=delete&message=Tag deleted successfully");

        } else {
            Tag tag = new Tag();
            tag.setName(name);

            tagService.save(tag);
            response.sendRedirect("tags?action=add&message=Tag added successfully");
        }
    }

}

