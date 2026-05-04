package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        return "Login";
    }
    
    @PostMapping("/login")
    public String login(@ModelAttribute User user, HttpSession session, RedirectAttributes redirectAttributes) {
        if (userService.validateUser(user.getUsername(), user.getPassword())) {
            session.setAttribute("currentUser", user.getUsername());
            redirectAttributes.addFlashAttribute("message", "Login Success");
            return "redirect:/dashboard";
        } else {
            redirectAttributes.addFlashAttribute("message", "Login Failure - Invalid credentials");
            return "redirect:/login";
        }
    }
    
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "Register";
    }
    
    @PostMapping("/register")
    public String register(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            userService.registerUser(user);
            redirectAttributes.addFlashAttribute("message", "Registration Success - Please login");
            return "redirect:/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("message", "Registration Failure - " + e.getMessage());
            return "redirect:/register";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("message", "Logout Success");
        return "redirect:/login";
    }
}