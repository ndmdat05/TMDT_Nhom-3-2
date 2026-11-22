package com.tmdt.Dao;

import com.tmdt.Model.Product;
import com.tmdt.db.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

import java.util.ArrayList;
import java.util.List;

public class WishlistDao {

    private ProductDao productDao = new ProductDao();

    // 1. Thêm truyện vào kệ sách (INSERT IGNORE để không bị lỗi nếu đã bấm thích trước đó)
    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT IGNORE INTO user_collections (user_id, product_id, created_at) "
                + "VALUES (:userId, :productId, NOW())";
        try {
            Jdbi jdbi = JDBIConnector.get();
            int rows = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .execute()
            );
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Xóa truyện khỏi kệ sách
    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM user_collections WHERE user_id = :userId AND product_id = :productId";
        try {
            Jdbi jdbi = JDBIConnector.get();
            int rows = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .execute()
            );
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Lấy toàn bộ danh sách truyện đã lưu của một User
    public List<Product> getWishlistByUserId(int userId) {
        String sql = "SELECT product_id FROM user_collections WHERE user_id = :userId ORDER BY created_at DESC";
        List<Product> products = new ArrayList<>();

        try {
            Jdbi jdbi = JDBIConnector.get();
            List<Integer> productIds = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .mapTo(Integer.class)
                            .list()
            );

            for (Integer pid : productIds) {
                Product p = productDao.getProductById(pid);
                if (p != null) {
                    products.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    // 4. Kiểm tra sản phẩm đã nằm trong kệ sách chưa
    public boolean isWishlisted(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM user_collections WHERE user_id = :userId AND product_id = :productId";
        try {
            Jdbi jdbi = JDBIConnector.get();
            Integer count = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .bind("productId", productId)
                            .mapTo(Integer.class)
                            .one()
            );
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}