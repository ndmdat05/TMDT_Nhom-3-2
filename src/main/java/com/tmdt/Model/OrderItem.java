package com.tmdt.Model;

public class OrderItem {
    private int id;
    private int orderId;
    private int productId;
    private String productTitle;
    private int quantity;
    private double unitPrice;
    private String imageUrl;
    private String receiverName;
    private String receiverPhone;

    public OrderItem(int id, int orderId, int productId, String productTitle, int quantity, double unitPrice, String imageUrl) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.productTitle = productTitle;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public int getOrderId() {
        return orderId;
    }

    public int getProductId() {
        return productId;
    }

    public String getProductTitle() {
        return productTitle;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }
    public double getTotalPrice() {
        return this.quantity * this.unitPrice;
    }
}
