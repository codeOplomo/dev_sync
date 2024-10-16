package org.example.devsync4.services;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.devsync4.entities.Request;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.RequestStatus;
import org.example.devsync4.repositories.RequestRepository;
import org.example.devsync4.repositories.UserRepository;

import java.io.IOException;
import java.util.List;

public class RequestService {
    private final RequestRepository requestRepository = new RequestRepository();
    private final UserService userService = new UserService();
    private final TaskService taskService = new TaskService();


    public void createRequest(Request request) {
        requestRepository.save(request);
    }

    public List<Request> getPendingRequests(Long managerId) {
        return requestRepository.getRequestsByManager(managerId);
    }

    public List<Request> getDeveloperRequests(Long developerId) {
        return requestRepository.getRequestsByDeveloper(developerId);
    }

    public boolean hasRequestForTask(Long taskId, Long developerId) {
        return requestRepository.existsByTaskIdAndRequestedById(taskId, developerId);
    }

    public Request findRequestById(Long requestId) {
        return requestRepository.findById(requestId);
    }


    public boolean acceptRequest(Long requestId, Long managerId) {
        Request requestEntity = requestRepository.findById(requestId);

        if (requestEntity != null && requestEntity.getTask().getCreatedBy().getId().equals(managerId)) {
            User developer = requestEntity.getRequestedBy();

            // Check if developer has enough tokens
            if (developer.getDailyTokens() > 0) {
                // Decrease daily tokens
                developer.setDailyTokens(developer.getDailyTokens() - 1);
                userService.update(developer);

                // Detach the developer from the task
                Task task = requestEntity.getTask();
                task.setAssignedTo(null);
                task.setReassigned(true);
                taskService.update(task);

                // Update request status to ACCEPTED
                requestEntity.setStatus(RequestStatus.APPROVED);
                requestRepository.update(requestEntity);

                // Return success for further handling in the servlet
                return true;
            }
        }
        return false;
    }


    public boolean denyRequest(Long requestId, Long managerId) {
        Request request = this.findRequestById(requestId);

        // Ensure the request exists and that the manager is the one handling the task
        if (request != null && request.getTask().getCreatedBy().getId().equals(managerId)) {
            // Update request status to DENIED
            request.setStatus(RequestStatus.DENIED);
            requestRepository.update(request);

            return true;
        }

        return false;
    }
}
