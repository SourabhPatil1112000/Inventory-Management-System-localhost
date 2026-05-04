package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.InventoryService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.ProductService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/inventory")
public class InventoryController {
    
    @Autowired
    private InventoryService inventoryService;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping
    public String showInventory(Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        model.addAttribute("inventory", inventoryService.getAllInventoryByUser(currentUser));
        model.addAttribute("products", productService.getAllProductsByUser(currentUser));
        model.addAttribute("currentUser", username);
        return "Inventory";
    }
    
    @PostMapping("/update-stock")
    public String updateStock(@RequestParam Long productId,
                            @RequestParam Integer quantity,
                            RedirectAttributes redirectAttributes,
                            HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            inventoryService.updateStock(productId, quantity, currentUser);
            redirectAttributes.addFlashAttribute("message", "Stock updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error updating stock: " + e.getMessage());
        }
        
        return "redirect:/inventory";
    }
    
    @PostMapping("/delete-stock")
    public String deleteStock(@RequestParam Long productId,
                            RedirectAttributes redirectAttributes,
                            HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            boolean deleted = inventoryService.deleteInventory(productId, currentUser);
            if (deleted) {
                redirectAttributes.addFlashAttribute("message", "Inventory entry deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("message", "Inventory entry not found!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error deleting inventory: " + e.getMessage());
        }
        
        return "redirect:/inventory";
    }
}