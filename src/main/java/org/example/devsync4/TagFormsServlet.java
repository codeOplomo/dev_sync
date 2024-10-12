package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Tag;
import org.example.devsync4.services.TagService;

import java.io.IOException;

@WebServlet(name = "tagForms", value = "/tagForms")
public class TagFormsServlet extends HttpServlet {

    private final TagService tagService = new TagService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        String name = request.getParameter("tagName");

        // Handle update tag operation
        if ("update".equals(action) && id != null) {
            Tag tag = new Tag();
            tag.setId(Long.parseLong(id));
            tag.setName(name);

            tagService.update(tag);
            response.sendRedirect("tags?action=update&message=Tag updated successfully");

            // Handle delete tag operation
        } else if ("delete".equals(action) && id != null) {
            tagService.delete(Long.parseLong(id));
            response.sendRedirect("tags?action=delete&message=Tag deleted successfully");

            // Handle add new tag operation
        } else {
            Tag tag = new Tag();
            tag.setName(name);

            tagService.save(tag);
            response.sendRedirect("tags?action=add&message=Tag added successfully");
        }
    }
}
