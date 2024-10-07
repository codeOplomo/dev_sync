package org.example.devsync4.entities;

import jakarta.persistence.*;
import lombok.Data;
import org.example.devsync4.entities.enumerations.Role;

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

    //@OneToMany(mappedBy = "assignedTo")
    //private List<Task> tasks; // List of tasks assigned to the user (developer)
}
