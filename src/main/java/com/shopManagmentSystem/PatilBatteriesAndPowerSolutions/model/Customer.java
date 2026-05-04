package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "customers")
public class Customer {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(name = "mobile_number", nullable = false)
    private String mobileNumber;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;
    
    @Column(name = "purchase_date")
    private LocalDate purchaseDate;
    
    @Column(name = "vehicle_number")
    private String vehicleNumber;
    
    private String area;
    
    @Column(name = "selling_price", precision = 10, scale = 2)
    private BigDecimal sellingPrice;
    
    @Column(name = "profit_loss", precision = 10, scale = 2)
    private BigDecimal profitLoss;
    
    @Column(name = "profit_loss_percent", precision = 5, scale = 2)
    private BigDecimal profitLossPercent;
    
    @Column(nullable = false)
    private Integer quantity = 1;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    // Transient fields for calculation
    @Transient
    private BigDecimal totalSellingPrice;
    
    @Transient
    private BigDecimal totalProfitLoss;
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }
    
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { 
        this.product = product; 
        // Recalculate when product changes
        calculateProfitLossFromSellingPrice();
    }
    
    public LocalDate getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(LocalDate purchaseDate) { this.purchaseDate = purchaseDate; }
    
    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }
    
    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }
    
    public BigDecimal getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(BigDecimal sellingPrice) { 
        this.sellingPrice = sellingPrice; 
        calculateProfitLossFromSellingPrice();
    }
    
    public BigDecimal getProfitLoss() { return profitLoss; }
    public void setProfitLoss(BigDecimal profitLoss) { 
        this.profitLoss = profitLoss; 
        calculateSellingPriceFromProfitLoss();
    }
    
    public BigDecimal getProfitLossPercent() { return profitLossPercent; }
    public void setProfitLossPercent(BigDecimal profitLossPercent) { 
        this.profitLossPercent = profitLossPercent; 
        calculateFromProfitLossPercent();
    }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { 
        this.quantity = quantity != null ? quantity : 1;
        calculateDerivedFields();
    }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    // Calculate derived fields
    private void calculateDerivedFields() {
        if (sellingPrice != null && quantity != null) {
            totalSellingPrice = sellingPrice.multiply(new BigDecimal(quantity));
        }
        
        if (profitLoss != null && quantity != null) {
            totalProfitLoss = profitLoss.multiply(new BigDecimal(quantity));
        }
    }
    
    // New method to calculate profit/loss from selling price
    private void calculateProfitLossFromSellingPrice() {
        if (sellingPrice != null && product != null && product.getPurchasePrice() != null) {
            BigDecimal purchasePrice = product.getPurchasePrice();
            profitLoss = sellingPrice.subtract(purchasePrice);
            
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                profitLossPercent = profitLoss.multiply(new BigDecimal("100"))
                    .divide(purchasePrice, 2, RoundingMode.HALF_UP);
            }
            
            calculateDerivedFields();
        }
    }
    
    // New method to calculate selling price from profit/loss
    private void calculateSellingPriceFromProfitLoss() {
        if (profitLoss != null && product != null && product.getPurchasePrice() != null) {
            BigDecimal purchasePrice = product.getPurchasePrice();
            sellingPrice = purchasePrice.add(profitLoss);
            
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                profitLossPercent = profitLoss.multiply(new BigDecimal("100"))
                    .divide(purchasePrice, 2, RoundingMode.HALF_UP);
            }
            
            calculateDerivedFields();
        }
    }
    
    // New method to calculate from profit/loss percentage
    private void calculateFromProfitLossPercent() {
        if (profitLossPercent != null && product != null && product.getPurchasePrice() != null) {
            BigDecimal purchasePrice = product.getPurchasePrice();
            BigDecimal multiplier = profitLossPercent.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
            profitLoss = purchasePrice.multiply(multiplier);
            sellingPrice = purchasePrice.add(profitLoss);
            
            calculateDerivedFields();
        }
    }
    
    public BigDecimal getTotalSellingPrice() {
        if (totalSellingPrice == null && sellingPrice != null && quantity != null) {
            totalSellingPrice = sellingPrice.multiply(new BigDecimal(quantity));
        }
        return totalSellingPrice;
    }
    
    public BigDecimal getTotalProfitLoss() {
        if (totalProfitLoss == null && profitLoss != null && quantity != null) {
            totalProfitLoss = profitLoss.multiply(new BigDecimal(quantity));
        }
        return totalProfitLoss;
    }
    
    // Helper method to calculate profit/loss from purchase price (for backward compatibility)
    public void calculateProfitLossFromPurchasePrice(BigDecimal purchasePrice) {
        if (sellingPrice != null && purchasePrice != null) {
            BigDecimal singleProfitLoss = sellingPrice.subtract(purchasePrice);
            this.profitLoss = singleProfitLoss;
            
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                this.profitLossPercent = singleProfitLoss.multiply(new BigDecimal("100"))
                    .divide(purchasePrice, 2, RoundingMode.HALF_UP);
            }
            
            calculateDerivedFields();
        }
    }
    
    // Helper method to calculate selling price from profit/loss (for backward compatibility)
    public void calculateSellingPriceFromProfitLoss(BigDecimal profitLoss, BigDecimal purchasePrice) {
        if (purchasePrice != null) {
            this.sellingPrice = purchasePrice.add(profitLoss);
            this.profitLoss = profitLoss;
            
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                this.profitLossPercent = profitLoss.multiply(new BigDecimal("100"))
                    .divide(purchasePrice, 2, RoundingMode.HALF_UP);
            }
            
            calculateDerivedFields();
        }
    }
    
    // Helper method to calculate profit/loss from percentage (for backward compatibility)
    public void calculateProfitLossFromPercent(BigDecimal profitLossPercent, BigDecimal purchasePrice) {
        if (purchasePrice != null) {
            BigDecimal multiplier = profitLossPercent.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
            BigDecimal profitLoss = purchasePrice.multiply(multiplier);
            this.sellingPrice = purchasePrice.add(profitLoss);
            this.profitLoss = profitLoss;
            this.profitLossPercent = profitLossPercent;
            
            calculateDerivedFields();
        }
    }
}