<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer - PATIL BATTERIES</title>
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
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="customers" />
    </jsp:include>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header bg-warning text-white">
                        <h4 class="mb-0"><i class="fas fa-edit"></i> Edit Customer</h4>
                    </div>
                    <div class="card-body">
                        <form:form action="${pageContext.request.contextPath}/customers/update" method="post" modelAttribute="customer" id="customerForm">
                            <form:hidden path="id"/>
                            
                            <!-- Basic Information -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="name">Customer Name *</label>
                                        <form:input path="name" id="name" class="form-control" required="required"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="mobileNumber">Mobile Number *</label>
                                        <form:input path="mobileNumber" id="mobileNumber" class="form-control" required="required" 
                                                   pattern="[6-9][0-9]{9}"/>
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
                                                <option value="${cat.id}" ${cat.id == customer.category.id ? 'selected' : ''}>${cat.name}</option>
                                            </c:forEach>
                                        </form:select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="product">Product Name *</label>
                                        <form:select path="product.id" id="product" class="form-control" required="required">
                                            <option value="">Select Product</option>
                                            <c:forEach var="prod" items="${products}">
                                                <option value="${prod.id}" ${prod.id == customer.product.id ? 'selected' : ''} 
                                                        data-purchase-price="${prod.purchasePrice}">${prod.name}</option>
                                            </c:forEach>
                                        </form:select>
                                    </div>
                                </div>
                            </div>

                            <!-- Quantity and Purchase Date -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="quantity">Quantity *</label>
                                        <form:input path="quantity" id="quantity" class="form-control" required="required" 
                                                   type="number" min="1" step="1" value="${customer.quantity != null ? customer.quantity : 1}"/>
                                        <small class="form-text text-muted">Number of units purchased</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="purchaseDate">Purchase Date</label>
                                        <form:input path="purchaseDate" type="date" id="purchaseDate" class="form-control"
                                                   value="${customer.purchaseDate != null ? customer.purchaseDate.toString() : ''}"/>
                                    </div>
                                </div>
                            </div>

                            <!-- Additional Information -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="vehicleNumber">Vehicle Number</label>
                                        <form:input path="vehicleNumber" id="vehicleNumber" class="form-control"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="area">Area</label>
                                        <form:select path="area" id="area" class="form-control">
                                            <option value="">Select Area</option>
                                            <c:forEach var="area" items="${areas}">
                                                <option value="${area}" ${area == customer.area ? 'selected' : ''}>${area}</option>
                                            </c:forEach>
                                        </form:select>
                                    </div>
                                </div>
                            </div>

                            <!-- Pricing Section -->
                            <div class="row calculation-row">
                                <div class="col-12">
                                    <h5><i class="fas fa-calculator"></i> Pricing & Profit Calculation</h5>
                                    <p class="text-muted mb-3"><small>Only Selling Price is editable. Profit/Loss auto-calculates.</small></p>
                                </div>
                                
                                <!-- Purchase Price (Readonly) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Purchase Price</label>
                                        <input type="text" id="purchasePriceDisplay" class="form-control readonly-field" readonly 
                                               value="${customer.product.purchasePrice}"/>
                                        <form:hidden path="product.purchasePrice" id="hiddenPurchasePrice" value="${customer.product.purchasePrice}"/>
                                    </div>
                                </div>
                                
                                <!-- Selling Price (Editable) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="sellingPrice">Selling Price *</label>
                                        <form:input path="sellingPrice" id="sellingPrice" class="form-control" required="required" 
                                                   type="number" step="0.01" min="0" value="${customer.sellingPrice}"/>
                                    </div>
                                </div>
                                
                                <!-- Profit/Loss Amount (Auto-calculated) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Profit/Loss</label>
                                        <input type="text" id="profitLossDisplay" class="form-control readonly-field" readonly 
                                               value="${customer.profitLoss}"/>
                                        <form:hidden path="profitLoss" id="hiddenProfitLoss"/>
                                    </div>
                                </div>
                                
                                <!-- Profit/Loss Percentage (Auto-calculated) -->
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Profit/Loss (%)</label>
                                        <input type="text" id="profitLossPercentDisplay" class="form-control readonly-field" readonly 
                                               value="${customer.profitLossPercent}"/>
                                        <form:hidden path="profitLossPercent" id="hiddenProfitLossPercent"/>
                                    </div>
                                </div>
                                
                                <!-- Total Calculations (Readonly) -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Total Purchase</label>
                                        <input type="text" id="totalPurchase" class="form-control readonly-field" readonly 
                                               value="${customer.product.purchasePrice * (customer.quantity != null ? customer.quantity : 1)}"/>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Total Selling</label>
                                        <input type="text" id="totalSelling" class="form-control readonly-field" readonly 
                                               value="${customer.sellingPrice * (customer.quantity != null ? customer.quantity : 1)}"/>
                                    </div>
                                </div>
                                
                                <!-- Total Profit Display (Readonly) -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Total Profit/Loss</label>
                                        <input type="text" id="totalProfitLoss" class="form-control readonly-field" readonly 
                                               value="${customer.profitLoss * (customer.quantity != null ? customer.quantity : 1)}"/>
                                    </div>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="form-group text-center">
                                <button type="submit" class="btn btn-warning btn-lg mr-2" id="updateBtn">
                                    <i class="fas fa-save"></i> Update Customer
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
            // Set purchase date max to today (for validation only)
            var today = new Date().toISOString().split('T')[0];
            $('#purchaseDate').attr('max', today);
            
            // Check if date field is empty (not just whitespace)
            var currentDate = $('#purchaseDate').val();
            if (!currentDate || currentDate.trim() === '') {
                // Only set to today if it's truly empty
                $('#purchaseDate').val(today);
            }
            
            // Initialize with current values
            var initialPurchasePrice = parseFloat($('#product option:selected').data('purchase-price')) || 0;
            var initialSellingPrice = parseFloat($('#sellingPrice').val()) || 0;
            var initialQuantity = parseInt($('#quantity').val()) || 1;
            
            // Update purchase price display
            $('#purchasePriceDisplay').val(initialPurchasePrice.toFixed(2));
            $('#hiddenPurchasePrice').val(initialPurchasePrice);
            
            // Calculate initial values
            calculateAll();
            
            // Calculate when selling price changes
            $('#sellingPrice').on('change keyup', function() {
                calculateAll();
            });
            
            // Calculate when quantity changes
            $('#quantity').on('change keyup', function() {
                calculateAll();
            });
            
            // Calculate when product changes
            $('#product').change(function() {
                var purchasePrice = parseFloat($('#product option:selected').data('purchase-price')) || 0;
                $('#purchasePriceDisplay').val(purchasePrice.toFixed(2));
                $('#hiddenPurchasePrice').val(purchasePrice);
                calculateAll();
            });
            
            function calculateAll() {
                var purchasePrice = parseFloat($('#purchasePriceDisplay').val()) || 0;
                var sellingPrice = parseFloat($('#sellingPrice').val()) || 0;
                var quantity = parseInt($('#quantity').val()) || 1;
                
                // Calculate profit/loss
                var profitLoss = sellingPrice - purchasePrice;
                var profitLossPercent = (purchasePrice > 0) ? (profitLoss / purchasePrice) * 100 : 0;
                
                // Update display fields
                $('#profitLossDisplay').val(profitLoss.toFixed(2));
                $('#profitLossPercentDisplay').val(profitLossPercent.toFixed(2));
                
                // Update hidden fields for form submission
                $('#hiddenProfitLoss').val(profitLoss);
                $('#hiddenProfitLossPercent').val(profitLossPercent);
                
                // Calculate totals
                var totalPurchase = purchasePrice * quantity;
                var totalSelling = sellingPrice * quantity;
                var totalProfit = profitLoss * quantity;
                
                // Update total fields
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
            
            // Form submission validation
            $('#customerForm').on('submit', function(e) {
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
                
                // Validate selling price
                var sellingPrice = parseFloat($('#sellingPrice').val());
                if (!sellingPrice || sellingPrice <= 0) {
                    $('#sellingPrice').addClass('is-invalid');
                    isValid = false;
                }
                
                // Validate quantity
                var quantity = parseInt($('#quantity').val());
                if (!quantity || quantity < 1) {
                    $('#quantity').addClass('is-invalid');
                    isValid = false;
                }
                
             // Replace just the date validation section with:
                var purchaseDate = $('#purchaseDate').val();
                if (purchaseDate) {
                    // Get today's date in YYYY-MM-DD format
                    var today = new Date();
                    var todayStr = today.getFullYear() + '-' + 
                                   String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                                   String(today.getDate()).padStart(2, '0');
                    
                    // Simple string comparison (YYYY-MM-DD format)
                    if (purchaseDate > todayStr) {
                        $('#purchaseDate').addClass('is-invalid');
                        toastr.error('Purchase date cannot be in the future');
                        isValid = false;
                    }
                }
                
                if (!isValid) {
                    e.preventDefault();
                    toastr.error('Please fill all required fields correctly');
                    return false;
                }
                
                // Show loading
                $('#updateBtn').html('<i class="fas fa-spinner fa-spin"></i> Updating...').prop('disabled', true);
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