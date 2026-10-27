package com.tmdt.Dao;

import com.tmdt.Model.Product;
import com.tmdt.db.JDBIConnector;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    // =========================================================================
    // 1. CÁC HÀM CHO TRANG CHỦ & TRANG CHI TIẾT SẢN PHẨM
    // =========================================================================

    // Lấy danh sách manga mới cập nhật (Chỉ lấy sản phẩm APPROVED)
    public List<Product> getTopNewProducts(int limit) {
        String sql = "SELECT p.id, p.title, p.price, p.stock_quantity AS stockQuantity, " +
                "       COALESCE(p.image_url, '') AS imageUrl, p.description, " +
                "       p.series_name AS seriesName, p.author, p.volume_number AS volumeNumber, " +
                "       p.edition, p.item_condition AS itemCondition, p.language, p.status, " +
                "       p.seller_id AS sellerId, u.full_name AS sellerName " +
                "FROM products p " +
                "LEFT JOIN users u ON p.seller_id = u.id " +
                "WHERE p.status = 'APPROVED' " +
                "ORDER BY p.created_at DESC LIMIT :limit";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("limit", limit)
                            .mapToBean(Product.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Lấy danh sách manga nổi bật (Sắp xếp theo giá trị sưu tầm)
    public List<Product> getFeaturedProducts(int limit) {
        String sql = "SELECT p.id, p.title, p.price, p.stock_quantity AS stockQuantity, " +
                "       COALESCE(p.image_url, '') AS imageUrl, p.description, " +
                "       p.series_name AS seriesName, p.author, p.volume_number AS volumeNumber, " +
                "       p.edition, p.item_condition AS itemCondition, p.language, p.status, " +
                "       p.seller_id AS sellerId, u.full_name AS sellerName " +
                "FROM products p " +
                "LEFT JOIN users u ON p.seller_id = u.id " +
                "WHERE p.status = 'APPROVED' " +
                "ORDER BY p.price DESC LIMIT :limit";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("limit", limit)
                            .mapToBean(Product.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Lấy toàn bộ manga đang bán (Cho trang danh mục /products)
    public List<Product> getAllProducts() {
        String sql = "SELECT p.id, p.title, p.price, p.stock_quantity AS stockQuantity, " +
                "       COALESCE(p.image_url, '') AS imageUrl, p.description, " +
                "       p.series_name AS seriesName, p.author, p.volume_number AS volumeNumber, " +
                "       p.edition, p.item_condition AS itemCondition, p.language, p.status, " +
                "       p.seller_id AS sellerId, u.full_name AS sellerName " +
                "FROM products p " +
                "LEFT JOIN users u ON p.seller_id = u.id " +
                "WHERE p.status = 'APPROVED' " +
                "ORDER BY p.id DESC";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .mapToBean(Product.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Lấy chi tiết 1 cuốn manga theo ID (Dùng cho TrangChiTiet và Form Chỉnh sửa)
    public Product getProductById(int id) {
        String sql = "SELECT p.id, p.title, p.price, p.stock_quantity AS stockQuantity, " +
                "       COALESCE(p.image_url, '') AS imageUrl, p.description, " +
                "       p.series_name AS seriesName, p.author, p.volume_number AS volumeNumber, " +
                "       p.edition, p.item_condition AS itemCondition, p.language, p.status, " +
                "       p.seller_id AS sellerId, u.full_name AS sellerName, u.avatar_url AS sellerAvatar " +
                "FROM products p " +
                "LEFT JOIN users u ON p.seller_id = u.id " +
                "WHERE p.id = :id AND p.status <> 'DELETED' " +
                "LIMIT 1";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("id", id)
                            .mapToBean(Product.class)
                            .findOne()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // =========================================================================
    // 2. CÁC HÀM QUẢN LÝ DÀNH CHO SELLER & ADMIN (SELLERMANAGESERVLET)
    // =========================================================================

    // Lấy danh sách manga của 1 người bán cụ thể
    public List<Product> getProductsBySellerId(int sellerId) {
        String sql = "SELECT p.id, p.title, p.price, p.stock_quantity AS stockQuantity, " +
                "       COALESCE(p.image_url, '') AS imageUrl, p.description, " +
                "       p.series_name AS seriesName, p.author, p.volume_number AS volumeNumber, " +
                "       p.edition, p.item_condition AS itemCondition, p.language, p.status " +
                "FROM products p " +
                "WHERE p.seller_id = :sellerId AND p.status <> 'DELETED' " +
                "ORDER BY p.id DESC";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("sellerId", sellerId)
                            .mapToBean(Product.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Thêm mới sản phẩm từ SellerManageServlet
    public int addProduct(Product p) {
        // Chuẩn hóa status sang enum hợp lệ của bảng products
        String status = p.getStatus();
        if (status == null || "ACTIVE".equalsIgnoreCase(status) || status.trim().isEmpty()) {
            status = "APPROVED";
        }

        // Bù đắp giá trị mặc định cho các cột NOT NULL trong MySQL
        String condition = (p.getItemCondition() != null && !p.getItemCondition().trim().isEmpty())
                ? p.getItemCondition() : "NEW";
        String lang = (p.getLanguage() != null && !p.getLanguage().trim().isEmpty())
                ? p.getLanguage() : "Tiếng Việt";
        int stock = p.getStockQuantity() > 0 ? p.getStockQuantity() : 1;
        String img = (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty())
                ? p.getImageUrl() : "Image/manga_01.jpg";

        String sql = "INSERT INTO products (seller_id, category_id, brand_id, title, description, price, " +
                "                      stock_quantity, image_url, series_name, author, volume_number, " +
                "                      edition, item_condition, language, status) " +
                "VALUES (:sellerId, 1, 1, :title, :description, :price, :stockQuantity, " +
                "        :imageUrl, :seriesName, :author, :volumeNumber, :edition, :itemCondition, " +
                "        :language, :status)";
        try {
            final String finalStatus = status;
            return JDBIConnector.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("sellerId", p.getSellerId() > 0 ? p.getSellerId() : 1)
                            .bind("title", p.getTitle())
                            .bind("description", p.getDescription())
                            .bind("price", p.getPrice())
                            .bind("stockQuantity", stock)
                            .bind("imageUrl", img)
                            .bind("seriesName", p.getSeriesName())
                            .bind("author", p.getAuthor())
                            .bind("volumeNumber", p.getVolumeNumber())
                            .bind("edition", p.getEdition())
                            .bind("itemCondition", condition)
                            .bind("language", lang)
                            .bind("status", finalStatus)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // Cập nhật thông tin sản phẩm
    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET " +
                "title = :title, " +
                "price = :price, " +
                "description = :description, " +
                "image_url = CASE WHEN :imageUrl IS NOT NULL AND :imageUrl <> '' THEN :imageUrl ELSE image_url END " +
                "WHERE id = :id";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", p.getId())
                            .bind("title", p.getTitle())
                            .bind("price", p.getPrice())
                            .bind("description", p.getDescription())
                            .bind("imageUrl", p.getImageUrl())
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Ẩn / Hiện manga (Toggle trạng thái giữa APPROVED và HIDDEN)
    public boolean toggleProductStatus(int productId) {
        String sql = "UPDATE products " +
                "SET status = CASE WHEN status = 'APPROVED' THEN 'HIDDEN' ELSE 'APPROVED' END " +
                "WHERE id = :id AND status <> 'DELETED'";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", productId)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft Delete: Chuyển trạng thái sang DELETED
    public boolean deleteProduct(int productId) {
        String sql = "UPDATE products SET status = 'DELETED' WHERE id = :id";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", productId)
                            .execute() > 0
            );
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm tổng số lượng manga còn hoạt động
    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products WHERE status <> 'DELETED'";
        try {
            return JDBIConnector.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .mapTo(Integer.class)
                            .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

}