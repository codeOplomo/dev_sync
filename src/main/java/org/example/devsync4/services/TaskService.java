package org.example.devsync4.services;

import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.repositories.TaskRepository;

import java.util.List;
import java.util.stream.Collectors;

public class TaskService {
    private TaskRepository taskRepository;

    public TaskService() {
        this.taskRepository = new TaskRepository();
    }

    public List<Task> findTasksByCreator(User creator) {
        List<Task> allTasks = this.findAll();
        return allTasks.stream()
                .filter(task -> task.getCreatedBy().equals(creator))
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

