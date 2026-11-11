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
    private String paymentMethod;
    private String paymentStatus;
    private String cancelReason; // Đã thêm

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

    public Order(int id, String orderCode, String productTitle, String buyerName, String sellerName, double totalAmount, String status, String trackingNumber, String shippingAddress, Date estimatedDelivery, Timestamp createdAt, String receiverName, String receiverPhone, String paymentMethod, String paymentStatus) {
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
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public void setEstimatedDelivery(Date estimatedDelivery) {
        this.estimatedDelivery = estimatedDelivery;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public int getId() {
        return id;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public String getProductTitle() {
        return productTitle;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public String getSellerName() {
        return sellerName;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public Date getEstimatedDelivery() {
        return estimatedDelivery;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public String getCancelReason() {
        return cancelReason;
    }
}