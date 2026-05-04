<%-- AddProduct.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="products" />
    </jsp:include>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-plus-circle"></i> Add New Product</h4>
                    </div>
                    <div class="card-body">
                        <form:form action="${pageContext.request.contextPath}/products/save" method="post" modelAttribute="product">
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
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="name">Product Name *</label>
                                        <form:input path="name" id="name" class="form-control" required="required" 
                                                   placeholder="e.g., XLTZ5, Z9, Solar On-grid"/>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="description">Description</label>
                                <form:textarea path="description" id="description" class="form-control" 
                                              rows="3" placeholder="Optional product description"/>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="purchasePrice">Purchase Price (₹) *</label>
                                        <form:input path="purchasePrice" id="purchasePrice" class="form-control" 
                                                   required="required" type="number" step="0.01" 
                                                   placeholder="0.00"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="sellingPrice">Selling Price (₹) *</label>
                                        <form:input path="sellingPrice" id="sellingPrice" class="form-control" 
                                                   required="required" type="number" step="0.01" 
                                                   placeholder="0.00"/>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group text-center">
                                <button type="submit" class="btn btn-success btn-lg mr-2">
                                    <i class="fas fa-save"></i> Save Product
                                </button>
                                <a href="${pageContext.request.contextPath}/products/prices" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>