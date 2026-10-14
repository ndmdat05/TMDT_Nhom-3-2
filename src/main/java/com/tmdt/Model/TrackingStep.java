package com.tmdt.Model;

/** Một mốc trong hành trình giao hàng (ví dụ "Đã đặt hàng" + thời điểm). */
public class TrackingStep {
    private String label;
    private String timeText;   // văn bản thời gian hiển thị, ví dụ "08/11 • 09:15"

    public TrackingStep() {}

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    public String getTimeText() { return timeText; }
    public void setTimeText(String timeText) { this.timeText = timeText; }
}
