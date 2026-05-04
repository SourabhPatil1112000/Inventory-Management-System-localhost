<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inventory Management - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <style>
        .low-stock { background-color: #ffe6e6 !important; }
        .medium-stock { background-color: #fff3cd !important; }
        .good-stock { background-color: #d4edda !important; }
        .stock-badge { font-size: 0.8em; }
        .out-of-stock { background-color: #f8d7da !important; }
        .actions-column { white-space: nowrap; }
        .btn-action { margin: 2px; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="inventory" />
    </jsp:include>

    <div class="container-fluid mt-4">
        <!-- Stock Summary Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">TOTAL PRODUCTS</h6>
                                <h3 class="mb-0">${inventory.size()}</h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-cubes fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">IN STOCK</h6>
                                <h3 class="mb-0">
                                    <c:set var="inStockCount" value="0"/>
                                    <c:forEach var="item" items="${inventory}">
                                        <c:if test="${item.quantity > 0}">
                                            <c:set var="inStockCount" value="${inStockCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${inStockCount}
                                </h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-check-circle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">LOW STOCK</h6>
                                <h3 class="mb-0">
                                    <c:set var="lowStockCount" value="0"/>
                                    <c:forEach var="item" items="${inventory}">
                                        <c:if test="${item.quantity > 0 && item.quantity <= 5}">
                                            <c:set var="lowStockCount" value="${lowStockCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${lowStockCount}
                                </h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-exclamation-triangle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">OUT OF STOCK</h6>
                                <h3 class="mb-0">
                                    <c:set var="outOfStockCount" value="0"/>
                                    <c:forEach var="item" items="${inventory}">
                                        <c:if test="${item.quantity == 0}">
                                            <c:set var="outOfStockCount" value="${outOfStockCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${outOfStockCount}
                                </h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-times-circle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Inventory Table -->
        <div class="card">
            <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-boxes"></i> Current Inventory</h5>
                <div>
                    <button type="button" class="btn btn-danger btn-sm mr-2" data-toggle="modal" data-target="#deleteStockModal">
                        <i class="fas fa-trash"></i> Delete Stock
                    </button>
                    <button type="button" class="btn btn-success btn-sm" data-toggle="modal" data-target="#updateStockModal">
                        <i class="fas fa-edit"></i> Update Stock
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="thead-dark">
                            <tr>
                                <th>#</th>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Current Stock</th>
                                <th>Stock Status</th>
                                <th>Last Updated</th>
                                <th>Purchase Price</th>
                                <th>Selling Price</th>
                                <th>Total Value</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${inventory}" varStatus="status">
                                <c:set var="stockClass" value=""/>
                                <c:set var="stockStatus" value=""/>
                                <c:set var="stockBadge" value=""/>
                                
                                <c:choose>
                                    <c:when test="${item.quantity == 0}">
                                        <c:set var="stockClass" value="out-of-stock"/>
                                        <c:set var="stockStatus" value="Out of Stock"/>
                                        <c:set var="stockBadge" value="danger"/>
                                    </c:when>
                                    <c:when test="${item.quantity <= 5}">
                                        <c:set var="stockClass" value="low-stock"/>
                                        <c:set var="stockStatus" value="Low Stock"/>
                                        <c:set var="stockBadge" value="warning"/>
                                    </c:when>
                                    <c:when test="${item.quantity <= 15}">
                                        <c:set var="stockClass" value="medium-stock"/>
                                        <c:set var="stockStatus" value="Medium Stock"/>
                                        <c:set var="stockBadge" value="info"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="stockClass" value="good-stock"/>
                                        <c:set var="stockStatus" value="Good Stock"/>
                                        <c:set var="stockBadge" value="success"/>
                                    </c:otherwise>
                                </c:choose>
                                
                                <tr class="${stockClass}" id="inventory-row-${item.product.id}">
                                    <td>${status.index + 1}</td>
                                    <td>
                                        <strong>${item.product.name}</strong>
                                        <c:if test="${item.quantity <= 5}">
                                            <br><small class="text-danger"><i class="fas fa-exclamation-circle"></i> Needs restocking</small>
                                        </c:if>
                                    </td>
                                    <td>${item.product.category.name}</td>
                                    <td class="text-center">
                                        <h4 class="mb-0"><span class="badge badge-dark">${item.quantity}</span></h4>
                                        <c:if test="${item.quantity == 0}">
                                            <small class="text-danger">Cannot sell to customers</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge badge-${stockBadge} stock-badge">${stockStatus}</span>
                                    </td>
                                    <td>
										<c:if test="${not empty item.lastUpdated}">
										    ${item.lastUpdated.toLocalDate()} ${item.lastUpdated.toLocalTime()}
										</c:if>
                                    </td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${item.product.purchasePrice}" type="currency" currencySymbol="₹"/>
                                    </td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${item.product.sellingPrice}" type="currency" currencySymbol="₹"/>
                                    </td>
                                    <td class="text-right font-weight-bold">
                                        <fmt:formatNumber value="${item.product.purchasePrice * item.quantity}" type="currency" currencySymbol="₹"/>
                                    </td>
                                    <td class="actions-column">
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-primary btn-sm btn-action update-inventory-btn" 
                                                    data-product-id="${item.product.id}" 
                                                    data-product-name="${item.product.name}"
                                                    data-product-category="${item.product.category.name}"
                                                    data-current-stock="${item.quantity}"
                                                    onclick="updateSpecificProduct(${item.product.id}, '${item.product.category.name} - ${item.product.name}', ${item.quantity})">
                                                <i class="fas fa-edit"></i> Update
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm btn-action delete-inventory-btn" 
                                                    data-product-id="${item.product.id}" 
                                                    data-product-name="${item.product.name}"
                                                    data-product-category="${item.product.category.name}"
                                                    data-product-stock="${item.quantity}"
                                                    onclick="deleteSpecificProduct(${item.product.id}, '${item.product.category.name} - ${item.product.name} (Stock: ${item.quantity})')">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty inventory}">
                                <tr>
                                    <td colspan="10" class="text-center text-muted py-4">
                                        <i class="fas fa-box-open fa-3x mb-3"></i><br>
                                        <h4>No Inventory Data</h4>
                                        <p>Start by adding products and updating their stock levels.</p>
                                        <a href="${pageContext.request.contextPath}/products/add" class="btn btn-primary">
                                            <i class="fas fa-plus"></i> Add Products First
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Stock Modal -->
    <div class="modal fade" id="updateStockModal" tabindex="-1" role="dialog" aria-labelledby="updateStockModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="updateStockModalLabel">Update Stock Quantity</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="stockUpdateForm" action="${pageContext.request.contextPath}/inventory/update-stock" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="form-group">
                            <label for="productSelect">Select Product</label>
                            <select class="form-control" id="productSelect" name="productId" required>
                                <option value="">Select Product</option>
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.id}">${product.category.name} - ${product.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="quantity">Current Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" 
                                   min="0" required placeholder="Enter stock quantity">
                            <small class="form-text text-muted">
                                This will set the absolute quantity. Stock automatically updates when customers are added/removed.
                            </small>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="updateStock()">Update Stock</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Stock Modal -->
    <div class="modal fade" id="deleteStockModal" tabindex="-1" role="dialog" aria-labelledby="deleteStockModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteStockModalLabel">Delete Stock Entry</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Warning:</strong> This action will permanently delete the inventory entry for this product.
                        This cannot be undone. Customers associated with this product will remain, but stock tracking will be removed.
                    </div>
                    <form id="stockDeleteForm" action="${pageContext.request.contextPath}/inventory/delete-stock" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="form-group">
                            <label for="deleteProductSelect">Select Product to Delete</label>
                            <select class="form-control" id="deleteProductSelect" name="productId" required>
                                <option value="">Select Product</option>
                                <c:forEach var="item" items="${inventory}">
                                    <option value="${item.product.id}">
                                        ${item.product.category.name} - ${item.product.name} (Stock: ${item.quantity})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="confirmDelete">Type "DELETE" to confirm</label>
                            <input type="text" class="form-control" id="confirmDelete" required 
                                   placeholder="Type DELETE here">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="deleteStock()">Delete Stock Entry</button>
                </div>
            </div>
        </div>
    </div>

    <script>
    // Function to update stock (for global update button)
    function updateStock() {
        var form = document.getElementById('stockUpdateForm');
        if (form.checkValidity()) {
            form.submit();
        } else {
            form.reportValidity();
        }
    }

    // Function to delete stock (for global delete button)
    function deleteStock() {
        var confirmText = $('#confirmDelete').val();
        if (confirmText !== 'DELETE') {
            toastr.error('Please type "DELETE" to confirm deletion');
            return;
        }
        
        var productId = $('#deleteProductSelect').val();
        if (!productId) {
            toastr.error('Please select a product to delete');
            return;
        }
        
        // Set the product ID in the form
        $('#stockDeleteForm').append('<input type="hidden" name="productId" value="' + productId + '">');
        
        var form = document.getElementById('stockDeleteForm');
        if (form.checkValidity()) {
            form.submit();
        } else {
            form.reportValidity();
        }
    }

    // NEW FUNCTION: Update specific product (for individual update buttons)
    function updateSpecificProduct(productId, productDisplayName, currentStock) {
        // Set the product in the update modal dropdown
        $('#productSelect').val(productId);
        
        // Set the current quantity in the quantity field
        $('#quantity').val(currentStock);
        
        // Focus on the quantity field for easy editing
        $('#quantity').focus();
        $('#quantity').select();
        
        // Show the update modal
        $('#updateStockModal').modal('show');
    }

    // NEW FUNCTION: Delete specific product (for individual delete buttons)
    function deleteSpecificProduct(productId, productDisplayName) {
        // Set the product in the delete modal dropdown
        $('#deleteProductSelect').val(productId);
        
        // Store the product ID for later use
        $('#deleteProductSelect').data('selected-id', productId);
        
        // Show the delete modal
        $('#deleteStockModal').modal('show');
        
        // Focus on the confirmation field
        setTimeout(function() {
            $('#confirmDelete').focus();
        }, 500);
    }

    // Auto-refresh inventory every 30 seconds
    setInterval(function() {
        location.reload();
    }, 30000);
    
    // Initialize modal events
    $(document).ready(function() {
        // When update modal is shown
        $('#updateStockModal').on('show.bs.modal', function () {
            // Nothing special to do here
        });
        
        // When update modal is hidden, clear the selection
        $('#updateStockModal').on('hidden.bs.modal', function () {
            $('#productSelect').val('');
            $('#quantity').val('');
        });
        
        // When delete modal is shown, clear confirmation field
        $('#deleteStockModal').on('show.bs.modal', function () {
            $('#confirmDelete').val('');
        });
        
        // When delete modal is hidden, clear the selection
        $('#deleteStockModal').on('hidden.bs.modal', function () {
            $('#deleteProductSelect').val('');
            $('#deleteProductSelect').removeData('selected-id');
        });
        
        // Quick update from table (double-click on stock quantity)
        $('td.text-center').on('dblclick', function() {
            var row = $(this).closest('tr');
            var productId = row.find('.update-inventory-btn').data('product-id');
            var productName = row.find('.update-inventory-btn').data('product-name');
            var categoryName = row.find('.update-inventory-btn').data('product-category');
            var currentStock = row.find('.update-inventory-btn').data('current-stock');
            
            if (productId) {
                updateSpecificProduct(productId, categoryName + ' - ' + productName, currentStock);
            }
        });
        
        // Add tooltips for better UX
        $('[data-toggle="tooltip"]').tooltip();
        
        // Add double-click hint
        $('td.text-center').css('cursor', 'pointer');
        $('td.text-center').attr('title', 'Double-click to quickly update stock');
        $('td.text-center').tooltip();
    });
</script>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>