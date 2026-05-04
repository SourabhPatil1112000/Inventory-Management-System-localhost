package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Category;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Product;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CategoryRepository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CustomerRepository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.ProductRepository;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    // Get all categories for specific user
    public List<Category> getAllCategoriesByUser(User user) {
        return categoryRepository.findByUser(user);
    }
    
    // Get all categories (for admin/backward compatibility)
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    public Optional<Category> getCategoryByIdAndUser(Long id, User user) {
        return categoryRepository.findByIdAndUser(id, user);
    }
    
    public Category saveCategory(Category category, User user) {
        // Check if category with same name exists for this user only
        Optional<Category> existingCategory = categoryRepository.findByNameAndUser(category.getName(), user);
        if (existingCategory.isPresent()) {
            throw new RuntimeException("Category already exists for your account: " + category.getName());
        }
        category.setUser(user); // Set user
        return categoryRepository.save(category);
    }
    
    // For backward compatibility
    public Category saveCategory(Category category) {
        // This should be avoided in new code
        return categoryRepository.save(category);
    }
    
    public Category updateCategory(Long id, Category category, User user) {
        Category existingCategory = categoryRepository.findByIdAndUser(id, user)
            .orElseThrow(() -> new RuntimeException("Category not found or access denied"));
        
        // Only check for duplicate name if name is being changed
        if (!existingCategory.getName().equals(category.getName())) {
            Optional<Category> duplicateCategory = categoryRepository.findByNameAndUser(category.getName(), user);
            if (duplicateCategory.isPresent() && !duplicateCategory.get().getId().equals(id)) {
                throw new RuntimeException("Category already exists for your account: " + category.getName());
            }
        }
        
        existingCategory.setName(category.getName());
        return categoryRepository.save(existingCategory);
    }
    
    @Transactional
    public boolean deleteCategory(Long id, User user) {
        try {
            Category category = categoryRepository.findByIdAndUser(id, user)
                .orElseThrow(() -> new RuntimeException("Category not found or access denied"));
            
            // First, get all products in this category for this user
            List<Product> productsInCategory = productRepository.findByCategoryIdAndUser(id, user);
            
            // Check if any customers are using products from this category
            for (Product product : productsInCategory) {
                List<Customer> customers = customerRepository.findByProductId(product.getId());
                if (!customers.isEmpty()) {
                    throw new RuntimeException(
                        "Cannot delete category. Product '" + product.getName() + 
                        "' has " + customers.size() + " customer(s) associated with it."
                    );
                }
            }
            
            // If no customers, delete all products in this category first
            for (Product product : productsInCategory) {
                productRepository.delete(product);
            }
            
            // Now delete the category
            categoryRepository.delete(category);
            return true;
            
        } catch (RuntimeException e) {
            // Re-throw our custom exception
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Error deleting category: " + e.getMessage());
        }
    }
    
    public boolean canDeleteCategory(Long id, User user) {
        Category category = categoryRepository.findByIdAndUser(id, user)
            .orElseThrow(() -> new RuntimeException("Category not found or access denied"));
        
        List<Product> productsInCategory = productRepository.findByCategoryIdAndUser(id, user);
        for (Product product : productsInCategory) {
            List<Customer> customers = customerRepository.findByProductId(product.getId());
            if (!customers.isEmpty()) {
                return false;
            }
        }
        return true;
    }

    public String getDeletionStatus(Long id, User user) {
        Category category = categoryRepository.findByIdAndUser(id, user)
            .orElseThrow(() -> new RuntimeException("Category not found or access denied"));
        
        List<Product> productsInCategory = productRepository.findByCategoryIdAndUser(id, user);
        StringBuilder status = new StringBuilder();
        boolean canDelete = true;
        
        if (productsInCategory.isEmpty()) {
            return "Category can be deleted (no products in this category)";
        }
        
        for (Product product : productsInCategory) {
            List<Customer> customers = customerRepository.findByProductId(product.getId());
            if (!customers.isEmpty()) {
                canDelete = false;
                status.append("Product '").append(product.getName())
                      .append("' has ").append(customers.size())
                      .append(" customer(s)").append("\n");
            }
        }
        
        if (canDelete) {
            return "Category can be deleted";
        } else {
            return "Cannot delete category. The following products have customers:\n" + status.toString();
        }
    }
}