package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CustomerRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CustomerService {
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private InventoryService inventoryService;
    
    @Autowired
    private UserService userService;
    
    // Get all customers for specific user
    public List<Customer> getAllCustomersByUser(User user) {
        return customerRepository.findByUser(user);
    }
    
    // Get all customers (for admin purposes)
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }
    
    // Get customer by ID for specific user
    public Optional<Customer> getCustomerByIdAndUser(Long id, User user) {
        return customerRepository.findByIdAndUser(id, user);
    }
    
    // Get customer by ID (without user check - for backwards compatibility)
    public Optional<Customer> getCustomerById(Long id) {
        return customerRepository.findById(id);
    }
    
    // Save customer with user association (UPDATED METHOD)
    public Customer saveCustomer(Customer customer, User user) {
        // Check if product is in stock
        if (customer.getProduct() != null && customer.getQuantity() > 0) {
            Optional<com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory> inventoryOpt = 
                inventoryService.getInventoryByProductIdAndUser(customer.getProduct().getId(), user);
            
            if (inventoryOpt.isPresent()) {
                com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory inventory = inventoryOpt.get();
                if (inventory.getQuantity() < customer.getQuantity()) {
                    throw new RuntimeException(
                        "Product '" + customer.getProduct().getName() + 
                        "' is out of stock. Available: " + inventory.getQuantity() + 
                        ", Requested: " + customer.getQuantity()
                    );
                }
            } else {
                throw new RuntimeException(
                    "Product '" + customer.getProduct().getName() + "' is not in inventory"
                );
            }
        }
        
        // Calculate profit/loss based on selling price
        if (customer.getProduct() != null && customer.getProduct().getPurchasePrice() != null 
            && customer.getSellingPrice() != null) {
            BigDecimal purchasePrice = customer.getProduct().getPurchasePrice();
            BigDecimal sellingPrice = customer.getSellingPrice();
            
            // Calculate profit/loss from selling price
            BigDecimal profitLoss = sellingPrice.subtract(purchasePrice);
            customer.setProfitLoss(profitLoss);
            
            // Calculate percentage
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal profitLossPercent = profitLoss.multiply(new BigDecimal("100"))
                    .divide(purchasePrice, 2, RoundingMode.HALF_UP);
                customer.setProfitLossPercent(profitLossPercent);
            }
        }
        
        customer.setUser(user); // Set the user
        if (customer.getPurchaseDate() == null) {
            customer.setPurchaseDate(LocalDate.now());
        }
        customer.setCreatedAt(LocalDateTime.now());
        Customer savedCustomer = customerRepository.save(customer);
        
        // Update inventory - reduce stock by quantity for this user
        if (savedCustomer.getProduct() != null && savedCustomer.getQuantity() > 0) {
            inventoryService.reduceStock(savedCustomer.getProduct().getId(), savedCustomer.getQuantity(), user);
        }
        
        return savedCustomer;
    }
    
    // Save customer without user (for backwards compatibility)
    public Customer saveCustomer(Customer customer) {
        // For backward compatibility - try to get user from session
        // This should be replaced with saveCustomer(customer, user) in controllers
        return saveCustomerWithDefaultUser(customer);
    }
    
    private Customer saveCustomerWithDefaultUser(Customer customer) {
        // This is a temporary method until all controllers are updated
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        return saveCustomer(customer, defaultUser);
    }
    
    // Update customer with user validation (UPDATED METHOD)
    public Customer updateCustomer(Long id, Customer customer, User user) {
        Customer existingCustomer = customerRepository.findByIdAndUser(id, user)
            .orElseThrow(() -> new RuntimeException("Customer not found or access denied"));
        
        // Save old quantity and product for inventory adjustment
        int oldQuantity = existingCustomer.getQuantity();
        Long oldProductId = existingCustomer.getProduct().getId();
        
        int newQuantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
        Long newProductId = customer.getProduct().getId();
        
        boolean productChanged = !oldProductId.equals(newProductId);
        boolean quantityChanged = oldQuantity != newQuantity;
        
        // If product changed or quantity changed, update inventory
        if (productChanged) {
            // Return stock for old product
            inventoryService.increaseStock(oldProductId, oldQuantity, user);
            
            // Check if new product has enough stock
            Optional<com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory> inventoryOpt = 
                inventoryService.getInventoryByProductIdAndUser(newProductId, user);
            
            if (inventoryOpt.isPresent()) {
                com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory inventory = inventoryOpt.get();
                if (inventory.getQuantity() < newQuantity) {
                    // Restore old product stock
                    inventoryService.reduceStock(oldProductId, oldQuantity, user);
                    throw new RuntimeException(
                        "Product '" + customer.getProduct().getName() + 
                        "' is out of stock. Available: " + inventory.getQuantity() + 
                        ", Requested: " + newQuantity
                    );
                }
            }
            // Reduce stock for new product
            inventoryService.reduceStock(newProductId, newQuantity, user);
            
        } else if (quantityChanged) {
            int quantityDifference = newQuantity - oldQuantity;
            
            if (quantityDifference > 0) {
                // Need to reduce more stock
                Optional<com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory> inventoryOpt = 
                    inventoryService.getInventoryByProductIdAndUser(oldProductId, user);
                
                if (inventoryOpt.isPresent()) {
                    com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory inventory = inventoryOpt.get();
                    if (inventory.getQuantity() < quantityDifference) {
                        throw new RuntimeException(
                            "Insufficient stock. Available: " + inventory.getQuantity() + 
                            ", Additional needed: " + quantityDifference
                        );
                    }
                }
            }
            
            if (quantityDifference > 0) {
                inventoryService.reduceStock(oldProductId, quantityDifference, user);
            } else {
                inventoryService.increaseStock(oldProductId, -quantityDifference, user);
            }
        }
        
        // Update fields - KEEP THE EXISTING SELLING PRICE FROM FORM
        existingCustomer.setName(customer.getName());
        existingCustomer.setMobileNumber(customer.getMobileNumber());
        existingCustomer.setCategory(customer.getCategory());
        existingCustomer.setProduct(customer.getProduct());
        existingCustomer.setPurchaseDate(customer.getPurchaseDate());
        existingCustomer.setVehicleNumber(customer.getVehicleNumber());
        existingCustomer.setArea(customer.getArea());
        existingCustomer.setQuantity(newQuantity);
        
        // CRITICAL FIX: Set the selling price from the form
        if (customer.getSellingPrice() != null) {
            existingCustomer.setSellingPrice(customer.getSellingPrice());
        }
        
        // Set profit/loss from form (they should be calculated in the form)
        if (customer.getProfitLoss() != null) {
            existingCustomer.setProfitLoss(customer.getProfitLoss());
        }
        
        if (customer.getProfitLossPercent() != null) {
            existingCustomer.setProfitLossPercent(customer.getProfitLossPercent());
        }
        
        // If profit/loss is not set but selling price is, calculate it
        if (existingCustomer.getSellingPrice() != null && existingCustomer.getProduct() != null 
            && existingCustomer.getProduct().getPurchasePrice() != null) {
            BigDecimal purchasePrice = existingCustomer.getProduct().getPurchasePrice();
            BigDecimal sellingPrice = existingCustomer.getSellingPrice();
            BigDecimal profitLoss = sellingPrice.subtract(purchasePrice);
            
            existingCustomer.setProfitLoss(profitLoss);
            
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal profitLossPercent = profitLoss.multiply(new BigDecimal("100"))
                    .divide(purchasePrice, 2, RoundingMode.HALF_UP);
                existingCustomer.setProfitLossPercent(profitLossPercent);
            }
        }
        
        return customerRepository.save(existingCustomer);
    }
    
    // Update customer without user (for backwards compatibility)
    public Customer updateCustomer(Long id, Customer customer) {
        // For backward compatibility
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        return updateCustomer(id, customer, defaultUser);
    }
    
    // Delete customer with user validation (UPDATED METHOD)
    public boolean deleteCustomer(Long id, User user) {
        Optional<Customer> customerOpt = customerRepository.findByIdAndUser(id, user);
        if (customerOpt.isPresent()) {
            Customer customer = customerOpt.get();
            // Return stock to inventory for this user
            if (customer.getProduct() != null && customer.getQuantity() > 0) {
                inventoryService.increaseStock(customer.getProduct().getId(), customer.getQuantity(), user);
            }
            customerRepository.deleteById(id);
            return true;
        }
        return false;
    }
    
    // Delete customer without user (for backwards compatibility)
    public boolean deleteCustomer(Long id) {
        // For backward compatibility
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        return deleteCustomer(id, defaultUser);
    }
    
    // Search customers for specific user (NEW METHOD)
    public List<Customer> searchCustomers(User user, String name, String mobileNumber, 
                                        Long categoryId, String area, 
                                        LocalDate startDate, LocalDate endDate) {
        
        List<Customer> allCustomers = customerRepository.findByUser(user);
        
        return allCustomers.stream()
            .filter(customer -> name == null || name.trim().isEmpty() || 
                    customer.getName().toLowerCase().contains(name.toLowerCase().trim()))
            .filter(customer -> mobileNumber == null || mobileNumber.trim().isEmpty() || 
                    customer.getMobileNumber().contains(mobileNumber.trim()))
            .filter(customer -> categoryId == null || 
                    (customer.getCategory() != null && customer.getCategory().getId().equals(categoryId)))
            .filter(customer -> area == null || area.trim().isEmpty() || 
                    (customer.getArea() != null && customer.getArea().equalsIgnoreCase(area.trim())))
            .filter(customer -> startDate == null || 
                    (customer.getPurchaseDate() != null && !customer.getPurchaseDate().isBefore(startDate)))
            .filter(customer -> endDate == null || 
                    (customer.getPurchaseDate() != null && !customer.getPurchaseDate().isAfter(endDate)))
            .collect(Collectors.toList());
    }
    
    // Search customers without user (for backwards compatibility)
    public List<Customer> searchCustomers(String name, String mobileNumber, Long categoryId, 
                                        String area, LocalDate startDate, LocalDate endDate) {
        // For backward compatibility - search all users' data
        List<Customer> allCustomers = customerRepository.findAll();
        
        return allCustomers.stream()
            .filter(customer -> name == null || name.trim().isEmpty() || 
                    customer.getName().toLowerCase().contains(name.toLowerCase().trim()))
            .filter(customer -> mobileNumber == null || mobileNumber.trim().isEmpty() || 
                    customer.getMobileNumber().contains(mobileNumber.trim()))
            .filter(customer -> categoryId == null || 
                    (customer.getCategory() != null && customer.getCategory().getId().equals(categoryId)))
            .filter(customer -> area == null || area.trim().isEmpty() || 
                    (customer.getArea() != null && customer.getArea().equalsIgnoreCase(area.trim())))
            .filter(customer -> startDate == null || 
                    (customer.getPurchaseDate() != null && !customer.getPurchaseDate().isBefore(startDate)))
            .filter(customer -> endDate == null || 
                    (customer.getPurchaseDate() != null && !customer.getPurchaseDate().isAfter(endDate)))
            .collect(Collectors.toList());
    }
}