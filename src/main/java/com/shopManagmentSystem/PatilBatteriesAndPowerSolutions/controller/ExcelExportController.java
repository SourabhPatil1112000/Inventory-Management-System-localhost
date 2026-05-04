package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.CustomerService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.util.ExcelExporter;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@Controller
public class ExcelExportController {
    
    @Autowired
    private CustomerService customerService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/export/customers")
    public void exportCustomersToExcel(HttpServletResponse response,
                                     HttpSession session,
                                     @RequestParam(required = false) String name,
                                     @RequestParam(required = false) String mobileNumber,
                                     @RequestParam(required = false) Long categoryId,
                                     @RequestParam(required = false) String area,
                                     @RequestParam(required = false) String startDate,
                                     @RequestParam(required = false) String endDate) throws IOException {
        
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            response.sendRedirect("/login");
            return;
        }
        
        // Get current user
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        LocalDate start = startDate != null ? LocalDate.parse(startDate) : null;
        LocalDate end = endDate != null ? LocalDate.parse(endDate) : null;
        
        // Get filtered customers for this user
        List<Customer> customers = customerService.searchCustomers(
            currentUser, name, mobileNumber, categoryId, area, start, end);
        
        // Export to Excel using the new ExcelExporter
        ExcelExporter.exportCustomersToExcel(customers, response);
    }
}