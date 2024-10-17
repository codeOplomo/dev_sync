package org.example.devsync4.services;

import org.example.devsync4.entities.Tag;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.exceptions.InvalidInputException;
import org.example.devsync4.exceptions.TaskNotFoundException;
import org.example.devsync4.repositories.TaskRepository;
import org.example.devsync4.utils.InputValidator;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class TaskService {
    private TaskRepository taskRepository;
    private TagService tagService;
    private UserService userService;

    public TaskService() {
        this.taskRepository = new TaskRepository();
        this.tagService = new TagService();
        this.userService = new UserService();
    }

    public void handleTaskUpdate(String id, String title, String description, String assignedToId, LocalDate startDate, LocalDate endDate, User currentUser, Long[] selectedTagIds) throws TaskNotFoundException {
        // Validate the task ID
        if (!InputValidator.isValidId(id)) {
            throw new InvalidInputException("Invalid task ID.");
        }

        Task task = this.findById(Long.parseLong(id));
        if (task == null) {
            throw new TaskNotFoundException("Task not found.");
        }

        task.setTitle(title);
        task.setDescription(description);
        task.setStartDate(startDate);
        task.setEndDate(endDate);

        if (Role.MANAGER.equals(currentUser.getRole())) {
            // Manager can assign the task to another user
            if (assignedToId != null && !InputValidator.isValidId(assignedToId)) {
                User assignedTo = userService.findById(Long.parseLong(assignedToId));
                task.setAssignedTo(assignedTo);
            }
        } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
            // Developer assigns the task to themselves
            task.setAssignedTo(currentUser);
        }

        // Handle tags
        if (selectedTagIds != null) {
            List<Long> selectedTagIdsList = Arrays.asList(selectedTagIds);
            List<Tag> tags = tagService.findByIds(selectedTagIdsList);
            task.setTags(tags);
        }

        // Update the task
        this.update(task);
    }

    public void handleTaskDeletion(String id, User currentUser) throws TaskNotFoundException {
        // Validate the task ID
        if (!InputValidator.isValidId(id)) {
            throw new InvalidInputException("Invalid task ID.");
        }

        Task task = this.findById(Long.parseLong(id));
        if (task == null) {
            throw new TaskNotFoundException("Task not found.");
        }

        // Delete the task
        this.delete(Long.parseLong(id));
    }

    public void handleTaskAddition(String title, String description, String assignedToId, LocalDate startDate, LocalDate endDate, User currentUser, Long[] selectedTagIds) {
        Task task = new Task();
        task.setTitle(title);
        task.setDescription(description);
        task.setStartDate(startDate);
        task.setEndDate(endDate);
        task.setStatus(TaskStatus.PENDING);
        task.setCreatedBy(currentUser);
        task.setCreatedAt(LocalDateTime.now());

        if (Role.MANAGER.equals(currentUser.getRole())) {
            // If manager, assign the task to the selected user
            if (assignedToId != null && !InputValidator.isValidId(assignedToId)) {
                User assignedTo = userService.findById(Long.parseLong(assignedToId));
                task.setAssignedTo(assignedTo);
            }
        } else if (Role.DEVELOPER.equals(currentUser.getRole())) {
            // Developer assigns the task to themselves
            task.setAssignedTo(currentUser);
        }

        // Handle tags
        if (selectedTagIds != null) {
            List<Long> selectedTagIdsList = Arrays.asList(selectedTagIds);
            List<Tag> tags = tagService.findByIds(selectedTagIdsList);
            task.setTags(tags);
        }

        // Save the new task
        this.save(task);
    }


    public List<Task> findTasksByCreator(User creator) {
        List<Task> allTasks = this.findAll();
        return allTasks.stream()
                .filter(task -> task.getCreatedBy().equals(creator))
                .collect(Collectors.toList());
    }

    public List<Task> findTasksByTagAndCreator(Long tagId, User creator) {
        // Step 1: Get all tasks created by the given user
        List<Task> tasksByCreator = this.findTasksByCreator(creator);

        // Step 2: Filter tasks by the provided tag
        return tasksByCreator.stream()
                .filter(task -> task.getTags().stream().anyMatch(tag -> tag.getId().equals(tagId)))
                .collect(Collectors.toList());
    }

    public List<Task> getTasksAssignedToUser(Long developerId) {
        return taskRepository.getTasksAssignedToUser(developerId);
    }

    public List<Task> findPendingTasks() {
        return taskRepository.findByStatus(TaskStatus.PENDING);
    }

    public List<Task> findAll() {
        return taskRepository.findAll();
    }

    public Task findById(Long id) {
        return taskRepository.findById(id);
    }

    public void save(Task task) {
        taskRepository.save(task);
    }

    public void update(Task task) {
        taskRepository.update(task);
    }

    public void delete(Long id) {
        taskRepository.delete(id);
    }
}

