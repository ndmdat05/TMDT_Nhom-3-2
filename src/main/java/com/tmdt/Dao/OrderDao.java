package com.tmdt.Dao;

import com.tmdt.Model.Cart;
import com.tmdt.Model.Order;
import com.tmdt.Model.OrderItem;
import com.tmdt.db.JDBIConnector;
import org.jdbi.v3.core.Jdbi;
import com.tmdt.Model.CartItem;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import com.tmdt.Model.Product;
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
    public int createOrder(Integer buyerId, Integer sellerId,
                           String receiverName, String receiverPhone,
                           String address, double totalAmount, String paymentMethod,
                           String paymentStatus, String orderCode, Cart cart) {

        // ============ ✅ VALIDATE BẮT BUỘC ============
        if (buyerId == null || buyerId <= 0) {
            System.err.println("[createOrder] FAIL: buyerId không hợp lệ = " + buyerId);
            return 0;
        }
        if (sellerId == null || sellerId <= 0) {
            System.err.println("[createOrder] FAIL: sellerId không hợp lệ = " + sellerId);
            return 0;
        }
        if (orderCode == null || orderCode.trim().isEmpty()) {
            System.err.println("[createOrder] FAIL: orderCode rỗng");
            return 0;
        }
        if (cart == null || cart.getTotalQuantity() == 0) {
            System.err.println("[createOrder] FAIL: cart rỗng");
            return 0;
        }
        if (totalAmount <= 0) {
            System.err.println("[createOrder] FAIL: totalAmount <= 0");
            return 0;
        }

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
            final int finalBuyerId  = buyerId;
            final int finalSellerId = sellerId;

            return jdbi.inTransaction(handle -> {
                int orderId = handle.createUpdate(sqlOrder)
                        .bind("orderCode", orderCode)
                        .bind("buyerId",   finalBuyerId)
                        .bind("sellerId",  finalSellerId)
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

                for (CartItem item : cart.getItems()) {
                    Product p = item.getProduct();
                    if (p == null) continue;

                    handle.createUpdate(sqlItem)
                            .bind("orderId", orderId)
                            .bind("productId", p.getId())
                            .bind("productTitle", p.getTitle())
                            .bind("quantity", item.getQuantity())
                            .bind("unitPrice", p.getPrice())
                            .execute();

                    handle.createUpdate(
                                    "UPDATE products SET stock_quantity = stock_quantity - :quantity "
                                            + "WHERE id = :productId AND stock_quantity >= :quantity")
                            .bind("quantity", item.getQuantity())
                            .bind("productId", p.getId())
                            .execute();
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

                System.out.println("[createOrder] OK: orderId=" + orderId
                        + ", buyer=" + finalBuyerId + ", seller=" + finalSellerId);

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

    // 1. CHI TIẾT ĐƠN CHO BUYER (ĐÃ BỔ SUNG CANCEL_REASON)
    public Order getOrderById(int orderId, int buyerId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone, o.payment_method, o.payment_status, o.cancel_reason "
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
                                o.setCancelReason(rs.getString("cancel_reason"));
                                return o;
                            })
                            .findOne().orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 2. CHI TIẾT ĐƠN CHO SELLER (ĐÃ BỔ SUNG CANCEL_REASON)
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.id, o.order_code, "
                + "COALESCE((SELECT oi.product_title FROM order_items oi WHERE oi.order_id = o.id LIMIT 1), 'Manga Sưu Tầm') AS productTitle, "
                + "u_buyer.username AS buyerName, "
                + "COALESCE(u_seller.full_name, u_seller.username, 'MangaVault') AS sellerName, "
                + "o.total_amount, o.order_status AS status, "
                + "COALESCE(o.tracking_number, 'Đang cập nhật') AS tracking_number, "
                + "o.shipping_address, o.estimated_delivery, o.created_at, "
                + "o.receiver_name, o.receiver_phone, o.payment_method, o.payment_status, o.cancel_reason "
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
                                o.setCancelReason(rs.getString("cancel_reason"));
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

    // ==============================================================
    // HÀM HỦY ĐƠN VÀ HOÀN TIỀN VÀO VÍ MANGAVAULT (CHUẨN ACID TRANSACTION)
    // ==============================================================
    public boolean cancelOrderWithWalletRefund(int orderId, int buyerId, String cancelReason) {
        try {
            return get().inTransaction(handle -> {
                // 1. Kiểm tra đơn hàng thuộc về đúng buyer_id và đang ở trạng thái PENDING
                var orderOpt = handle.createQuery(
                                "SELECT id, order_code, total_amount, payment_status, payment_method, order_status " +
                                        "FROM orders WHERE id = :orderId AND buyer_id = :buyerId FOR UPDATE"
                        )
                        .bind("orderId", orderId)
                        .bind("buyerId", buyerId)
                        .mapToMap()
                        .findOne();

                if (orderOpt.isEmpty()) {
                    return false;
                }

                var order = orderOpt.get();
                String currentStatus = String.valueOf(order.get("order_status"));
                if (!"PENDING".equalsIgnoreCase(currentStatus)) {
                    return false; // Chỉ cho phép hủy khi đang PENDING
                }

                String paymentStatus = String.valueOf(order.get("payment_status"));
                String paymentMethod = String.valueOf(order.get("payment_method"));
                double totalAmount = Double.parseDouble(String.valueOf(order.get("total_amount")));
                String orderCode = order.get("order_code") != null ? String.valueOf(order.get("order_code")) : String.valueOf(orderId);

                boolean isPaid = "PAID".equalsIgnoreCase(paymentStatus)
                        || "ONLINE".equalsIgnoreCase(paymentMethod)
                        || "VNPAY".equalsIgnoreCase(paymentMethod);

                // 2. Cập nhật trạng thái đơn hàng trong DB
                if (isPaid) {
                    // Đã thanh toán: Chuyển CANCELLED + REFUNDED + lưu lý do
                    handle.createUpdate(
                                    "UPDATE orders SET order_status = 'CANCELLED', payment_status = 'REFUNDED', cancel_reason = :reason WHERE id = :orderId"
                            )
                            .bind("reason", cancelReason)
                            .bind("orderId", orderId)
                            .execute();

                    // 3. Hoàn tiền vào ví: Cộng wallet_balance trong bảng users
                    handle.createUpdate(
                                    "UPDATE users SET wallet_balance = COALESCE(wallet_balance, 0) + :amount WHERE id = :buyerId"
                            )
                            .bind("amount", totalAmount)
                            .bind("buyerId", buyerId)
                            .execute();

                    // 4. Ghi lịch sử biến động số dư ví vào bảng wallet_transactions
                    String desc = "Hoàn tiền đơn hàng #" + orderCode + " - Lý do: " + cancelReason;
                    handle.createUpdate(
                                    "INSERT INTO wallet_transactions (user_id, order_id, amount, type, description, created_at) " +
                                            "VALUES (:buyerId, :orderId, :amount, 'REFUND', :desc, NOW())"
                            )
                            .bind("buyerId", buyerId)
                            .bind("orderId", orderId)
                            .bind("amount", totalAmount)
                            .bind("desc", desc)
                            .execute();

                } else {
                    // Đơn COD chưa thanh toán: Chỉ chuyển CANCELLED và lưu lý do
                    handle.createUpdate(
                                    "UPDATE orders SET order_status = 'CANCELLED', cancel_reason = :reason WHERE id = :orderId"
                            )
                            .bind("reason", cancelReason)
                            .bind("orderId", orderId)
                            .execute();
                }

                // 5. CỘNG HOÀN LẠI TỒN KHO CHO SẢN PHẨM (Áp dụng cho cả đơn COD và Đơn Online)
                handle.createUpdate(
                                "UPDATE products p " +
                                        "JOIN order_items oi ON p.id = oi.product_id " +
                                        "SET p.stock_quantity = p.stock_quantity + oi.quantity " +
                                        "WHERE oi.order_id = :orderId"
                        )
                        .bind("orderId", orderId)
                        .execute();

                // Cập nhật cả list RAM (nếu là đơn mock)
                for (Order o : orderList) {
                    if (o.getId() == orderId) {
                        o.setStatus("CANCELLED");
                        o.setCancelReason(cancelReason);
                        if (isPaid) {
                            o.setPaymentStatus("REFUNDED");
                        }
                        break;
                    }
                }

                return true;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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