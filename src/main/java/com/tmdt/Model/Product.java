package com.tmdt.Model;

public class Product {
    private int id;
    private String title;
    private double price;
    private int stockQuantity;
    private String imageUrl;
    private String description;
    private String seriesName;
    private String author;
    private Integer volumeNumber;
    private String edition;
    private String itemCondition;
    private String language;
    private int sellerId;
    private String sellerName;
    private String sellerAvatar;
    private String status;
    private String rejectionReason;

    public Product() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSeriesName() { return seriesName; }
    public void setSeriesName(String seriesName) { this.seriesName = seriesName; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public Integer getVolumeNumber() { return volumeNumber; }
    public void setVolumeNumber(Integer volumeNumber) { this.volumeNumber = volumeNumber; }

    public String getEdition() { return edition; }
    public void setEdition(String edition) { this.edition = edition; }

    public String getItemCondition() { return itemCondition; }
    public void setItemCondition(String itemCondition) { this.itemCondition = itemCondition; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }

    public String getSellerAvatar() { return sellerAvatar; }
    public void setSellerAvatar(String sellerAvatar) { this.sellerAvatar = sellerAvatar; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    // --- CÁC HÀM GETTER/SETTER ALIAS BỔ SUNG ĐỂ HẾT LỖI 500 TRÊN JSP ---
    public int getStock_quantity() { return stockQuantity; }
    public void setStock_quantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getImage_url() { return imageUrl; }
    public void setImage_url(String imageUrl) { this.imageUrl = imageUrl; }

    public String getSeries_name() { return seriesName; }
    public void setSeries_name(String seriesName) { this.seriesName = seriesName; }

    public Integer getVolume_number() { return volumeNumber; }
    public void setVolume_number(Integer volumeNumber) { this.volumeNumber = volumeNumber; }

    public String getItem_condition() { return itemCondition; }
    public void setItem_condition(String itemCondition) { this.itemCondition = itemCondition; }

    public int getSeller_id() { return sellerId; }
    public void setSeller_id(int sellerId) { this.sellerId = sellerId; }

    public String getName() { return title; }
    public void setName(String name) { this.title = name; }

    public String getImage() { return imageUrl; }
    public void setImage(String image) { this.imageUrl = image; }
}