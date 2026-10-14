package com.tmdt.Model;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Một cột của biểu đồ cột: giá trị ký quỹ theo ngày. */
public class DashboardChartPoint {
    private LocalDate day;
    private BigDecimal value;

    public DashboardChartPoint() {}

    public LocalDate getDay() { return day; }
    public void setDay(LocalDate day) { this.day = day; }
    public BigDecimal getValue() { return value; }
    public void setValue(BigDecimal value) { this.value = value; }
}
