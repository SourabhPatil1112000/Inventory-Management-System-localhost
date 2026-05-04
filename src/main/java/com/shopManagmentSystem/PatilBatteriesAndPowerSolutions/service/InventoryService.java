package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.InventoryRepository;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class InventoryService {
    
    @Autowired
    private InventoryRepository inventoryRepository;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private UserService userService;
    
    // Get all inventory for specific user
    public List<Inventory> getAllInventoryByUser(User user) {
        return inventoryRepository.findByUser(user);
    }
    
    // Get all inventory (for admin purposes)
    public List<Inventory> getAllInventory() {
        return inventoryRepository.findAll();
    }
    
    // Get inventory by product for specific user
    public Optional<Inventory> getInventoryByProductIdAndUser(Long productId, User user) {
        return inventoryRepository.findByProductIdAndUser(productId, user);
    }
    
    // Get inventory by product (without user check - for backwards compatibility)
    public Optional<Inventory> getInventoryByProductId(Long productId) {
        return inventoryRepository.findByProductId(productId);
    }
    
    // Update stock for specific user
    public Inventory updateStock(Long productId, Integer quantity, User user) {
        Optional<Inventory> inventoryOpt = inventoryRepository.findByProductIdAndUser(productId, user);
        Inventory inventory;
        
        if (inventoryOpt.isPresent()) {
            inventory = inventoryOpt.get();
            inventory.setQuantity(quantity);
        } else {
            inventory = new Inventory();
            inventory.setProduct(productService.getProductByIdAndUser(productId, user)
                .orElseThrow(() -> new RuntimeException("Product not found or access denied")));
            inventory.setQuantity(quantity);
            inventory.setUser(user); // Set user
        }
        
        inventory.setLastUpdated(LocalDateTime.now());
        return inventoryRepository.save(inventory);
    }
    
    // Update stock without user (for backwards compatibility)
    public Inventory updateStock(Long productId, Integer quantity) {
        // For backward compatibility
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        return updateStock(productId, quantity, defaultUser);
    }
    
    // Reduce stock for specific user
    public void reduceStock(Long productId, Integer quantity, User user) {
        Optional<Inventory> inventoryOpt = inventoryRepository.findByProductIdAndUser(productId, user);
        if (inventoryOpt.isPresent()) {
            Inventory inventory = inventoryOpt.get();
            int newQuantity = inventory.getQuantity() - quantity;
            if (newQuantity < 0) newQuantity = 0;
            inventory.setQuantity(newQuantity);
            inventory.setLastUpdated(LocalDateTime.now());
            inventoryRepository.save(inventory);
        } else {
            // Create new inventory with 0 stock if doesn't exist
            Inventory inventory = new Inventory();
            inventory.setProduct(productService.getProductByIdAndUser(productId, user)
                .orElseThrow(() -> new RuntimeException("Product not found or access denied")));
            inventory.setQuantity(0);
            inventory.setUser(user);
            inventory.setLastUpdated(LocalDateTime.now());
            inventoryRepository.save(inventory);
        }
    }
    
    // Reduce stock without user (for backwards compatibility)
    public void reduceStock(Long productId, Integer quantity) {
        // For backward compatibility
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        reduceStock(productId, quantity, defaultUser);
    }
    
    // Increase stock for specific user
    public void increaseStock(Long productId, Integer quantity, User user) {
        Optional<Inventory> inventoryOpt = inventoryRepository.findByProductIdAndUser(productId, user);
        Inventory inventory;
        
        if (inventoryOpt.isPresent()) {
            inventory = inventoryOpt.get();
            inventory.setQuantity(inventory.getQuantity() + quantity);
        } else {
            inventory = new Inventory();
            inventory.setProduct(productService.getProductByIdAndUser(productId, user)
                .orElseThrow(() -> new RuntimeException("Product not found or access denied")));
            inventory.setQuantity(quantity);
            inventory.setUser(user); // Set user
        }
        
        inventory.setLastUpdated(LocalDateTime.now());
        inventoryRepository.save(inventory);
    }
    
    // Increase stock without user (for backwards compatibility)
    public void increaseStock(Long productId, Integer quantity) {
        // For backward compatibility
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        increaseStock(productId, quantity, defaultUser);
    }
    
    // Delete inventory entry for specific user
    public boolean deleteInventory(Long productId, User user) {
        Optional<Inventory> inventoryOpt = inventoryRepository.findByProductIdAndUser(productId, user);
        if (inventoryOpt.isPresent()) {
            inventoryRepository.delete(inventoryOpt.get());
            return true;
        }
        return false;
    }
    
    // Delete inventory without user (for backwards compatibility)
    public boolean deleteInventory(Long productId) {
        // For backward compatibility
        User defaultUser = userService.findByUsername("admin")
            .orElseThrow(() -> new RuntimeException("Default user not found"));
        return deleteInventory(productId, defaultUser);
    }
    
    // Get low stock alerts
    public List<Map<String, Object>> getLowStockAlerts(User user, int threshold) {
        List<Inventory> userInventory = getAllInventoryByUser(user);
        List<Map<String, Object>> alerts = new ArrayList<>();
        
        for (Inventory inventory : userInventory) {
            if (inventory.getQuantity() <= threshold) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("productId", inventory.getProduct().getId());
                alert.put("productName", inventory.getProduct().getName());
                alert.put("quantity", inventory.getQuantity());
                alert.put("threshold", threshold);
                alerts.add(alert);
            }
        }
        
        return alerts;
    }
    
    // Check if product is in stock
    public boolean isInStock(Long productId, Integer requiredQuantity, User user) {
        Optional<Inventory> inventoryOpt = inventoryRepository.findByProductIdAndUser(productId, user);
        if (inventoryOpt.isPresent()) {
            return inventoryOpt.get().getQuantity() >= requiredQuantity;
        }
        return false;
    }
}