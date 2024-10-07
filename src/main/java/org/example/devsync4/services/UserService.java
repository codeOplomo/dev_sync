package org.example.devsync4.services;

import org.example.devsync4.entities.User;
import org.example.devsync4.repositories.UserRepository;

import java.util.Optional;

public class UserService {
    private final UserRepository userRepository = new UserRepository();

    public User authenticateUser(String email, String password) {
        Optional<User> optionalUser = userRepository.findByEmail(email);

        // Check if user is present and if the password matches
        if (optionalUser.isPresent() && optionalUser.get().getPassword().equals(password)) {
            return optionalUser.get();
        }

        return null; // Or throw an exception or return an Optional<User> instead
    }
}
