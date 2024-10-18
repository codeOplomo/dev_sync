package org.example.devsync4.services;

import org.example.devsync4.entities.Task;
import org.example.devsync4.exceptions.InvalidInputException;
import org.example.devsync4.exceptions.NullTaskException;
import org.example.devsync4.repositories.TaskRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.lang.reflect.Field;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

public class TaskServiceTest {
    private TaskService taskService;

    @Mock
    private TaskRepository taskRepository;

    @Mock
    private TagService tagService;

    @Mock
    private UserService userService;

    @BeforeEach
    void setUp() throws NoSuchFieldException, IllegalAccessException {
        MockitoAnnotations.openMocks(this);
        taskService = new TaskService();

        // Injecting mocked dependencies using reflection
        setField(taskService, "taskRepository", taskRepository);
        setField(taskService, "tagService", tagService);
        setField(taskService, "userService", userService);
    }

    private void setField(Object target, String fieldName, Object value) throws NoSuchFieldException, IllegalAccessException {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }


    @Test
    void testSaveTask() {
        Task task = new Task();
        task.setTitle("Test Task");
        task.setDescription("Description for test task");

        taskService.save(task);

        verify(taskRepository, times(1)).save(task);
    }

    @Test
    void testSaveNullTask() {
        Exception exception = Assertions.assertThrows(NullTaskException.class, () -> {
            taskService.save(null);
        });

        assertEquals("Task cannot be null.", exception.getMessage());
    }

    @Test
    void testSaveTaskWithEmptyTitle() {
        Task task = new Task();
        task.setTitle("");
        task.setDescription("Description with empty title");

        Exception exception = Assertions.assertThrows(InvalidInputException.class, () -> {
            taskService.save(task);
        });

        assertEquals("Task title cannot be null or empty.", exception.getMessage());
    }

    @Test
    void testSaveTaskWithMissingDescription() {
        Task task = new Task();
        task.setTitle("Task without description");

        Exception exception = Assertions.assertThrows(InvalidInputException.class, () -> {
            taskService.save(task);
        });

        assertEquals("Task description cannot be null or empty.", exception.getMessage());
    }

    @Test
    void testSaveTaskWithInvalidData() {
        Task task = new Task();
        task.setTitle("Valid Title");
        task.setDescription("Valid Description");
        doThrow(new RuntimeException("Validation failed")).when(taskRepository).save(task);

        Exception exception = Assertions.assertThrows(RuntimeException.class, () -> {
            taskService.save(task);
        });

        assertEquals("Validation failed", exception.getMessage());
    }

}
