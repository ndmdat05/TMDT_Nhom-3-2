package com.tmdt.Dao;

import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardStats;
import com.tmdt.Model.DashboardTransaction;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DashboardDao extends BaseDao {

    // 1. Thống kê tổng quan (doanh thu, đơn hàng, khách hàng)
    public DashboardStats getStats(LocalDate from, LocalDate to) {
        try {
            String sql = "SELECT " +
                    "  COALESCE(SUM(CASE WHEN order_status = 'COMPLETED' THEN total_amount ELSE 0 END), 0) AS totalRevenue, " +
                    "  COUNT(id) AS totalOrders, " +
                    "  COUNT(DISTINCT buyer_id) AS totalCustomers " +
                    "FROM orders " +
                    "WHERE DATE(created_at) BETWEEN :from AND :to";

            return get().withHandle(h -> h.createQuery(sql)
                    .bind("from", from)
                    .bind("to", to)
                    .mapToBean(DashboardStats.class)
                    .findOne()
                    .orElseGet(DashboardStats::new));
        } catch (Exception e) {
            return new DashboardStats();
        }
    }

    // 2. Điểm vẽ biểu đồ theo ngày
    public List<DashboardChartPoint> getEscrowValueByDay(LocalDate from, LocalDate to) {
        try {
            String sql = "SELECT DATE(created_at) AS dateLabel, " +
                    "COALESCE(SUM(total_amount), 0) AS value " +
                    "FROM orders " +
                    "WHERE DATE(created_at) BETWEEN :from AND :to " +
                    "GROUP BY DATE(created_at) " +
                    "ORDER BY DATE(created_at) ASC";

            return get().withHandle(h -> h.createQuery(sql)
                    .bind("from", from)
                    .bind("to", to)
                    .mapToBean(DashboardChartPoint.class)
                    .list());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // 3. Tỷ lệ cơ cấu danh mục
    public List<DashboardCategoryShare> getCategoryShares(LocalDate from, LocalDate to) {
        try {
            String sql = "SELECT c.name AS categoryName, COALESCE(SUM(oi.price * oi.quantity), 0) AS value " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.id " +
                    "JOIN categories c ON p.category_id = c.id " +
                    "JOIN orders o ON oi.order_id = o.id " +
                    "WHERE DATE(o.created_at) BETWEEN :from AND :to " +
                    "GROUP BY c.id, c.name";

            return get().withHandle(h -> h.createQuery(sql)
                    .bind("from", from)
                    .bind("to", to)
                    .mapToBean(DashboardCategoryShare.class)
                    .list());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    // 4. Đếm tổng số giao dịch theo bộ lọc trạng thái (phục vụ phân trang)
    public long countTransactions(String statusFilter) {
        try {
            boolean hasStatus = (statusFilter != null && !statusFilter.isBlank());
            String sql = "SELECT COUNT(*) FROM orders " + (hasStatus ? "WHERE order_status = :status" : "");

            return get().withHandle(h -> {
                var query = h.createQuery(sql);
                if (hasStatus) {
                    query.bind("status", statusFilter);
                }
                return query.mapTo(Long.class).one();
            });
        } catch (Exception e) {
            return 0L;
        }
    }

    // 5. Lấy danh sách giao dịch có phân trang
    public List<DashboardTransaction> getRecentTransactions(String statusFilter, int limit, int offset) {
        try {
            boolean hasStatus = (statusFilter != null && !statusFilter.isBlank());
            String sql = "SELECT id, order_code AS orderCode, total_amount AS amount, " +
                    "order_status AS status, created_at AS createdAt " +
                    "FROM orders " +
                    (hasStatus ? "WHERE order_status = :status " : " ") +
                    "ORDER BY created_at DESC " +
                    "LIMIT :limit OFFSET :offset";

            return get().withHandle(h -> {
                var query = h.createQuery(sql)
                        .bind("limit", limit)
                        .bind("offset", offset);
                if (hasStatus) {
                    query.bind("status", statusFilter);
                }
                return query.mapToBean(DashboardTransaction.class).list();
            });
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}