<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark" style="background: #ff0000;">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
        <strong><i class="fas fa-bolt"></i> PATIL BATTERIES & POWER SOLUTIONS</strong>
    </a>
    
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" 
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item ${param.activePage == 'dashboard' ? 'active' : ''}">
                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-home"></i> Home
                </a>
            </li>
            <li class="nav-item dropdown ${param.activePage == 'customers' ? 'active' : ''}">
                <a class="nav-link dropdown-toggle" href="#" id="customersDropdown" role="button" 
                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-users"></i> Customers
                </a>
                <div class="dropdown-menu" aria-labelledby="customersDropdown">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/customers/add">
                        <i class="fas fa-user-plus"></i> Add New Customer
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/customers/view">
                        <i class="fas fa-list"></i> View All Customers
                    </a>
                </div>
            </li>
            <li class="nav-item dropdown ${param.activePage == 'products' ? 'active' : ''}">
                <a class="nav-link dropdown-toggle" href="#" id="productsDropdown" role="button" 
                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-tags"></i> Products & Prices
                </a>
                <div class="dropdown-menu" aria-labelledby="productsDropdown">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/products/prices">
                        <i class="fas fa-rupee-sign"></i> Set Prices
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/products/categories/add">
                        <i class="fas fa-folder-plus"></i> Add Category
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/products/add">
                        <i class="fas fa-plus-circle"></i> Add Product
                    </a>
                </div>
            </li>
            <li class="nav-item ${param.activePage == 'inventory' ? 'active' : ''}">
                <a class="nav-link" href="${pageContext.request.contextPath}/inventory">
                    <i class="fas fa-boxes"></i> Inventory
                </a>
            </li>
        </ul>
        
        <!-- User Info and Logout -->
        <div class="navbar-nav ml-auto">
            <div class="nav-item dropdown">
                <a class="nav-link dropdown-toggle user-info" href="#" id="userDropdown" 
                   role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-user-circle fa-lg"></i>
                    <span class="user-name">${currentUser}</span>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                    <div class="dropdown-header">
                        <i class="fas fa-user"></i> Welcome, <strong>${currentUser}</strong>
                    </div>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</nav>

<style>
    /* Navbar Background - Pure Red Theme */
    .navbar {
        background: #ff0000 !important;
        box-shadow: 0 2px 10px rgba(255, 0, 0, 0.3);
        border-bottom: 3px solid #ffc107;
    }
    
    /* User Info Styling */
    .user-info {
        color: #fff !important;
        padding: 8px 15px !important;
        border-radius: 25px;
        background: rgba(255, 255, 255, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.4);
        transition: all 0.3s ease;
        margin-left: 10px;
    }
    
    .user-info:hover {
        background: rgba(255, 255, 255, 0.3);
        border-color: rgba(255, 255, 255, 0.6);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(255, 255, 255, 0.3);
    }
    
    .user-name {
        margin-left: 8px;
        font-weight: 500;
    }
    
    /* Dropdown Styling */
    .dropdown-menu {
        border: none;
        box-shadow: 0 4px 15px rgba(255, 0, 0, 0.2);
        border-radius: 8px;
        min-width: 200px;
        border-top: 3px solid #ff0000;
    }
    
    .dropdown-header {
        color: #ff0000;
        font-size: 0.875rem;
        font-weight: 600;
        padding: 8px 16px;
        background: #f8f9fa;
    }
    
    .dropdown-item {
        padding: 8px 16px;
        transition: all 0.2s ease;
        color: #495057;
    }
    
    .dropdown-item:hover {
        background-color: #ffe6e6;
        color: #ff0000;
    }
    
    .dropdown-item i {
        width: 20px;
        margin-right: 8px;
        color: #ff0000;
    }
    
    /* Navbar Brand Styling */
    .navbar-brand {
        font-size: 1.3rem;
        font-weight: bold;
        padding: 8px 0;
        color: #fff !important;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
    }
    
    .navbar-brand i {
        color: #ffc107;
        margin-right: 8px;
        text-shadow: 0 0 5px rgba(255, 193, 7, 0.5);
    }
    
    /* Nav Item Styling */
    .nav-link {
        padding: 10px 15px !important;
        border-radius: 5px;
        margin: 0 2px;
        transition: all 0.3s ease;
        color: rgba(255, 255, 255, 0.95) !important;
        font-weight: 500;
    }
    
    .nav-link:hover {
        background: rgba(255, 255, 255, 0.25);
        color: #fff !important;
        transform: translateY(-1px);
    }
    
    .nav-item.active .nav-link {
        background: rgba(255, 255, 255, 0.3);
        color: #fff !important;
        font-weight: 600;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }
    
    /* Dropdown Toggle Arrow */
    .dropdown-toggle::after {
        border-top-color: rgba(255, 255, 255, 0.9);
    }
    
    /* Navbar Toggler */
    .navbar-toggler {
        border-color: rgba(255, 255, 255, 0.6);
    }
    
    .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' width='30' height='30' viewBox='0 0 30 30'%3e%3cpath stroke='rgba(255, 255, 255, 0.9)' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }
    
    /* Dropdown Menu Styling */
    .dropdown-menu {
        animation: fadeIn 0.2s ease-in-out;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    /* Mobile Responsive */
    @media (max-width: 768px) {
        .user-info {
            margin: 10px 0;
            text-align: center;
            width: 100%;
        }
        
        .navbar-nav {
            text-align: center;
        }
        
        .dropdown-menu {
            text-align: center;
        }
        
        .nav-link {
            margin: 2px 0;
        }
        
        .form-row > div {
            margin-bottom: 15px;
        }
        
        .btn-lg {
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }
    }
</style>

<!-- Font Awesome for Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">