<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Customer - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <style>
        .profit-positive { background-color: #d4edda !important; color: #155724 !important; }
        .profit-negative { background-color: #f8d7da !important; color: #721c24 !important; }
        .profit-neutral { background-color: #e2e3e5 !important; color: #383d41 !important; }
        .calculation-row {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .readonly-field {
            background-color: #f8f9fa !important;
            cursor: not-allowed;
        }
    </style>
<style>
    .profit-positive { 
        background-color: #d4edda !important; 
        color: #155724 !important; 
        border-color: #c3e6cb !important;
    }
    .profit-negative { 
        background-color: #f8d7da !important; 
        color: #721c24 !important;
        border-color: #f5c6cb !important;
    }
    .profit-neutral { 
        background-color: #e2e3e5 !important; 
        color: #383d41 !important;
        border-color: #d6d8db !important;
    }
    .readonly-field {
        cursor: not-allowed;
        /* REMOVE the background-color from here */
    }
</style>
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="customers" />
    </jsp:include>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-user-plus"></i> Add New Customer</h4>
                    </div>
                    <div class="card-body">
                        <form:form action="${pageContext.request.contextPath}/customers/save" method="post" modelAttribute="customer" id="customerForm">
                            <!-- CSRF Protection -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            
                            <!-- Hidden fields for profit/loss calculations -->
                            <form:hidden path="profitLoss" id="hiddenProfitLoss"/>
                            <form:hidden path="profitLossPercent" id="hiddenProfitLossPercent"/>
                            
                            <!-- Basic Information -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="name">Customer Name *</label>
                                        <form:input path="name" id="name" class="form-control" required="required" 
                                                   placeholder="Enter customer name" maxlength="100"/>
                                        <div class="invalid-feedback">Please enter customer name</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="mobileNumber">Mobile Number *</label>
                                        <form:input path="mobileNumber" id="mobileNumber" class="form-control" required="required" 
                                                   pattern="[6-9][0-9]{9}" placeholder="Enter 10-digit mobile number"
                                                   maxlength="10"/>
                                        <div class="invalid-feedback">Please enter a valid 10-digit mobile number starting with 6-9</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Category and Product Selection -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="category">Category *</label>
                                        <form:select path="category.id" id="category" class="form-control" required="required">
                                            <option value="">Select Category</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}">${cat.name}</option>
                                            </c:forEach>
                                        </form:select>
                                        <div class="invalid-feedback">Please select a category</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="product">Product Name *</label>
                                        <form:select path="product.id" id="product" class="form-control" required="required" disabled="true">
                                            <option value="">Select Category First</option>
                                        </form:select>
                                        <div class="invalid-feedback">Please select a product</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quantity -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="quantity">Quantity *</label>
                                        <form:input path="quantity" id="quantity" class="form-control" required="required" 
                                                   type="number" min="1" step="1" value="1"/>
                                        <small class="form-text text-muted">Number of units purchased</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="purchaseDate">Purchase Date</label>
                                        <form:input path="purchaseDate" type="date" id="purchaseDate" class="form-control" max=""/>
                                        <div class="invalid-feedback">Please select a valid date</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Additional Information -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="vehicleNumber">Vehicle Number</label>
                                        <form:input path="vehicleNumber" id="vehicleNumber" class="form-control" 
                                                   placeholder="Enter vehicle number" maxlength="20"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="area">Area</label>
                                        <form:select path="area" id="area" class="form-control">
                                            <option value="">Select Area</option>
                                            <c:forEach var="area" items="${areas}">
                                                <option value="${area}">${area}</option>
                                            </c:forEach>
                                        </form:select>
                                    </div>
                                </div>
                            </div>

                            <!-- Pricing Section -->
                            <div class="row calculation-row">
                                <div class="col-12">
                                    <h5><i class="fas fa-calculator"></i> Pricing & Profit Calculation</h5>
                                    <p class="text-muted mb-3"><small>Only Selling Price is editable. All other fields auto-calculate.</small></p>
                                </div>
                                
                                <!-- Purchase Price (Readonly) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Purchase Price (₹)</label>
                                        <input type="text" id="purchasePrice" class="form-control readonly-field" readonly 
                                               placeholder="Select product first"/>
                                    </div>
                                </div>
                                
                                <!-- Selling Price (ONLY EDITABLE FIELD) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="sellingPrice">Selling Price (₹) *</label>
                                        <form:input path="sellingPrice" id="sellingPrice" class="form-control" required="required" 
                                                   type="number" step="0.01" min="0" placeholder="Enter selling price"
                                                   disabled="true"/>
                                        <div class="invalid-feedback">Please enter selling price</div>
                                    </div>
                                </div>
                                
                                <!-- Profit/Loss Amount (Readonly) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Profit/Loss (₹)</label>
                                        <input type="text" id="profitLossDisplay" class="form-control readonly-field" readonly 
                                               placeholder="Will auto-calculate"/>
                                    </div>
                                </div>
                                
                                <!-- Profit/Loss Percentage (Readonly) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Profit/Loss (%)</label>
                                        <input type="text" id="profitLossPercentDisplay" class="form-control readonly-field" readonly 
                                               placeholder="Will auto-calculate"/>
                                    </div>
                                </div>
                                
                                <!-- Total Calculations (Readonly) -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Total Purchase (₹)</label>
                                        <input type="text" id="totalPurchase" class="form-control readonly-field" readonly 
                                               placeholder="0.00"/>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Total Selling (₹)</label>
                                        <input type="text" id="totalSelling" class="form-control readonly-field" readonly 
                                               placeholder="0.00"/>
                                    </div>
                                </div>
                                
                                <!-- Total Profit Display (Readonly) -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Total Profit/Loss (₹)</label>
                                        <input type="text" id="totalProfitLoss" class="form-control readonly-field" readonly 
                                               placeholder="0.00"/>
                                    </div>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="form-group text-center">
                                <button type="submit" class="btn btn-success btn-lg mr-2" id="submitBtn">
                                    <i class="fas fa-save"></i> Save Customer
                                </button>
                                <a href="${pageContext.request.contextPath}/customers/view" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            console.log('Add Customer page loaded');
            
            // Set today's date as default and max date
            var today = new Date().toISOString().split('T')[0];
            $('#purchaseDate').val(today);
            $('#purchaseDate').attr('max', today);
            
            // Sanitize input function
            function sanitizeInput(input) {
                return input ? input.replace(/[<>]/g, '') : '';
            }
            
            // Mobile number validation
            $('#mobileNumber').on('blur', function() {
                var mobile = $(this).val().trim();
                if (mobile && !/^[6-9][0-9]{9}$/.test(mobile)) {
                    $(this).addClass('is-invalid');
                    $(this).next('.invalid-feedback').text('Please enter a valid 10-digit mobile number starting with 6-9');
                } else {
                    $(this).removeClass('is-invalid');
                }
            });
            
            // Load products when category changes
            $('#category').change(function() {
                var categoryId = $(this).val();
                var categoryName = $('#category option:selected').text();
                console.log('Category changed to:', categoryId, '-', categoryName);
                
                if (categoryId) {
                    $('#product').prop('disabled', false);
                    $('#product').empty();
                    $('#product').append('<option value="">Loading products...</option>');
                    
                    // Make AJAX call
                    $.ajax({
                        url: '${pageContext.request.contextPath}/customers/products-by-category',
                        type: 'GET',
                        data: { categoryId: categoryId },
                        dataType: 'json',
                        success: function(response) {
                            console.log('AJAX Response:', response);
                            
                            var products;
                            try {
                                if (Array.isArray(response)) {
                                    products = response;
                                } else if (typeof response === 'string') {
                                    products = JSON.parse(response);
                                } else if (response && typeof response === 'object') {
                                    products = response.data || response.products || [];
                                } else {
                                    console.error('Unexpected response format:', typeof response);
                                    products = [];
                                }
                            } catch (e) {
                                console.error('JSON parsing error:', e);
                                console.error('Response was:', response);
                                products = [];
                            }
                            
                            updateProductDropdown(products);
                        },
                        error: function(xhr, status, error) {
                            console.error('AJAX Error Details:');
                            console.error('Status:', status);
                            console.error('Error:', error);
                            console.error('Response Text:', xhr.responseText);
                            console.error('Status Code:', xhr.status);
                            
                            $('#product').empty();
                            var errorMsg = 'Error loading products';
                            if (xhr.status === 404) {
                                errorMsg = 'Service not found. Please check server connection.';
                            } else if (xhr.status === 500) {
                                errorMsg = 'Server error. Please try again later.';
                            }
                            $('#product').append('<option value="">' + errorMsg + '</option>');
                        }
                    });
                } else {
                    $('#product').prop('disabled', true);
                    $('#product').empty().append('<option value="">Select Category First</option>');
                    $('#sellingPrice').prop('disabled', true).val('');
                    $('#purchasePrice').val('');
                    $('#profitLossDisplay').val('');
                    $('#profitLossPercentDisplay').val('');
                    resetTotalCalculations();
                }
            });
            
            // Function to update product dropdown
            function updateProductDropdown(products) {
                $('#product').empty();
                
                if (products && products.length > 0) {
                    $('#product').append('<option value="">Select Product</option>');
                    $.each(products, function(index, product) {
                        console.log('Adding product to dropdown:', product.name, 'ID:', product.id, 'Price:', product.purchasePrice);
                        $('#product').append(
                            '<option value="' + (product.id || '') + '" ' +
                            'data-purchase-price="' + (product.purchasePrice || 0) + '">' + 
                            (product.name || 'Unnamed Product') + 
                            '</option>'
                        );
                    });
                    console.log('Total products added to dropdown:', products.length);
                } else {
                    $('#product').append('<option value="">No products found in this category</option>');
                    console.log('No products found for the selected category');
                }
            }
            
            // Enable/disable selling price based on product selection
            $('#product').change(function() {
                if ($(this).val()) {
                    $('#sellingPrice').prop('disabled', false);
                    calculateAll();
                } else {
                    $('#sellingPrice').prop('disabled', true).val('');
                    $('#purchasePrice').val('');
                    $('#profitLossDisplay').val('');
                    $('#profitLossPercentDisplay').val('');
                    resetTotalCalculations();
                }
            });
            
            // Calculate when selling price or quantity changes
            $('#sellingPrice, #quantity').on('change keyup', function() {
                calculateAll();
            });
            
            function calculateAll() {
                var purchasePrice = parseFloat($('#product option:selected').data('purchase-price')) || 0;
                var sellingPrice = parseFloat($('#sellingPrice').val()) || 0;
                var quantity = parseInt($('#quantity').val()) || 1;
                
                // Update purchase price display
                $('#purchasePrice').val(purchasePrice.toFixed(2));
                
                // Calculate profit/loss
                var profitLoss = sellingPrice - purchasePrice;
                var profitLossPercent = (purchasePrice > 0) ? (profitLoss / purchasePrice) * 100 : 0;
                
                // Update display fields
                $('#profitLossDisplay').val(profitLoss.toFixed(2));
                $('#profitLossPercentDisplay').val(profitLossPercent.toFixed(2) + '%');
                
                // Update hidden fields for form submission
                $('#hiddenProfitLoss').val(profitLoss);
                $('#hiddenProfitLossPercent').val(profitLossPercent);
                
                // Update total calculations
                calculateTotalsOnly();
            }
            
            function calculateTotalsOnly() {
                var purchasePrice = parseFloat($('#purchasePrice').val()) || 0;
                var sellingPrice = parseFloat($('#sellingPrice').val()) || 0;
                var profitLoss = parseFloat($('#profitLossDisplay').val()) || 0;
                var quantity = parseInt($('#quantity').val()) || 1;
                
                var totalPurchase = purchasePrice * quantity;
                var totalSelling = sellingPrice * quantity;
                var totalProfit = profitLoss * quantity;
                
                $('#totalPurchase').val(totalPurchase.toFixed(2));
                $('#totalSelling').val(totalSelling.toFixed(2));
                $('#totalProfitLoss').val(totalProfit.toFixed(2));
                
                // Color coding and styling for total profit
                $('#totalProfitLoss').removeClass('profit-positive profit-negative profit-neutral');
                if (totalProfit > 0) {
                    $('#totalProfitLoss').addClass('profit-positive');
                } else if (totalProfit < 0) {
                    $('#totalProfitLoss').addClass('profit-negative');
                } else {
                    $('#totalProfitLoss').addClass('profit-neutral');
                }
            }
            
            function resetTotalCalculations() {
                $('#totalPurchase').val('0.00');
                $('#totalSelling').val('0.00');
                $('#totalProfitLoss').val('0.00').removeClass('profit-positive profit-negative profit-neutral');
            }
            
            // Form submission with validation
            $('#customerForm').on('submit', function(e) {
                // Sanitize inputs
                $('input[type="text"], textarea').each(function() {
                    $(this).val(sanitizeInput($(this).val()));
                });
                
                // Validate required fields
                var isValid = true;
                $('input[required], select[required]').each(function() {
                    if (!$(this).val()) {
                        $(this).addClass('is-invalid');
                        isValid = false;
                    } else {
                        $(this).removeClass('is-invalid');
                    }
                });
                
                // Validate mobile number
                var mobile = $('#mobileNumber').val();
                if (mobile && !/^[6-9][0-9]{9}$/.test(mobile)) {
                    $('#mobileNumber').addClass('is-invalid');
                    isValid = false;
                }
                
                // Validate quantity
                var quantity = parseInt($('#quantity').val());
                if (!quantity || quantity < 1) {
                    $('#quantity').addClass('is-invalid');
                    isValid = false;
                }
                
                // Validate selling price
                var sellingPrice = parseFloat($('#sellingPrice').val());
                if (!sellingPrice || sellingPrice <= 0) {
                    $('#sellingPrice').addClass('is-invalid');
                    isValid = false;
                }
                
                if (!isValid) {
                    e.preventDefault();
                    toastr.error('Please fill all required fields correctly');
                    return false;
                }
                
                // Show loading
                $('#submitBtn').html('<i class="fas fa-spinner fa-spin"></i> Saving...').prop('disabled', true);
                return true;
            });
            
            // Prevent typing in readonly fields
            $('.readonly-field').on('keydown', function(e) {
                e.preventDefault();
                return false;
            });
        });
    </script>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>