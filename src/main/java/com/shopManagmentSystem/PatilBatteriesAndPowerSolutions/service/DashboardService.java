package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CustomerRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardService {
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private ChartDataService chartDataService;
    
    public Map<String, Object> getDashboardInsights(User user) {
        Map<String, Object> insights = new HashMap<>();
        LocalDate today = LocalDate.now();
        int currentYear = today.getYear();
        
        // Get today's customers for this user
        List<Customer> todayCustomers = customerRepository.findAll((root, query, criteriaBuilder) -> {
            return criteriaBuilder.and(
                criteriaBuilder.equal(root.get("user"), user),
                criteriaBuilder.equal(root.get("purchaseDate"), today)
            );
        });
        
        // Get this week's customers (Monday to Sunday)
        LocalDate weekStart = today.with(DayOfWeek.MONDAY);
        LocalDate weekEnd = today.with(DayOfWeek.SUNDAY);
        
        List<Customer> weekCustomers = customerRepository.findAll((root, query, criteriaBuilder) -> {
            return criteriaBuilder.and(
                criteriaBuilder.equal(root.get("user"), user),
                criteriaBuilder.between(root.get("purchaseDate"), weekStart, weekEnd)
            );
        });
        
        // Get monthly customers for this user
        LocalDate monthStart = today.with(TemporalAdjusters.firstDayOfMonth());
        LocalDate monthEnd = today.with(TemporalAdjusters.lastDayOfMonth());
        
        List<Customer> monthCustomers = customerRepository.findAll((root, query, criteriaBuilder) -> {
            return criteriaBuilder.and(
                criteriaBuilder.equal(root.get("user"), user),
                criteriaBuilder.between(root.get("purchaseDate"), monthStart, monthEnd)
            );
        });
        
        // Get yearly customers for this user
        LocalDate yearStart = LocalDate.of(currentYear, 1, 1);
        LocalDate yearEnd = LocalDate.of(currentYear, 12, 31);
        
        List<Customer> yearCustomers = customerRepository.findAll((root, query, criteriaBuilder) -> {
            return criteriaBuilder.and(
                criteriaBuilder.equal(root.get("user"), user),
                criteriaBuilder.between(root.get("purchaseDate"), yearStart, yearEnd)
            );
        });
        
        // Calculate totals and profits - MULTIPLY BY QUANTITY
        BigDecimal todayRevenue = BigDecimal.ZERO;
        BigDecimal todayProfit = BigDecimal.ZERO;
        for (Customer customer : todayCustomers) {
            if (customer.getSellingPrice() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                todayRevenue = todayRevenue.add(customer.getSellingPrice().multiply(new BigDecimal(quantity)));
            }
            if (customer.getProfitLoss() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                todayProfit = todayProfit.add(customer.getProfitLoss().multiply(new BigDecimal(quantity)));
            }
        }
        
        BigDecimal weekRevenue = BigDecimal.ZERO;
        BigDecimal weekProfit = BigDecimal.ZERO;
        for (Customer customer : weekCustomers) {
            if (customer.getSellingPrice() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                weekRevenue = weekRevenue.add(customer.getSellingPrice().multiply(new BigDecimal(quantity)));
            }
            if (customer.getProfitLoss() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                weekProfit = weekProfit.add(customer.getProfitLoss().multiply(new BigDecimal(quantity)));
            }
        }
        
        BigDecimal monthRevenue = BigDecimal.ZERO;
        BigDecimal monthProfit = BigDecimal.ZERO;
        for (Customer customer : monthCustomers) {
            if (customer.getSellingPrice() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                monthRevenue = monthRevenue.add(customer.getSellingPrice().multiply(new BigDecimal(quantity)));
            }
            if (customer.getProfitLoss() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                monthProfit = monthProfit.add(customer.getProfitLoss().multiply(new BigDecimal(quantity)));
            }
        }
        
        BigDecimal yearRevenue = BigDecimal.ZERO;
        BigDecimal yearProfit = BigDecimal.ZERO;
        for (Customer customer : yearCustomers) {
            if (customer.getSellingPrice() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                yearRevenue = yearRevenue.add(customer.getSellingPrice().multiply(new BigDecimal(quantity)));
            }
            if (customer.getProfitLoss() != null) {
                Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
                yearProfit = yearProfit.add(customer.getProfitLoss().multiply(new BigDecimal(quantity)));
            }
        }
        
        // Calculate percentages
        BigDecimal todayProfitPercent = BigDecimal.ZERO;
        if (todayRevenue.compareTo(BigDecimal.ZERO) > 0) {
            todayProfitPercent = todayProfit.multiply(new BigDecimal("100"))
                .divide(todayRevenue, 2, RoundingMode.HALF_UP);
        }
        
        BigDecimal weekProfitPercent = BigDecimal.ZERO;
        if (weekRevenue.compareTo(BigDecimal.ZERO) > 0) {
            weekProfitPercent = weekProfit.multiply(new BigDecimal("100"))
                .divide(weekRevenue, 2, RoundingMode.HALF_UP);
        }
        
        BigDecimal monthProfitPercent = BigDecimal.ZERO;
        if (monthRevenue.compareTo(BigDecimal.ZERO) > 0) {
            monthProfitPercent = monthProfit.multiply(new BigDecimal("100"))
                .divide(monthRevenue, 2, RoundingMode.HALF_UP);
        }
        
        BigDecimal yearProfitPercent = BigDecimal.ZERO;
        if (yearRevenue.compareTo(BigDecimal.ZERO) > 0) {
            yearProfitPercent = yearProfit.multiply(new BigDecimal("100"))
                .divide(yearRevenue, 2, RoundingMode.HALF_UP);
        }
        
        // Add insights
        insights.put("todayCustomers", todayCustomers.size());
        insights.put("todayRevenue", todayRevenue);
        insights.put("todayProfit", todayProfit);
        insights.put("todayProfitPercent", todayProfitPercent);
        
        insights.put("weekCustomers", weekCustomers.size());
        insights.put("weekRevenue", weekRevenue);
        insights.put("weekProfit", weekProfit);
        insights.put("weekProfitPercent", weekProfitPercent);
        
        insights.put("monthCustomers", monthCustomers.size());
        insights.put("monthRevenue", monthRevenue);
        insights.put("monthProfit", monthProfit);
        insights.put("monthProfitPercent", monthProfitPercent);
        
        insights.put("yearCustomers", yearCustomers.size());
        insights.put("yearRevenue", yearRevenue);
        insights.put("yearProfit", yearProfit);
        insights.put("yearProfitPercent", yearProfitPercent);
        
        insights.put("currentYear", currentYear);
        
        // Add chart data
        insights.put("monthlySalesData", chartDataService.getMonthlySalesData(user, currentYear));
        insights.put("topProductsData", chartDataService.getTopProductsData(user));
        
        // Debug logging
        System.out.println("=== Dashboard Insights ===");
        System.out.println("Today revenue: " + todayRevenue + " (with quantity multiplication)");
        System.out.println("Today profit: " + todayProfit + " (with quantity multiplication)");
        System.out.println("Week revenue: " + weekRevenue + " (with quantity multiplication)");
        System.out.println("Week profit: " + weekProfit + " (with quantity multiplication)");
        
        return insights;
    }
}