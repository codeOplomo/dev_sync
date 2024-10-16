package org.example.devsync4.services;

import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.repositories.UserRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class UserService {
    private final UserRepository userRepository = new UserRepository();

    public User authenticateUser(String email, String password) {
        Optional<User> optionalUser = userRepository.findByEmail(email);

        // Check if user is present and if the password matches
        if (optionalUser.isPresent() && optionalUser.get().getPassword().equals(password)) {
            return optionalUser.get();
        }

        return null;
    }

    public List<User> getAllDevelopersExcluding(Long excludedDeveloperId) {
        // Fetch all users with the "Developer" role
        List<User> developers = this.findByRole(Role.DEVELOPER);

        // Filter out the developer with the given ID
        return developers.stream()
                .filter(dev -> !dev.getId().equals(excludedDeveloperId))
                .collect(Collectors.toList());
    }

    public List<User> findByRole(Role role) {
        return userRepository.findByRole(role);
    }

    public User findById(Long id) {
        return userRepository.findById(id);
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public void save(User user) {
        userRepository.save(user);
    }

    public void update(User user) {
        userRepository.update(user);
    }

    public void delete(Long id) {
        userRepository.delete(id);
    }
}
