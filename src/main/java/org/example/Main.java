package org.example;

import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.repositories.UserRepository;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        // Create a new User object
        User user = new User();
        user.setName("John Doe");
        user.setEmail("aihsi@gaha.cc");
        user.setPassword("password");
        user.setRole(Role.DEVELOPER);
        UserRepository userRepository = new UserRepository();
        userRepository.save(user);
        System.out.println("User saved successfully!");

    }
}