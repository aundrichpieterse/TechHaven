<%-- 
    Document   : login
    Created on : Sep 12, 2024, 7:35:13 AM
    Author     : Aundrich Pieterse
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            width: 300px;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .login-container input[type=text], .login-container input[type=password] {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .login-container button {
            width: 100%;
            padding: 14px;
            background-color: #15305d;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .login-container button:hover {
            background-color: #6610f2;
        }
        .login-container .container {
            padding: 16px;
        }
        .login-container .error {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Admin Login</h2>
        
        <!-- Form that submits username and password to the LoginServlet -->
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="container">
                <!-- Label and input field for username -->
                <label for="username"><b>Username</b></label>
                <input type="text" placeholder="Enter Username" name="username" required>

                <!-- Label and input field for password -->
                <label for="password"><b>Password</b></label>
                <input type="password" placeholder="Enter Password" name="password" required>

                <!-- Submit button to login -->
                <button type="submit">Login</button>

                <!-- Error handling section for displaying login-related errors -->
                <div class="error">
                    <!-- Check if the 'error' parameter is passed from the server -->
                    <% if (request.getParameter("error") != null) { %>
                        <!-- If error code is 1, display invalid credentials message -->
                        <% if ("1".equals(request.getParameter("error"))) { %>
                            Invalid username or password.
                        <!-- If error code is 2, display database connection error message -->
                        <% } else if ("2".equals(request.getParameter("error"))) { %>
                            Database connection error.
                        <!-- If error code is 3, display session login required message -->
                        <% } else if ("3".equals(request.getParameter("error"))) { %>
                            Please log in to access this page.
                        <% } %>
                    <% } %>
                </div>
            </div>
        </form>
    </div>
</body>
</html>
