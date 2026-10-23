package com.tmdt.Dao;

import com.tmdt.Model.ReportItem;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ReportDao {
    private final Jdbi jdbi = com.tmdt.db.JDBIConnector.get();

    public List<ReportItem> getAllReports() {
        String sql = "" +
                "SELECT r.id, r.reporter_id AS reporterId, rep.full_name AS reporterName, " +
                "       r.reported_id AS reportedId, rep2.full_name AS reportedUserName, " +
                "       r.order_id AS orderId, r.target_type AS targetType, r.target_id AS targetId, " +
                "       r.target_title AS targetTitle, r.reason_type AS reasonType, r.description, " +
                "       r.status, r.admin_note AS adminNote, " +
                "       DATE_FORMAT(r.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                "       DATE_FORMAT(r.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                "FROM reports r " +
                "LEFT JOIN users rep ON rep.id = r.reporter_id " +
                "LEFT JOIN users rep2 ON rep2.id = r.reported_id " +
                "ORDER BY r.created_at DESC";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(ReportItem.class)
                .list());
    }

    public ReportItem getById(int reportId) {
        String sql = "" +
                "SELECT r.id, r.reporter_id AS reporterId, rep.full_name AS reporterName, " +
                "       r.reported_id AS reportedId, rep2.full_name AS reportedUserName, " +
                "       r.order_id AS orderId, r.target_type AS targetType, r.target_id AS targetId, " +
                "       r.target_title AS targetTitle, r.reason_type AS reasonType, r.description, " +
                "       r.status, r.admin_note AS adminNote, " +
                "       DATE_FORMAT(r.created_at, '%Y-%m-%d %H:%i:%s') AS createdAt, " +
                "       DATE_FORMAT(r.updated_at, '%Y-%m-%d %H:%i:%s') AS updatedAt " +
                "FROM reports r " +
                "LEFT JOIN users rep ON rep.id = r.reporter_id " +
                "LEFT JOIN users rep2 ON rep2.id = r.reported_id " +
                "WHERE r.id = :id";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", reportId)
                .mapToBean(ReportItem.class)
                .findOne()
                .orElse(null));
    }

    public boolean updateStatus(int reportId, String status, String adminNote, Integer handledBy) {
        String sql = "UPDATE reports SET status = :status, admin_note = :adminNote, handled_by = :handledBy, handled_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("status", status)
                .bind("adminNote", adminNote)
                .bind("handledBy", handledBy)
                .bind("id", reportId)
                .execute() > 0);
    }

    public int countPending() {
        String sql = "SELECT COUNT(*) FROM reports WHERE status = 'PENDING'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countResolved() {
        String sql = "SELECT COUNT(*) FROM reports WHERE status = 'RESOLVED'";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }
}
