package com.tmdt.Dao;

import com.tmdt.Model.Auction;
import com.tmdt.Model.Bid;
import com.tmdt.db.JDBIConnector;

import java.util.List;
import java.util.Map;

public class AuctionDao {

    // 1. Lấy thông tin phiên đấu giá của 1 sản phẩm
    public Auction getAuctionByProductId(int productId) {
        // Tự động cập nhật trạng thái thành ENDED nếu đã quá giờ
        JDBIConnector.get().useHandle(h ->
                h.createUpdate("UPDATE auctions SET status = 'ENDED' WHERE product_id = :pid AND status = 'ONGOING' AND end_time < NOW()")
                        .bind("pid", productId).execute()
        );

        String sql = "SELECT * FROM auctions WHERE product_id = :pid ORDER BY id DESC LIMIT 1";
        return JDBIConnector.get().withHandle(h ->
                h.createQuery(sql).bind("pid", productId).mapToBean(Auction.class).findOne().orElse(null)
        );
    }

    // 2. Lấy lịch sử đặt giá
    public List<Bid> getBidsByAuctionId(int auctionId) {
        String sql = "SELECT b.*, u.full_name AS userName FROM bids b " +
                "JOIN users u ON b.user_id = u.id " +
                "WHERE b.auction_id = :aid ORDER BY b.bid_amount DESC, b.created_at DESC";
        return JDBIConnector.get().withHandle(h ->
                h.createQuery(sql).bind("aid", auctionId).mapToBean(Bid.class).list()
        );
    }

    // 3. Xử lý đặt giá
    public String placeBid(int auctionId, int userId, double bidAmount) {
        try {
            return JDBIConnector.get().inTransaction(handle -> {
                Auction auction = handle.createQuery("SELECT * FROM auctions WHERE id = :id FOR UPDATE")
                        .bind("id", auctionId).mapToBean(Auction.class).one();

                if (auction == null) return "Phiên đấu giá không tồn tại.";
                if (!"ONGOING".equals(auction.getStatus())) return "Phiên đấu giá chưa bắt đầu hoặc đã kết thúc.";
                if (auction.getSellerId() == userId) return "Bạn không thể tự đấu giá sản phẩm của chính mình.";

                long now = System.currentTimeMillis();
                if (now > auction.getEndTime().getTime()) return "Phiên đấu giá đã hết thời gian.";

                double minValid = auction.getCurrentHighestPrice() > 0
                        ? auction.getCurrentHighestPrice() + auction.getBidStep()
                        : auction.getStartingPrice();

                if (bidAmount < minValid && auction.getCurrentHighestPrice() > 0) {
                    return "Giá đặt phải từ " + String.format("%,.0f", minValid) + " VNĐ trở lên.";
                }
                if (bidAmount < auction.getStartingPrice()) {
                    return "Giá đặt không được thấp hơn giá khởi điểm (" + String.format("%,.0f", auction.getStartingPrice()) + " VNĐ).";
                }

                // --- LOGIC ĐẶT CỌC 10% ---
                Integer hasBid = handle.createQuery("SELECT COUNT(*) FROM bids WHERE auction_id = :aid AND user_id = :uid")
                        .bind("aid", auctionId).bind("uid", userId).mapTo(Integer.class).one();

                if (hasBid == 0) { // Chỉ trừ cọc ở lần đặt giá đầu tiên
                    double depositAmount = auction.getStartingPrice() * 0.65;

                    Double walletBalance = handle.createQuery("SELECT COALESCE(wallet_balance, 0) FROM users WHERE id = :uid")
                            .bind("uid", userId).mapTo(Double.class).one();

                    if (walletBalance < depositAmount) {
                        return "Số dư ví không đủ. Bạn cần nạp thêm " + String.format("%,.0f", depositAmount - walletBalance) + " VNĐ để đặt cọc.";
                    }

                    // Trừ tiền trong ví
                    handle.createUpdate("UPDATE users SET wallet_balance = COALESCE(wallet_balance, 0) - :deposit WHERE id = :uid")
                            .bind("deposit", depositAmount).bind("uid", userId).execute();

                    // Lưu lịch sử giao dịch ví
                    try {
                        handle.createUpdate("INSERT INTO wallet_transactions (user_id, amount, type, description, created_at) VALUES (:uid, :amount, 'DEPOSIT_AUCTION', :desc, NOW())")
                                .bind("uid", userId).bind("amount", depositAmount)
                                .bind("desc", "Đặt cọc 10% tham gia đấu giá sản phẩm #" + auction.getProductId()).execute();
                    } catch (Exception e) {
                        throw new RuntimeException("Lỗi lưu lịch sử giao dịch (Kiểm tra lại bảng wallet_transactions): " + e.getMessage());
                    }
                }

                handle.createUpdate("UPDATE auctions SET current_highest_price = :bid, winner_id = :uid WHERE id = :id")
                        .bind("bid", bidAmount).bind("uid", userId).bind("id", auctionId).execute();

                handle.createUpdate("INSERT INTO bids (auction_id, user_id, bid_amount) VALUES (:aid, :uid, :bid)")
                        .bind("aid", auctionId).bind("uid", userId).bind("bid", bidAmount).execute();

                return "SUCCESS";
            });
        } catch (Exception e) {
            e.printStackTrace();
            return "LỖI: " + e.getMessage();
        }
    }

