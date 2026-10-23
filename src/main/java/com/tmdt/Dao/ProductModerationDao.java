package com.tmdt.Dao;

import com.tmdt.Model.ProductModeration;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductModerationDao {
    private final Jdbi jdbi = com.tmdt.db.JDBIConnector.get();

    public List<ProductModeration> getPendingProducts() {
        String sql = "" +
                "SELECT p.id, p.title, p.description, p.price, p.seller_id AS sellerId, u.full_name AS sellerName, " +
                "       p.image_url AS imageUrl, p.status, p.rejection_reason AS rejectionReason, " +
                "       DATE_FORMAT(p.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                "       DATE_FORMAT(p.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                "FROM products p " +
                "LEFT JOIN users u ON u.id = p.seller_id " +
                "WHERE p.status = 'PENDING_APPROVAL' " +
                "ORDER BY p.created_at DESC";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(ProductModeration.class)
                .list());
    }

    public ProductModeration getById(int id) {
        String sql = "" +
                "SELECT p.id, p.title, p.description, p.price, p.seller_id AS sellerId, u.full_name AS sellerName, " +
                "       p.image_url AS imageUrl, p.status, p.rejection_reason AS rejectionReason, " +
                "       DATE_FORMAT(p.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                "       DATE_FORMAT(p.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                "FROM products p " +
                "LEFT JOIN users u ON u.id = p.seller_id " +
                "WHERE p.id = :id";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .mapToBean(ProductModeration.class)
                .findOne()
                .orElse(null));
    }

    public int countPending() {
        String sql = "SELECT COUNT(*) FROM products WHERE status = 'PENDING_APPROVAL'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    /** Đếm theo ngày duyệt thực tế (updated_at), không phải ngày tạo bài */
    public int countApprovedToday() {
        String sql = "SELECT COUNT(*) FROM products WHERE status = 'APPROVED' AND DATE(updated_at) = CURDATE()";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countRejectedThisWeek() {
        String sql = "SELECT COUNT(*) FROM products WHERE status = 'REJECTED' AND updated_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public boolean approveProduct(int productId) {
        String sql = "UPDATE products SET status = 'APPROVED', rejection_reason = NULL, updated_at = CURRENT_TIMESTAMP WHERE id = :id AND status = 'PENDING_APPROVAL'";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", productId)
                .execute() > 0);
    }

    public boolean rejectProduct(int productId, String reason) {
        String sql = "UPDATE products SET status = 'REJECTED', rejection_reason = :reason, updated_at = CURRENT_TIMESTAMP WHERE id = :id AND status = 'PENDING_APPROVAL'";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", productId)
                .bind("reason", reason)
                .execute() > 0);
    }

    public boolean requestEdit(int productId, String reason) {
        String sql = "UPDATE products SET status = 'REJECTED', rejection_reason = :reason, updated_at = CURRENT_TIMESTAMP WHERE id = :id AND status = 'PENDING_APPROVAL'";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", productId)
                .bind("reason", "Yêu cầu chỉnh sửa: " + (reason != null ? reason : ""))
                .execute() > 0);
    }
}
