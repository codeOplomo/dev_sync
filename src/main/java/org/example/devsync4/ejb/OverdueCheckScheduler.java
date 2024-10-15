package org.example.devsync4.ejb;


import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.TaskService;

import java.time.LocalDate;
import java.util.List;

@Singleton
@Startup
public class OverdueCheckScheduler {

    private final TaskService taskService;

    public OverdueCheckScheduler() {
        this.taskService = new TaskService();
    }

    public void checkForOverdueTasks(Task task) {
        LocalDate now = LocalDate.now();
        if (task.getEndDate().isBefore(now) && task.getStatus() != TaskStatus.COMPLETED) {
            task.setStatus(TaskStatus.OVERDUE);
            // Persist the updated task here
            taskService.update(task);
        }
    }

    @Schedule(hour = "12", minute = "0", second = "0", persistent = true)
    public void updateOverdueTasks() {
        List<Task> tasks = taskService.findAll();
        for (Task task : tasks) {
            checkForOverdueTasks(task);
        }
    }
}

