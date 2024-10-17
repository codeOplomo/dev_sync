package org.example.devsync4.utils;

import org.example.devsync4.entities.enumerations.Role;

public class InputValidator {

    // Validate email
    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    // Validate password
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    // Validate role
    public static boolean isValidRole(String role) {
        try {
            Role.valueOf(role);  // Assuming Role is an Enum
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    // Validate name
    public static boolean isValidName(String name) {
        return name != null && !name.trim().isEmpty();
    }

    // Validate ID
    public static boolean isValidId(String id) {
        return id != null && id.matches("\\d+");  // Checks if ID is numeric
    }
}

