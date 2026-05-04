<%-- ProductDeleteConfirm.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirm Product Deletion - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="products" />
    </jsp:include>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h4 class="mb-0"><i class="fas fa-trash"></i> Confirm Product Deletion</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <h5>Product Details</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Name:</strong> ${product.name}</p>
                                    <p><strong>Category:</strong> ${product.category.name}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Purchase Price:</strong> ₹<fmt:formatNumber value="${product.purchasePrice}" pattern="0.00"/></p>
                                    <p><strong>Selling Price:</strong> ₹<fmt:formatNumber value="${product.sellingPrice}" pattern="0.00"/></p>
                                </div>
                            </div>
                            <c:if test="${not empty product.description}">
                                <p><strong>Description:</strong> ${product.description}</p>
                            </c:if>
                        </div>
                        
                        <c:choose>
                            <c:when test="${canDelete}">
                                <div class="alert alert-success">
                                    <h5><i class="fas fa-check-circle"></i> Product Can Be Deleted</h5>
                                    <p>No customers are associated with this product.</p>
                                    <p class="mb-0">Are you sure you want to delete this product?</p>
                                </div>
                                
                                <div class="text-center mt-4">
                                    <a href="${pageContext.request.contextPath}/products/prices" class="btn btn-secondary btn-lg mr-3">
                                        <i class="fas fa-times"></i> Cancel
                                    </a>
                                    <a href="${pageContext.request.contextPath}/products/delete/${product.id}" 
                                       class="btn btn-danger btn-lg"
                                       onclick="return confirm('⚠️ Are you absolutely sure? This action cannot be undone.')">
                                        <i class="fas fa-trash"></i> Yes, Delete Product
                                    </a>
                                </div>
                            </c:when>
                            
                            <c:otherwise>
                                <div class="alert alert-danger">
                                    <h5><i class="fas fa-exclamation-triangle"></i> Cannot Delete Product</h5>
                                    <p>This product has <strong>${customerCount} customer(s)</strong> associated with it.</p>
                                    <p><strong>Action Required:</strong> Before deleting this product, you must:</p>
                                    <ol>
                                        <li>Delete or update the ${customerCount} customer(s) using this product</li>
                                        <li>Or consider archiving the product instead</li>
                                        <li>Or update those customers to use a different product</li>
                                    </ol>
                                </div>
                                
                                <div class="text-center mt-4">
                                    <a href="${pageContext.request.contextPath}/products/prices" class="btn btn-secondary btn-lg mr-3">
                                        <i class="fas fa-arrow-left"></i> Return to Products
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customers/view" class="btn btn-info btn-lg">
                                        <i class="fas fa-users"></i> View Customers
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>