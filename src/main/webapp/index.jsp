<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.devsync4.entities.User" %>
<html>
<head>
    <title>Login - DevSync</title>
    <!-- Add Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('images/login-background.png') no-repeat center center fixed;
            background-size: cover;
        }
        .card {
            border-radius: 1rem;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
        }
        .btn-primary {
            transition: background-color 0.3s, transform 0.2s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }
        .form-label {
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container d-flex align-items-center justify-content-center vh-100">
    <div class="card shadow" style="width: 100%; max-width: 400px;">
        <div class="card-body">
            <h2 class="card-title text-center mb-4">Login to DevSync</h2>
            <!-- Login Form -->
            <form id="loginForm" action="login" method="post" class="needs-validation" novalidate>
                <!-- Email Input -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
                    <div class="invalid-feedback">
                        Please enter a valid email address.
                    </div>
                </div>

                <!-- Password Input -->
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                    <div class="invalid-feedback">
                        Please enter your password.
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary w-100">Login</button>
                <!-- Optional Social Media Login -->
                <div class="text-center mt-3">
                    <p>Or login with:</p>
                    <button class="btn btn-outline-secondary w-100 mb-2">Google</button>
                    <button class="btn btn-outline-secondary w-100">GitHub</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS & Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function() {
        'use strict';
        const form = document.getElementById('loginForm');

        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();
</script>
</body>
</html>
