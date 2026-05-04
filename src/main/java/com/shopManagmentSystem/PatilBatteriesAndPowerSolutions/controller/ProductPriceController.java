package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Category;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Product;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.CategoryService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.ProductService;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/products")
public class ProductPriceController {
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/prices")
    public String showPriceManagement(Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Get all categories for current user
        List<Category> categories = categoryService.getAllCategoriesByUser(currentUser);
        model.addAttribute("categories", categories);
        model.addAttribute("currentUser", username);
        
        return "PriceManagement";
    }
    
    // ========== CATEGORY METHODS ==========
    
    @GetMapping("/categories/add")
    public String showAddCategoryForm(Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("category", new Category());
        model.addAttribute("currentUser", username);
        return "AddCategory";
    }
    
    @PostMapping("/categories/save")
    public String saveCategory(@ModelAttribute Category category, 
                             RedirectAttributes redirectAttributes,
                             HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            categoryService.saveCategory(category, currentUser);
            redirectAttributes.addFlashAttribute("message", "Category added successfully!");
            return "redirect:/products/prices";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error adding category: " + e.getMessage());
            return "redirect:/products/categories/add";
        }
    }
    
    @GetMapping("/categories/edit/{id}")
    public String showEditCategoryForm(@PathVariable Long id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Category category = categoryService.getCategoryByIdAndUser(id, currentUser)
            .orElseThrow(() -> new RuntimeException("Category not found or access denied"));
        
        model.addAttribute("category", category);
        model.addAttribute("currentUser", username);
        return "EditCategory";
    }
    
    @PostMapping("/categories/update")
    public String updateCategory(@ModelAttribute Category category,
                               RedirectAttributes redirectAttributes,
                               HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            categoryService.updateCategory(category.getId(), category, currentUser);
            redirectAttributes.addFlashAttribute("message", "Category updated successfully!");
            return "redirect:/products/prices";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error updating category: " + e.getMessage());
            return "redirect:/products/categories/edit/" + category.getId();
        }
    }
    
    @GetMapping("/categories/delete-confirm/{id}")
    public String showDeleteCategoryConfirm(@PathVariable Long id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Category category = categoryService.getCategoryByIdAndUser(id, currentUser)
            .orElseThrow(() -> new RuntimeException("Category not found or access denied"));
        
        boolean canDelete = categoryService.canDeleteCategory(id, currentUser);
        
        model.addAttribute("category", category);
        model.addAttribute("canDelete", canDelete);
        model.addAttribute("currentUser", username);
        
        return "CategoryDeleteConfirm";
    }
    
    @GetMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable Long id,
                               RedirectAttributes redirectAttributes,
                               HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            boolean deleted = categoryService.deleteCategory(id, currentUser);
            if (deleted) {
                redirectAttributes.addFlashAttribute("message", "Category deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("message", "Error deleting category");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error: " + e.getMessage());
        }
        
        return "redirect:/products/prices";
    }
    
    // ========== PRODUCT METHODS ==========
    
    @GetMapping("/add")
    public String showAddProductForm(Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        model.addAttribute("product", new Product());
        model.addAttribute("categories", categoryService.getAllCategoriesByUser(currentUser));
        model.addAttribute("currentUser", username);
        return "AddProduct";
    }
    
    @PostMapping("/save")
    public String saveProduct(@ModelAttribute Product product,
                            RedirectAttributes redirectAttributes,
                            HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            productService.saveProduct(product, currentUser);
            redirectAttributes.addFlashAttribute("message", "Product added successfully!");
            return "redirect:/products/prices";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error adding product: " + e.getMessage());
            return "redirect:/products/add";
        }
    }
    
    @GetMapping("/edit/{id}")
    public String showEditProductForm(@PathVariable Long id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Product product = productService.getProductByIdAndUser(id, currentUser)
            .orElseThrow(() -> new RuntimeException("Product not found or access denied"));
        
        model.addAttribute("product", product);
        model.addAttribute("categories", categoryService.getAllCategoriesByUser(currentUser));
        model.addAttribute("currentUser", username);
        return "EditProduct";
    }
    
    @PostMapping("/update")
    public String updateProduct(@ModelAttribute Product product,
                              RedirectAttributes redirectAttributes,
                              HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            productService.updateProduct(product.getId(), product, currentUser);
            redirectAttributes.addFlashAttribute("message", "Product updated successfully!");
            return "redirect:/products/prices";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error updating product: " + e.getMessage());
            return "redirect:/products/edit/" + product.getId();
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id,
                              RedirectAttributes redirectAttributes,
                              HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            boolean deleted = productService.deleteProduct(id, currentUser);
            if (deleted) {
                redirectAttributes.addFlashAttribute("message", "Product deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("message", "Error deleting product");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error: " + e.getMessage());
        }
        
        return "redirect:/products/prices";
    }
    
    @PostMapping("/update-price")
    public String updateProductPrice(@RequestParam Long productId,
                                   @RequestParam BigDecimal purchasePrice,
                                   @RequestParam BigDecimal sellingPrice,
                                   RedirectAttributes redirectAttributes,
                                   HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        try {
            productService.updateProductPrice(productId, purchasePrice, sellingPrice, currentUser);
            redirectAttributes.addFlashAttribute("message", "Product price updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Error updating price: " + e.getMessage());
        }
        
        return "redirect:/products/prices";
    }
    
    @GetMapping("/delete-confirm/{id}")
    public String showDeleteProductConfirm(@PathVariable Long id, 
                                         Model model, 
                                         HttpSession session) {
        String username = (String) session.getAttribute("currentUser");
        if (username == null) {
            return "redirect:/login";
        }
        
        User currentUser = userService.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Product product = productService.getProductByIdAndUser(id, currentUser)
            .orElseThrow(() -> new RuntimeException("Product not found or access denied"));
        
        boolean canDelete = productService.canDeleteProduct(id, currentUser);
        int customerCount = productService.getCustomerCount(id);
        
        model.addAttribute("product", product);
        model.addAttribute("canDelete", canDelete);
        model.addAttribute("customerCount", customerCount);
        model.addAttribute("currentUser", username);
        
        return "ProductDeleteConfirm";
    }
    
}