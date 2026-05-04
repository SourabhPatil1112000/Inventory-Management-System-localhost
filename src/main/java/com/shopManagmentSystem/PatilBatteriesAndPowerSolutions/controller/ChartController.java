package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CustomerRepository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.ChartDataService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import jakarta.servlet.http.HttpSession;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/charts")
public class ChartController {
    
    @Autowired
    private ChartDataService chartDataService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @GetMapping("/sales")
    public Map<String, Object> getSalesData(@RequestParam String period, 
                                           @RequestParam String type,
                                           HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return null;
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        return chartDataService.getSalesData(currentUser, period, type);
    }
    
    @GetMapping("/top-products")
    public Map<String, Object> getTopProducts(@RequestParam String period,
                                             HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return null;
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        return chartDataService.getTopProductsData(currentUser, period);
    }
    
    // Original methods for backward compatibility
    @GetMapping("/monthly-sales")
    public Map<String, Object> getMonthlySales(HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return null;
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        return chartDataService.getSalesData(currentUser, "year", "revenue");
    }
    
    @GetMapping("/test-week")
    @ResponseBody
    public Map<String, Object> testWeekCalculation(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            result.put("error", "Not logged in");
            return result;
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.with(DayOfWeek.MONDAY);
        
        result.put("today", today.toString());
        result.put("todayDayOfWeek", today.getDayOfWeek().toString());
        result.put("weekStart", weekStart.toString());
        result.put("weekEnd", today.toString());
        
        // Get customers for this week
        List<Customer> customers = customerRepository.findAll((root, query, criteriaBuilder) -> {
            return criteriaBuilder.and(
                criteriaBuilder.equal(root.get("user"), currentUser),
                criteriaBuilder.between(root.get("purchaseDate"), weekStart, today)
            );
        });
        
        result.put("customerCount", customers.size());
        
        // List customers
        List<Map<String, Object>> customerList = new ArrayList<>();
        for (Customer customer : customers) {
            Map<String, Object> cust = new HashMap<>();
            cust.put("name", customer.getName());
            cust.put("date", customer.getPurchaseDate());
            cust.put("profit", customer.getProfitLoss());
            cust.put("revenue", customer.getSellingPrice());
            customerList.add(cust);
        }
        result.put("customers", customerList);
        
        return result;
    }
}