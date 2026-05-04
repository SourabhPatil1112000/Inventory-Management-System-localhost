<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Category Deletion</title>
    <style>
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .success-box {
            border: 2px solid #27ae60;
            background-color: #d5f4e6;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .error-box {
            border: 2px solid #e74c3c;
            background-color: #fadbd8;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .warning-box {
            border: 2px solid #f39c12;
            background-color: #fef5e7;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .category-info {
            background-color: #e8f4fc;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
        }
        .btn {
            padding: 10px 20px;
            margin-right: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
        }
        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        pre {
            background-color: #f4f4f4;
            padding: 10px;
            border-radius: 4px;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Confirm Category Deletion</h2>
        
        <div class="category-info">
            <h3>Category: ${category.name}</h3>
            <p>ID: ${category.id}</p>
        </div>
        
        <c:choose>
            <c:when test="${canDelete}">
                <div class="success-box">
                    <h3>✅ Category Can Be Deleted</h3>
                    <p>${deletionStatus}</p>
                    <p>Are you sure you want to delete this category?</p>
                </div>
                
                <div class="actions">
                    <a href="/products/prices" class="btn btn-secondary">Cancel</a>
                    <a href="/products/categories/delete/${category.id}" 
                       class="btn btn-danger"
                       onclick="return confirm('Are you absolutely sure? This action cannot be undone.')">
                        Yes, Delete Category
                    </a>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="error-box">
                    <h3>⛔ Cannot Delete Category</h3>
                    <pre>${deletionStatus}</pre>
                    <p><strong>Action Required:</strong> Before deleting this category, you must:</p>
                    <ol>
                        <li>Delete or reassign customers from the products in this category</li>
                        <li>Or consider archiving the category instead</li>
                        <li>Or contact the customers to update their product information</li>
                    </ol>
                </div>
                
                <div class="actions">
                    <a href="/products/prices" class="btn btn-secondary">Return to Products</a>
                    <a href="/products/edit" class="btn btn-secondary">Manage Products</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>