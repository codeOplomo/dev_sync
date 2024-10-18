package org.example.devsync4.servlets;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.TaskService;
import org.example.devsync4.utils.InputValidator;

import java.io.IOException;

@WebServlet(name = "updateTaskStatus", value = "/updateTaskStatus")
public class TaskStatusServlet extends HttpServlet {

    private TaskService taskService = new TaskService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse JSON data from the request body
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuffer.append(line);
            }
            String jsonData = jsonBuffer.toString();

            // Assuming you have a library like Gson or Jackson to parse JSON
            Gson gson = new Gson(); // Example using Gson
            JsonObject jsonObject = gson.fromJson(jsonData, JsonObject.class);

            // Extract taskId and status from the JSON object
            String taskIdStr = jsonObject.get("taskId").getAsString();
            String statusStr = jsonObject.get("status").getAsString();

            // Validate inputs
            if (!InputValidator.isValidId(taskIdStr) || !InputValidator.isValidRole(statusStr)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid task ID or status");
                return; // Exit the method early if validation fails
            }

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
        } catch (IllegalArgumentException e) {
            // Handle parsing errors or invalid enum values
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid data format");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred while processing the request");
        }
    }
}


