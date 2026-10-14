package com.tmdt.service;

import com.tmdt.Dao.DashboardDao;
import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardData;
import com.tmdt.Model.DashboardTransaction;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Nghiệp vụ Dashboard: chuẩn hóa tham số (khoảng ngày, trạng thái, trang),
 * gọi DashboardDao và gom kết quả vào DashboardData. Không tạo số liệu nào.
 */
public class DashboardService {
    private static final int DEFAULT_RANGE_DAYS = 30;
    private static final int MAX_RANGE_DAYS = 90;
    private static final int PAGE_SIZE = 4;
    private static final Set<String> STATUS_CODES = Set.of("released", "holding", "reviewing", "dispute");

    private final DashboardDao dashboardDao = new DashboardDao();

    /**
     * @param fromText   yyyy-MM-dd hoặc null
     * @param toText     yyyy-MM-dd hoặc null
     * @param status     released | holding | reviewing | dispute, rỗng/null = tất cả
     * @param pageText   số trang (>=1) hoặc null
     */
    public DashboardData load(String fromText, String toText, String status, String pageText) {
        DashboardData data = new DashboardData();

        // 1. Khoảng ngày
        LocalDate today = LocalDate.now();
        LocalDate from = null;
        LocalDate to = null;
        boolean hasRange = notBlank(fromText) || notBlank(toText);
        if (hasRange) {
            try {
                from = LocalDate.parse(fromText.trim());
                to = LocalDate.parse(toText.trim());
            } catch (DateTimeParseException | NullPointerException e) {
                from = null;
                data.setErrorMessage("Khoảng ngày không hợp lệ.");
            }
            if (from != null && from.isAfter(to)) {
                from = null;
                data.setErrorMessage("Khoảng ngày không hợp lệ.");
            } else if (from != null && ChronoUnit.DAYS.between(from, to) + 1 > MAX_RANGE_DAYS) {
                from = null;
                data.setErrorMessage("Tối đa " + MAX_RANGE_DAYS + " ngày.");
            }
        }
        if (from == null) {   // không truyền hoặc không hợp lệ -> mặc định 30 ngày gần nhất
            to = today;
            from = today.minusDays(DEFAULT_RANGE_DAYS - 1L);
        }
        data.setFrom(from);
        data.setTo(to);
        long span = ChronoUnit.DAYS.between(from, to) + 1;
        data.setRangeDays(to.equals(today) && (span == 7 || span == 30 || span == 90) ? (int) span : 0);

        // 2. Bộ lọc trạng thái + trang
        String statusFilter = (status != null && STATUS_CODES.contains(status.trim())) ? status.trim() : "";
        data.setStatusFilter(statusFilter);
        int page = parsePositive(pageText, 1);

        // 3. Dữ liệu từ DAO
        data.setStats(dashboardDao.getStats(from, to));

        List<DashboardChartPoint> byDay = dashboardDao.getEscrowValueByDay(from, to);
        data.setEscrowByDay(byDay != null ? byDay : new ArrayList<>());

        List<DashboardCategoryShare> shares = dashboardDao.getCategoryShares(from, to);
        if (shares == null) shares = new ArrayList<>();
        BigDecimal sum = BigDecimal.ZERO;
        for (DashboardCategoryShare s : shares) {
            if (s.getValue() != null) sum = sum.add(s.getValue());
        }
        for (DashboardCategoryShare s : shares) {
            if (s.getValue() != null && sum.signum() > 0) {
                s.setPercent(s.getValue().multiply(BigDecimal.valueOf(100))
                        .divide(sum, 1, java.math.RoundingMode.HALF_UP).doubleValue());
            }
        }
        data.setCategoryShares(shares);

        // 4. Phân trang giao dịch
        long total = dashboardDao.countTransactions(statusFilter);
        int totalPages = (int) Math.max(1, (total + PAGE_SIZE - 1) / PAGE_SIZE);
        if (page > totalPages) page = totalPages;
        List<DashboardTransaction> txs = total > 0
                ? dashboardDao.getRecentTransactions(statusFilter, PAGE_SIZE, (page - 1) * PAGE_SIZE)
                : new ArrayList<>();
        data.setTransactions(txs != null ? txs : new ArrayList<>());
        data.setTotalTransactions(total);
        data.setPageSize(PAGE_SIZE);
        data.setPage(page);
        data.setTotalPages(totalPages);
        List<Integer> pages = new ArrayList<>();
        for (int p = Math.max(1, page - 2); p <= Math.min(totalPages, page + 2); p++) pages.add(p);
        data.setPageNumbers(pages);
        return data;
    }

    /** Dữ liệu trống (không gọi DAO) với khoảng ngày mặc định - dùng khi truy vấn bị lỗi. */
    public DashboardData empty(String errorMessage) {
        DashboardData data = new DashboardData();
        LocalDate today = LocalDate.now();
        data.setFrom(today.minusDays(DEFAULT_RANGE_DAYS - 1L));
        data.setTo(today);
        data.setRangeDays(DEFAULT_RANGE_DAYS);
        data.setPageSize(PAGE_SIZE);
        data.setErrorMessage(errorMessage);
        return data;
    }

    private static boolean notBlank(String s) {
        return s != null && !s.isBlank();
    }

    private static int parsePositive(String text, int fallback) {
        try {
            int v = Integer.parseInt(text.trim());
            return v >= 1 ? v : fallback;
        } catch (NumberFormatException | NullPointerException e) {
            return fallback;
        }
    }
}
