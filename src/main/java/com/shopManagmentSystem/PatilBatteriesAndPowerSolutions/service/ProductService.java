package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Product;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CustomerRepository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.InventoryRepository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.ProductRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private InventoryRepository inventoryRepository;
    
    // Get all products for specific user
    public List<Product> getAllProductsByUser(User user) {
        return productRepository.findByUser(user);
    }
    
    // Get all products (for admin/backward compatibility)
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    public List<Product> getProductsByCategoryAndUser(Long categoryId, User user) {
        return productRepository.findByCategoryIdAndUser(categoryId, user);
    }
    
    // For backward compatibility (CustomerController uses this)
    public List<Product> getProductsByCategory(Long categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }

    public Optional<Product> getProductByIdAndUser(Long id, User user) {
        return productRepository.findByIdAndUser(id, user);
    }
    
    // For backward compatibility
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }
    
    public Product saveProduct(Product product, User user) {
        // Check if product with same name exists in same category for this user only
        Optional<Product> existingProduct = productRepository.findByNameAndCategoryIdAndUser(
            product.getName(), product.getCategory().getId(), user);
        if (existingProduct.isPresent()) {
            throw new RuntimeException("Product already exists in this category for your account: " + product.getName());
        }
        product.setUser(user); // Set user
        return productRepository.save(product);
    }
    
    // For backward compatibility
    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }
    
    public Product updateProduct(Long id, Product product, User user) {
        Product existingProduct = productRepository.findByIdAndUser(id, user)
            .orElseThrow(() -> new RuntimeException("Product not found or access denied"));
        
        // Check for duplicate name only if name or category is being changed
        if (!existingProduct.getName().equals(product.getName()) || 
            !existingProduct.getCategory().getId().equals(product.getCategory().getId())) {
            
            Optional<Product> duplicateProduct = productRepository.findByNameAndCategoryIdAndUser(
                product.getName(), product.getCategory().getId(), user);
            if (duplicateProduct.isPresent() && !duplicateProduct.get().getId().equals(id)) {
                throw new RuntimeException("Product already exists in this category for your account: " + product.getName());
            }
        }
        
        existingProduct.setName(product.getName());
        existingProduct.setDescription(product.getDescription());
        existingProduct.setPurchasePrice(product.getPurchasePrice());
        existingProduct.setSellingPrice(product.getSellingPrice());
        existingProduct.setCategory(product.getCategory());
        
        return productRepository.save(existingProduct);
    }
    
    @Transactional
    public boolean deleteProduct(Long id, User user) {
        try {
            Product product = productRepository.findByIdAndUser(id, user)
                .orElseThrow(() -> new RuntimeException("Product not found or access denied"));
            
            // First check if any customers are using this product
            List<Customer> customers = customerRepository.findByProductId(id);
            
            if (!customers.isEmpty()) {
                throw new RuntimeException(
                    "Cannot delete product. It has " + customers.size() + " customer(s) associated with it."
                );
            }
            
            // Check and delete inventory if exists for this user
            Optional<Inventory> inventoryOpt = inventoryRepository.findByProductIdAndUser(id, user);
            if (inventoryOpt.isPresent()) {
                inventoryRepository.delete(inventoryOpt.get());
            }
            
            // Now delete the product
            productRepository.delete(product);
            return true;
            
        } catch (RuntimeException e) {
            // Re-throw our custom exception
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Error deleting product: " + e.getMessage());
        }
    }
    
    public void updateProductPrice(Long productId, BigDecimal purchasePrice, BigDecimal sellingPrice, User user) {
        Product product = productRepository.findByIdAndUser(productId, user)
            .orElseThrow(() -> new RuntimeException("Product not found or access denied"));
        
        product.setPurchasePrice(purchasePrice);
        product.setSellingPrice(sellingPrice);
        productRepository.save(product);
    }
    
    // Helper method to check if product can be deleted
    public boolean canDeleteProduct(Long id, User user) {
        List<Customer> customers = customerRepository.findByProductId(id);
        return customers.isEmpty();
    }
    
    // Get customer count for a product
    public int getCustomerCount(Long productId) {
        List<Customer> customers = customerRepository.findByProductId(productId);
        return customers.size();
    }
}