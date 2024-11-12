package com.aundrich.techhaven.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.aundrich.techhaven.dbtest.DatabaseConnection;

@WebServlet("/admin/addItem")
public class AddItemServlet extends HttpServlet {

    /**
     * Handles POST requests to add a new item.
     * 
     * @param request  The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException If a servlet error occurs.
     * @throws IOException If an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceString = request.getParameter("price");
        String stockQuantityString = request.getParameter("stockQuantity");
        String image = request.getParameter("image");
        String categoryIdString = request.getParameter("categoryId");

        BigDecimal price = null;
        int stockQuantity = 0;
        int categoryId = 0;

        try {
            // Convert input strings to appropriate data types
            price = new BigDecimal(priceString);
            stockQuantity = Integer.parseInt(stockQuantityString);
            categoryId = Integer.parseInt(categoryIdString);
        } catch (NumberFormatException e) {
            // Handle conversion errors
            request.setAttribute("errorMessage", "Invalid input: " + e.getMessage());
            request.getRequestDispatcher("/admin/addItem.jsp").forward(request, response);
            return;
        }

        // Database connection and statement
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Get a database connection
            conn = DatabaseConnection.getConnection();

            // Prepare SQL statement to insert item
            String sql = "INSERT INTO Item (name, description, price, image, category_id, stock_quantity) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setBigDecimal(3, price);
            ps.setString(4, image);
            ps.setInt(5, categoryId);
            ps.setInt(6, stockQuantity);

            // Execute the statement
            int result = ps.executeUpdate();

            // Set success or error message
            if (result > 0) {
                request.setAttribute("message", "Product added successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add the product.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "SQL Error: " + e.getMessage());
        } finally {
            // Close resources
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        // Forward to JSP with message
        request.getRequestDispatcher("/admin/addItem.jsp").forward(request, response);
    }
}
