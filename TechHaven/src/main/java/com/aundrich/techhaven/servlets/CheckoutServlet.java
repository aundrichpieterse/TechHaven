package com.aundrich.techhaven.servlets;

import com.aundrich.techhaven.Cart;
import com.aundrich.techhaven.Product;
import com.aundrich.techhaven.dbtest.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null && !cart.isEmpty()) {
            try {
                processCheckout(cart); // Process the checkout
                
                session.removeAttribute("cart"); // Clearing the cart after placing the order cart
                response.sendRedirect("confirmation.jsp"); // Redirect to confirmation page
            } catch (SQLException e) {
                log("SQL error during checkout: " + e.getMessage(), e);
                response.sendRedirect("cart.jsp?error=CheckoutFailed"); // Redirect on error
            } catch (Exception e) {
                log("Unexpected error during checkout: " + e.getMessage(), e);
                response.sendRedirect("cart.jsp?error=CheckoutFailed"); // Redirect on error
            }
        } else {
            response.sendRedirect("cart.jsp"); // Redirect if cart is empty
        }
    }

    private void processCheckout(Cart cart) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false); // Start transaction

            // Insert order
            String insertOrderSQL = "INSERT INTO `Order` (order_date) VALUES (NOW())";
            try (PreparedStatement ps = connection.prepareStatement(insertOrderSQL, 
                PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.executeUpdate();
                try (var rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);

                        // Insert order details
                        String insertOrderDetailsSQL = "INSERT INTO OrderDetails (order_id, item_id, quantity) VALUES (?, ?, ?)";
                        try (PreparedStatement psDetails = connection.prepareStatement(insertOrderDetailsSQL)) {
                            for (Product product : cart.getProducts()) {
                                psDetails.setInt(1, orderId);
                                psDetails.setInt(2, product.getId());
                                psDetails.setInt(3, product.getQuantity());
                                psDetails.addBatch();
                            }
                            psDetails.executeBatch();
                        }

                        // Update stock
                        String updateStockSQL = "UPDATE Item SET stock_quantity = stock_quantity - ? WHERE id = ?";
                        try (PreparedStatement psStock = connection.prepareStatement(updateStockSQL)) {
                            for (Product product : cart.getProducts()) {
                                psStock.setInt(1, product.getQuantity());
                                psStock.setInt(2, product.getId());
                                psStock.addBatch();
                            }
                            psStock.executeBatch();
                        }

                        connection.commit(); // Commit the transaction
                    } else {
                        throw new SQLException("Failed to retrieve generated order ID.");
                    }
                }
            } 
        } catch (SQLException e) {
            throw new SQLException("Error processing checkout", e);
        }
    }
}
