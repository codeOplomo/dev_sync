package org.example.devsync4.entities;

import jakarta.persistence.*;
import lombok.Data;
import org.example.devsync4.entities.enumerations.RequestStatus;

import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "requests")
public class Request {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "task_id", nullable = false)
    private Task task;

    @ManyToOne
    @JoinColumn(name = "requested_by", nullable = false)
    private User requestedBy;

    @ManyToOne
    @JoinColumn(name = "approved_by")
    private User approvedBy;

    @Column
    private String reason;

    @Enumerated(EnumType.STRING)
    private RequestStatus status = RequestStatus.PENDING;

    @Column(nullable = false)
    private LocalDateTime requestedAt = LocalDateTime.now();
}
