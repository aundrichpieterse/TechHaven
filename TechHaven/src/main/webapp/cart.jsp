<%-- 
    Document   : cart
    Created on : Sep 9, 2024, 11:36:18 AM
    Author     : Aundrich Pieterse
--%>

<%@ page import="com.aundrich.techhaven.Cart" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.aundrich.techhaven.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TechHaven - My Cart</title>
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

        .container {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .cart-details {
            width: 100%;
            max-width: 800px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .cart-details img {
            max-width: 120px;
            max-height: 120px;
            object-fit: cover;
            border-radius: 8px;
        }

        .cart-details .details {
            flex: 1;
        }

        .cart-details .details h3 {
            margin: 0;
            font-size: 18px;
            color: #15305d;
        }

        .cart-details .details p {
            margin: 5px 0;
            color: #666;
        }

        .cart-details .price {
            font-size: 18px;
            font-weight: bold;
            color: #15305d;
        }

        .subtotal {
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            color: #15305d;
            margin-top: 20px;
        }

        .buttons {
            text-align: right;
            margin-top: 20px;
        }

        .buttons button {
            padding: 12px 24px;
            font-size: 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 15px;
            transition: background-color 0.3s ease;
        }

        .checkout-button {
            background-color: #15305d;
            color: #ffffff;
        }

        .checkout-button:hover {
            background-color: #6610f2;
        }

        .keep-shopping-button {
            background-color: #6610f2;
            color: #ffffff;
        }

        .keep-shopping-button:hover {
            background-color: #5a0cda;
        }

        footer {
            background-color: #15305d;
            color: white;
            text-align: center;
            padding: 12px 18px;
            height: 40px;
            box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
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
        <h1>My Cart</h1>
        <% 
            // Get the cart object from the session
            Cart cart = (Cart) session.getAttribute("cart");

            // Check if the cart is empty or doesn't exist
            if (cart == null || cart.isEmpty()) {
        %>
            <!-- Display message if cart is empty -->
            <p>Your cart is empty.</p>
        <% 
            } else {
                // Get the subtotal of items in the cart
                BigDecimal subtotal = cart.getSubtotal();

                // Loop through all products in the cart and display them
                for (Product product : cart.getProducts()) {
        %>
            <div class="cart-details">
                <!-- Display product image -->
                <img src="<%= product.getImage() %>" alt="<%= product.getName() %>">
                <div class="details">
                    <!-- Display product name -->
                    <h3><%= product.getName() %></h3>
                    <!-- Show the quantity of the product -->
                    <p>Quantity: <%= product.getQuantity() %></p>
                    <!-- Show the price of the product -->
                    <p class="price">R<%= product.getPrice() %></p>
                </div>
            </div>
        <% 
                }
        %>
            <!-- Display subtotal of all items in the cart -->
            <div class="subtotal"><strong>Subtotal: R<%= subtotal %></strong></div>

            <!-- Checkout and Keep Shopping buttons -->
            <div class="buttons">
                <form action="checkout" method="post" style="display: inline-block;">
                    <button type="submit" class="checkout-button">Checkout</button>
                </form>
                <form action="home.jsp" method="get" style="display: inline-block;">
                    <button type="submit" class="keep-shopping-button">Keep Shopping</button>
                </form>
            </div>
        <% 
            } 

            // Check if there's an error message passed in the URL for checkout failure
            String error = request.getParameter("error");
            if (error != null && error.equals("CheckoutFailed")) {
        %>
            <!-- Display error message if checkout failed -->
            <p style="color: red;">There was an error processing your checkout. Please try again.</p>
        <% 
            }
        %>
    </div>

    <footer>
        <p>&copy; 2024 TechHaven</p>
    </footer>
</body>
</html>
