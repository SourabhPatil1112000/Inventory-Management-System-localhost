package com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.Customer;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.model.User;
import com.shopManagmentSystem.PatilBatteriesAndPowerSolutions.repository.CustomerRepository;
import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ChartDataService {

	@Autowired
	private CustomerRepository customerRepository;

	public Map<String, Object> getSalesData(User user, String period, String type) {
		Map<String, Object> result = new HashMap<>();

		LocalDate endDate = LocalDate.now();
		LocalDate startDate;

		switch (period.toLowerCase()) {
		case "day":
			startDate = endDate;
			break;
		case "week":
			// FIXED: Get Monday of current week properly
			startDate = endDate.with(DayOfWeek.MONDAY);
			// If today is Sunday, we need to go back to Monday
			if (endDate.getDayOfWeek() == DayOfWeek.SUNDAY) {
				startDate = endDate.minusDays(6);
			}
			break;
		case "month":
			startDate = endDate.withDayOfMonth(1);
			break;
		case "year":
			startDate = LocalDate.of(endDate.getYear(), 1, 1);
			break;
		default:
			startDate = endDate.withDayOfMonth(1);
			period = "month";
		}

		System.out.println("=== Chart Data Request ===");
		System.out.println("Period: " + period);
		System.out.println("Type: " + type);
		System.out.println("Start Date: " + startDate);
		System.out.println("End Date: " + endDate);
		System.out.println("User: " + user.getUsername());

		// Create final copies for use in lambda
		final LocalDate finalStartDate = startDate;
		final LocalDate finalEndDate = endDate;

		List<Customer> customers = customerRepository.findAll((root, query, criteriaBuilder) -> {
			return criteriaBuilder.and(criteriaBuilder.equal(root.get("user"), user),
					criteriaBuilder.between(root.get("purchaseDate"), finalStartDate, finalEndDate));
		});

		System.out.println("Found " + customers.size() + " customers for this period");

		if (period.equals("day")) {
			return getDailySalesData(customers, type);
		} else if (period.equals("week")) {
			return getWeeklySalesData(customers, type, startDate, endDate);
		} else if (period.equals("month")) {
			return getMonthlySalesData(customers, type, startDate, endDate);
		} else {
			return getYearlySalesData(customers, type, startDate, endDate);
		}
	}

	private Map<String, Object> getDailySalesData(List<Customer> customers, String type) {
		Map<String, Object> result = new HashMap<>();
		Map<Integer, BigDecimal> hourData = new TreeMap<>();

		// Initialize all 24 hours with ZERO
		for (int hour = 0; hour < 24; hour++) {
			hourData.put(hour, BigDecimal.ZERO);
		}

		for (Customer customer : customers) {
			if (customer.getPurchaseDate() != null) {
				BigDecimal valueToAdd = BigDecimal.ZERO;
				Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;

				if (type.equals("profit") && customer.getProfitLoss() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getProfitLoss().multiply(new BigDecimal(quantity));
				} else if (type.equals("revenue") && customer.getSellingPrice() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getSellingPrice().multiply(new BigDecimal(quantity));
				}

				// Default to noon hour
				int hour = 12;

				// Safely add the value
				BigDecimal current = hourData.get(hour);
				if (current == null) {
					current = BigDecimal.ZERO;
				}
				hourData.put(hour, current.add(valueToAdd));
			}
		}

		List<String> labels = new ArrayList<>();
		List<BigDecimal> data = new ArrayList<>();

		for (Map.Entry<Integer, BigDecimal> entry : hourData.entrySet()) {
			labels.add(String.format("%02d:00", entry.getKey()));
			data.add(entry.getValue());
		}

		result.put("labels", labels);
		result.put("data", data);
		result.put("title", "Today's " + (type.equals("profit") ? "Total Profit" : "Total Revenue"));

		return result;
	}

	private Map<String, Object> getWeeklySalesData(List<Customer> customers, String type, LocalDate weekStart,
			LocalDate weekEnd) {
		Map<String, Object> result = new HashMap<>();
		Map<String, BigDecimal> dayData = new LinkedHashMap<>();

		// Initialize all days of the week with ZERO - use uppercase to match DayOfWeek
		String[] dayNames = { "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN" };
		for (String day : dayNames) {
			dayData.put(day, BigDecimal.ZERO);
		}

		System.out.println("=== Weekly Sales Data ===");
		System.out.println("Week Start: " + weekStart);
		System.out.println("Week End: " + weekEnd);
		System.out.println("Number of customers: " + customers.size());

		for (Customer customer : customers) {
			if (customer.getPurchaseDate() != null) {
				LocalDate purchaseDate = customer.getPurchaseDate();
				// Get day name in uppercase 3-letter format
				String dayName = purchaseDate.getDayOfWeek().toString().substring(0, 3);

				BigDecimal valueToAdd = BigDecimal.ZERO;
				Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;

				if (type.equals("profit") && customer.getProfitLoss() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getProfitLoss().multiply(new BigDecimal(quantity));
					System.out.println("Customer total profit: " + valueToAdd + " (" + customer.getProfitLoss() + " × " + quantity + ") on " + purchaseDate + " (" + dayName + ")");
				} else if (type.equals("revenue") && customer.getSellingPrice() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getSellingPrice().multiply(new BigDecimal(quantity));
					System.out.println("Customer total revenue: " + valueToAdd + " (" + customer.getSellingPrice() + " × " + quantity + ") on " + purchaseDate + " (" + dayName + ")");
				}

				// Safely add the value
				BigDecimal current = dayData.get(dayName);
				if (current == null) {
					System.out.println("WARNING: Day " + dayName + " not found in dayData map!");
					current = BigDecimal.ZERO;
				}
				BigDecimal newValue = current.add(valueToAdd);
				dayData.put(dayName, newValue);
				System.out.println("Added " + valueToAdd + " to " + dayName + ". New total: " + newValue);
			}
		}

		List<String> labels = new ArrayList<>();
		List<BigDecimal> data = new ArrayList<>();

		// Convert to display format (capitalized properly)
		String[] displayDayNames = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
		String[] dataDayNames = { "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN" };

		for (int i = 0; i < displayDayNames.length; i++) {
			labels.add(displayDayNames[i]);
			BigDecimal dayValue = dayData.get(dataDayNames[i]);
			data.add(dayValue != null ? dayValue : BigDecimal.ZERO);
			System.out.println("Day " + displayDayNames[i] + " (" + dataDayNames[i] + "): " + dayValue);
		}

		result.put("labels", labels);
		result.put("data", data);
		result.put("title", "Weekly " + (type.equals("profit") ? "Total Profit" : "Total Revenue"));

		System.out.println("Weekly data result: " + result);
		return result;
	}

	private Map<String, Object> getMonthlySalesData(List<Customer> customers, String type, LocalDate monthStart,
			LocalDate monthEnd) {
		Map<String, Object> result = new HashMap<>();
		Map<Integer, BigDecimal> dayData = new TreeMap<>();

		// Initialize all days of the month with ZERO
		int daysInMonth = monthStart.lengthOfMonth();
		for (int day = 1; day <= daysInMonth; day++) {
			dayData.put(day, BigDecimal.ZERO);
		}

		for (Customer customer : customers) {
			if (customer.getPurchaseDate() != null) {
				int dayOfMonth = customer.getPurchaseDate().getDayOfMonth();

				BigDecimal valueToAdd = BigDecimal.ZERO;
				Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;

				if (type.equals("profit") && customer.getProfitLoss() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getProfitLoss().multiply(new BigDecimal(quantity));
				} else if (type.equals("revenue") && customer.getSellingPrice() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getSellingPrice().multiply(new BigDecimal(quantity));
				}

				// Safely add the value
				BigDecimal current = dayData.get(dayOfMonth);
				if (current == null) {
					current = BigDecimal.ZERO;
				}
				dayData.put(dayOfMonth, current.add(valueToAdd));
			}
		}

		List<String> labels = new ArrayList<>();
		List<BigDecimal> data = new ArrayList<>();

		for (Map.Entry<Integer, BigDecimal> entry : dayData.entrySet()) {
			labels.add(String.valueOf(entry.getKey()));
			data.add(entry.getValue());
		}

		result.put("labels", labels);
		result.put("data", data);
		result.put("title", "Monthly " + (type.equals("profit") ? "Total Profit" : "Total Revenue"));

		return result;
	}

	private Map<String, Object> getYearlySalesData(List<Customer> customers, String type, LocalDate yearStart,
			LocalDate yearEnd) {
		Map<String, Object> result = new HashMap<>();
		Map<String, BigDecimal> monthData = new LinkedHashMap<>();

		// Initialize all months with ZERO
		String[] monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
		for (String month : monthNames) {
			monthData.put(month, BigDecimal.ZERO);
		}

		for (Customer customer : customers) {
			if (customer.getPurchaseDate() != null && customer.getPurchaseDate().getYear() == yearStart.getYear()) {
				int monthIndex = customer.getPurchaseDate().getMonthValue() - 1;
				String monthName = monthNames[monthIndex];

				BigDecimal valueToAdd = BigDecimal.ZERO;
				Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;

				if (type.equals("profit") && customer.getProfitLoss() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getProfitLoss().multiply(new BigDecimal(quantity));
				} else if (type.equals("revenue") && customer.getSellingPrice() != null) {
					// MULTIPLY BY QUANTITY - FIXED
					valueToAdd = customer.getSellingPrice().multiply(new BigDecimal(quantity));
				}

				// Safely add the value
				BigDecimal current = monthData.get(monthName);
				if (current == null) {
					current = BigDecimal.ZERO;
				}
				monthData.put(monthName, current.add(valueToAdd));
			}
		}

		List<String> labels = new ArrayList<>();
		List<BigDecimal> data = new ArrayList<>();

		for (String month : monthNames) {
			labels.add(month);
			data.add(monthData.get(month));
		}

		result.put("labels", labels);
		result.put("data", data);
		result.put("title", "Yearly " + (type.equals("profit") ? "Total Profit" : "Total Revenue"));

		return result;
	}

	// Get top products data for different time periods - COUNT QUANTITY, not just customer records
	public Map<String, Object> getTopProductsData(User user, String period) {
		Map<String, Object> result = new HashMap<>();

		LocalDate endDate = LocalDate.now();
		LocalDate startDate;

		switch (period.toLowerCase()) {
		case "day":
			startDate = endDate;
			break;
		case "week":
			startDate = endDate.with(DayOfWeek.MONDAY);
			break;
		case "month":
			startDate = endDate.withDayOfMonth(1);
			break;
		case "year":
			startDate = LocalDate.of(endDate.getYear(), 1, 1);
			break;
		default:
			startDate = LocalDate.of(1900, 1, 1); // All time
		}

		// Create final copies for use in lambda
		final LocalDate finalStartDate = startDate;
		final LocalDate finalEndDate = endDate;

		List<Customer> customers;
		if (period.equals("all")) {
			customers = customerRepository.findByUser(user);
		} else {
			customers = customerRepository.findAll((root, query, criteriaBuilder) -> {
				return criteriaBuilder.and(criteriaBuilder.equal(root.get("user"), user),
						criteriaBuilder.between(root.get("purchaseDate"), finalStartDate, finalEndDate));
			});
		}

		// Count products - INCLUDE QUANTITY in the count
		Map<String, Integer> productCounts = new HashMap<>();

		for (Customer customer : customers) {
			if (customer.getProduct() != null) {
				String productName = customer.getProduct().getName();
				Integer quantity = customer.getQuantity() != null ? customer.getQuantity() : 1;
				// ADD QUANTITY instead of just 1
				productCounts.put(productName, productCounts.getOrDefault(productName, 0) + quantity);
			}
		}

		// Sort by count (descending) and take top 5
		List<Map.Entry<String, Integer>> sorted = productCounts.entrySet().stream()
				.sorted(Map.Entry.<String, Integer>comparingByValue().reversed()).limit(5).collect(Collectors.toList());

		List<String> labels = new ArrayList<>();
		List<Integer> data = new ArrayList<>();
		List<String> colors = Arrays.asList("#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0", "#9966FF");

		for (Map.Entry<String, Integer> entry : sorted) {
			labels.add(entry.getKey());
			data.add(entry.getValue());
		}

		// If no data, show placeholder
		if (labels.isEmpty()) {
			labels.add("No Sales Yet");
			data.add(1);
		}

		result.put("labels", labels);
		result.put("data", data);
		result.put("colors", colors.subList(0, Math.min(labels.size(), colors.size())));
		result.put("title", "Top Products (" + period + ") - Quantity Sold");

		// Debug log
		System.out.println("=== Top Products Data ===");
		System.out.println("Period: " + period);
		System.out.println("Total customers: " + customers.size());
		System.out.println("Product counts (including quantity): " + productCounts);
		System.out.println("Top 5: " + sorted);

		return result;
	}

	// Original method for backward compatibility
	public Map<String, Object> getMonthlySalesData(User user, int year) {
		return getSalesData(user, "year", "revenue");
	}

	// Original method for backward compatibility
	public Map<String, Object> getTopProductsData(User user) {
		return getTopProductsData(user, "all");
	}
}