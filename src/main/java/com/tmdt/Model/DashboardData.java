package com.tmdt.Model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Gói dữ liệu Dashboard do DashboardService trả về cho Servlet/JSP. */
public class DashboardData {
    private LocalDate from;
    private LocalDate to;
    private int rangeDays;                 // 7 / 30 / 90 nếu khớp preset, ngược lại 0 (tùy chọn)
    private String statusFilter = "";
    private String errorMessage;           // lỗi tham số (ví dụ khoảng ngày không hợp lệ)

    private DashboardStats stats = new DashboardStats();
    private List<DashboardChartPoint> escrowByDay = new ArrayList<>();
    private List<DashboardCategoryShare> categoryShares = new ArrayList<>();

    private List<DashboardTransaction> transactions = new ArrayList<>();
    private int page = 1;
    private int pageSize = 4;
    private long totalTransactions;
    private int totalPages = 1;
    private List<Integer> pageNumbers = new ArrayList<>();

    public LocalDate getFrom() { return from; }
    public void setFrom(LocalDate from) { this.from = from; }
    public LocalDate getTo() { return to; }
    public void setTo(LocalDate to) { this.to = to; }
    public int getRangeDays() { return rangeDays; }
    public void setRangeDays(int rangeDays) { this.rangeDays = rangeDays; }
    public String getStatusFilter() { return statusFilter; }
    public void setStatusFilter(String statusFilter) { this.statusFilter = statusFilter; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public DashboardStats getStats() { return stats; }
    public void setStats(DashboardStats stats) { this.stats = stats; }
    public List<DashboardChartPoint> getEscrowByDay() { return escrowByDay; }
    public void setEscrowByDay(List<DashboardChartPoint> escrowByDay) { this.escrowByDay = escrowByDay; }
    public List<DashboardCategoryShare> getCategoryShares() { return categoryShares; }
    public void setCategoryShares(List<DashboardCategoryShare> categoryShares) { this.categoryShares = categoryShares; }
    public List<DashboardTransaction> getTransactions() { return transactions; }
    public void setTransactions(List<DashboardTransaction> transactions) { this.transactions = transactions; }
    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public long getTotalTransactions() { return totalTransactions; }
    public void setTotalTransactions(long totalTransactions) { this.totalTransactions = totalTransactions; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public List<Integer> getPageNumbers() { return pageNumbers; }
    public void setPageNumbers(List<Integer> pageNumbers) { this.pageNumbers = pageNumbers; }
}
