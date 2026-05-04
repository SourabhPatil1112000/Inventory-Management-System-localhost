package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Inventory;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import java.util.List;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    // Existing methods
    Optional<Inventory> findByProductId(Long productId);
    
    // New user-specific methods
    List<Inventory> findByUser(User user);
    Optional<Inventory> findByProductIdAndUser(Long productId, User user);
    Boolean existsByProductIdAndUser(Long productId, User user);
}