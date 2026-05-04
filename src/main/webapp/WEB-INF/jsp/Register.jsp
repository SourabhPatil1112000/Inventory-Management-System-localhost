<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - PATIL BATTERIES & POWER SOLUTIONS</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    
    <!-- Custom CSS -->
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0;
        }
        
        .register-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
        }
        
        .register-header {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        
        .register-header h2 {
            margin: 0;
            font-weight: 600;
        }
        
        .register-header p {
            margin: 5px 0 0 0;
            opacity: 0.8;
            font-size: 14px;
        }
        
        .register-body {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #27ae60;
            box-shadow: 0 0 0 0.2rem rgba(39, 174, 96, 0.25);
        }
        
        .btn-register {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            border: none;
            border-radius: 8px;
            color: white;
            padding: 12px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
            font-size: 16px;
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4);
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .login-link a {
            color: #27ae60;
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .input-group-text {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-right: none;
        }
        
        .form-control-with-icon {
            border-left: none;
        }
        
        .password-strength {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
            border-radius: 2px;
        }
        
        .strength-weak { background: #e74c3c; width: 25%; }
        .strength-fair { background: #f39c12; width: 50%; }
        .strength-good { background: #3498db; width: 75%; }
        .strength-strong { background: #27ae60; width: 100%; }
        
        .password-feedback {
            font-size: 12px;
            margin-top: 5px;
            min-height: 18px;
        }
        
        .terms-text {
            font-size: 12px;
            color: #6c757d;
            text-align: center;
            margin-top: 15px;
        }
        
        .form-note {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <!-- Header -->
        <div class="register-header">
            <div class="logo">
                <i class="fas fa-bolt"></i> PATIL BATTERIES
            </div>
            <h2>Create Account</h2>
            <p>Join PATIL BATTERIES management system</p>
        </div>
        
        <!-- Registration Form -->
        <div class="register-body">
            <form:form action="${pageContext.request.contextPath}/register" method="post" modelAttribute="user" id="registerForm">
                
                <!-- Username -->
                <div class="form-group">
                    <label for="username" class="form-label">Username *</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="fas fa-user"></i>
                            </span>
                        </div>
                        <form:input path="username" id="username" class="form-control form-control-with-icon" 
                                   required="required" placeholder="Choose a username" 
                                   minlength="3" maxlength="20"/>
                    </div>
                    <div class="form-note">3-20 characters, letters and numbers only</div>
                </div>
                
                <!-- Email -->
                <div class="form-group">
                    <label for="email" class="form-label">Email Address *</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="fas fa-envelope"></i>
                            </span>
                        </div>
                        <form:input path="email" type="email" id="email" class="form-control form-control-with-icon" 
                                   required="required" placeholder="Enter your email address"/>
                    </div>
                </div>
                
                <!-- Password -->
                <div class="form-group">
                    <label for="password" class="form-label">Password *</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="fas fa-lock"></i>
                            </span>
                        </div>
                        <form:password path="password" id="password" class="form-control form-control-with-icon" 
                                      required="required" placeholder="Create a strong password"
                                      minlength="6"/>
                    </div>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="passwordStrengthBar"></div>
                    </div>
                    <div class="password-feedback" id="passwordFeedback"></div>
                    <div class="form-note">Minimum 6 characters</div>
                </div>
                
                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="fas fa-lock"></i>
                            </span>
                        </div>
                        <input type="password" id="confirmPassword" class="form-control form-control-with-icon" 
                               required placeholder="Confirm your password">
                    </div>
                    <div class="password-feedback" id="confirmPasswordFeedback"></div>
                </div>
                
                <!-- Register Button -->
                <div class="form-group">
                    <button type="submit" class="btn btn-register" id="registerButton">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </div>
                
            </form:form>
            
            <!-- Terms Text -->
            <div class="terms-text">
                By creating an account, you agree to our Terms of Service
            </div>
            
            <!-- Login Link -->
            <div class="login-link">
                <p>Already have an account? 
                    <a href="${pageContext.request.contextPath}/login">Sign in here</a>
                </p>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <!-- Registration Form Script -->
    <script>
        window.onload = function () {
            var msg = "${message}";
            if (msg.startsWith("Registration Failure")) {
                var errorMsg = msg.replace("Registration Failure - ", "");
                toastr.error(errorMsg);
            } else if (msg === "Registration Success - Please login") {
                toastr.success("Registration successful! Please login with your credentials.");
            }

            // Toastr configuration
            toastr.options = {
                "closeButton": true,
                "debug": false,
                "newestOnTop": true,
                "progressBar": true,
                "positionClass": "toast-top-right",
                "preventDuplicates": false,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "5000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            };

            // Focus on username field
            document.getElementById('username').focus();
        };

        $(document).ready(function() {
            // Password strength checker
            $('#password').on('input', function() {
                var password = $(this).val();
                var strengthBar = $('#passwordStrengthBar');
                var feedback = $('#passwordFeedback');
                
                // Reset
                strengthBar.removeClass('strength-weak strength-fair strength-good strength-strong');
                feedback.text('');
                
                if (password.length === 0) {
                    return;
                }
                
                var strength = 0;
                var feedbackText = '';
                
                // Length check
                if (password.length >= 6) strength += 25;
                if (password.length >= 8) strength += 25;
                
                // Complexity checks
                if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength += 25;
                if (password.match(/\d/)) strength += 15;
                if (password.match(/[^a-zA-Z\d]/)) strength += 10;
                
                // Set strength level
                if (strength < 25) {
                    strengthBar.addClass('strength-weak');
                    feedbackText = 'Weak password';
                    feedback.css('color', '#e74c3c');
                } else if (strength < 50) {
                    strengthBar.addClass('strength-fair');
                    feedbackText = 'Fair password';
                    feedback.css('color', '#f39c12');
                } else if (strength < 75) {
                    strengthBar.addClass('strength-good');
                    feedbackText = 'Good password';
                    feedback.css('color', '#3498db');
                } else {
                    strengthBar.addClass('strength-strong');
                    feedbackText = 'Strong password';
                    feedback.css('color', '#27ae60');
                }
                
                feedback.text(feedbackText);
            });
            
            // Password confirmation check
            $('#confirmPassword').on('input', function() {
                var password = $('#password').val();
                var confirmPassword = $(this).val();
                var feedback = $('#confirmPasswordFeedback');
                
                if (confirmPassword.length === 0) {
                    feedback.text('');
                    return;
                }
                
                if (password === confirmPassword) {
                    feedback.text('Passwords match');
                    feedback.css('color', '#27ae60');
                } else {
                    feedback.text('Passwords do not match');
                    feedback.css('color', '#e74c3c');
                }
            });
            
            // Form validation
            $('#registerForm').on('submit', function(e) {
                var password = $('#password').val();
                var confirmPassword = $('#confirmPassword').val();
                var username = $('#username').val();
                
                // Check password match
                if (password !== confirmPassword) {
                    toastr.error('Passwords do not match. Please check your confirmation password.');
                    e.preventDefault();
                    return false;
                }
                
                // Check password strength
                if (password.length < 6) {
                    toastr.error('Password must be at least 6 characters long.');
                    e.preventDefault();
                    return false;
                }
                
                // Check username format
                if (!username.match(/^[a-zA-Z0-9_]{3,20}$/)) {
                    toastr.error('Username must be 3-20 characters and can only contain letters, numbers, and underscores.');
                    e.preventDefault();
                    return false;
                }
                
                return true;
            });
            
            // Add focus effects
            $('.form-control').focus(function() {
                $(this).parent().parent().addClass('focused');
            }).blur(function() {
                $(this).parent().parent().removeClass('focused');
            });
        });
    </script>
</body>
</html>