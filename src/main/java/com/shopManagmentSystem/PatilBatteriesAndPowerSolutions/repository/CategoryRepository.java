package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Category;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByName(String name);
    Boolean existsByName(String name);
    
    // User-specific methods
    List<Category> findByUser(User user);
    Optional<Category> findByIdAndUser(Long id, User user);
    Optional<Category> findByNameAndUser(String name, User user);
    Boolean existsByNameAndUser(String name, User user);
}