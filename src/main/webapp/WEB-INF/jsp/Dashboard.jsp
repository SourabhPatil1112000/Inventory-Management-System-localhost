<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - PATIL BATTERIES</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

/* Revenue Stats Cards - Blue/Purple theme */
.bg-today { 
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
}
.bg-week { 
    background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
    border: none;
}
.bg-month { 
    background: linear-gradient(135deg, #3A7BD5 0%, #00D2FF 100%);
    border: none;
}
.bg-year { 
    background: linear-gradient(135deg, #1E3C72 0%, #2A5298 100%);
    border: none;
}

/* Profit Stats Cards - Green/Teal theme */
.bg-profit-today { 
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
    border: none;
}
.bg-profit-week { 
    background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
    border: none;
}
.bg-profit-month { 
    background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
    border: none;
}
.bg-profit-year { 
    background: linear-gradient(135deg, #02AAB0 0%, #00CDAC 100%);
    border: none;
} 

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
        .dashboard-alert {
            border-left: 4px solid #ff0000;
            background: #ffe6e6;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .dashboard-alert.warning {
            border-left-color: #ffc107;
            background: #fff3cd;
        }
        .dashboard-alert.info {
            border-left-color: #17a2b8;
            background: #d1ecf1;
        }
        .dashboard-alert.success {
            border-left-color: #28a745;
            background: #d4edda;
        }
        .chart-controls {
            background: #f8f9fa;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            border: 1px solid #dee2e6;
        }
        .chart-controls label {
            font-weight: 600;
            margin-right: 10px;
            color: #495057;
        }
        .chart-controls select {
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 5px 10px;
            background: white;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp">
        <jsp:param name="activePage" value="dashboard" />
    </jsp:include>

    <div class="container-fluid mt-4">
        <!-- Alerts Section -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${empty categories}">
                        <div class="dashboard-alert info">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-info-circle mr-2"></i>
                                    <strong>Setup Required:</strong> No product categories found. Start by adding your first category.
                                </div>
                                <a href="${pageContext.request.contextPath}/products/categories/add" 
                                   class="btn btn-info btn-sm">
                                    <i class="fas fa-plus"></i> Add Category
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:when test="${empty insights.todayCustomers or insights.todayCustomers == 0}">
                        <div class="dashboard-alert warning">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-exclamation-triangle mr-2"></i>
                                    <strong>No Sales Today:</strong> No customers added yet. Start by adding your first customer.
                                </div>
                                <a href="${pageContext.request.contextPath}/customers/add" 
                                   class="btn btn-warning btn-sm">
                                    <i class="fas fa-user-plus"></i> Add Customer
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="dashboard-alert success">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-check-circle mr-2"></i>
                                    <strong>Good Progress!</strong> You have ${insights.todayCustomers} sale(s) today.
                                </div>
                                <a href="${pageContext.request.contextPath}/customers/add" 
                                   class="btn btn-success btn-sm">
                                    <i class="fas fa-user-plus"></i> Add More
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Stats Cards -->
        <!-- Today's Stats -->
        <div class="row">
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-today stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">TODAY</h6>
                                <h4 class="mb-0">${insights.todayCustomers} Customers</h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.todayRevenue}" type="currency" currencySymbol="₹"/>
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-calendar-day fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total ${empty insights.todayCustomers ? '0' : insights.todayCustomers} transaction(s) today</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- This Week Stats -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-week stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">THIS WEEK</h6>
                                <h4 class="mb-0">${insights.weekCustomers} Customers</h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.weekRevenue}" type="currency" currencySymbol="₹"/>
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-calendar-week fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total week revenue</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Monthly Stats -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-month stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">THIS MONTH</h6>
                                <h4 class="mb-0">${insights.monthCustomers} Customers</h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.monthRevenue}" type="currency" currencySymbol="₹"/>
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-calendar-alt fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total month revenue</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Yearly Stats -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-year stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">THIS YEAR</h6>
                                <h4 class="mb-0">${insights.yearCustomers} Customers</h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.yearRevenue}" type="currency" currencySymbol="₹"/>
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-calendar fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total year revenue</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Profit Stats -->
        <div class="row mt-3">
            <!-- Today's Profit -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-profit-today stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">TODAY'S PROFIT</h6>
                                <h4 class="mb-0">
                                    <fmt:formatNumber value="${insights.todayProfit}" type="currency" currencySymbol="₹"/>
                                </h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.todayProfitPercent}" pattern="0.00"/>%
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-rupee-sign fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total profit after costs</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- This Week's Profit -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-profit-week stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">WEEK'S PROFIT</h6>
                                <h4 class="mb-0">
                                    <fmt:formatNumber value="${insights.weekProfit}" type="currency" currencySymbol="₹"/>
                                </h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.weekProfitPercent}" pattern="0.00"/>%
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-chart-line fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total weekly profit</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Monthly Profit -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-profit-month stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">MONTH'S PROFIT</h6>
                                <h4 class="mb-0">
                                    <fmt:formatNumber value="${insights.monthProfit}" type="currency" currencySymbol="₹"/>
                                </h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.monthProfitPercent}" pattern="0.00"/>%
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-chart-bar fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total monthly profit</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Yearly Profit -->
            <div class="col-xl-3 col-lg-6 col-md-6">
                <div class="card text-white bg-profit-year stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">YEAR'S PROFIT</h6>
                                <h4 class="mb-0">
                                    <fmt:formatNumber value="${insights.yearProfit}" type="currency" currencySymbol="₹"/>
                                </h4>
                                <p class="mb-0">
                                    <fmt:formatNumber value="${insights.yearProfitPercent}" pattern="0.00"/>%
                                </p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-chart-pie fa-3x opacity-75"></i>
                            </div>
                        </div>
                        <div class="mt-3">
                            <small>Total yearly profit</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="row mt-4">
            <div class="col-lg-6 col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-chart-line"></i> Sales Trend</h5>
                        <div class="chart-controls">
                            <label for="salesPeriod">Period:</label>
                            <select id="salesPeriod" onchange="changeSalesChart()">
                                <option value="day">Today</option>
                                <option value="week">This Week</option>
                                <option value="month" selected>This Month</option>
                                <option value="year">This Year</option>
                            </select>
                            <label for="salesType" class="ml-3">Type:</label>
                            <select id="salesType" onchange="changeSalesChart()">
                                <option value="revenue" selected>Total Revenue</option>
                                <option value="profit">Total Profit</option>
                            </select>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="salesChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-12">
                <div class="card">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-chart-pie"></i> Top Selling Products</h5>
                        <div class="chart-controls">
                            <label for="productsPeriod">Period:</label>
                            <select id="productsPeriod" onchange="changeProductsChart()">
                                <option value="all">All Time</option>
                                <option value="day">Today</option>
                                <option value="week">This Week</option>
                                <option value="month" selected>This Month</option>
                                <option value="year">This Year</option>
                            </select>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="productsChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/customers/add" class="btn btn-success btn-lg btn-block py-3">
                                    <i class="fas fa-user-plus fa-2x mb-2"></i><br>
                                    <span class="d-block">Add Customer</span>
                                    <small class="d-block mt-1">Register new sale</small>
                                </a>
                            </div>
                            <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/customers/view" class="btn btn-info btn-lg btn-block py-3">
                                    <i class="fas fa-users fa-2x mb-2"></i><br>
                                    <span class="d-block">View Customers</span>
                                    <small class="d-block mt-1">All customer records</small>
                                </a>
                            </div>
                            <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/products/prices" class="btn btn-warning btn-lg btn-block py-3">
                                    <i class="fas fa-tags fa-2x mb-2"></i><br>
                                    <span class="d-block">Manage Prices</span>
                                    <small class="d-block mt-1">Update product prices</small>
                                </a>
                            </div>
                            <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-danger btn-lg btn-block py-3">
                                    <i class="fas fa-boxes fa-2x mb-2"></i><br>
                                    <span class="d-block">Inventory</span>
                                    <small class="d-block mt-1">Stock management</small>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        // Initialize empty charts
        var salesChart = initSalesChart();
        var productsChart = initProductsChart();
        
        // Load initial chart data
        loadSalesChart(salesChart, 'month', 'revenue');
        loadProductsChart(productsChart, 'month');
    });
    
    function initSalesChart() {
        var ctx = document.getElementById('salesChart').getContext('2d');
        return new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Loading...'],
                datasets: [{
                    label: 'Loading...',
                    data: [0],
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ₹' + context.parsed.y.toLocaleString('en-IN');
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '₹' + value.toLocaleString('en-IN');
                            }
                        }
                    }
                }
            }
        });
    }
    
    function initProductsChart() {
        var ctx = document.getElementById('productsChart').getContext('2d');
        return new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Loading...'],
                datasets: [{
                    data: [100],
                    backgroundColor: ['#dee2e6'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.raw + ' unit(s) sold';
                            }
                        }
                    }
                }
            }
        });
    }
    
    function changeSalesChart() {
        var salesChart = Chart.getChart('salesChart');
        var period = $('#salesPeriod').val();
        var type = $('#salesType').val();
        loadSalesChart(salesChart, period, type);
    }
    
    function changeProductsChart() {
        var productsChart = Chart.getChart('productsChart');
        var period = $('#productsPeriod').val();
        loadProductsChart(productsChart, period);
    }
    
    function loadSalesChart(chart, period, type) {
        // Show loading state
        chart.data.labels = ['Loading...'];
        chart.data.datasets[0].data = [0];
        chart.data.datasets[0].label = 'Loading...';
        chart.update();
        
        $.ajax({
            url: '${pageContext.request.contextPath}/api/charts/sales',
            type: 'GET',
            data: { 
                period: period,
                type: type
            },
            success: function(response) {
                if (response && response.labels && response.data) {
                    // Check if all data is zero
                    var allZero = response.data.every(function(value) {
                        return value === 0 || value === 0.0 || value === '0' || value === '0.00';
                    });
                    
                    if (allZero || response.data.length === 0) {
                        // Show message for no data
                        chart.data.labels = ['No Data'];
                        chart.data.datasets[0].data = [0];
                        chart.data.datasets[0].label = response.title + ' (No data available)';
                    } else {
                        // Update with actual data
                        chart.data.labels = response.labels;
                        chart.data.datasets[0].data = response.data;
                        chart.data.datasets[0].label = response.title;
                    }
                    chart.update();
                } else {
                    console.error('Invalid response format:', response);
                    // Show error message
                    chart.data.labels = ['Error'];
                    chart.data.datasets[0].data = [0];
                    chart.data.datasets[0].label = 'Error loading data';
                    chart.update();
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading sales chart:', error);
                // Show error message
                chart.data.labels = ['Error'];
                chart.data.datasets[0].data = [0];
                chart.data.datasets[0].label = 'Error loading chart data';
                chart.update();
            }
        });
    }
    
    function loadProductsChart(chart, period) {
        // Show loading state
        chart.data.labels = ['Loading...'];
        chart.data.datasets[0].data = [100];
        chart.update();
        
        $.ajax({
            url: '${pageContext.request.contextPath}/api/charts/top-products',
            type: 'GET',
            data: { period: period },
            success: function(response) {
                if (response && response.labels && response.data) {
                    // Check if it's the "No Sales Yet" placeholder
                    if (response.labels.length === 1 && response.labels[0] === 'No Sales Yet') {
                        chart.data.labels = ['No Sales Yet'];
                        chart.data.datasets[0].data = [100];
                        chart.data.datasets[0].backgroundColor = ['#dee2e6'];
                    } else {
                        chart.data.labels = response.labels;
                        chart.data.datasets[0].data = response.data;
                        
                        // Update colors if available
                        if (response.colors) {
                            chart.data.datasets[0].backgroundColor = response.colors;
                        }
                    }
                    chart.update();
                } else {
                    console.error('Invalid response format:', response);
                    chart.data.labels = ['Error'];
                    chart.data.datasets[0].data = [100];
                    chart.update();
                }
            },
            error: function(xhr, status, error) {
                console.error('Error loading products chart:', error);
                chart.data.labels = ['Error'];
                chart.data.datasets[0].data = [100];
                chart.update();
            }
        });
    }
</script>

    <jsp:include page="common/toastr.jsp" />
</body>
</html>