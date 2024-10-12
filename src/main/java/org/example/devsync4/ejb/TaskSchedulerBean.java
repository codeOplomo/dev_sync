package org.example.devsync4.ejb;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.inject.Inject;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.enumerations.TaskStatus;
import org.example.devsync4.services.TaskService;

import java.time.LocalDate;
import java.util.List;


@Startup
@Singleton // Ensures only one instance of this bean runs
public class TaskSchedulerBean {

    private final TaskService taskService;

    public TaskSchedulerBean() {
        this.taskService = new TaskService();
    }

    // This method will run every day at midnight to update tasks
    @Schedule(hour = "0", minute = "0", second = "0", persistent = false)
    public void updatePendingTasks() {
        List<Task> pendingTasks = taskService.findPendingTasks();

        for (Task task : pendingTasks) {
            // Check if current date is greater than or equal to the start date
            if (!task.getStartDate().isAfter(LocalDate.now())) { // This checks if start date is less than or equal to current date
                task.setStatus(TaskStatus.IN_PROGRESS);
                taskService.update(task); // Update task in the database
            }
        }
    }
}
