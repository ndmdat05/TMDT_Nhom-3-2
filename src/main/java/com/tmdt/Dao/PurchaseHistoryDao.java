package com.tmdt.Dao;

import com.tmdt.Model.OrderTracking;
import com.tmdt.Model.PurchaseOrder;
import com.tmdt.Model.TrackingStep;

import java.util.ArrayList;
import java.util.List;

public class PurchaseHistoryDao extends BaseDao {

    private static final String SQL_ORDERS_BY_USER = 
            "SELECT v.order_code AS orderCode, v.order_date AS orderDate, v.total_amount AS totalAmount, " +
            "       v.status_code AS statusCode, v.status_label AS statusLabel " +
            "FROM ( " +
            "  SELECT o.id, o.order_code, DATE(o.created_at) AS order_date, o.created_at, o.total_amount, " +
            "         CASE WHEN o.order_status = 'COMPLETED' THEN 'done' " +
            "              WHEN o.order_status = 'CANCELLED' THEN 'cancel' " +
            "              WHEN o.order_status IN ('CONFIRMED','SHIPPING') THEN 'ship' " +
            "              ELSE 'pay' END AS status_code, " +
            "         CASE WHEN o.order_status = 'COMPLETED' THEN 'Hoàn tất' " +
            "              WHEN o.order_status = 'CANCELLED' THEN 'Đã hủy' " +
            "              WHEN o.order_status = 'SHIPPING' THEN 'Đang vận chuyển' " +
            "              WHEN o.order_status = 'CONFIRMED' THEN 'Chuẩn bị hàng' " +
            "              WHEN o.payment_method = 'ONLINE' AND o.payment_status = 'PENDING' THEN 'Chờ thanh toán' " +
            "              WHEN o.payment_method = 'ONLINE' AND o.payment_status = 'FAILED' THEN 'Thanh toán thất bại' " +
            "              ELSE 'Chờ xác nhận' END AS status_label " +
            "  FROM orders o " +
            "  WHERE (o.buyer_id = :userId OR EXISTS (SELECT 1 FROM users a WHERE a.id = :userId AND a.role = 'ADMIN' AND a.status = 'ACTIVE')) " +
            "    AND (:keyword = '' OR INSTR(o.order_code, :keyword) > 0) " +
            ") v " +
            "WHERE (:status = '' OR v.status_code = :status) " +
            "ORDER BY v.created_at DESC, v.id DESC";


    private static final String SQL_LATEST_SHIPPING_ORDER = 
            "SELECT o.order_code AS orderCode, o.estimated_delivery AS estimatedDelivery, " +
            "       o.shipping_address AS shippingAddress, " +
            "       (SELECT COUNT(*) FROM order_trackings t WHERE t.order_id = o.id) AS currentStep " +
            "FROM orders o " +
            "WHERE (o.buyer_id = :userId OR EXISTS (SELECT 1 FROM users a WHERE a.id = :userId AND a.role = 'ADMIN' AND a.status = 'ACTIVE')) " +
            "  AND o.order_status = 'SHIPPING' " +
            "ORDER BY o.updated_at DESC, o.id DESC " +
            "LIMIT 1";

    private static final String SQL_TRACKING_STEPS = 
            "SELECT s.label AS label, s.time_text AS timeText FROM ( " +
            "  SELECT 0 AS grp, o.created_at AS ts, 0 AS sid, 'Đặt hàng thành công' AS label, " +
            "         DATE_FORMAT(o.created_at, '%d/%m • %H:%i') AS time_text " +
            "  FROM orders o WHERE o.order_code = :orderCode AND (o.buyer_id = :userId OR EXISTS (SELECT 1 FROM users a WHERE a.id = :userId AND a.role = 'ADMIN' AND a.status = 'ACTIVE')) " +
            "  UNION ALL " +
            "  SELECT 1, t.created_at, t.id, t.step_status, DATE_FORMAT(t.created_at, '%d/%m • %H:%i') " +
            "  FROM order_trackings t JOIN orders o ON o.id = t.order_id " +
            "  WHERE o.order_code = :orderCode AND (o.buyer_id = :userId OR EXISTS (SELECT 1 FROM users a WHERE a.id = :userId AND a.role = 'ADMIN' AND a.status = 'ACTIVE')) " +
            "  UNION ALL " +

                    "  SELECT 2, o.estimated_delivery, 0, 'Dự kiến giao hàng', " +
                    "         IF(o.estimated_delivery IS NULL, 'Chưa có ngày dự kiến', CONCAT('Dự kiến ', DATE_FORMAT(o.estimated_delivery, '%d/%m'))) " +
                    "  FROM orders o WHERE o.order_code = :orderCode AND (o.buyer_id = :userId OR EXISTS (SELECT 1 FROM users a WHERE a.id = :userId AND a.role = 'ADMIN' AND a.status = 'ACTIVE')) AND o.order_status = 'SHIPPING' " +
                    ") s ORDER BY s.grp, s.ts, s.sid";

    private static boolean notConfigured(String sql) {
        return sql == null || sql.isBlank();
    }

    public List<PurchaseOrder> findOrdersByUser(int userId, String keyword, String status) {
        if (notConfigured(SQL_ORDERS_BY_USER)) {
            return new ArrayList<>();
        }
        return get().withHandle(h -> h.createQuery(SQL_ORDERS_BY_USER)
                .bind("userId", userId)
                .bind("keyword", keyword)
                .bind("status", status)
                .mapToBean(PurchaseOrder.class)
                .list());
    }


    public OrderTracking findLatestShippingOrder(int userId) {
        if (notConfigured(SQL_LATEST_SHIPPING_ORDER)) {
            return null;
        }
        return get().withHandle(h -> h.createQuery(SQL_LATEST_SHIPPING_ORDER)
                .bind("userId", userId)
                .mapToBean(OrderTracking.class)
                .findOne()
                .orElse(null));
    }


    public List<TrackingStep> findTrackingSteps(int userId, String orderCode) {
        if (notConfigured(SQL_TRACKING_STEPS)) {
            return new ArrayList<>();
        }
        return get().withHandle(h -> h.createQuery(SQL_TRACKING_STEPS)
                .bind("userId", userId)
                .bind("orderCode", orderCode)
                .mapToBean(TrackingStep.class)
                .list());
    }
}
