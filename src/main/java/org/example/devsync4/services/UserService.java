package org.example.devsync4.services;

import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.exceptions.UserAuthorizationException;
import org.example.devsync4.exceptions.UserAuthenticationException;
import org.example.devsync4.exceptions.UserNotFoundException;
import org.example.devsync4.repositories.UserRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class UserService {
    private final UserRepository userRepository = new UserRepository();

    public User authenticateUser(String email, String password) {
        Optional<User> optionalUser = userRepository.findByEmail(email);

        // Check if user exists, otherwise throw exception
        if (optionalUser.isEmpty()) {
            throw new UserNotFoundException("User with email " + email + " not found");
        }

        User user = optionalUser.get();

        // Check if password matches, otherwise throw exception
        if (!user.getPassword().equals(password)) {
            throw new UserAuthenticationException("Incorrect password");
        }

        return user;
    }

    // Method to authenticate and authorize user
    public User authenticateAndAuthorizeUser(String email, String password) throws UserAuthenticationException {
        User user = authenticateUser(email, password);

        // Add role validation if needed
        if (user == null) {
            throw new UserAuthenticationException("Invalid email or password");
        }

        return user;
    }

    // Role-based redirection logic
    public String getRedirectPageForUser(User user) {
        if (Role.MANAGER.equals(user.getRole())) {
            return "homeDash";
        } else if (Role.DEVELOPER.equals(user.getRole())) {
            return "devDash";
        } else {
            throw new UserAuthorizationException("User role not authorized for access");
        }
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
