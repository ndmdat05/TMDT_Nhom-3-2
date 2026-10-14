package com.tmdt.Dao;

import com.tmdt.Model.OrderTracking;
import com.tmdt.Model.PurchaseOrder;
import com.tmdt.Model.TrackingStep;

import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho trang Lịch sử mua hàng của người dùng. Viết theo mẫu UserDao: extends BaseDao + JDBI.
 *
 * ============================ KHUNG CẦN HOÀN THIỆN ============================
 * Hiện CHƯA có database cho đơn hàng nên các hằng SQL_* để TRỐNG. Khi trống, method trả
 * về rỗng/null (KHÔNG có dữ liệu giả) và giao diện hiển thị trạng thái trống.
 *
 * Mọi câu SQL PHẢI lọc theo người mua :userId (id người dùng đang đăng nhập) để người
 * dùng chỉ thấy đơn của chính mình.
 * Đặt ALIAS cột đúng tên thuộc tính DTO để JDBI mapToBean tự ánh xạ.
 * ==============================================================================
 */
public class PurchaseHistoryDao extends BaseDao {

    // ---------------------------------------------------------------------
    // TODO(DB) 1/3 - Danh sách đơn của người mua + tìm kiếm + lọc trạng thái.
    // Tham số: :userId (int), :keyword (chuỗi tìm theo mã đơn, rỗng = bỏ qua; nhớ dùng LIKE),
    //          :status (ship | done | cancel | pay; rỗng = tất cả).
    // Cột trả về -> PurchaseOrder: orderCode, orderDate (DATE), totalAmount,
    //          statusCode (ship|done|cancel|pay), statusLabel (chữ hiển thị, vd "Hoàn tất").
    //   Gợi ý: dùng CASE WHEN để quy đổi trạng thái trong DB sang statusCode/statusLabel.
    // ORDER BY ngày đặt DESC.
    // ---------------------------------------------------------------------
    private static final String SQL_ORDERS_BY_USER = "";

    // ---------------------------------------------------------------------
    // TODO(DB) 2/3 - Đơn đang vận chuyển gần nhất của người mua (khối "ĐANG GIAO VẬN").
    // Tham số: :userId. Trả về tối đa 1 dòng.
    // Cột trả về -> OrderTracking: orderCode, estimatedDelivery (DATE), shippingAddress,
    //          currentStep (chỉ số 0-based của mốc hiện tại trong danh sách mốc).
    // ---------------------------------------------------------------------
    private static final String SQL_LATEST_SHIPPING_ORDER = "";

    // ---------------------------------------------------------------------
    // TODO(DB) 3/3 - Các mốc hành trình của một đơn, theo thứ tự thời gian.
    // Tham số: :orderCode (và có thể :userId để chắc chắn đơn thuộc người dùng).
    // Cột trả về -> TrackingStep: label, timeText (chuỗi hiển thị, vd "08/11 • 09:15"
    //          hoặc "Dự kiến 12/11" - có thể format bằng DATE_FORMAT trong SQL).
    // ---------------------------------------------------------------------
    private static final String SQL_TRACKING_STEPS = "";

    private static boolean notConfigured(String sql) {
        return sql == null || sql.isBlank();
    }

    /** Đơn hàng của người mua, lọc theo mã đơn và trạng thái (rỗng = bỏ qua điều kiện đó). */
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

    /** Đơn đang vận chuyển gần nhất (chưa kèm các mốc). Không có -> null. */
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

    /** Các mốc hành trình của một đơn. */
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
