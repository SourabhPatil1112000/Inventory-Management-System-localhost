<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Price Management - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <style>
        .price-card {
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        .price-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .category-header {
            background: linear-gradient(45deg, #ff0000, #ff6b6b);
            color: white;
            padding: 12px 15px;
            border-radius: 8px 8px 0 0;
            font-weight: 600;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #dee2e6;
        }
        .price-input {
            text-align: right;
            font-weight: 500;
        }
        .profit-margin {
            font-size: 0.85rem;
            color: #28a745;
            font-weight: 500;
        }
        .loss-margin {
            font-size: 0.85rem;
            color: #dc3545;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="products" />
    </jsp:include>

    <div class="container-fluid mt-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2><i class="fas fa-tags text-danger"></i> Price Management</h2>
                        <p class="text-muted">Manage product categories and pricing</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/products/categories/add" 
                           class="btn btn-primary mr-2">
                            <i class="fas fa-folder-plus"></i> Add Category
                        </a>
                        <a href="${pageContext.request.contextPath}/products/add" 
                           class="btn btn-success">
                            <i class="fas fa-plus-circle"></i> Add Product
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Categories and Products Display -->
        <c:choose>
            <c:when test="${empty categories}">
                <!-- Empty State - No Categories -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="empty-state">
                                    <i class="fas fa-folder-open"></i>
                                    <h4>No Categories Found</h4>
                                    <p>Start by creating your first product category</p>
                                    <a href="${pageContext.request.contextPath}/products/categories/add" 
                                       class="btn btn-primary btn-lg">
                                        <i class="fas fa-plus"></i> Create First Category
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <!-- Categories with Products -->
                <c:forEach var="category" items="${categories}">
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card price-card">
                                <div class="category-header d-flex justify-content-between align-items-center">
                                    <div>
                                        <i class="fas fa-folder mr-2"></i>
                                        ${category.name}
                                        <span class="badge badge-light ml-2">
                                            ${not empty category.products ? category.products.size() : 0} product(s)
                                        </span>
                                    </div>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/products/categories/edit/${category.id}" 
                                           class="btn btn-sm btn-light mr-2">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
										<%-- Change to (correct) - JSP confirmation page --%>
										<a href="${pageContext.request.contextPath}/products/categories/delete-confirm/${category.id}" 
										   class="btn btn-sm btn-danger">
										    <i class="fas fa-trash"></i> Delete
										</a>
                                    </div>
                                </div>
                                
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty category.products}">
                                            <!-- Empty Products in Category -->
                                            <div class="text-center py-4">
                                                <i class="fas fa-box-open fa-2x text-muted mb-3"></i>
                                                <p class="text-muted">No products in this category</p>
                                                <a href="${pageContext.request.contextPath}/products/add?categoryId=${category.id}" 
                                                   class="btn btn-sm btn-outline-success">
                                                    <i class="fas fa-plus"></i> Add Product
                                                </a>
                                            </div>
                                        </c:when>
                                        
                                        <c:otherwise>
                                            <!-- Products Table -->
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Product Name</th>
                                                            <th>Description</th>
                                                            <th>Purchase Price (₹)</th>
                                                            <th>Selling Price (₹)</th>
                                                            <th>Margin</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="product" items="${category.products}">
                                                            <tr>
                                                                <td>
                                                                    <strong>${product.name}</strong>
                                                                </td>
                                                                <td>
                                                                    <small class="text-muted">
                                                                        ${not empty product.description ? product.description : 'No description'}
                                                                    </small>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${product.purchasePrice}" 
                                                                        type="currency" currencySymbol="₹" 
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${product.sellingPrice}" 
                                                                        type="currency" currencySymbol="₹" 
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                                </td>
                                                                <td>
                                                                    <c:if test="${product.purchasePrice > 0}">
                                                                        <c:set var="margin" 
                                                                               value="${((product.sellingPrice - product.purchasePrice) / product.purchasePrice) * 100}"/>
                                                                        <c:choose>
                                                                            <c:when test="${margin >= 0}">
                                                                                <span class="profit-margin">
                                                                                    <i class="fas fa-arrow-up"></i>
                                                                                    <fmt:formatNumber value="${margin}" 
                                                                                        pattern="0.00"/>%
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="loss-margin">
                                                                                    <i class="fas fa-arrow-down"></i>
                                                                                    <fmt:formatNumber value="${margin}" 
                                                                                        pattern="0.00"/>%
                                                                                </span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    <div class="btn-group btn-group-sm">
                                                                        <a href="${pageContext.request.contextPath}/products/edit/${product.id}" 
                                                                           class="btn btn-warning">
                                                                            <i class="fas fa-edit"></i> Edit
                                                                        </a>
                                                                        <a href="${pageContext.request.contextPath}/products/delete-confirm/${product.id}" 
                                                                           class="btn btn-danger">
                                                                            <i class="fas fa-trash"></i> Delete
                                                                        </a>
                                                                        <button type="button" 
                                                                                class="btn btn-info" 
                                                                                data-toggle="modal" 
                                                                                data-target="#priceModal"
                                                                                data-product-id="${product.id}"
                                                                                data-product-name="${product.name}"
                                                                                data-purchase-price="${product.purchasePrice}"
                                                                                data-selling-price="${product.sellingPrice}">
                                                                            <i class="fas fa-rupee-sign"></i> Update Price
                                                                        </button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <!-- Quick Stats -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h3 class="text-primary">
                            <i class="fas fa-folder"></i>
                            ${not empty categories ? categories.size() : 0}
                        </h3>
                        <p class="text-muted mb-0">Total Categories</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
						<h3 class="text-success">
						    <i class="fas fa-box"></i>
						    <c:set var="totalProducts" value="0"/>
						    <c:forEach var="category" items="${categories}">
						        <c:set var="totalProducts" 
						               value="${totalProducts + (not empty category.products ? category.products.size() : 0)}"/>
						    </c:forEach>
						    ${totalProducts}
						</h3>
                        <p class="text-muted mb-0">Total Products</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <h3 class="text-warning">
                            <i class="fas fa-rupee-sign"></i>
                            <fmt:formatNumber value="0" type="currency" currencySymbol="₹"/>
                        </h3>
                        <p class="text-muted mb-0">Average Margin</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Price Update Modal -->
    <div class="modal fade" id="priceModal" tabindex="-1" role="dialog" aria-labelledby="priceModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form id="priceUpdateForm" action="${pageContext.request.contextPath}/products/update-price" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" id="modalProductId" name="productId">
                    
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="priceModalLabel">
                            <i class="fas fa-rupee-sign"></i> Update Product Price
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="modalProductName">Product Name</label>
                            <input type="text" id="modalProductName" class="form-control" readonly>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modalPurchasePrice">Purchase Price (₹)</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">₹</span>
                                        </div>
                                        <input type="number" id="modalPurchasePrice" name="purchasePrice" 
                                               class="form-control price-input" step="0.01" min="0" required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="modalSellingPrice">Selling Price (₹)</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">₹</span>
                                        </div>
                                        <input type="number" id="modalSellingPrice" name="sellingPrice" 
                                               class="form-control price-input" step="0.01" min="0" required>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-info mt-3">
                            <div class="d-flex justify-content-between">
                                <span>Margin:</span>
                                <span id="marginDisplay">0.00%</span>
                            </div>
                            <div class="progress mt-2" style="height: 5px;">
                                <div id="marginProgress" class="progress-bar" role="progressbar" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Price
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // Price modal handling
            $('#priceModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget);
                var productId = button.data('product-id');
                var productName = button.data('product-name');
                var purchasePrice = button.data('purchase-price');
                var sellingPrice = button.data('selling-price');
                
                var modal = $(this);
                modal.find('#modalProductId').val(productId);
                modal.find('#modalProductName').val(productName);
                modal.find('#modalPurchasePrice').val(purchasePrice);
                modal.find('#modalSellingPrice').val(sellingPrice);
                
                calculateMargin(purchasePrice, sellingPrice);
            });
            
            // Calculate margin when prices change
            $('#modalPurchasePrice, #modalSellingPrice').on('input', function() {
                var purchasePrice = parseFloat($('#modalPurchasePrice').val()) || 0;
                var sellingPrice = parseFloat($('#modalSellingPrice').val()) || 0;
                calculateMargin(purchasePrice, sellingPrice);
            });
            
            function calculateMargin(purchasePrice, sellingPrice) {
                var margin = 0;
                if (purchasePrice > 0) {
                    margin = ((sellingPrice - purchasePrice) / purchasePrice) * 100;
                }
                
                var marginDisplay = $('#marginDisplay');
                var progressBar = $('#marginProgress');
                
                marginDisplay.text(margin.toFixed(2) + '%');
                
                // Color coding and progress bar
                if (margin >= 0) {
                    marginDisplay.removeClass('text-danger').addClass('text-success');
                    progressBar.removeClass('bg-danger').addClass('bg-success');
                } else {
                    marginDisplay.removeClass('text-success').addClass('text-danger');
                    progressBar.removeClass('bg-success').addClass('bg-danger');
                }
                
                // Set progress bar width (capped at 100% for display)
                var progressWidth = Math.min(Math.abs(margin), 100);
                progressBar.css('width', progressWidth + '%');
            }
            
            // Form validation
            $('#priceUpdateForm').on('submit', function(e) {
                var purchasePrice = parseFloat($('#modalPurchasePrice').val()) || 0;
                var sellingPrice = parseFloat($('#modalSellingPrice').val()) || 0;
                
                if (purchasePrice <= 0 || sellingPrice <= 0) {
                    e.preventDefault();
                    toastr.error('Please enter valid prices (greater than 0)');
                    return false;
                }
                
                if (sellingPrice < purchasePrice) {
                    if (!confirm('Selling price is lower than purchase price. This will result in a loss. Continue?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                // Show loading
                $(this).find('button[type="submit"]').html('<i class="fas fa-spinner fa-spin"></i> Saving...').prop('disabled', true);
                return true;
            });
        });
    </script>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>