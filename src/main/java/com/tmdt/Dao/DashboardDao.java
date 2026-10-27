package com.tmdt.Dao;

import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardStats;
import com.tmdt.Model.DashboardTransaction;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;


public class DashboardDao extends BaseDao {

    // Đơn có báo cáo (tranh chấp) đang chờ xử lý
    private static final String DISPUTE_EXISTS =
            "EXISTS (SELECT 1 FROM reports r WHERE r.order_id = o.id AND r.status = 'PENDING')";

    // Ánh xạ trạng thái DB -> statusCode của giao diện. Dispute được ưu tiên cao nhất.
    private static final String STATUS_CASE =
            "CASE " +
                    " WHEN " + DISPUTE_EXISTS + " THEN 'dispute' " +
                    " WHEN o.order_status = 'COMPLETED' THEN 'released' " +
                    " WHEN o.order_status IN ('CONFIRMED','SHIPPING') THEN 'holding' " +
                    " WHEN o.order_status = 'PENDING' THEN 'reviewing' " +
                    " ELSE 'cancelled' END";

    /** Điều kiện lọc phải khớp 100% với STATUS_CASE ở trên. status đã được Service kiểm tra whitelist. */
    private static String statusCondition(String status) {
        if (status == null) return "";
        switch (status) {
            case "released":
                return " AND o.order_status = 'COMPLETED' AND NOT " + DISPUTE_EXISTS + " ";
            case "holding":
                return " AND o.order_status IN ('CONFIRMED','SHIPPING') AND NOT " + DISPUTE_EXISTS + " ";
            case "reviewing":
                return " AND o.order_status = 'PENDING' AND NOT " + DISPUTE_EXISTS + " ";
            case "dispute":
                return " AND " + DISPUTE_EXISTS + " ";
            default:
                return "";
        }
    }
    // 4. Đếm tổng số giao dịch theo bộ lọc trạng thái (phục vụ phân trang)
    public long countTransactions(String statusFilter) {
        try {
            boolean hasStatus = (statusFilter != null && !statusFilter.isBlank());
            String sql = "SELECT COUNT(*) FROM orders " + (hasStatus ? "WHERE order_status = :status" : "");

    // 1. KPI tổng quan
    public DashboardStats getStats(LocalDate from, LocalDate to) {
        String sql =
                "SELECT " +
                        " COALESCE(SUM(CASE WHEN o.order_status = 'COMPLETED' THEN o.total_amount END), 0) AS totalEscrowValue, " +
                        " COUNT(CASE WHEN o.order_status = 'COMPLETED' THEN 1 END) AS successfulOrders, " +
                        " ROUND(100.0 * COUNT(CASE WHEN o.order_status = 'COMPLETED' THEN 1 END) / NULLIF(COUNT(*), 0), 1) AS successRatePercent, " +
                        " COUNT(DISTINCT o.buyer_id) AS activeCollectors, " +
                        " (SELECT COUNT(*) FROM users WHERE DATE(created_at) = CURDATE()) AS newCollectorsToday, " +
                        " (SELECT COUNT(*) FROM reports WHERE status = 'PENDING' AND order_id IS NOT NULL) AS disputeCount, " +
                        " (SELECT COUNT(*) FROM products WHERE status = 'PENDING_APPROVAL') AS pendingAppraisals " +
                        "FROM orders o " +
                        "WHERE DATE(o.created_at) BETWEEN :from AND :to";

        DashboardStats stats = get().withHandle(h -> h.createQuery(sql)
                .bind("from", from)
                .bind("to", to)
                .mapToBean(DashboardStats.class)
                .findOne()
                .orElseGet(DashboardStats::new));

        // % thay đổi GMV so với kỳ liền trước có cùng độ dài
        long span = ChronoUnit.DAYS.between(from, to) + 1;
        LocalDate prevTo = from.minusDays(1);
        LocalDate prevFrom = from.minusDays(span);
        BigDecimal prev = sumCompleted(prevFrom, prevTo);
        BigDecimal cur = stats.getTotalEscrowValue();
        if (prev != null && prev.signum() > 0 && cur != null) {
            double pct = cur.subtract(prev)
                    .multiply(BigDecimal.valueOf(100))
                    .divide(prev, 1, java.math.RoundingMode.HALF_UP)
                    .doubleValue();
            stats.setEscrowChangePercent(pct);
        } // prev = 0 -> để null: JSP hiển thị "Chưa có dữ liệu"
        return stats;
    }

    private BigDecimal sumCompleted(LocalDate from, LocalDate to) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                "WHERE order_status = 'COMPLETED' AND DATE(created_at) BETWEEN :from AND :to";
        return get().withHandle(h -> h.createQuery(sql)
                .bind("from", from)
                .bind("to", to)
                .mapTo(BigDecimal.class)
                .one());
    }

    // 2. Điểm vẽ biểu đồ cột theo ngày (chỉ đơn COMPLETED, cùng tiêu chí với KPI)
    public List<DashboardChartPoint> getEscrowValueByDay(LocalDate from, LocalDate to) {
        String sql =
                "SELECT DATE(created_at) AS `day`, COALESCE(SUM(total_amount), 0) AS `value` " +
                        "FROM orders " +
                        "WHERE order_status = 'COMPLETED' AND DATE(created_at) BETWEEN :from AND :to " +
                        "GROUP BY DATE(created_at) " +
                        "ORDER BY DATE(created_at) ASC";

        return get().withHandle(h -> h.createQuery(sql)
                .bind("from", from)
                .bind("to", to)
                .mapToBean(DashboardChartPoint.class)
                .list());
    }

    // 3. Cơ cấu danh mục (bỏ đơn đã hủy)
    public List<DashboardCategoryShare> getCategoryShares(LocalDate from, LocalDate to) {
        String sql =
                "SELECT c.name AS `name`, COALESCE(SUM(oi.unit_price * oi.quantity), 0) AS `value` " +
                        "FROM order_items oi " +
                        "JOIN products p   ON oi.product_id = p.id " +
                        "JOIN categories c ON p.category_id = c.id " +
                        "JOIN orders o     ON oi.order_id = o.id " +
                        "WHERE o.order_status <> 'CANCELLED' " +
                        "  AND DATE(o.created_at) BETWEEN :from AND :to " +
                        "GROUP BY c.id, c.name " +
                        "ORDER BY `value` DESC";

        return get().withHandle(h -> h.createQuery(sql)
                .bind("from", from)
                .bind("to", to)
                .mapToBean(DashboardCategoryShare.class)
                .list());
    }

    // 4. Đếm giao dịch theo bộ lọc trạng thái (phục vụ phân trang)
    public long countTransactions(String statusFilter) {
        String sql = "SELECT COUNT(*) FROM orders o WHERE 1=1 " + statusCondition(statusFilter);

        return get().withHandle(h -> h.createQuery(sql)
                .mapTo(Long.class)
                .one());
    }

    // 5. Danh sách giao dịch có phân trang
    public List<DashboardTransaction> getRecentTransactions(String statusFilter, int limit, int offset) {
        String sql =
                "SELECT o.order_code AS escrowCode, " +
                        " (SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id ORDER BY oi.id LIMIT 1) AS title, " +
                        " CONCAT((SELECT COALESCE(SUM(oi2.quantity), 0) FROM order_items oi2 WHERE oi2.order_id = o.id), ' sản phẩm') AS subtitle, " +
                        " b.full_name AS buyer, " +
                        " s.full_name AS seller, " +
                        " o.total_amount AS amount, " +
                        " " + STATUS_CASE + " AS statusCode " +
                        "FROM orders o " +
                        "JOIN users b ON o.buyer_id  = b.id " +
                        "JOIN users s ON o.seller_id = s.id " +
                        "WHERE 1=1 " + statusCondition(statusFilter) +
                        "ORDER BY o.created_at DESC, o.id DESC " +
                        "LIMIT :limit OFFSET :offset";

        return get().withHandle(h -> h.createQuery(sql)
                .bind("limit", limit)
                .bind("offset", offset)
                .mapToBean(DashboardTransaction.class)
                .list());
    }
}