package com.tmdt.Model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/** Hành trình giao hàng của đơn đang vận chuyển gần nhất (khối "ĐANG GIAO VẬN"). */
public class OrderTracking {
    private String orderCode;
    private LocalDate estimatedDelivery;
    private String shippingAddress;
    private int currentStep;                       // chỉ số (0-based) của mốc hiện tại trong steps
    private List<TrackingStep> steps = new ArrayList<>();

    public OrderTracking() {}

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public LocalDate getEstimatedDelivery() { return estimatedDelivery; }
    public void setEstimatedDelivery(LocalDate estimatedDelivery) { this.estimatedDelivery = estimatedDelivery; }
    /** Ngày giao dự kiến để hiển thị, ví dụ "12 tháng 11, 2026". Rỗng nếu chưa có. */
    public String getEstimatedDeliveryText() {
        return estimatedDelivery == null ? "" : estimatedDelivery.format(DateTimeFormatter.ofPattern("d 'tháng' M, yyyy"));
    }
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    public int getCurrentStep() { return currentStep; }
    public void setCurrentStep(int currentStep) { this.currentStep = currentStep; }
    public List<TrackingStep> getSteps() { return steps; }
    public void setSteps(List<TrackingStep> steps) { this.steps = steps; }
}
