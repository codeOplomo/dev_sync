package org.example.devsync4;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.TaskService;

import java.io.IOException;

public class TaskStatusServlet extends HttpServlet {

    private TaskService taskService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String taskIdStr = request.getParameter("taskId");
        String statusStr = request.getParameter("status");

        if (taskIdStr != null && statusStr != null) {
            try {
                long taskId = Long.parseLong(taskIdStr);
                TaskStatus newStatus = TaskStatus.valueOf(statusStr);

                Task task = taskService.findById(taskId);
                if (task != null) {
                    task.setStatus(newStatus);
                    taskService.update(task);

                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Task status updated successfully");
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("Task not found");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid data");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing parameters");
        }
    }
}
