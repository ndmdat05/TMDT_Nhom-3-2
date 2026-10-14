package com.tmdt.Model;

import java.math.BigDecimal;

/**
 * Số liệu 4 thẻ KPI + cảnh báo của Dashboard.
 * Mọi trường là kiểu wrapper: null = "chưa có dữ liệu" (JSP sẽ hiển thị trạng thái trống).
 * KHÔNG gán giá trị mặc định/giả ở đây.
 */
public class DashboardStats {
    private BigDecimal totalEscrowValue;     // Tổng giá trị ký quỹ trong kỳ
    private Double escrowChangePercent;      // % thay đổi so với kỳ trước
    private Long successfulOrders;           // Số đơn thành công
    private Double successRatePercent;       // Tỷ lệ chốt
    private Long pendingAppraisals;          // Hồ sơ chờ thẩm định
    private Long activeCollectors;           // Người dùng hoạt động
    private Long newCollectorsToday;         // Người dùng mới hôm nay
    private Long disputeCount;               // Số giao dịch đang tranh chấp

    public DashboardStats() {}

    public BigDecimal getTotalEscrowValue() { return totalEscrowValue; }
    public void setTotalEscrowValue(BigDecimal totalEscrowValue) { this.totalEscrowValue = totalEscrowValue; }
    public Double getEscrowChangePercent() { return escrowChangePercent; }
    public void setEscrowChangePercent(Double escrowChangePercent) { this.escrowChangePercent = escrowChangePercent; }
    public Long getSuccessfulOrders() { return successfulOrders; }
    public void setSuccessfulOrders(Long successfulOrders) { this.successfulOrders = successfulOrders; }
    public Double getSuccessRatePercent() { return successRatePercent; }
    public void setSuccessRatePercent(Double successRatePercent) { this.successRatePercent = successRatePercent; }
    public Long getPendingAppraisals() { return pendingAppraisals; }
    public void setPendingAppraisals(Long pendingAppraisals) { this.pendingAppraisals = pendingAppraisals; }
    public Long getActiveCollectors() { return activeCollectors; }
    public void setActiveCollectors(Long activeCollectors) { this.activeCollectors = activeCollectors; }
    public Long getNewCollectorsToday() { return newCollectorsToday; }
    public void setNewCollectorsToday(Long newCollectorsToday) { this.newCollectorsToday = newCollectorsToday; }
    public Long getDisputeCount() { return disputeCount; }
    public void setDisputeCount(Long disputeCount) { this.disputeCount = disputeCount; }
}
