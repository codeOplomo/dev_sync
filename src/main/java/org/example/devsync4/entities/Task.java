package org.example.devsync4.entities;

import jakarta.persistence.*;
import lombok.Data;
import org.example.devsync4.entities.enumerations.TaskStatus;

import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "tasks")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String description;

    @Enumerated(EnumType.STRING)
    private TaskStatus status; // Assuming you will create this enum for task statuses

    @ManyToOne
    @JoinColumn(name = "assigned_to", nullable = true)
    private User assignedTo; // Developer to whom the task is assigned

    @ManyToOne
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy; // Manager who created the task

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now(); // Timestamp for task creation

}
