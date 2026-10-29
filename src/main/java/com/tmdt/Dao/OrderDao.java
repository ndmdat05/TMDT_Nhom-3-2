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
                           String paymentStatus, String orderCode, Cart cart) { // <-- THÊM THAM SỐ "Cart cart"

        // 1. Câu lệnh lưu đơn hàng tổng
        String sqlOrder = "INSERT INTO orders (order_code, buyer_id, seller_id, receiver_name, receiver_phone, "
                + "shipping_address, total_amount, payment_method, payment_status, order_status, "
                + "tracking_number, created_at) "
                + "VALUES (:orderCode, :buyerId, :sellerId, :receiverName, :receiverPhone, "
                + ":address, :totalAmount, :paymentMethod, :paymentStatus, 'PENDING', "
                + ":trackingNumber, NOW())";

        // 2. Câu lệnh lưu từng cuốn truyện mua vào bảng order_items
        String sqlItem = "INSERT INTO order_items (order_id, product_id, product_title, quantity, unit_price) "
                + "VALUES (:orderId, :productId, :productTitle, :quantity, :unitPrice)";

        // 3. Câu lệnh lưu lịch sử giao nhận
        String sqlTracking = "INSERT INTO order_trackings (order_id, step_status, note, created_at) "
                + "VALUES (:orderId, :stepStatus, :note, NOW())";

        try {
            Jdbi jdbi = JDBIConnector.get();

            return jdbi.inTransaction(handle -> {
                // Bước 1: Lưu đơn tổng và lấy về orderId tự sinh
                int orderId = handle.createUpdate(sqlOrder)
                        .bind("orderCode", orderCode)
                        .bind("buyerId", (buyerId != null && buyerId > 0) ? buyerId : 1)
                        .bind("sellerId", (sellerId != null && sellerId > 0) ? sellerId : 2)
                        .bind("receiverName", receiverName)
                        .bind("receiverPhone", receiverPhone)
                        .bind("address", address)
                        .bind("totalAmount", BigDecimal.valueOf(totalAmount))
                        .bind("paymentMethod", paymentMethod)
                        .bind("paymentStatus", paymentStatus)
                        .bind("trackingNumber", orderCode)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();

                // Bước 2: Duyệt từng cuốn truyện trong giỏ hàng để lưu vào order_items
                if (cart != null && cart.getItems() != null) {
                    for (com.tmdt.Model.CartItem item : cart.getItems()) {
                        com.tmdt.Model.Product p = item.getProduct();
                        if (p != null) {
                            handle.createUpdate(sqlItem)
                                    .bind("orderId", orderId)
                                    .bind("productId", p.getId())
                                    .bind("productTitle", p.getTitle()) // Nếu Product.java dùng getName() thì đổi thành p.getName()
                                    .bind("quantity", item.getQuantity())
                                    .bind("unitPrice", p.getPrice())
                                    .execute();
                        }
                    }
                }

                // Bước 3: Lưu lịch sử tracking
                String note = "PAID".equalsIgnoreCase(paymentStatus)
                        ? "Thanh toán trực tuyến thành công qua VNPAY Sandbox"
                        : "Đơn hàng mới tạo (Thanh toán tiền mặt khi nhận hàng)";
                String stepStatus = "PAID".equalsIgnoreCase(paymentStatus) ? "PAID" : "CREATED";

                handle.createUpdate(sqlTracking)
                        .bind("orderId", orderId)
                        .bind("stepStatus", stepStatus)
                        .bind("note", note)
                        .execute();

                // Bước 4: Lưu vào list RAM hiển thị tạm
                orderList.add(new Order(orderId, "Đơn hàng " + orderCode, "MangaVault", receiverName, (int) totalAmount, "PENDING", orderCode));

                return orderId;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    public List<com.tmdt.Model.Order> getOrdersByBuyerId(int buyerId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at "
                + "FROM orders o "
                + "LEFT JOIN users u_buyer ON o.buyer_id = u_buyer.id "
                + "LEFT JOIN users u_seller ON o.seller_id = u_seller.id "
                + "WHERE o.buyer_id = :buyerId "
                + "ORDER BY o.created_at DESC";

        try {
            return com.tmdt.db.JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("buyerId", buyerId)
                            .map((rs, ctx) -> new com.tmdt.Model.Order(
                                    rs.getInt("id"),
                                    rs.getString("order_code"),
                                    rs.getString("productTitle"),
                                    rs.getString("buyerName"),
                                    rs.getString("sellerName"),
                                    rs.getDouble("total_amount"),
                                    rs.getString("status"),
                                    rs.getString("tracking_number"),
                                    rs.getString("shipping_address"),
                                    rs.getDate("estimated_delivery"),
                                    rs.getTimestamp("created_at")
                            ))
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
    public com.tmdt.Model.Order getOrderById(int orderId, int buyerId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone "
                + "FROM orders o "
                + "LEFT JOIN users u_buyer ON o.buyer_id = u_buyer.id "
                + "LEFT JOIN users u_seller ON o.seller_id = u_seller.id "
                + "WHERE o.id = :orderId AND o.buyer_id = :buyerId";

        try {
            return com.tmdt.db.JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("orderId", orderId)
                            .bind("buyerId", buyerId)
                            .map((rs, ctx) -> {
                                com.tmdt.Model.Order o = new com.tmdt.Model.Order();
                                o.setId(rs.getInt("id"));
                                o.setOrderCode(rs.getString("order_code"));
                                o.setProductTitle(rs.getString("productTitle"));
                                o.setBuyerName(rs.getString("buyerName"));
                                o.setSellerName(rs.getString("sellerName"));
                                o.setTotalAmount(rs.getDouble("total_amount"));
                                o.setStatus(rs.getString("status"));
                                o.setTrackingNumber(rs.getString("tracking_number"));
                                o.setShippingAddress(rs.getString("shipping_address"));
                                o.setEstimatedDelivery(rs.getDate("estimated_delivery"));
                                o.setCreatedAt(rs.getTimestamp("created_at"));
                                o.setReceiverName(rs.getString("receiver_name"));
                                o.setReceiverPhone(rs.getString("receiver_phone"));
                                return o;
                            })
                            .findOne().orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 2. Lấy danh sách các sản phẩm (order_items) trong đơn hàng đó
    public List<com.tmdt.Model.OrderItem> getOrderItemsByOrderId(int orderId) {
        String sql = "SELECT oi.id, oi.order_id, oi.product_id, oi.product_title, oi.quantity, oi.unit_price, "
                + "COALESCE(p.image_url, 'Image/manga_01.jpg') AS image_url "
                + "FROM order_items oi "
                + "LEFT JOIN products p ON oi.product_id = p.id "
                + "WHERE oi.order_id = :orderId";

        try {
            return com.tmdt.db.JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("orderId", orderId)
                            .map((rs, ctx) -> new com.tmdt.Model.OrderItem(
                                    rs.getInt("id"),
                                    rs.getInt("order_id"),
                                    rs.getInt("product_id"),
                                    rs.getString("product_title"),
                                    rs.getInt("quantity"),
                                    rs.getDouble("unit_price"),
                                    rs.getString("image_url")
                            ))
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

}