package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.devsync4.entities.Request;
import org.example.devsync4.entities.Tag;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.services.RequestService;
import org.example.devsync4.services.TagService;
import org.example.devsync4.services.TaskService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/devDash")
public class DevServlet extends HttpServlet {

    private TaskService taskService = new TaskService();
    private TagService tagService = new TagService();
    private RequestService requestService = new RequestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInDeveloper = (User) session.getAttribute("loggedInDeveloper");

        if (loggedInDeveloper != null) {
            List<Task> assignedTasks = taskService.getTasksAssignedToUser(loggedInDeveloper.getId());

            List<Task> developerTasks = new ArrayList<>();
            List<Task> managersTasks = new ArrayList<>();

            for (Task task : assignedTasks) {
                if (task.getCreatedBy().getId().equals(loggedInDeveloper.getId())) {
                    developerTasks.add(task);

                } else if (Role.MANAGER.equals(task.getCreatedBy().getRole())) {
                    managersTasks.add(task);
                }
            }

            List<Tag> allTags = tagService.findAll();

            List<Request> unassignmentRequests = requestService.getDeveloperRequests(loggedInDeveloper.getId());

            request.setAttribute("developerTasks", developerTasks);
            request.setAttribute("managersTasks", managersTasks);
            request.setAttribute("tagsList", allTags);
            request.setAttribute("unassignmentRequests", unassignmentRequests);

            request.getRequestDispatcher("devDash.jsp").forward(request, response);
        } else {
            response.sendRedirect("login");
        }
    }
}

