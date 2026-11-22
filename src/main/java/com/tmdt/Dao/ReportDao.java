package com.tmdt.Dao;

import com.tmdt.Model.ReportItem;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ReportDao {

    private final Jdbi jdbi = com.tmdt.db.JDBIConnector.get();

    public List<ReportItem> getAllReports() {
        String sql = ""
                + "SELECT r.id, r.reporter_id AS reporterId, rep.full_name AS reporterName, "
                + "       r.reported_id AS reportedId, rep2.full_name AS reportedUserName, "
                + "       r.order_id AS orderId, r.target_type AS targetType, r.target_id AS targetId, "
                + "       r.target_title AS targetTitle, r.reason_type AS reasonType, r.description, "
                + "       r.status, r.admin_note AS adminNote, "
                + "       DATE_FORMAT(r.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, "
                + "       DATE_FORMAT(r.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt "
                + "FROM reports r "
                + "LEFT JOIN users rep ON rep.id = r.reporter_id "
                + "LEFT JOIN users rep2 ON rep2.id = r.reported_id "
                + "ORDER BY r.created_at DESC";

        return jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(ReportItem.class).list());
    }

    public ReportItem getById(int reportId) {
        String sql = ""
                + "SELECT r.id, r.reporter_id AS reporterId, rep.full_name AS reporterName, "
                + "       r.reported_id AS reportedId, rep2.full_name AS reportedUserName, "
                + "       r.order_id AS orderId, r.target_type AS targetType, r.target_id AS targetId, "
                + "       r.target_title AS targetTitle, r.reason_type AS reasonType, r.description, "
                + "       r.status, r.admin_note AS adminNote, "
                + "       DATE_FORMAT(r.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, "
                + "       DATE_FORMAT(r.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt "
                + "FROM reports r "
                + "LEFT JOIN users rep ON rep.id = r.reporter_id "
                + "LEFT JOIN users rep2 ON rep2.id = r.reported_id "
                + "WHERE r.id = :id";

        return jdbi.withHandle(handle -> handle.createQuery(sql).bind("id", reportId).mapToBean(ReportItem.class).findOne().orElse(null));
    }

    public boolean updateStatus(int reportId, String status, String adminNote, Integer handledBy) {
        if (!"RESOLVED".equals(status) && !"DISMISSED".equals(status)) {
            throw new IllegalArgumentException("Trạng thái báo cáo không hợp lệ.");
        }
        String sql = ""
                + "UPDATE reports SET status = :status, admin_note = :adminNote, handled_by = :handledBy, "
                + "handled_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP "
                + "WHERE id = :id AND status = 'PENDING'";

        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("status", status).bind("adminNote", adminNote).bind("handledBy", handledBy).bind("id", reportId)
                .execute() > 0);
    }

    public int countPending() {
        return jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM reports WHERE status = 'PENDING'").mapTo(Integer.class).one());
    }

    public int countResolved() {
        return jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM reports WHERE status = 'RESOLVED'").mapTo(Integer.class).one());
    }

    public int countDismissed() {
        return jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM reports WHERE status = 'DISMISSED'").mapTo(Integer.class).one());
    }

    public int countAll() {
        return jdbi.withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM reports").mapTo(Integer.class).one());
    }

    // ==============================================================
    // HÀM MỚI: Tự động chèn báo cáo (Dành cho hệ thống AI)
    // ==============================================================
    public boolean insertReport(ReportItem report) {
        String sql = "INSERT INTO reports (reporter_id, reported_id, order_id, target_type, target_id, target_title, reason_type, description, status, created_at, updated_at) "
                + "VALUES (:reporterId, :reportedId, :orderId, :targetType, :targetId, :targetTitle, :reasonType, :description, :status, NOW(), NOW())";
        try {
            return jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("reporterId", report.getReporterId())
                            .bind("reportedId", report.getReportedId())
                            .bind("orderId", report.getOrderId()) // Có thể null
                            .bind("targetType", report.getTargetType())
                            .bind("targetId", report.getTargetId())
                            .bind("targetTitle", report.getTargetTitle()) // Có thể null
                            .bind("reasonType", report.getReasonType())
                            .bind("description", report.getDescription())
                            .bind("status", report.getStatus())
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}