<%-- 
    Document   : viewItems
    Created on : Sep 10, 2024, 10:00:05 AM
    Author     : Aundrich Pieterse
--%>

<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin session is valid
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp"); // Redirect to login page if session is invalid
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Items - TechHaven</title>
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
        
        /* Main Section */
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #15305d;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        /* Footer */
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
                    <li><a href="viewItems.jsp">View Items</a></li>
                    <li><a href="inventory.jsp">Inventory</a></li>
                    <li><a href="addItem.jsp">Add Products</a></li>
                    <li><a href="updateQuantity.jsp">Update Quantity</a></li>
                    <li><a href="../home.jsp" class="right">Go to Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="right">Logout</a></li>
                </ul>
            </div>
        </div>
    </header>

    <main>
        <h2>All items in the database</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Category ID</th>
                    <th>Stock Quantity</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection details
                    String jdbcUrl = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
                    String jdbcUser = ""; // Provide own username
                    String jdbcPassword = ""; // Provide own password

                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        // Load MySQL JDBC Driver
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        // Establish connection to the database
                        conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

                        // SQL query to fetch items
                        String sql = "SELECT id, name, description, price, category_id, stock_quantity FROM Item";
                        pstmt = conn.prepareStatement(sql);

                        // Execute the query
                        rs = pstmt.executeQuery();

                        // Iterate through the result set and display items
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String name = rs.getString("name");
                            String description = rs.getString("description");
                            BigDecimal price = rs.getBigDecimal("price");
                            int categoryId = rs.getInt("category_id");
                            int stockQuantity = rs.getInt("stock_quantity");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= name %></td>
                    <td><%= description %></td>
                    <td><%= price %></td>
                    <td><%= categoryId %></td>
                    <td><%= stockQuantity %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<p>Error fetching products: " + e.getMessage() + "</p>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
    </main>

    <footer>
        <p>&copy; 2024 TechHaven | Admin Panel</p>
    </footer>
</body>
</html>
