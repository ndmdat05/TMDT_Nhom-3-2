package com.tmdt.Model;
import java.sql.Timestamp;

public class Auction {
    private int id;
    private int productId;
    private int sellerId;
    private double startingPrice;
    private double bidStep;
    private double currentHighestPrice;
    private Timestamp startTime;
    private Timestamp endTime;
    private Integer winnerId;
    private String status; // UPCOMING, ONGOING, ENDED

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public double getStartingPrice() { return startingPrice; }
    public void setStartingPrice(double startingPrice) { this.startingPrice = startingPrice; }
    public double getBidStep() { return bidStep; }
    public void setBidStep(double bidStep) { this.bidStep = bidStep; }
    public double getCurrentHighestPrice() { return currentHighestPrice; }
    public void setCurrentHighestPrice(double currentHighestPrice) { this.currentHighestPrice = currentHighestPrice; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public Integer getWinnerId() { return winnerId; }
    public void setWinnerId(Integer winnerId) { this.winnerId = winnerId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}