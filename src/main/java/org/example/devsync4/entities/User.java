package org.example.devsync4.entities;

import jakarta.persistence.*;
import lombok.Data;
import org.example.devsync4.entities.enumerations.Role;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Data
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    private Role role;

    @Column(name = "daily_tokens")
    private int dailyTokens = 2;

    @Column(name = "monthly_token")
    private int monthlyToken = 1;

    @Column(name = "last_daily_reset")
    private LocalDateTime lastDailyReset = LocalDateTime.now();

    @Column(name = "last_monthly_reset")
    private LocalDateTime lastMonthlyReset = LocalDateTime.now();

//    @OneToMany(mappedBy = "assignedTo", fetch = FetchType.LAZY)
//    private List<Task> tasks;
}

