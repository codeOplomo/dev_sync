package org.example.devsync4.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Tag;
import org.example.devsync4.repositories.TagRepository;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "tags", value = "/tags")
public class TagServlet extends HttpServlet {
    private final TagRepository tagRepository = new TagRepository();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Tag> tasks = tagRepository.findAll();
        request.setAttribute("tags", tasks);
        RequestDispatcher dispatcher = request.getRequestDispatcher("tags.jsp");
        dispatcher.forward(request, response);
    }
}
