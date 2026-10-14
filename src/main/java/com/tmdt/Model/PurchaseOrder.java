package com.tmdt.Model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Một dòng trong "Lịch sử đơn hàng" của người mua.
 * (Không dùng lại com.tmdt.Model.Order vì Order hiện là model quản lý của Admin/Seller.)
 * statusCode: ship | done | cancel | pay (DAO ánh xạ từ trạng thái trong DB).
 */
public class PurchaseOrder {
    private String orderCode;
    private LocalDate orderDate;
    private BigDecimal totalAmount;
    private String statusCode;
    private String statusLabel;

    public PurchaseOrder() {}

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public LocalDate getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDate orderDate) { this.orderDate = orderDate; }
    /** Ngày đặt dạng dd/MM/yyyy. Rỗng nếu chưa có. */
    public String getOrderDateText() {
        return orderDate == null ? "" : orderDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getStatusCode() { return statusCode; }
    public void setStatusCode(String statusCode) { this.statusCode = statusCode; }
    public String getStatusLabel() { return statusLabel; }
    public void setStatusLabel(String statusLabel) { this.statusLabel = statusLabel; }

    /** Class CSS của badge (b-o/b-g/b-r/b-b trong history.css). */
    public String getBadgeClass() {
        if (statusCode == null) return "";
        switch (statusCode) {
            case "ship":   return "b-o";
            case "done":   return "b-g";
            case "cancel": return "b-r";
            case "pay":    return "b-b";
            default:       return "";
        }
    }
}
