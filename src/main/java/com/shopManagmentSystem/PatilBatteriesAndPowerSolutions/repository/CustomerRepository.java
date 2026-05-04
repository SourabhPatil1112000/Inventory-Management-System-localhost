package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long>, JpaSpecificationExecutor<Customer> {
    // Existing methods
    List<Customer> findByMobileNumber(String mobileNumber);
    Optional<Customer> findByNameAndMobileNumber(String name, String mobileNumber);
    List<Customer> findByArea(String area);
    List<Customer> findByCategoryId(Long categoryId);
    
    // New user-specific methods
    List<Customer> findByUser(User user);
    Optional<Customer> findByIdAndUser(Long id, User user);
    List<Customer> findByUserAndCategoryId(User user, Long categoryId);
    List<Customer> findByUserAndArea(User user, String area);
    void deleteByIdAndUser(Long id, User user);
    
    // ADD THIS METHOD - To check if customers exist for a product
    List<Customer> findByProductId(Long productId);
    
    // ADD THIS METHOD - To count customers for a product
    Long countByProductId(Long productId);
}