package com.tmdt.Model;

import java.math.BigDecimal;

/** Một phần của biểu đồ tròn: giá trị theo danh mục (percent do Service tính). */
public class DashboardCategoryShare {
    private String name;
    private BigDecimal value;
    private double percent;

    public DashboardCategoryShare() {}

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getValue() { return value; }
    public void setValue(BigDecimal value) { this.value = value; }
    public double getPercent() { return percent; }
    public void setPercent(double percent) { this.percent = percent; }
}
