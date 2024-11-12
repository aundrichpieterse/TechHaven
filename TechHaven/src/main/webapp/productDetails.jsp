<%-- 
    Document   : productdetails
    Created on : Sep 9, 2024, 11:48:41 AM
    Author     : Aundrich Pieterse
--%>

<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TechHaven - Product Details</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }
        .navbar {
            background-color: #d5ddea;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            position: sticky;
            top: 0;
            display: flex;
            align-items: center;
            padding: 0 20px;
            box-sizing: border-box;
        }
        .navbar .logo {
            font-size: 18px;
            color: #15305d;
            font-weight: bold;
            margin-left: 20px;
        }
        .nav-items {
            flex: 1;
            display: flex;
            justify-content: center;
        }
        .nav-items ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
        }
        .nav-items ul li {
            margin: 0 10px;
            position: relative;
        }
        .nav-items ul li a {
            display: block;
            color: #15305d;
            padding: 12px 18px;
            text-decoration: none;
            background-color: #5305d;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease;
        }
        .nav-items ul li a:hover {
            background-color: #6610f2;
            color: #ffffff;
            transform: scale(1.05);
        }
        .nav-items .dropdown {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background-color: #d5ddea;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .nav-items .dropdown a {
            display: block;
            color: #15305d;
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 3px;
            transition: background-color 0.3s ease;
        }
        .nav-items .dropdown a:hover {
            background-color: #6610f2;
            color: #ffffff;
        }
        .nav-items ul li:hover .dropdown {
            display: block;
        }
        .container {
            flex: 1;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            box-sizing: border-box; 
        }
        .product-details {
            max-width: 300px; 
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 15px;
            text-align: center;
            margin: 0 auto;
        }
        .product-details img {
            width: 300px; 
            height: 300px; 
            object-fit: cover; 
            margin-bottom: 15px; 
        }
        .product-details h2 {
            color: #15305d;
            margin: 10px 0;
            font-size: 18px; 
        }
        .product-details p {
            color: #666;
            margin: 8px 0; 
        }
        .product-details .price {
            font-weight: bold;
            font-size: 18px; 
            color: #15305d;
        }
        .product-details form {
            margin-top: 15px; 
        }
        .product-details form input {
            padding: 6px; 
            font-size: 14px; 
            margin: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 100%; 
            max-width: 100px; 
            box-sizing: border-box; 
        }
        .product-details form button {
            padding: 6px 12px; 
            font-size: 14px; 
            background-color: #15305d;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .product-details form button:hover {
            background-color: #6610f2;
        }
        
        footer {
            background-color: #15305d;
            color: white;
            text-align: center;
            padding: 12px 18px;
            height: 40px;
            box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <div class="logo">TechHaven</div>
            <div class="nav-items">
                <ul>
                    <li><a href="home.jsp">Home</a></li>
                    <li>
                        <a href="#">Categories</a>
                        <div class="dropdown">
                            <a href="home.jsp">All</a>
                            <a href="laptops.jsp">Laptops</a>
                            <a href="desktops.jsp">Desktops</a>
                            <a href="tablets.jsp">Tablets</a>
                            <a href="accessories.jsp">Accessories</a>
                        </div>
                    </li>
                    <li><a href="cart.jsp">My Cart</a></li>
                </ul>
            </div>
        </div>
    </header>

<div class="container">
    <div class="product-details">
        <%
            // Retrieve the product ID from the request
            String itemId = request.getParameter("id");

            if (itemId != null && !itemId.isEmpty()) {
                // Database connection URL, username, and password
                String jdbcUrl = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
                String jdbcUser = ""; // Provide own username
                String jdbcPassword = ""; // Provide own password

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Loading MySQL JDBC Driver
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // Establish connection to the database
                    conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

                    // SQL query to fetch item details
                    String sql = "SELECT name, description, price, image, stock_quantity FROM Item WHERE id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(itemId));

                    // Execute the query
                    rs = pstmt.executeQuery();

                    // If the item is found, display its details
                    if (rs.next()) {
                        String name = rs.getString("name");
                        String description = rs.getString("description");
                        BigDecimal price = rs.getBigDecimal("price");
                        String image = rs.getString("image");
                        int stockQuantity = rs.getInt("stock_quantity");
        %>
                        <!-- Display product image -->
                        <img src="<%= image %>" alt="<%= name %>">

                        <!-- Display product name and description -->
                        <h2><%= name %></h2>
                        <p><%= description %></p>

                        <!-- Display product price -->
                        <p class="price">R<%= price %></p>

                        <!-- Add to Cart form with quantity selection -->
                        <form action="addToCart" method="post">
                            <!-- Hidden field to store the product ID -->
                            <input type="hidden" name="productId" value="<%= itemId %>">
                            
                            <!-- Quantity input, with min as 1 and max as stock quantity -->
                            <input type="number" name="quantity" min="1" max="<%= stockQuantity %>" value="1">
                            
                            <!-- Submit button to add the product to cart -->
                            <button type="submit">Add to Cart</button>
                        </form>
        <%
                    } else {
                        // If the item is not found in the database
                        out.println("<p>Item not found.</p>");
                    }
                } catch (Exception e) {
                    // Handle any errors that occur during the database query
                    out.println("<p>Error fetching product details: " + e.getMessage() + "</p>");
                } finally {
                    // Close the result set, prepared statement, and connection
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            } else {
                // If the product ID is missing or invalid
                out.println("<p>Invalid or missing item ID.</p>");
            }
        %>
    </div>
</div>


    <footer>
        <p>&copy; 2024 TechHaven</p>
    </footer>
</body>
</html>
