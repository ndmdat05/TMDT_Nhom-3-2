package com.tmdt.Dao;

import com.tmdt.Model.SupportRequest;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class SupportRequestDao {
    private final Jdbi jdbi = com.tmdt.db.JDBIConnector.get();

    public List<SupportRequest> getAllTickets() {
        String sql = "" +
                "SELECT sr.id, sr.order_id AS orderId, o.order_code AS orderCode, sr.buyer_id AS buyerId, " +
                "       buyer.full_name AS buyerName, sr.seller_id AS sellerId, seller.full_name AS sellerName, " +
                "       sr.type, sr.subject, sr.description, sr.status, sr.admin_note AS adminNote, " +
                "       p.status AS paymentStatus, c.refund_status AS refundStatus, o.total_amount AS totalAmount, " +
                "       COALESCE((SELECT SUM(amount) FROM payments WHERE order_id = sr.order_id AND status = 'SUCCESS'), 0) AS paidAmount, " +
                "       DATE_FORMAT(sr.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                "       DATE_FORMAT(sr.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                "FROM support_requests sr " +
                "LEFT JOIN orders o ON o.id = sr.order_id " +
                "LEFT JOIN users buyer ON buyer.id = sr.buyer_id " +
                "LEFT JOIN users seller ON seller.id = sr.seller_id " +
                "LEFT JOIN payments p ON p.order_id = sr.order_id AND p.status = 'SUCCESS' " +
                "LEFT JOIN cancellations c ON c.order_id = sr.order_id " +
                "ORDER BY sr.created_at DESC";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(SupportRequest.class)
                .list());
    }

    public SupportRequest getById(int id) {
        String sql = "" +
                "SELECT sr.id, sr.order_id AS orderId, o.order_code AS orderCode, sr.buyer_id AS buyerId, " +
                "       buyer.full_name AS buyerName, sr.seller_id AS sellerId, seller.full_name AS sellerName, " +
                "       sr.type, sr.subject, sr.description, sr.status, sr.admin_note AS adminNote, " +
                "       p.status AS paymentStatus, c.refund_status AS refundStatus, o.total_amount AS totalAmount, " +
                "       COALESCE((SELECT SUM(amount) FROM payments WHERE order_id = sr.order_id AND status = 'SUCCESS'), 0) AS paidAmount, " +
                "       DATE_FORMAT(sr.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                "       DATE_FORMAT(sr.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                "FROM support_requests sr " +
                "LEFT JOIN orders o ON o.id = sr.order_id " +
                "LEFT JOIN users buyer ON buyer.id = sr.buyer_id " +
                "LEFT JOIN users seller ON seller.id = sr.seller_id " +
                "LEFT JOIN payments p ON p.order_id = sr.order_id AND p.status = 'SUCCESS' " +
                "LEFT JOIN cancellations c ON c.order_id = sr.order_id " +
                "WHERE sr.id = :id";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .mapToBean(SupportRequest.class)
                .findOne()
                .orElse(null));
    }

    public boolean updateStatus(int ticketId, String status, String adminNote) {
        String sql = "UPDATE support_requests SET status = :status, admin_note = :adminNote, updated_at = CURRENT_TIMESTAMP WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("status", status)
                .bind("adminNote", adminNote)
                .bind("id", ticketId)
                .execute() > 0);
    }

    public int countPending() {
        String sql = "SELECT COUNT(*) FROM support_requests WHERE status = 'PENDING'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countInReview() {
        String sql = "SELECT COUNT(*) FROM support_requests WHERE status = 'IN_REVIEW'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }
}
