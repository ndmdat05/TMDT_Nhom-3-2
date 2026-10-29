package com.tmdt.Model;

import java.sql.Date;
import java.sql.Timestamp;

public class Order {
    private int id;
    private String orderCode;
    private String productTitle;
    private String buyerName;
    private String sellerName;
    private double totalAmount;
    private String status; // PENDING, CONFIRMED, SHIPPING, COMPLETED, CANCELLED
    private String trackingNumber;
    private String shippingAddress;
    private Date estimatedDelivery;
    private Timestamp createdAt;
    private String receiverName;
    private String receiverPhone;

    public Order() {}

    // Constructor cũ (giữ nguyên để tránh lỗi code cũ)
    public Order(int id, String productTitle, String buyerName, String sellerName, double totalAmount, String status, String trackingNumber) {
        this.id = id;
        this.productTitle = productTitle;
        this.buyerName = buyerName;
        this.sellerName = sellerName;
        this.totalAmount = totalAmount;
        this.status = status;
        this.trackingNumber = trackingNumber;
    }

    // Constructor đầy đủ cho giao diện mới
    public Order(int id, String orderCode, String productTitle, String buyerName, String sellerName,
                 double totalAmount, String status, String trackingNumber,
                 String shippingAddress, Date estimatedDelivery, Timestamp createdAt) {
        this.id = id;
        this.orderCode = orderCode;
        this.productTitle = productTitle;
        this.buyerName = buyerName;
        this.sellerName = sellerName;
        this.totalAmount = totalAmount;
        this.status = status;
        this.trackingNumber = trackingNumber;
        this.shippingAddress = shippingAddress;
        this.estimatedDelivery = estimatedDelivery;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public String getProductTitle() { return productTitle; }
    public void setProductTitle(String productTitle) { this.productTitle = productTitle; }
    public String getBuyerName() { return buyerName; }
    public void setBuyerName(String buyerName) { this.buyerName = buyerName; }
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { this.trackingNumber = trackingNumber; }
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    public Date getEstimatedDelivery() { return estimatedDelivery; }
    public void setEstimatedDelivery(Date estimatedDelivery) { this.estimatedDelivery = estimatedDelivery; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getReceiverName() {
        return receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }
}