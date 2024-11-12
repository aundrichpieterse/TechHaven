package com.aundrich.techhaven.servlets;

import com.aundrich.techhaven.Cart;
import com.aundrich.techhaven.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AddToCartServlet.class.getName());

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
    private static final String JDBC_USER = ""; // Provide own username
    private static final String JDBC_PASSWORD = ""; // Provide own password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");

        logger.log(Level.INFO, "Received productId: {0}, quantity: {1}", new Object[]{productIdParam, quantityParam});

        // Validate parameters
        if (productIdParam == null || quantityParam == null || productIdParam.isEmpty() || quantityParam.isEmpty()) {
            logger.log(Level.WARNING, "Missing parameters: productId or quantity");
            response.sendRedirect("home.jsp?error=MissingParameters");
            return;
        }

        int productId;
        int quantity;

        try {
            // Convert parameters to integers
            productId = Integer.parseInt(productIdParam);
            quantity = Integer.parseInt(quantityParam);
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid parameters: unable to parse productId or quantity");
            response.sendRedirect("home.jsp?error=InvalidParameters");
            return;
        }

        // Validate quantity
        if (quantity <= 0) {
            logger.log(Level.WARNING, "Invalid quantity: {0}", quantity);
            response.sendRedirect("productDetails.jsp?id=" + productId + "&error=InvalidQuantity");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load JDBC driver and connect to database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Query product details
            String sql = "SELECT name, price, stock_quantity, image FROM Item WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Get product details from result set
                String name = rs.getString("name");
                BigDecimal price = rs.getBigDecimal("price");
                int stockQuantity = rs.getInt("stock_quantity");
                String image = rs.getString("image");

                // Check stock availability
                if (quantity > stockQuantity) {
                    logger.log(Level.WARNING, "Requested quantity {0} exceeds stock {1} for product ID {2}", new Object[]{quantity, stockQuantity, productId});
                    response.sendRedirect("productDetails.jsp?id=" + productId + "&error=InsufficientStock");
                    return;
                }

                // Add item to cart
                HttpSession session = request.getSession();
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) {
                    cart = new Cart();
                    session.setAttribute("cart", cart);
                }

                Product product = new Product(productId, name, price, quantity, image);
                cart.addItem(product);

                // Redirect to cart page
                response.sendRedirect("cart.jsp?success=ItemAdded");
            } else {
                logger.log(Level.WARNING, "Product not found with id: {0}", productId);
                response.sendRedirect("home.jsp?error=ProductNotFound");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Database error occurred", e);
            response.sendRedirect("home.jsp?error=DatabaseError");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                logger.log(Level.SEVERE, "Error closing resources", ex);
            }
        }
    }
}
