<%-- 
    Document   : home
    Created on : Sep 8, 2024, 6:06:44 PM
    Author     : Aundrich Pieterse
--%>

<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TechHaven - Products</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
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
        }

        .nav-items ul li {
            margin: 0 10px;
            position: relative;
        }

        .nav-items ul li a {
            display: block;
            color: #15305d;
            text-align: center;
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

        .navbar .right {
            margin-left: 10px;
            background-color: #d5ddea;
            color: #15305d;
            border: none;
            padding: 12px 18px;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .navbar .right:hover {
            background-color: #6610f2;
            color: #ffffff;
            transform: scale(1.05);
        }

        main {
            flex: 1;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #15305d;
            text-align: center;
        }

        .cards-container {
            width: 100%;
            max-width: 1200px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .card {
            width: 240px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card img {
            width: 100%;
            height: 160px; 
            object-fit: cover;
        }

        .card-content {
            padding: 10px; 
        }

        .card-content h3 {
            font-size: 16px; 
            margin: 0;
        }

        .card-content p {
            margin: 8px 0;
            color: #666;
        }

        .card-content .id, 
        .card-content .price {
            font-weight: bold;
        }

        .card-hover {
            display: none;
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            text-align: center;
        }

        .card-hover a {
            display: inline-block;
            width: 200px;
            padding: 10px;
            background-color: #15305d;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .card-hover a:hover {
            background-color: #6610f2;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .card:hover .card-hover {
            display: block;
        }

        footer {
            background-color: #15305d;
            color: white;
            text-align: center;
            padding: 12px 18px;
            height: 40px;
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

<main>
    <h2>Our Products</h2>

    <!-- Container to hold all product cards -->
    <div class="cards-container">
        <%
            // Database connection URL, username, and password
            String jdbcUrl = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
            String jdbcUser = ""; // Provide own username
            String jdbcPassword = ""; // Provide own password 

            Connection conn = null;
            PreparedStatement pstmt = null;  
            ResultSet rs = null;  

            try {
                // Loading the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish a connection to the database
                conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

                // SQL query to fetch all products from the Item table
                String sql = "SELECT id, name, description, price, image FROM Item";
                pstmt = conn.prepareStatement(sql);  // Prepare the SQL query

                // Execute the query and store the results in ResultSet
                rs = pstmt.executeQuery();

                // Loop through each product in the result set
                while (rs.next()) {
                    // Retrieve product details from the current row
                    int id = rs.getInt("id");  // Product ID
                    String name = rs.getString("name");  // Product name
                    String description = rs.getString("description");  // Product description
                    BigDecimal price = rs.getBigDecimal("price");  // Product price
                    String image = rs.getString("image");  // Image URL of the product
        %>
                    
                    <div class="card">
                        <!-- Product image -->
                        <img src="<%= image %>" alt="<%= name %>">
                        
                        <!-- Product details -->
                        <div class="card-content">
                            <h3><%= name %></h3>  <!-- Product name -->
                            <p class="id">Product ID: <%= id %></p>  <!-- Product ID -->
                            <p class="description"><%= description %></p>  <!-- Product description -->
                            <p class="price">R<%= price %></p>  <!-- Product price -->
                        </div>

                        <!-- Add to cart link/button -->
                        <div class="card-hover">
                            <a href="productDetails.jsp?id=<%= id %>">Add to Cart</a>  <!-- Links to product details -->
                        </div>
                    </div>
        <%
                }  // End of while loop for iterating over products
            } catch (Exception e) {
                // Print an error message if something goes wrong
                out.println("<p>Error fetching products: " + e.getMessage() + "</p>");
            } finally {
                // Close all database resources to avoid memory leaks
                try {
                    if (rs != null) rs.close();  // Close the result set
                    if (pstmt != null) pstmt.close();  // Close the prepared statement
                    if (conn != null) conn.close();  // Close the database connection
                } catch (Exception ex) {
                    ex.printStackTrace();  // Print stack trace for any exceptions during cleanup
                }
            }
        %>
    </div>
</main>
    
    <footer>
        <p>&copy; 2024 TechHaven</p>
    </footer>
</body>
</html>
