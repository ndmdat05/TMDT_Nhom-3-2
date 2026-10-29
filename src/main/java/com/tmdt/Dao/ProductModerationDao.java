
package com.tmdt.Dao;

import com.tmdt.Model.ProductModeration;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductModerationDao {

    private final Jdbi jdbi = com.tmdt.db.JDBIConnector.get();

    /**
     * Lấy danh sách bài đăng đang chờ kiểm duyệt.
     */
    public List<ProductModeration> getPendingProducts() {
        String sql =
                "SELECT p.id, " +
                        "       p.title, " +
                        "       p.description, " +
                        "       p.price, " +
                        "       p.seller_id AS sellerId, " +
                        "       COALESCE(u.full_name, CONCAT('Người dùng #', p.seller_id)) AS sellerName, " +
                        "       p.image_url AS imageUrl, " +
                        "       p.status, " +
                        "       p.rejection_reason AS rejectionReason, " +
                        "       DATE_FORMAT(p.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                        "       DATE_FORMAT(p.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                        "FROM products p " +
                        "LEFT JOIN users u ON u.id = p.seller_id " +
                        "WHERE UPPER(TRIM(p.status)) = 'PENDING_APPROVAL' " +
                        "ORDER BY p.created_at DESC";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(ProductModeration.class)
                        .list()
        );
    }

    /**
     * Đếm bài chờ duyệt trong chính database mà ứng dụng đang kết nối.
     */
    public int countPending() {
        String sql =
                "SELECT COUNT(*) " +
                        "FROM products " +
                        "WHERE UPPER(TRIM(status)) = 'PENDING_APPROVAL'";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    /**
     * Kiểm tra database và số bài chờ duyệt ứng dụng nhìn thấy.
     * Dùng tạm khi debug; có thể bỏ sau khi xác định được lỗi.
     */
    public String getPendingDiagnostic() {
        String sql =
                "SELECT CONCAT(" +
                        "DATABASE(), " +
                        "' | Total products: ', COUNT(*), " +
                        "' | Pending approval: ', " +
                        "COALESCE(SUM(" +
                        "CASE WHEN TRIM(UPPER(status)) = 'PENDING_APPROVAL' " +
                        "THEN 1 ELSE 0 END), 0)" +
                        ") " +
                        "FROM products";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(String.class)
                        .one()
        );
    }

    public ProductModeration getById(int id) {
        String sql =
                "SELECT p.id, p.title, p.description, p.price, " +
                        "       p.seller_id AS sellerId, " +
                        "       COALESCE(u.full_name, CONCAT('Người dùng #', p.seller_id)) AS sellerName, " +
                        "       p.image_url AS imageUrl, p.status, " +
                        "       p.rejection_reason AS rejectionReason, " +
                        "       DATE_FORMAT(p.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                        "       DATE_FORMAT(p.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                        "FROM products p " +
                        "LEFT JOIN users u ON u.id = p.seller_id " +
                        "WHERE p.id = :id";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(ProductModeration.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public int countApprovedToday() {
        String sql =
                "SELECT COUNT(*) FROM products " +
                        "WHERE status = 'APPROVED' " +
                        "AND DATE(updated_at) = CURDATE()";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    public int countRejectedThisWeek() {
        String sql =
                "SELECT COUNT(*) FROM products " +
                        "WHERE status = 'REJECTED' " +
                        "AND updated_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    public double getApprovalRateThisWeek() {
        String sql =
                "SELECT COALESCE(ROUND(" +
                        "  100.0 * SUM(CASE WHEN status = 'APPROVED' THEN 1 ELSE 0 END) " +
                        "  / NULLIF(COUNT(*), 0), 1), 0) " +
                        "FROM products " +
                        "WHERE status IN ('APPROVED', 'REJECTED') " +
                        "AND updated_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql).mapTo(Double.class).one()
        );
    }

    public boolean approveProduct(int productId) {
        String sql =
                "UPDATE products " +
                        "SET status = 'APPROVED', rejection_reason = NULL, " +
                        "    updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id = :id AND status = 'PENDING_APPROVAL'";

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", productId)
                        .execute() > 0
        );
    }

    public boolean rejectProduct(int productId, String reason) {
        String sql =
                "UPDATE products " +
                        "SET status = 'REJECTED', rejection_reason = :reason, " +
                        "    updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id = :id AND status = 'PENDING_APPROVAL'";

        String safeReason = reason == null || reason.trim().isEmpty()
                ? "Bài đăng không đáp ứng yêu cầu kiểm duyệt."
                : reason.trim();

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", productId)
                        .bind("reason", safeReason)
                        .execute() > 0
        );
    }

    public boolean requestEdit(int productId, String reason) {
        String sql =
                "UPDATE products " +
                        "SET status = 'REJECTED', rejection_reason = :reason, " +
                        "    updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id = :id AND status = 'PENDING_APPROVAL'";

        String safeReason = reason == null || reason.trim().isEmpty()
                ? "Vui lòng chỉnh sửa thông tin bài đăng."
                : reason.trim();

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", productId)
                        .bind("reason", "Yêu cầu chỉnh sửa: " + safeReason)
                        .execute() > 0
        );
    }
}
