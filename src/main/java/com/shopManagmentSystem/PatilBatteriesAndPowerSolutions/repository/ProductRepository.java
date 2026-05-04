package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Product;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    // User-specific methods
    List<Product> findByUser(User user);
    List<Product> findByCategoryIdAndUser(Long categoryId, User user);
    Optional<Product> findByIdAndUser(Long id, User user);
    Optional<Product> findByNameAndCategoryIdAndUser(String name, Long categoryId, User user);
    Boolean existsByNameAndCategoryIdAndUser(String name, Long categoryId, User user);
    
    // For backward compatibility
    List<Product> findByCategoryId(Long categoryId);
}