package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Product;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.CategoryService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.CustomerService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.ProductService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/customers")
public class CustomerController {
    
    @Autowired
    private CustomerService customerService;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/add")
    public String showAddCustomerForm(Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Customer customer = new Customer();
        customer.setPurchaseDate(LocalDate.now()); // Set default purchase date
        customer.setQuantity(1); // Default quantity
        
        model.addAttribute("customer", customer);
        model.addAttribute("categories", categoryService.getAllCategoriesByUser(currentUser));
        model.addAttribute("areas", List.of("Hadapsar", "Mundhwa", "Kharadi", "Hinjewadi", "Wagholi", "Viman Nagar", "Kalyani Nagar", "Koregaon Park"));
        model.addAttribute("currentUser", username);
        return "AddCustomer";
    }
    
    @PostMapping("/save")
    public String saveCustomer(@ModelAttribute Customer customer, 
                             RedirectAttributes redirectAttributes, 
                             HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            // Set purchase date if not set
            if (customer.getPurchaseDate() == null) {
                customer.setPurchaseDate(LocalDate.now());
            }
            
            // Set default quantity if not set
            if (customer.getQuantity() == null || customer.getQuantity() < 1) {
                customer.setQuantity(1);
            }
            
            customerService.saveCustomer(customer, currentUser);
            redirectAttributes.addFlashAttribute("message", "Customer added successfully!");
            return "redirect:/customers/view";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error adding customer: " + e.getMessage());
            return "redirect:/customers/add";
        }
    }
    
    @GetMapping("/view")
    public String viewAllCustomers(Model model, HttpSession session,
                                 @RequestParam(required = false) String name,
                                 @RequestParam(required = false) String mobileNumber,
                                 @RequestParam(required = false) Long categoryId,
                                 @RequestParam(required = false) String area,
                                 @RequestParam(required = false) String startDate,
                                 @RequestParam(required = false) String endDate) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        LocalDate start = startDate != null ? LocalDate.parse(startDate) : null;
        LocalDate end = endDate != null ? LocalDate.parse(endDate) : null;
        
        List<Customer> customers = customerService.searchCustomers(
            currentUser, name, mobileNumber, categoryId, area, start, end);
        
        model.addAttribute("customers", customers);
        model.addAttribute("categories", categoryService.getAllCategoriesByUser(currentUser));
        model.addAttribute("areas", List.of("Hadapsar", "Mundhwa", "Kharadi", "Hinjewadi", "Wagholi", "Viman Nagar", "Kalyani Nagar", "Koregaon Park"));
        model.addAttribute("currentUser", username);
        model.addAttribute("searchName", name);
        model.addAttribute("searchMobile", mobileNumber);
        model.addAttribute("searchCategoryId", categoryId);
        model.addAttribute("searchArea", area);
        model.addAttribute("searchStartDate", startDate);
        model.addAttribute("searchEndDate", endDate);
        
        return "ViewCustomers";
    }
    
    @GetMapping("/edit/{id}")
    public String editCustomer(@PathVariable Long id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Customer customer = customerService.getCustomerByIdAndUser(id, currentUser)
            .orElseThrow(() -> new RuntimeException("Customer not found or access denied"));
        
        // Preserve existing purchase date
        if (customer.getPurchaseDate() == null) {
            customer.setPurchaseDate(LocalDate.now());
        }
        
        // Set default quantity if not set
        if (customer.getQuantity() == null || customer.getQuantity() < 1) {
            customer.setQuantity(1);
        }
        
        model.addAttribute("customer", customer);
        model.addAttribute("categories", categoryService.getAllCategoriesByUser(currentUser));
        model.addAttribute("products", productService.getProductsByCategoryAndUser(customer.getCategory().getId(), currentUser));
        model.addAttribute("areas", List.of("Hadapsar", "Mundhwa", "Kharadi", "Hinjewadi", "Wagholi", "Viman Nagar", "Kalyani Nagar", "Koregaon Park"));
        model.addAttribute("currentUser", username);
        
        return "EditCustomer";
    }
    
    @PostMapping("/update")
    public String updateCustomer(@ModelAttribute Customer customer, 
                               RedirectAttributes redirectAttributes, 
                               HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            // Preserve purchase date if not provided
            if (customer.getPurchaseDate() == null) {
                Customer existingCustomer = customerService.getCustomerByIdAndUser(customer.getId(), currentUser)
                    .orElseThrow(() -> new RuntimeException("Customer not found"));
                customer.setPurchaseDate(existingCustomer.getPurchaseDate());
            }
            
            // Set default quantity if not set
            if (customer.getQuantity() == null || customer.getQuantity() < 1) {
                customer.setQuantity(1);
            }
            
            customerService.updateCustomer(customer.getId(), customer, currentUser);
            redirectAttributes.addFlashAttribute("message", "Customer updated successfully!");
            return "redirect:/customers/view";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error updating customer: " + e.getMessage());
            return "redirect:/customers/edit/" + customer.getId();
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteCustomer(@PathVariable Long id, 
                               RedirectAttributes redirectAttributes, 
                               HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (customerService.deleteCustomer(id, currentUser)) {
            redirectAttributes.addFlashAttribute("message", "Customer deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("message", "Error deleting customer or access denied");
        }
        
        return "redirect:/customers/view";
    }
    
    @GetMapping("/products-by-category")
    @ResponseBody
    public String getProductsByCategory(@RequestParam Long categoryId, HttpSession session) {
        try {
            String username = (String) session.getAttribute("currentUser");
            if (username == null) {
                return "[]";
            }
            
            User currentUser = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
            
            System.out.println("=== PRODUCTS BY CATEGORY ===");
            System.out.println("Category ID: " + categoryId);
            System.out.println("User: " + currentUser.getUsername());
            
            List<Product> products = productService.getProductsByCategoryAndUser(categoryId, currentUser);
            System.out.println("Products found: " + products.size());
            
            // Manual JSON to avoid all Jackson issues
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                Product product = products.get(i);
                json.append("{")
                    .append("\"id\":").append(product.getId()).append(",")
                    .append("\"name\":\"").append(escapeJson(product.getName())).append("\",")
                    .append("\"purchasePrice\":").append(product.getPurchasePrice() != null ? product.getPurchasePrice() : "0")
                    .append("}");
                
                if (i < products.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            
            System.out.println("Final JSON: " + json.toString());
            return json.toString();
            
        } catch (Exception e) {
            System.err.println("ERROR in products-by-category: " + e.getMessage());
            e.printStackTrace();
            return "[]";
        }
    }

    // Helper method to escape JSON strings
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}