<%-- EditCategory.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Category - PATIL BATTERIES</title>
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
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning text-white">
                        <h4 class="mb-0"><i class="fas fa-edit"></i> Edit Category</h4>
                    </div>
                    <div class="card-body">
                        <form:form action="${pageContext.request.contextPath}/products/categories/update" method="post" modelAttribute="category">
                            <form:hidden path="id"/>
                            
                            <div class="form-group">
                                <label for="name">Category Name *</label>
                                <form:input path="name" id="name" class="form-control" required="required"/>
                                <small class="form-text text-muted">Products in this category: ${category.products.size()}</small>
                            </div>
                            
                            <div class="form-group text-center">
                                <button type="submit" class="btn btn-warning btn-lg mr-2">
                                    <i class="fas fa-save"></i> Update Category
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