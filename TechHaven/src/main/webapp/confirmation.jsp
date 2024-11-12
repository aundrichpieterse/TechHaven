<%-- 
    Document   : confirmation
    Created on : Sep 9, 2024, 4:06:58 PM
    Author     : Aundrich Pieterse
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TechHaven - Order Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            align-items: center;
            justify-content: center;
        }

        .confirmation-box {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 100%;
            max-width: 600px;
            text-align: center;
        }

        h1, h2 {
            color: #15305d;
        }

        p {
            color: #666;
            font-size: 18px;
            margin: 10px 0;
        }

        a {
            color: #15305d;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        a:hover {
            color: #6610f2;
        }
    </style>
</head>
<body>
    <!-- Container for the confirmation message -->
    <div class="confirmation-box">
        <!-- Display a thank-you message after a successful purchase -->
        <h1>Thank you for your purchase!</h1>
        
        <!-- Display confirmation message -->
        <p>Your order has been placed successfully.</p>
        
        <!-- Link to return to the homepage -->
        <p><a href="home.jsp">Return to Home</a></p>
    </div>
</body>

</html>
