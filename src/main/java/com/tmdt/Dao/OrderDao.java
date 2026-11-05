package com.tmdt.Dao;

import com.tmdt.Model.Cart;
import com.tmdt.Model.Order;
import com.tmdt.Model.OrderItem;
import com.tmdt.db.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static com.tmdt.db.JDBIConnector.get;

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
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone, o.payment_method, o.payment_status "
                + "FROM orders o "
                + "LEFT JOIN users u_buyer ON o.buyer_id = u_buyer.id "
                + "LEFT JOIN users u_seller ON o.seller_id = u_seller.id "
                + "WHERE u_seller.username = :sellerName OR u_seller.full_name = :sellerName "
                + "ORDER BY o.created_at DESC";

        try {
            return get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("sellerName", sellerName)
                            .map((rs, ctx) -> {
                                Order o = new Order();
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
                                o.setPaymentMethod(rs.getString("payment_method"));
                                o.setPaymentStatus(rs.getString("payment_status"));
                                return o;
                            })
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // CẬP NHẬT TRẠNG THÁI: LƯU VÀO DATABASE MYSQL VÀ CẬP NHẬT CẢ RAM
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "COMPLETED".equalsIgnoreCase(newStatus)
                ? "UPDATE orders SET order_status = :status, payment_status = 'PAID' WHERE id = :id"
                : "UPDATE orders SET order_status = :status WHERE id = :id";

        try {
            boolean updatedInDb = get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("status", newStatus)
                            .bind("id", orderId)
                            .execute() > 0
            );

            // Cập nhật cả list RAM (nếu là đơn mock 501, 502)
            for (Order o : orderList) {
                if (o.getId() == orderId) {
                    o.setStatus(newStatus);
                    if ("COMPLETED".equalsIgnoreCase(newStatus)) {
                        o.setPaymentStatus("PAID");
                    }
                    return true;
                }
            }
            return updatedInDb;
        } catch (Exception e) {
            e.printStackTrace();
            for (Order o : orderList) {
                if (o.getId() == orderId) {
                    o.setStatus(newStatus);
                    return true;
                }
            }
            return false;
        }
    }

    public int countOrders() {
        return orderList.size();
    }

    public List<Order> getOrdersBySellerId(int sellerId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone, o.payment_method, o.payment_status "
                + "FROM orders o "
                + "LEFT JOIN users u_buyer ON o.buyer_id = u_buyer.id "
                + "LEFT JOIN users u_seller ON o.seller_id = u_seller.id "
                + "WHERE o.seller_id = :sellerId "
                + "ORDER BY o.created_at DESC";

        try {
            return get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("sellerId", sellerId)
                            .map((rs, ctx) -> {
                                Order o = new Order();
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
                                o.setPaymentMethod(rs.getString("payment_method"));
                                o.setPaymentStatus(rs.getString("payment_status"));
                                return o;
                            })
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public boolean updateOrderStatus(int orderId, int status) {
        String statusStr;
        switch (status) {
            case 0: statusStr = "PENDING"; break;
            case 1: statusStr = "CONFIRMED"; break;
            case 2: statusStr = "COMPLETED"; break;
            case 3: statusStr = "CANCELLED"; break;
            default: statusStr = String.valueOf(status); break;
        }
        return updateOrderStatus(orderId, statusStr);
    }

    // ==============================================================
    // HÀM LƯU ĐƠN HÀNG VÀO DATABASE MANGAZDB
    // ==============================================================
    public int createOrder(Integer buyerId, Integer sellerId, String receiverName, String receiverPhone,
                           String address, double totalAmount, String paymentMethod,
                           String paymentStatus, String orderCode, Cart cart) {

        String sqlOrder = "INSERT INTO orders (order_code, buyer_id, seller_id, receiver_name, receiver_phone, "
                + "shipping_address, total_amount, payment_method, payment_status, order_status, "
                + "tracking_number, created_at) "
                + "VALUES (:orderCode, :buyerId, :sellerId, :receiverName, :receiverPhone, "
                + ":address, :totalAmount, :paymentMethod, :paymentStatus, 'PENDING', "
                + ":trackingNumber, NOW())";

        String sqlItem = "INSERT INTO order_items (order_id, product_id, product_title, quantity, unit_price) "
                + "VALUES (:orderId, :productId, :productTitle, :quantity, :unitPrice)";

        String sqlTracking = "INSERT INTO order_trackings (order_id, step_status, note, created_at) "
                + "VALUES (:orderId, :stepStatus, :note, NOW())";

        try {
            Jdbi jdbi = get();

            return jdbi.inTransaction(handle -> {
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

                if (cart != null && cart.getItems() != null) {
                    for (com.tmdt.Model.CartItem item : cart.getItems()) {
                        com.tmdt.Model.Product p = item.getProduct();
                        if (p != null) {
                            handle.createUpdate(sqlItem)
                                    .bind("orderId", orderId)
                                    .bind("productId", p.getId())
                                    .bind("productTitle", p.getTitle())
                                    .bind("quantity", item.getQuantity())
                                    .bind("unitPrice", p.getPrice())
                                    .execute();
                        }
                    }
                }

                String note = "PAID".equalsIgnoreCase(paymentStatus)
                        ? "Thanh toán trực tuyến thành công qua VNPAY Sandbox"
                        : "Đơn hàng mới tạo (Thanh toán tiền mặt khi nhận hàng)";
                String stepStatus = "PAID".equalsIgnoreCase(paymentStatus) ? "PAID" : "CREATED";

                handle.createUpdate(sqlTracking)
                        .bind("orderId", orderId)
                        .bind("stepStatus", stepStatus)
                        .bind("note", note)
                        .execute();

                orderList.add(new Order(orderId, "Đơn hàng " + orderCode, "MangaVault", receiverName, (int) totalAmount, "PENDING", orderCode));

                return orderId;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Order> getOrdersByBuyerId(int buyerId) {
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
            return get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("buyerId", buyerId)
                            .map((rs, ctx) -> new Order(
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
            return new ArrayList<>();
        }
    }

    // 1. CHI TIẾT ĐƠN CHO BUYER (CẦN CHECK BUYER ID)
    public Order getOrderById(int orderId, int buyerId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone, o.payment_method, o.payment_status "
                + "FROM orders o "
                + "LEFT JOIN users u_buyer ON o.buyer_id = u_buyer.id "
                + "LEFT JOIN users u_seller ON o.seller_id = u_seller.id "
                + "WHERE o.id = :orderId AND o.buyer_id = :buyerId";

        try {
            return get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("orderId", orderId)
                            .bind("buyerId", buyerId)
                            .map((rs, ctx) -> {
                                Order o = new Order();
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
                                o.setPaymentMethod(rs.getString("payment_method"));
                                o.setPaymentStatus(rs.getString("payment_status"));
                                return o;
                            })
                            .findOne().orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 2. CHI TIẾT ĐƠN CHO SELLER (KHÔNG CẦN CHECK BUYER ID - HỖ TRỢ CẢ DB VÀ RAM MOCK)
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone, o.payment_method, o.payment_status "
                + "FROM orders o "
                + "LEFT JOIN users u_buyer ON o.buyer_id = u_buyer.id "
                + "LEFT JOIN users u_seller ON o.seller_id = u_seller.id "
                + "WHERE o.id = :orderId";

        try {
            Order order = get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("orderId", orderId)
                            .map((rs, ctx) -> {
                                Order o = new Order();
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
                                o.setPaymentMethod(rs.getString("payment_method"));
                                o.setPaymentStatus(rs.getString("payment_status"));
                                return o;
                            })
                            .findOne().orElse(null)
            );
            if (order != null) return order;
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Dự phòng cho đơn mock 501, 502 trong RAM
        for (Order o : orderList) {
            if (o.getId() == orderId) {
                return o;
            }
        }
        return null;
    }

    // 3. DANH SÁCH MÓN HÀNG TRONG ĐƠN (ORDER_ITEMS)
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        String sql = "SELECT oi.id, oi.order_id, oi.product_id, oi.product_title, oi.quantity, oi.unit_price, "
                + "COALESCE(p.image_url, 'Image/manga_01.jpg') AS image_url "
                + "FROM order_items oi "
                + "LEFT JOIN products p ON oi.product_id = p.id "
                + "WHERE oi.order_id = :orderId";

        try {
            return get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("orderId", orderId)
                            .map((rs, ctx) -> new OrderItem(
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
            return new ArrayList<>();
        }
    }

    public List<Order> getAllSellerOrders() {
        String sql = "SELECT id, order_code, shipping_address, total_amount, payment_method, payment_status, "
                + "order_status AS status, tracking_number, estimated_delivery, created_at, receiver_name, receiver_phone "
                + "FROM orders ORDER BY created_at DESC";
        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public List<Order> getOrdersByStatus(String status) {
        String sql = "SELECT id, order_code, shipping_address, total_amount, payment_method, payment_status, "
                + "order_status AS status, tracking_number, estimated_delivery, created_at, receiver_name, receiver_phone "
                + "FROM orders WHERE order_status = :status ORDER BY created_at DESC";
        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("status", status)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public List<Order> getRefundOrders() {
        String sql = "SELECT id, order_code, shipping_address, total_amount, payment_method, payment_status, "
                + "order_status AS status, tracking_number, estimated_delivery, created_at, receiver_name, receiver_phone "
                + "FROM orders WHERE payment_status = 'REFUNDED' OR order_status = 'RETURNED' "
                + "ORDER BY created_at DESC";
        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public int countAllOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        return get().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_status = :status";
        return get().withHandle(handle ->
                handle.createQuery(sql).bind("status", status).mapTo(Integer.class).one()
        );
    }

    public int countRefundOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE payment_status = 'REFUNDED' OR order_status = 'RETURNED'";
        return get().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }
}