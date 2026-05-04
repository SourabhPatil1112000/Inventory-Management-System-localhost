package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;

@Component
public class DataInitializer implements CommandLineRunner {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Override
    public void run(String... args) throws Exception {
        // Create admin user if doesn't exist
        createAdminUserIfNotExists();
        
        System.out.println("Data initialization complete - No auto categories/products created");
    }
    
    private void createAdminUserIfNotExists() {
        try {
            // Check if admin exists
            var adminExists = userService.findByUsername("admin");
            if (adminExists.isEmpty()) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword(passwordEncoder.encode("admin123")); // Default password
                admin.setEmail("admin@patilbatteries.com");
                userService.registerUser(admin);
                System.out.println("Admin user created successfully");
            } else {
                System.out.println("Admin user already exists");
            }
        } catch (Exception e) {
            System.out.println("Error creating admin user: " + e.getMessage());
        }
    }
}