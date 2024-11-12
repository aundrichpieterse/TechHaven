<%-- 
    Document   : inventory
    Created on : Sep 11, 2024, 12:11:59 PM
    Author     : Aundrich Pieterse
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*, java.math.BigDecimal" %>
<%@ page session="true" %> <!-- Ensures that the session is available -->
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
    <title>Inventory Report - TechHaven</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
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

        main {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .inventory-box {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 100%;
            max-width: 800px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #15305d;
            color: #ffffff;
        }

        footer {
            background-color: #15305d;
            color: #ffffff;
            text-align: center;
            padding: 10px;
            box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
        }

        .subtotal-row {
            font-weight: bold;
            background-color: #f1f1f1;
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
    <div class="inventory-box">
        <h2>Inventory Report</h2>

        <% 
            // Database connection and credential details
            String jdbcDriver = "com.mysql.cj.jdbc.Driver"; 
            String dbUrl = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
            String dbUser = ""; // Provide own username
            String dbPassword = "";  // Provide own password
            
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            // Subtotal for total sales calculation
            BigDecimal subtotal = BigDecimal.ZERO; 
            
            try {
                // Load the MySQL driver and establish a connection
                Class.forName(jdbcDriver);
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                // SQL query to calculate total quantity sold and total sales amount per item
                String sql = "SELECT i.name, SUM(od.quantity) AS total_quantity, SUM(i.price * od.quantity) AS total_price " +
                             "FROM OrderDetails od " +
                             "JOIN Item i ON od.item_id = i.id " +
                             "GROUP BY i.name";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                
                // Check if there are results to display
                if (rs != null && rs.isBeforeFirst()) {
        %>

        <!-- Inventory report table -->
        <table>
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Total Quantity Sold</th>
                    <th>Total Sales Amount</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Iterate through the result set and populate the table
                    while (rs.next()) {
                        String itemName = rs.getString("name");
                        int totalQuantity = rs.getInt("total_quantity");
                        BigDecimal totalPrice = rs.getBigDecimal("total_price");

                        // Accumulate the total sales amount
                        subtotal = subtotal.add(totalPrice); 
                %>
                <tr>
                    <td><%= itemName %></td>
                    <td><%= totalQuantity %></td>
                    <td><%= totalPrice %></td>
                </tr>
                <% 
                    }
                %>
                
                <!-- Row to display the subtotal of all sales -->
                <tr class="subtotal-row">
                    <td colspan="2">Subtotal</td>
                    <td><%= subtotal %></td>
                </tr>
            </tbody>
        </table>

        <% 
                } else {
        %>
        <!-- Message displayed if no data is found -->
        <p>No data available</p>
        <% 
                }
            } catch (Exception e) {
                // Catch and display any errors that occure
                e.printStackTrace();
        %>
        <p>Error retrieving data: <%= e.getMessage() %></p>

        <% 
            } finally {
                // Ensure resources are closed after use
                try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</main>
<footer>
    <p>&copy; 2024 TechHaven | Admin Panel</p>
</footer>
</body>
</html>