    // 4. Lấy tất cả phiên đấu giá đang diễn ra (Lọc bỏ các phiên đã hết hạn)
    public List<Map<String, Object>> getActiveAuctions() {
        String sql = "SELECT a.*, p.title, p.image_url, DATE_FORMAT(a.end_time, '%H:%i - %d/%m/%Y') AS end_time_formatted " +
                "FROM auctions a " +
                "JOIN products p ON a.product_id = p.id " +
                "WHERE a.status = 'ONGOING' AND p.status = 'APPROVED' AND a.end_time > NOW() " + // LỌC TẠI ĐÂY
                "ORDER BY a.end_time ASC";
        return JDBIConnector.get().withHandle(h -> h.createQuery(sql).mapToMap().list());
    }

    // 5. Chốt phiên đấu giá
    public String closeAuction(int auctionId) {
        return JDBIConnector.get().inTransaction(handle -> {
            Auction a = handle.createQuery("SELECT * FROM auctions WHERE id = :id AND status = 'ONGOING' FOR UPDATE")
                    .bind("id", auctionId).mapToBean(Auction.class).findOne().orElse(null);

            if (a == null) return "Phiên đấu giá không tồn tại hoặc đã được chốt.";

            if (a.getWinnerId() == null || a.getCurrentHighestPrice() == 0) {
                handle.createUpdate("UPDATE auctions SET status = 'ENDED' WHERE id = :id").bind("id", auctionId).execute();
                return "Đã đóng phiên đấu giá (Không có người tham gia).";
            }

            Map<String, Object> buyer = handle.createQuery("SELECT full_name, phone_number, address FROM users WHERE id = :uid")
                    .bind("uid", a.getWinnerId()).mapToMap().one();

            String receiverName = buyer.get("full_name") != null ? buyer.get("full_name").toString() : "Chờ cập nhật";
            String receiverPhone = buyer.get("phone_number") != null ? buyer.get("phone_number").toString() : "Chờ cập nhật";
            String shippingAddress = buyer.get("address") != null ? buyer.get("address").toString() : "Chờ cập nhật";

            String orderCode = "AUC" + System.currentTimeMillis();

            String sqlOrder = "INSERT INTO orders (order_code, buyer_id, seller_id, receiver_name, receiver_phone, shipping_address, total_amount, payment_method, payment_status, order_status) " +
                    "VALUES (:code, :bid, :sid, :rname, :rphone, :raddr, :total, 'ONLINE', 'PENDING', 'PENDING')";

            handle.createUpdate(sqlOrder)
                    .bind("code", orderCode).bind("bid", a.getWinnerId()).bind("sid", a.getSellerId())
                    .bind("rname", receiverName).bind("rphone", receiverPhone).bind("raddr", shippingAddress)
                    .bind("total", a.getCurrentHighestPrice()).execute();

            int orderId = handle.createQuery("SELECT LAST_INSERT_ID()").mapTo(Integer.class).one();
            String title = handle.createQuery("SELECT title FROM products WHERE id = :pid").bind("pid", a.getProductId()).mapTo(String.class).one();

            handle.createUpdate("INSERT INTO order_items (order_id, product_id, product_title, quantity, unit_price) VALUES (:oid, :pid, :title, 1, :price)")
                    .bind("oid", orderId).bind("pid", a.getProductId()).bind("title", title).bind("price", a.getCurrentHighestPrice()).execute();

            handle.createUpdate("UPDATE auctions SET status = 'ENDED' WHERE id = :id").bind("id", auctionId).execute();

            return "SUCCESS";
        });

    }
    // 6. Lấy toàn bộ danh sách đấu giá cho Admin
    public List<Map<String, Object>> getAllAuctionsForAdmin() {
        String sql = "SELECT a.*, p.title, p.image_url, u.full_name AS sellerName, " +
                "       w.full_name AS winnerName, " +
                "       DATE_FORMAT(a.end_time, '%H:%i - %d/%m/%Y') AS end_time_formatted " +
                "FROM auctions a " +
                "JOIN products p ON a.product_id = p.id " +
                "JOIN users u ON a.seller_id = u.id " +
                "LEFT JOIN users w ON a.winner_id = w.id " +
                "ORDER BY FIELD(a.status, 'ONGOING', 'UPCOMING', 'ENDED', 'CANCELLED'), a.end_time ASC";

        return JDBIConnector.get().withHandle(h -> h.createQuery(sql).mapToMap().list());
    }
}