<%-- 
    Document   : addItem
    Created on : Sep 11, 2024, 4:10:01 PM
    Author     : Aundrich Pieterse
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    // Check if admin session is valid
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp"); // Redirect to login page if session is invalid
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product - TechHaven</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
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
        
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        label {
            font-weight: bold;
            display: block;
            margin: 10px 0 5px;
            color: #333;
        }

        input, textarea, select, button {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            background-color: #15305d;
            color: white;
            cursor: pointer;
            border: none;
            padding: 8px 12px;
            font-size: 14px;
            display: block;
            width: 50%;
            margin: 20px auto;
        }

        button:hover {
            background-color: #6610f2;
        }

        .message {
            text-align: center;
            margin-bottom: 20px;
        }

        .message span {
            display: block;
        }

        .message .success {
            color: green;
        }

        .message .error {
            color: red;
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

    <div class="container">
        <h2>Add New Product</h2>

        <!-- Display success or error message -->
        <div class="message">
            <c:if test="${not empty message}">
                <span class="success">${message}</span>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <span class="error">${errorMessage}</span>
            </c:if>
        </div>

        <!-- Product form -->
        <form action="${pageContext.request.contextPath}/admin/addItem" method="post">
            <label for="name">Product Name:</label>
            <input type="text" id="name" name="name" placeholder="Enter product name" required>

            <label for="description">Product Description:</label>
            <textarea id="description" name="description" placeholder="Enter product description" required></textarea>

            <label for="price">Price:</label>
            <input type="text" id="price" name="price" placeholder="Enter product price (e.g., 19.99)" required>

            <label for="stockQuantity">Stock Quantity:</label>
            <input type="text" id="stockQuantity" name="stockQuantity" placeholder="Enter stock quantity" required>

            <label for="image">Image URL:</label>
            <input type="text" id="image" name="image" placeholder="Enter image URL" required>

            <label for="categoryId">Category:</label>
            <select id="categoryId" name="categoryId" required>
                <option value="1">Laptops</option>
                <option value="2">Desktops</option>
                <option value="3">Tablets</option>
                <option value="4">Accessories</option>
            </select>

            <button type="submit">Add Product</button>
        </form>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2024 TechHaven | Admin Panel</p>
    </footer>
</body>
</html>

