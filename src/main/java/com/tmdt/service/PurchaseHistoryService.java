package com.tmdt.service;

import com.tmdt.Dao.PurchaseHistoryDao;
import com.tmdt.Model.OrderTracking;
import com.tmdt.Model.PurchaseHistoryData;
import com.tmdt.Model.PurchaseOrder;
import com.tmdt.Model.TrackingStep;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Nghiệp vụ Lịch sử mua hàng: chuẩn hóa điều kiện tìm kiếm/lọc, gọi PurchaseHistoryDao.
 * Không tạo đơn hàng nào. Nếu chưa xác định được người dùng (userId == null) thì trả về dữ liệu rỗng.
 */
public class PurchaseHistoryService {
    private static final Set<String> STATUS_CODES = Set.of("ship", "done", "cancel", "pay");

    private final PurchaseHistoryDao purchaseHistoryDao = new PurchaseHistoryDao();

    public PurchaseHistoryData load(Integer userId, String keyword, String status) {
        PurchaseHistoryData data = new PurchaseHistoryData();
        String kw = keyword == null ? "" : keyword.trim();
        String st = (status != null && STATUS_CODES.contains(status.trim())) ? status.trim() : "";
        data.setKeyword(kw);
        data.setStatusFilter(st);

        if (userId == null) {
            return data;
        }

        List<PurchaseOrder> orders = purchaseHistoryDao.findOrdersByUser(userId, kw, st);
        data.setOrders(orders != null ? orders : new ArrayList<>());

        OrderTracking tracking = purchaseHistoryDao.findLatestShippingOrder(userId);
        if (tracking != null) {
            List<TrackingStep> steps = purchaseHistoryDao.findTrackingSteps(userId, tracking.getOrderCode());
            tracking.setSteps(steps != null ? steps : new ArrayList<>());
        }
        data.setTracking(tracking);
        return data;
    }
}
