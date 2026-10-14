package com.tmdt.Model;

import java.util.ArrayList;
import java.util.List;

/** Gói dữ liệu trang Lịch sử mua hàng do PurchaseHistoryService trả về. */
public class PurchaseHistoryData {
    private OrderTracking tracking;                 // null = không có đơn đang vận chuyển
    private List<PurchaseOrder> orders = new ArrayList<>();
    private String keyword = "";
    private String statusFilter = "";

    public OrderTracking getTracking() { return tracking; }
    public void setTracking(OrderTracking tracking) { this.tracking = tracking; }
    public List<PurchaseOrder> getOrders() { return orders; }
    public void setOrders(List<PurchaseOrder> orders) { this.orders = orders; }
    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
    public String getStatusFilter() { return statusFilter; }
    public void setStatusFilter(String statusFilter) { this.statusFilter = statusFilter; }
}
