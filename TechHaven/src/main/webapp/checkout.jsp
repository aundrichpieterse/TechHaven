<%-- 
    Document   : checkout
    Created on : Sep 9, 2024, 11:40:24 AM
    Author     : Aundrich Pieterse
--%>

<%@ page import="com.aundrich.techhaven.Cart" %>
<%@ page import="com.aundrich.techhaven.Product" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Get the cart object from the session
    Cart cart = (Cart) session.getAttribute("cart");

    // Check if the cart is not null and has items
    if (cart != null && !cart.isEmpty()) {
        // If the cart has items, redirect to the checkout process
        response.sendRedirect("checkout");
    } else {
        // If the cart is empty, redirect back to the cart page
        response.sendRedirect("cart.jsp");
    }
%>
