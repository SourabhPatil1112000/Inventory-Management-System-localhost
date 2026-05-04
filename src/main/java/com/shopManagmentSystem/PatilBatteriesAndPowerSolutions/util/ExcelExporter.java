package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.util;

import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class ExcelExporter {
    
    public static void exportCustomersToExcel(List<Customer> customers, HttpServletResponse response) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Customers");
        
        // Create header row
        Row headerRow = sheet.createRow(0);
        String[] headers = {
            "ID", "Name", "Mobile Number", "Category", "Product", 
            "Quantity", "Purchase Date", "Vehicle Number", "Area", 
            "Purchase Price (Unit)", "Selling Price (Unit)", 
            "Profit/Loss (Unit)", "Profit/Loss (%)",
            "Total Purchase", "Total Selling", "Total Profit/Loss"
        };
        
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);
        
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Create data rows
        int rowNum = 1;
        
        // Create cell styles
        CellStyle numberStyle = workbook.createCellStyle();
        numberStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));
        
        CellStyle currencyStyle = workbook.createCellStyle();
        currencyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0.00"));
        
        CellStyle percentStyle = workbook.createCellStyle();
        percentStyle.setDataFormat(workbook.createDataFormat().getFormat("0.00%"));
        
        for (Customer customer : customers) {
            Row row = sheet.createRow(rowNum++);
            
            // Get product purchase price
            BigDecimal purchasePrice = BigDecimal.ZERO;
            if (customer.getProduct() != null && customer.getProduct().getPurchasePrice() != null) {
                purchasePrice = customer.getProduct().getPurchasePrice();
            }
            
            // Get customer data
            Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
            BigDecimal sellingPrice = customer.getSellingPrice() != null ? customer.getSellingPrice() : BigDecimal.ZERO;
            BigDecimal profitLoss = customer.getProfitLoss() != null ? customer.getProfitLoss() : BigDecimal.ZERO;
            BigDecimal profitLossPercent = customer.getProfitLossPercent() != null ? 
                                         customer.getProfitLossPercent() : BigDecimal.ZERO;
            
            // Calculate totals
            BigDecimal totalPurchase = purchasePrice.multiply(new BigDecimal(quantity));
            BigDecimal totalSelling = sellingPrice.multiply(new BigDecimal(quantity));
            BigDecimal totalProfit = profitLoss.multiply(new BigDecimal(quantity));
            
            // ID
            Cell idCell = row.createCell(0);
            idCell.setCellValue(customer.getId() != null ? customer.getId().doubleValue() : 0);
            idCell.setCellStyle(numberStyle);
            
            // Name
            Cell nameCell = row.createCell(1);
            nameCell.setCellValue(customer.getName() != null ? customer.getName() : "");
            
            // Mobile Number
            Cell mobileCell = row.createCell(2);
            mobileCell.setCellValue(customer.getMobileNumber() != null ? customer.getMobileNumber() : "");
            
            // Category
            Cell categoryCell = row.createCell(3);
            categoryCell.setCellValue(customer.getCategory() != null && customer.getCategory().getName() != null ? 
                                     customer.getCategory().getName() : "");
            
            // Product
            Cell productCell = row.createCell(4);
            productCell.setCellValue(customer.getProduct() != null && customer.getProduct().getName() != null ? 
                                   customer.getProduct().getName() : "");
            
            // Quantity
            Cell qtyCell = row.createCell(5);
            qtyCell.setCellValue(quantity);
            qtyCell.setCellStyle(numberStyle);
            
            // Purchase Date
            Cell dateCell = row.createCell(6);
            if (customer.getPurchaseDate() != null) {
                dateCell.setCellValue(customer.getPurchaseDate().toString());
            } else {
                dateCell.setCellValue("");
            }
            
            // Vehicle Number
            Cell vehicleCell = row.createCell(7);
            vehicleCell.setCellValue(customer.getVehicleNumber() != null ? 
                                   customer.getVehicleNumber() : "");
            
            // Area
            Cell areaCell = row.createCell(8);
            areaCell.setCellValue(customer.getArea() != null ? customer.getArea() : "");
            
            // Purchase Price (Unit)
            Cell purchasePriceCell = row.createCell(9);
            purchasePriceCell.setCellValue(purchasePrice.doubleValue());
            purchasePriceCell.setCellStyle(currencyStyle);
            
            // Selling Price (Unit)
            Cell sellingPriceCell = row.createCell(10);
            sellingPriceCell.setCellValue(sellingPrice.doubleValue());
            sellingPriceCell.setCellStyle(currencyStyle);
            
            // Profit/Loss (Unit)
            Cell profitUnitCell = row.createCell(11);
            profitUnitCell.setCellValue(profitLoss.doubleValue());
            profitUnitCell.setCellStyle(currencyStyle);
            
            // Profit/Loss (%)
            Cell percentCell = row.createCell(12);
            if (purchasePrice.compareTo(BigDecimal.ZERO) > 0) {
                percentCell.setCellValue(profitLossPercent.doubleValue() / 100);
            } else {
                percentCell.setCellValue(0);
            }
            percentCell.setCellStyle(percentStyle);
            
            // Total Purchase
            Cell totalPurchaseCell = row.createCell(13);
            totalPurchaseCell.setCellValue(totalPurchase.doubleValue());
            totalPurchaseCell.setCellStyle(currencyStyle);
            
            // Total Selling
            Cell totalSellingCell = row.createCell(14);
            totalSellingCell.setCellValue(totalSelling.doubleValue());
            totalSellingCell.setCellStyle(currencyStyle);
            
            // Total Profit/Loss
            Cell totalProfitCell = row.createCell(15);
            totalProfitCell.setCellValue(totalProfit.doubleValue());
            totalProfitCell.setCellStyle(currencyStyle);
        }
        
        // Auto-size columns
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // Set response headers
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String fileName = "customers_export_" + timestamp + ".xlsx";
        
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
        response.setCharacterEncoding("UTF-8");
        
        // Write to response
        ServletOutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);
        workbook.close();
        outputStream.flush();
    }
}