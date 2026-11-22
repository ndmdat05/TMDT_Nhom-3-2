package com.tmdt.Model;
import java.sql.Timestamp;
public class WalletTransaction {
    private int id;
    private int userId;
    private Integer orderId;
    private double amount;
    private String type;
    private String description;
    private Timestamp createdAt;

    public WalletTransaction(int id, Timestamp createdAt, String description, double amount, Integer orderId, int userId, String type) {
        this.id = id;
        this.createdAt = createdAt;
        this.description = description;
        this.amount = amount;
        this.orderId = orderId;
        this.userId = userId;
        this.type = type;
    }

    public WalletTransaction() {
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public double getAmount() {
        return amount;
    }

    public String getType() {
        return type;
    }

    public String getDescription() {
        return description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}
