package com.aundrich.techhaven.dao;

import com.aundrich.techhaven.Product;
import com.aundrich.techhaven.Order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * The OrderDAO class is responsible for managing operations related to orders 
 * in the database, like inserting new orders, updating stock levels, 
 * and retrieving product data.
 */
public class OrderDAO {
    // Database connection object
    private Connection connection;

    /**
     * Constructor for OrderDAO.
     * 
     * @param connection The database connection to be used for operations.
     */
    public OrderDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * Inserts an order into the database along with its associated products.
     * The order details and product stock are updated accordingly.
     * 
     * @param order The order to be inserted.
     * @throws SQLException If a database access error occurs.
     */
    public void insertOrder(Order order) throws SQLException {
        String insertOrderSQL = "INSERT INTO `Order` (order_date, total_amount) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(insertOrderSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
            // Set the order date and total amount
            ps.setTimestamp(1, new java.sql.Timestamp(order.getOrderDate().getTime()));
            ps.setBigDecimal(2, order.getTotalAmount());
            ps.executeUpdate();

            // Retrieve the generated order ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int orderId = rs.getInt(1); // Generated order ID

                    // Insert each product in the order and update its stock
                    for (Product product : order.getProducts()) {
                        insertOrderProduct(orderId, product); // Insert into order-product table
                        updateStock(product.getId(), product.getQuantity()); // Update stock based on quantity
                    }
                }
            }
        }
    }

    /**
     * Inserts a product from an order into the OrderDetails table.
     * 
     * @param orderId  The ID of the order.
     * @param product  The product to be inserted.
     * @throws SQLException If a database access error occurs.
     */
    private void insertOrderProduct(int orderId, Product product) throws SQLException {
        String insertOrderProductSQL = "INSERT INTO OrderDetails (order_id, item_id, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(insertOrderProductSQL)) {
            ps.setInt(1, orderId); // Set order ID
            ps.setInt(2, product.getId()); // Set product ID
            ps.setInt(3, product.getQuantity()); // Set quantity ordered
            ps.executeUpdate(); // Execute the SQL statement
        }
    }

    /**
     * Updates the stock quantity of a product after an order is placed.
     * The stock is decreased by the quantity ordered.
     * 
     * @param productId The ID of the product.
     * @param quantity  The quantity ordered.
     * @throws SQLException If a database access error occurs.
     */
    private void updateStock(int productId, int quantity) throws SQLException {
        String updateStockSQL = "UPDATE Item SET stock_quantity = stock_quantity - ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(updateStockSQL)) {
            ps.setInt(1, quantity); // Set the quantity to be deducted from stock
            ps.setInt(2, productId); // Set the product ID
            ps.executeUpdate(); // Execute the SQL statement
        }
    }

    /**
     * Retrieves a product from the database by its ID.
     * 
     * @param productId The ID of the product.
     * @return The product object or null if not found.
     * @throws SQLException If a database access error occurs.
     */
    public Product getProductById(int productId) throws SQLException {
        String getProductSQL = "SELECT * FROM Item WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(getProductSQL)) {
            ps.setInt(1, productId); // Set the product ID for query
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Return the product with all relevant details
                    return new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image"),
                        getCategoryNameById(rs.getInt("category_id")) // Get category name based on ID
                    );
                } else {
                    return null; // No product found for the given ID
                }
            }
        }
    }

    /**
     * Retrieves the category name based on its ID.
     * 
     * @param categoryId The ID of the category.
     * @return The name of the category or null if not found.
     * @throws SQLException If a database access error occurs.
     */
    private String getCategoryNameById(int categoryId) throws SQLException {
        String getCategorySQL = "SELECT name FROM Category WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(getCategorySQL)) {
            ps.setInt(1, categoryId); // Set the category ID for query
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name"); // Return the category name
                } else {
                    return null; // No category found for the given ID
                }
            }
        }
    }

    /**
     * Retrieves all products from the database.
     * 
     * @return A list of all products available in the system.
     * @throws SQLException If a database access error occurs.
     */
    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>(); // List to store all products
        String getAllProductsSQL = "SELECT Item.id, Item.name, Item.description, Item.price, Item.stock_quantity, Item.image, Category.name AS category_name " +
                                   "FROM Item JOIN Category ON Item.category_id = Category.id";
        try (PreparedStatement ps = connection.prepareStatement(getAllProductsSQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Create a product object from the result set and add it to the list
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image"),
                    rs.getString("category_name") // Category name is included directly
                );
                products.add(product); // Add product to the list
            }
        }
        return products; // Return the list of all products
    }
}
