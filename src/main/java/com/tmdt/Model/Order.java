package com.tmdt.Model;

public class Order {
    private int id;
    private String productTitle;
    private String buyerName;
    private String sellerName;
    private double totalAmount;
    private String status; // PENDING, CONFIRMED, SHIPPING, COMPLETED, CANCELLED
    private String trackingNumber; // Mã vận đơn

    public Order() {}

    public Order(int id, String productTitle, String buyerName, String sellerName, double totalAmount, String status, String trackingNumber) {
        this.id = id;
        this.productTitle = productTitle;
        this.buyerName = buyerName;
        this.sellerName = sellerName;
        this.totalAmount = totalAmount;
        this.status = status;
        this.trackingNumber = trackingNumber;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
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
}