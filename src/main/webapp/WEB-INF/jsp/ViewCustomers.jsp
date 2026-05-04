<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Customers - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="customers" />
    </jsp:include>

    <div class="container-fluid mt-4">
        <!-- Search Filters -->
        <div class="card mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fas fa-search"></i> Search & Filter Customers</h5>
            </div>
            <div class="card-body">
                <form method="get" action="${pageContext.request.contextPath}/customers/view" id="searchForm">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="name">Customer Name</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${searchName}" placeholder="Enter name">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="mobileNumber">Mobile Number</label>
                                <input type="text" class="form-control" id="mobileNumber" name="mobileNumber" 
                                       value="${searchMobile}" placeholder="Enter mobile number">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="categoryId">Category</label>
                                <select class="form-control" id="categoryId" name="categoryId">
                                    <option value="">All Categories</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${cat.id == searchCategoryId ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="area">Area</label>
                                <select class="form-control" id="area" name="area">
                                    <option value="">All Areas</option>
                                    <c:forEach var="area" items="${areas}">
                                        <option value="${area}" ${area == searchArea ? 'selected' : ''}>${area}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="startDate">From Date</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" 
                                       value="${searchStartDate}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="endDate">To Date</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" 
                                       value="${searchEndDate}">
                            </div>
                        </div>
                        <div class="col-md-6 align-self-end">
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary mr-2">
                                    <i class="fas fa-search"></i> Search
                                </button>
                                <a href="${pageContext.request.contextPath}/customers/view" class="btn btn-secondary mr-2">
                                    <i class="fas fa-redo"></i> Clear
                                </a>
                                <button type="button" class="btn btn-success" onclick="exportToExcel()">
                                    <i class="fas fa-file-excel"></i> Export to Excel
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Customers Table -->
        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-users"></i> Customers List</h5>
                <span class="badge badge-light">Total: ${customers.size()} customers</span>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Mobile</th>
                                <th>Category</th>
                                <th>Product</th>
                                <th>Qty</th>
                                <th>Purchase Date</th>
                                <th>Vehicle No.</th>
                                <th>Area</th>
                                <th>Unit Price</th>
                                <th>Total Price</th>
                                <th>Unit Profit</th>
                                <th>Total Profit</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${customers}">
                                <tr>
                                    <td>${customer.id}</td>
                                    <td>${customer.name}</td>
                                    <td>${customer.mobileNumber}</td>
                                    <td>${customer.category.name}</td>
                                    <td>${customer.product.name}</td>
                                    <td class="text-center">
                                        <span class="badge badge-primary">${customer.quantity != null ? customer.quantity : 1}</span>
                                    </td>
                                    <td>${customer.purchaseDate}</td>
                                    <td>${customer.vehicleNumber}</td>
                                    <td>${customer.area}</td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${customer.sellingPrice}" type="currency" currencyCode="INR" pattern="##0.00"/>
                                    </td>
                                    <td class="text-right font-weight-bold">
                                        <fmt:formatNumber value="${customer.sellingPrice * (customer.quantity != null ? customer.quantity : 1)}" type="currency" currencyCode="INR" pattern="##0.00"/>
                                    </td>
                                    <td class="text-right">
                                        <c:choose>
                                            <c:when test="${customer.profitLoss > 0}">
                                                <span class="badge badge-success">
                                                    +<fmt:formatNumber value="${customer.profitLoss}" pattern="##0.00"/>
                                                </span>
                                            </c:when>
                                            <c:when test="${customer.profitLoss < 0}">
                                                <span class="badge badge-danger">
                                                    <fmt:formatNumber value="${customer.profitLoss}" pattern="##0.00"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary">
                                                    <fmt:formatNumber value="${customer.profitLoss != null ? customer.profitLoss : 0}" pattern="##0.00"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-right font-weight-bold">
                                        <c:set var="totalProfit" value="${customer.profitLoss * (customer.quantity != null ? customer.quantity : 1)}"/>
                                        <c:choose>
                                            <c:when test="${totalProfit > 0}">
                                                <span class="text-success">
                                                    +<fmt:formatNumber value="${totalProfit}" pattern="##0.00"/>
                                                </span>
                                            </c:when>
                                            <c:when test="${totalProfit < 0}">
                                                <span class="text-danger">
                                                    <fmt:formatNumber value="${totalProfit}" pattern="##0.00"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-secondary">
                                                    <fmt:formatNumber value="${totalProfit}" pattern="##0.00"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/customers/edit/${customer.id}" 
                                               class="btn btn-warning" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customers/delete/${customer.id}" 
                                               class="btn btn-danger" title="Delete"
                                               onclick="return confirm('Are you sure you want to delete this customer?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty customers}">
                                <tr>
                                    <td colspan="14" class="text-center text-muted">
                                        <i class="fas fa-info-circle fa-2x mb-2"></i><br>
                                        No customers found. <a href="${pageContext.request.contextPath}/customers/add">Add your first customer</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        function exportToExcel() {
            // Get current search parameters
            var form = document.getElementById('searchForm');
            var params = new URLSearchParams(new FormData(form)).toString();
            
            // Redirect to export endpoint with current filters
            window.location.href = '${pageContext.request.contextPath}/export/customers?' + params;
        }

        // Set default dates for better UX
        $(document).ready(function() {
            var today = new Date().toISOString().split('T')[0];
            if (!$('#startDate').val()) {
                // Set start date to first day of current month
                var firstDay = new Date();
                firstDay.setDate(1);
                $('#startDate').val(firstDay.toISOString().split('T')[0]);
            }
            if (!$('#endDate').val()) {
                $('#endDate').val(today);
            }
        });
    </script>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>