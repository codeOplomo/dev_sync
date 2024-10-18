package org.example.devsync4.services;

import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;
import org.example.devsync4.exceptions.UserAuthenticationException;
import org.example.devsync4.exceptions.UserAuthorizationException;
import org.example.devsync4.exceptions.UserNotFoundException;
import org.example.devsync4.repositories.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceTest {

    private UserRepository userRepository;
    private UserService userService;

    @BeforeEach
    void setUp() {
        userRepository = Mockito.mock(UserRepository.class);
        userService = new UserService(userRepository);
    }

    @Test
    void authenticateUser_validCredentials_shouldReturnUser() {
        // Arrange
        String email = "test@example.com";
        String password = "password123";
        User user =new User();
        user.setId(1L);
        user.setName("Test User");
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(Role.DEVELOPER);

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));

        // Act
        User authenticatedUser = userService.authenticateUser(email, password);

        // Assert
        assertEquals(user, authenticatedUser);
    }

    @Test
    void authenticateUser_invalidPassword_shouldThrowException() {
        // Arrange
        String email = "test@example.com";
        String password = "wrongPassword";
        User user = new User(1L, "Test User", email, "correctPassword", Role.DEVELOPER);

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));

        // Act & Assert
        assertThrows(UserAuthenticationException.class, () -> userService.authenticateUser(email, password));
    }

    @Test
    void authenticateUser_userNotFound_shouldThrowException() {
        // Arrange
        String email = "nonexistent@example.com";
        String password = "password123";

        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(UserNotFoundException.class, () -> userService.authenticateUser(email, password));
    }

    @Test
    void getRedirectPageForUser_developer_shouldReturnDevDash() {
        // Arrange
        User developer = new User(1L, "Test Developer", "dev@example.com", "password", Role.DEVELOPER);

        // Act
        String redirectPage = userService.getRedirectPageForUser(developer);

        // Assert
        assertEquals("devDash", redirectPage);
    }

    @Test
    void getRedirectPageForUser_manager_shouldReturnHomeDash() {
        // Arrange
        User manager = new User(1L, "Test Manager", "manager@example.com", "password", Role.MANAGER);

        // Act
        String redirectPage = userService.getRedirectPageForUser(manager);

        // Assert
        assertEquals("homeDash", redirectPage);
    }

    @Test
    void getRedirectPageForUser_unauthorizedRole_shouldThrowException() {
        // Arrange
        User unauthorizedUser = new User(1L, "Test Unauthorized", "unauth@example.com", "password", Role.UNKNOWN);

        // Act & Assert
        assertThrows(UserAuthorizationException.class, () -> userService.getRedirectPageForUser(unauthorizedUser));
    }
}