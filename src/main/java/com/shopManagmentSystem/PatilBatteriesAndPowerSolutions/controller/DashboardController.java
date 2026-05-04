package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Category;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.CategoryService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.DashboardService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class DashboardController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private DashboardService dashboardService;
    
    @Autowired
    private CategoryService categoryService;
    
    @GetMapping({"/", "/dashboard"})
    public String showDashboard(Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Map<String, Object> insights = dashboardService.getDashboardInsights(currentUser);
        model.addAttribute("insights", insights);
        model.addAttribute("currentUser", username);
        
        // Add categories to check if setup is needed
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        
        return "Dashboard"; // This should match your JSP file name (Dashboard.jsp)
    }
}