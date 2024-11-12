<%-- 
    Document   : updateQuantity
    Created on : Sep 12, 2024, 11:54:57 AM
    Author     : Aundrich Pieterse
--%>

<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin session is valid
    if (session == null || session.getAttribute("username") == null) {
        // Redirect to login page if session is invalid
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Product Quantity - TechHaven</title>
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

        /* Navbar styling */
        .navbar {
            background-color: #d5ddea;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            display: flex;
            align-items: center;
            padding: 0 20px;
        }

        /* Logo styling */
        .navbar .logo {
            font-size: 18px;
            color: #15305d;
            font-weight: bold;
        }

        /* Navigation items container */
        .nav-items {
            flex: 1;
            display: flex;
            justify-content: center;
        }

        /* Navigation list styling */
        .nav-items ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
        }

        /* Navigation item styling */
        .nav-items ul li {
            margin: 0 10px;
        }

        /* Styling for navigation links */
        .nav-items ul li a {
            display: block;
            color: #15305d;
            text-align: center;
            padding: 12px 18px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        /* Hover effect for navigation links */
        .nav-items ul li a:hover {
            background-color: #6610f2;
            color: #fff;
            transform: scale(1.05);
        }

        /* Main content styling */
        main {
            flex: 1;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        /* Form container styling */
        .form-container {
            width: 100%;
            max-width: 800px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-top: 20px;
        }

        /* Table styling */
        .form-container table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        /* Table header and cell styling */
        .form-container th, .form-container td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        /* Header row background color */
        .form-container th {
            background-color: #f2f2f2;
        }

        /* Input fields styling */
        .form-container input[type="number"] {
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 100px;
        }

        /* Update button styling */
        .form-container .update-button {
            background-color: #15305d;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            display: block;
            width: 150px;
            margin: 0 auto;
        }

        /* Hover effect for update button */
        .form-container .update-button:hover {
            background-color: #6610f2;
        }

        /* Success and error messages */
        .message {
            text-align: center;
            margin-top: 20px;
        }

        .message.success {
            color: green;
        }

        .message.error {
            color: red;
        }

        /* Footer styling */
        footer {
            background-color: #15305d;
            color: white;
            text-align: center;
            padding: 10px;
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
                    <li><a href="addItem.jsp">Add Product</a></li>
                    <li><a href="updateQuantity.jsp">Update Quantity</a></li>
                    <li><a href="../home.jsp" class="right">Go to Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="right">Logout</a></li>
                </ul>
            </div>
        </div>
    </header>

    <main>
        <h2>Update Product Quantity</h2>

        <div class="form-container">
            <form action="updateQuantity.jsp" method="post">
                <table>
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Current Quantity</th>
                            <th>New Quantity</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String jdbcUrl = "jdbc:mysql://localhost:3306/techhaven?useSSL=false";
                            String jdbcUser = ""; // Provide own username
                            String jdbcPassword = ""; // Provide own password

                            Connection conn = null;
                            PreparedStatement pstmt = null;
                            ResultSet rs = null;
                            String successMessage = "";
                            String errorMessage = "";

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

                                String action = request.getParameter("action");
                                if ("Update".equals(action)) {
                                    int id = Integer.parseInt(request.getParameter("id"));
                                    int newQuantity = Integer.parseInt(request.getParameter("quantity"));

                                    String updateSql = "UPDATE Item SET stock_quantity = ? WHERE id = ?";
                                    pstmt = conn.prepareStatement(updateSql);
                                    pstmt.setInt(1, newQuantity);
                                    pstmt.setInt(2, id);

                                    int rowsUpdated = pstmt.executeUpdate();
                                    if (rowsUpdated > 0) {
                                        successMessage = "Product quantity updated successfully.";
                                    } else {
                                        errorMessage = "Failed to update product quantity.";
                                    }
                                }

                                String sql = "SELECT id, name, stock_quantity FROM Item";
                                pstmt = conn.prepareStatement(sql);
                                rs = pstmt.executeQuery();
                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String name = rs.getString("name");
                                    int quantity = rs.getInt("stock_quantity");
                        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= name %></td>
                            <td><%= quantity %></td>
                            <td>
                                <input type="number" name="quantity" min="0" value="<%= quantity %>">
                                <input type="hidden" name="id" value="<%= id %>">
                            </td>
                        </tr>
                        <% 
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                errorMessage = "An error occurred: " + e.getMessage();
                            } finally {
                                if (rs != null) rs.close();
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            }
                        %>
                    </tbody>
                </table>
                <input type="submit" name="action" value="Update" class="update-button">
            </form>

            <% if (!successMessage.isEmpty()) { %>
            <div class="message success"><%= successMessage %></div>
            <% } %>
            <% if (!errorMessage.isEmpty()) { %>
            <div class="message error"><%= errorMessage %></div>
            <% } %>
        </div>
    </main>

    <footer>
        <p>&copy; 2024 TechHaven | Admin Panel</p>
    </footer>
</body>
</html>
