package com.tmdt.Model;

import java.math.BigDecimal;

/**
 * Một dòng của bảng "Giao dịch Đấu giá & Ký quỹ Gần nhất".
 * statusCode: released | holding | reviewing | dispute (DAO chịu trách nhiệm ánh xạ từ DB).
 */
public class DashboardTransaction {
    private String escrowCode;
    private String title;
    private String subtitle;
    private String buyer;
    private String seller;
    private BigDecimal amount;
    private String statusCode;
    private String statusLabel;

    public DashboardTransaction() {}

    public String getEscrowCode() { return escrowCode; }
    public void setEscrowCode(String escrowCode) { this.escrowCode = escrowCode; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }
    public String getBuyer() { return buyer; }
    public void setBuyer(String buyer) { this.buyer = buyer; }
    public String getSeller() { return seller; }
    public void setSeller(String seller) { this.seller = seller; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public String getStatusCode() { return statusCode; }
    public void setStatusCode(String statusCode) { this.statusCode = statusCode; }
    public String getStatusLabel() { return statusLabel; }
    public void setStatusLabel(String statusLabel) { this.statusLabel = statusLabel; }

    /** Class CSS của badge (b-g/b-b/b-o/b-r trong dashboard.css). */
    public String getBadgeClass() {
        if (statusCode == null) return "";
        switch (statusCode) {
            case "released":  return "b-g";
            case "holding":   return "b-b";
            case "reviewing": return "b-o";
            case "dispute":   return "b-r";
            default:          return "";
        }
    }
}
