package com.tmdt.Model;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items = new LinkedHashMap<>();

    public Cart() {}

    public List<CartItem> getItems() {
        return new ArrayList<>(items.values());
    }

    public void addProduct(Product product, int quantity) {
        if (product == null) return;
        int id = product.getId();
        if (items.containsKey(id)) {
            CartItem current = items.get(id);
            current.setQuantity(current.getQuantity() + quantity);
        } else {
            items.put(id, new CartItem(product, quantity));
        }
    }

    public void removeProduct(int productId) {
        items.remove(productId);
    }

    public void updateQuantity(int productId, int quantity) {
        if (items.containsKey(productId)) {
            if (quantity <= 0) {
                items.remove(productId);
            } else {
                items.get(productId).setQuantity(quantity);
            }
        }
    }
    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : items.values()) {
            total += item.getQuantity();
        }
        return total;
    }
    public double getTotalMoney() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getSubTotal();
        }
        return total;
    }
}