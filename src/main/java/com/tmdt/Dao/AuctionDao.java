package com.tmdt.Dao;

import com.tmdt.Model.Auction;
import com.tmdt.Model.Bid;
import com.tmdt.db.JDBIConnector;

import java.util.List;

public class AuctionDao {

    // 1. Lấy thông tin phiên đấu giá của 1 sản phẩm
    public Auction getAuctionByProductId(int productId) {
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

    // 3. Xử lý đặt giá (Transaction + Logic cọc 10%)
    public String placeBid(int auctionId, int userId, double bidAmount) {
        return JDBIConnector.get().inTransaction(handle -> {
            Auction auction = handle.createQuery("SELECT * FROM auctions WHERE id = :id FOR UPDATE")
                    .bind("id", auctionId).mapToBean(Auction.class).one();

            if (auction == null) return "Phiên đấu giá không tồn tại.";
            if (!"ONGOING".equals(auction.getStatus())) return "Phiên đấu giá chưa bắt đầu hoặc đã kết thúc.";

            long now = System.currentTimeMillis();
            if (now > auction.getEndTime().getTime()) return "Phiên đấu giá đã hết thời gian.";

            // Kiểm tra giá hợp lệ
            double minValid = auction.getCurrentHighestPrice() > 0
                    ? auction.getCurrentHighestPrice() + auction.getBidStep()
                    : auction.getStartingPrice();
            if (bidAmount < minValid) return "Giá đặt phải từ " + String.format("%,.0f", minValid) + " VNĐ trở lên.";

            // --- LOGIC ĐẶT CỌC 10% ---
            // Kiểm tra xem user đã từng đặt giá phiên này chưa? (Nếu chưa thì phải cọc)
            Integer hasBid = handle.createQuery("SELECT COUNT(*) FROM bids WHERE auction_id = :aid AND user_id = :uid")
                    .bind("aid", auctionId).bind("uid", userId).mapTo(Integer.class).one();

            if (hasBid == 0) {
                double depositAmount = auction.getStartingPrice() * 0.10; // Cọc 10% giá khởi điểm
                double walletBalance = handle.createQuery("SELECT COALESCE(wallet_balance, 0) FROM users WHERE id = :uid")
                        .bind("uid", userId).mapTo(Double.class).one();

                if (walletBalance < depositAmount) {
                    return "Bạn cần nạp thêm tiền vào ví để đặt cọc 10% (" + String.format("%,.0f", depositAmount) + " VNĐ).";
                }

                // Trừ tiền trong ví
                handle.createUpdate("UPDATE users SET wallet_balance = wallet_balance - :deposit WHERE id = :uid")
                        .bind("deposit", depositAmount).bind("uid", userId).execute();

                // Lưu lịch sử giao dịch ví
                handle.createUpdate("INSERT INTO wallet_transactions (user_id, amount, type, description) VALUES (:uid, :amount, 'DEPOSIT_AUCTION', :desc)")
                        .bind("uid", userId).bind("amount", depositAmount)
                        .bind("desc", "Đặt cọc 10% tham gia đấu giá sản phẩm #" + auction.getProductId()).execute();
            }

            // Cập nhật giá cao nhất
            handle.createUpdate("UPDATE auctions SET current_highest_price = :bid, winner_id = :uid WHERE id = :id")
                    .bind("bid", bidAmount).bind("uid", userId).bind("id", auctionId).execute();

            // Ghi lịch sử đấu giá
            handle.createUpdate("INSERT INTO bids (auction_id, user_id, bid_amount) VALUES (:aid, :uid, :bid)")
                    .bind("aid", auctionId).bind("uid", userId).bind("bid", bidAmount).execute();

            return "SUCCESS";
        });
    }

    // 4. Lấy tất cả phiên đấu giá đang diễn ra (Cho trang /auctions)
    public List<java.util.Map<String, Object>> getActiveAuctions() {
        String sql = "SELECT a.*, p.title, p.image_url FROM auctions a " +
                "JOIN products p ON a.product_id = p.id " +
                "WHERE a.status = 'ONGOING' AND p.status = 'APPROVED' ORDER BY a.end_time ASC";
        return JDBIConnector.get().withHandle(h -> h.createQuery(sql).mapToMap().list());
    }
}