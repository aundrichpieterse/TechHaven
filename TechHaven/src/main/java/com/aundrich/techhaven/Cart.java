package com.aundrich.techhaven;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<Product> products;

    public Cart() {
        products = new ArrayList<>();
    }

    // Adds a product to the cart. If the product already exists, update the quantity.
    public void addItem(Product newProduct) {
        for (Product product : products) {
            if (product.getId() == newProduct.getId()) {
                // Update quantity if product already exists in cart
                product.setQuantity(product.getQuantity() + newProduct.getQuantity());
                return;
            }
        }
        // If product doesn't exist in cart, add it
        products.add(newProduct);
    }

    // Clears all items from the cart
    public void clear() {
        products.clear();
    }

    // Get all products in the cart
    public List<Product> getProducts() {
        return products;
    }

    // Check if the cart is empty
    public boolean isEmpty() {
        return products.isEmpty();
    }

    // Calculate the total amount of the cart
    public BigDecimal getTotalAmount() {
        BigDecimal total = BigDecimal.ZERO;
        for (Product product : products) {
            total = total.add(product.getPrice().multiply(BigDecimal.valueOf(product.getQuantity())));
        }
        return total;
    }

    // Calculate the subtotal of the cart
    public BigDecimal getSubtotal() {
        return getTotalAmount();
    }
}
