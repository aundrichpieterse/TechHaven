package com.aundrich.techhaven;

import java.math.BigDecimal;

/**
 * The Product class represents a product in my TechHaven system.
 * It contains information about the product such as its ID, name, 
 * description, price, stock quantity, and image. Additionally, it 
 * handles operations related to products in a shopping cart.
 */
public class Product {
    // The unique identifier for the product
    private int id;

    // The name of the product
    private String name;

    // The price of the product
    private BigDecimal price;

    // The number of items available in stock
    private int stockQuantity;

    // The URL or path to the product's image
    private String image;

    // A brief description of the product
    private String description;

    // The category name to which the product belongs
    private String categoryName;

    // The quantity of the product selected for purchase
    private int quantity;

    /**
     * Constructs a Product object with full product details, 
     * including stock quantity and category.
     * 
     * @param id            The unique ID of the product.
     * @param name          The name of the product.
     * @param description   A brief description of the product.
     * @param price         The price of the product.
     * @param stockQuantity The number of items available in stock.
     * @param image         The image URL or path for the product.
     * @param categoryName  The name of the category the product belongs to.
     */
    public Product(int id, String name, String description, BigDecimal price, int stockQuantity, String image, String categoryName) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.image = image;
        this.categoryName = categoryName;
    }

    /**
     * Constructs a Product object for operations in a shopping cart,
     * that focus on basic details such as name, price, and quantity selected.
     * 
     * @param id        The unique ID of the product.
     * @param name      The name of the product.
     * @param price     The price of the product.
     * @param quantity  The quantity selected for purchase.
     * @param image     The image URL or path for the product.
     */
    public Product(int id, String name, BigDecimal price, int quantity, String image) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    // Getter and setter for id
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Getter and setter for name
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // Getter and setter for price
    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    // Getter and setter for stockQuantity
    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    // Getter and setter for image
    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    // Getter and setter for description
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Getter and setter for categoryName
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    // Getter and setter for quantity
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
