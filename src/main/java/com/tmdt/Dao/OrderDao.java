package com.tmdt.Dao;

import com.tmdt.Model.Cart;
import com.tmdt.Model.Order;
import com.tmdt.db.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private static List<Order> orderList = new ArrayList<>();

    static {
        orderList.add(new Order(501, "Slam Dunk Deluxe Tập 1", "tranvanb", "nguyenvana", 120000, "PENDING", ""));
        orderList.add(new Order(502, "One Piece Tập 1 (Bản in 1997)", "lethic", "nguyenvana", 550000, "CONFIRMED", "GHTK-102938"));
    }

    public List<Order> getAllOrders() {
        return orderList;
    }

    public List<Order> getOrdersBySellerName(String sellerName) {
        List<Order> result = new ArrayList<>();
        for (Order o : orderList) {
            if (o.getSellerName() != null && o.getSellerName().equalsIgnoreCase(sellerName)) {
                result.add(o);
            }
        }
        return result;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        for (Order o : orderList) {
            if (o.getId() == orderId) {
                o.setStatus(newStatus);
                return true;
            }
        }
        return false;
    }

    public int countOrders() {
        return orderList.size();
    }

    public List<Order> getOrdersBySellerId(int sellerId) {
        List<Order> result = new ArrayList<>();
        for (Order o : orderList) {
            result.add(o);
        }
        return result;
    }

    public boolean updateOrderStatus(int orderId, int status) {
        String statusStr;
        switch (status) {
            case 0:
                statusStr = "PENDING";
                break;
            case 1:
                statusStr = "CONFIRMED";
                break;
            case 2:
                statusStr = "COMPLETED";
                break;
            case 3:
                statusStr = "CANCELLED";
                break;
            default:
                statusStr = String.valueOf(status);
                break;
        }
        return updateOrderStatus(orderId, statusStr);
    }

    // ==============================================================
    // HÀM LƯU ĐƠN HÀNG KHỚP 100% DATABASE MANGAZDB
    // ==============================================================
    public int createOrder(Integer buyerId, Integer sellerId, String receiverName, String receiverPhone,
                           String address, double totalAmount, String paymentMethod,
                           String paymentStatus, String orderCode) {

        // Khớp bảng orders: buyer_id, seller_id, order_code, payment_method ('COD' | 'ONLINE')
        String sqlOrder = "INSERT INTO orders (order_code, buyer_id, seller_id, receiver_name, receiver_phone, "
                + "shipping_address, total_amount, payment_method, payment_status, order_status, "
                + "tracking_number, created_at) "
                + "VALUES (:orderCode, :buyerId, :sellerId, :receiverName, :receiverPhone, "
                + ":address, :totalAmount, :paymentMethod, :paymentStatus, 'PENDING', "
                + ":trackingNumber, NOW())";

        // Khớp bảng order_trackings (có chữ s)
        String sqlTracking = "INSERT INTO order_trackings (order_id, step_status, note, created_at) "
                + "VALUES (:orderId, :stepStatus, :note, NOW())";

        try {
            Jdbi jdbi = JDBIConnector.get();

            return jdbi.inTransaction(handle -> {
                // 1. Lưu bản ghi vào bảng orders
                int orderId = handle.createUpdate(sqlOrder)
                        .bind("orderCode", orderCode)
                        .bind("buyerId", (buyerId != null && buyerId > 0) ? buyerId : 1) // Tránh null vi phạm khóa ngoại
                        .bind("sellerId", (sellerId != null && sellerId > 0) ? sellerId : 2) // Mặc định Kenji Vault (ID: 2)
                        .bind("receiverName", receiverName)
                        .bind("receiverPhone", receiverPhone)
                        .bind("address", address)
                        .bind("totalAmount", BigDecimal.valueOf(totalAmount))
                        .bind("paymentMethod", paymentMethod) // 'COD' hoặc 'ONLINE'
                        .bind("paymentStatus", paymentStatus) // 'PENDING' hoặc 'PAID'
                        .bind("trackingNumber", orderCode)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();

                // 2. Lưu lịch sử vào bảng order_trackings
                String note = "PAID".equalsIgnoreCase(paymentStatus)
                        ? "Thanh toán trực tuyến thành công qua VNPAY Sandbox"
                        : "Đơn hàng mới tạo (Thanh toán tiền mặt khi nhận hàng)";
                String stepStatus = "PAID".equalsIgnoreCase(paymentStatus) ? "PAID" : "CREATED";

                handle.createUpdate(sqlTracking)
                        .bind("orderId", orderId)
                        .bind("stepStatus", stepStatus)
                        .bind("note", note)
                        .execute();

                // 3. Cập nhật vào list RAM hiển thị
                orderList.add(new Order(orderId, "Đơn hàng " + orderCode, "MangaVault", receiverName, (int) totalAmount, "PENDING", orderCode));

                return orderId;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}