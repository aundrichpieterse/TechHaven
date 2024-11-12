package com.aundrich.techhaven;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * This class represents an order in my TechHaven system.
 * It holds information about the order ID, order date, total amount,
 * and a list of products associated with the order.
 */
public class Order {
    // The unique identifier for the order
    private int orderId;

    // The date when the order was placed
    private Date orderDate;

    // The total cost of the order
    private BigDecimal totalAmount;

    // A list of products included in the order
    private List<Product> products;

    /**
     * Constructs an Order object with specified order details.
     * 
     * @param orderId      The unique ID of the order.
     * @param orderDate    The date the order was made.
     * @param totalAmount  The total cost of the order.
     * @param products     The list of products included in the order.
     */
    public Order(int orderId, Date orderDate, BigDecimal totalAmount, List<Product> products) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.products = products;
    }

    /**
     * Default constructor that creates an empty Order object.
     */
    public Order() {
    }

    /**
     * Gets the ID of the order.
     * 
     * @return The order ID.
     */
    public int getOrderId() {
        return orderId;
    }

    /**
     * Sets the ID of the order.
     * 
     * @param orderId The order ID to set.
     */
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    /**
     * Gets the date when the order was placed.
     * 
     * @return The order date.
     */
    public Date getOrderDate() {
        return orderDate;
    }

    /**
     * Sets the date when the order was placed.
     * 
     * @param orderDate The order date to set.
     */
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    /**
     * Gets the total cost of the order.
     * 
     * @return The total amount for the order.
     */
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    /**
     * Sets the total cost of the order.
     * 
     * @param totalAmount The total amount to set.
     */
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    /**
     * Gets the list of products in the order.
     * 
     * @return The list of products.
     */
    public List<Product> getProducts() {
        return products;
    }

    /**
     * Sets the list of products for the order.
     * 
     * @param products The products to set for the order.
     */
    public void setProducts(List<Product> products) {
        this.products = products;
    }
}
