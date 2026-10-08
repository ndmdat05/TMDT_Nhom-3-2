package com.tmdt.Model;

public class Product {
    private int id;
    private String title;
    private double price;
    private int sellerId;
    private String sellerName;
    private String status; // APPROVED, PENDING_APPROVAL, REJECTED, HIDDEN
    private String imageUrl;
    private String rejectionReason; // Lý do Admin từ chối

    public Product() {}

    public Product(int id, String title, double price, int sellerId, String sellerName, String status, String imageUrl, String rejectionReason) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.sellerId = sellerId;
        this.sellerName = sellerName;
        this.status = status;
        this.imageUrl = imageUrl;
        this.rejectionReason = rejectionReason;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
}