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

    // Lấy toàn bộ sản phẩm cho trang quản trị
    // Bao gồm APPROVED, PENDING_APPROVAL, REJECTED, HIDDEN
    // Không lấy sản phẩm đã bị xóa mềm (DELETED)
    public List<Product> getAllProductsForAdmin() {
        String sql = "SELECT p.id, p.title, p.price, " +
                "       p.stock_quantity AS stockQuantity, " +
                "       COALESCE(p.image_url, '') AS imageUrl, " +
                "       p.description, " +
                "       p.series_name AS seriesName, " +
                "       p.author, " +
                "       p.volume_number AS volumeNumber, " +
                "       p.edition, " +
                "       p.item_condition AS itemCondition, " +
                "       p.language, " +
                "       p.status, " +
                "       p.seller_id AS sellerId, " +
                "       u.full_name AS sellerName " +
                "FROM products p " +
                "LEFT JOIN users u ON p.seller_id = u.id " +
                "WHERE p.status <> 'DELETED' " +
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

    public List<Product> getProductsBySellerId(int sellerId) {
        String sql = "SELECT p.id, p.title, p.price, p.stock_quantity AS stockQuantity, "
                + "       COALESCE(p.image_url, '') AS imageUrl, p.description, "
                + "       p.series_name AS seriesName, p.author, p.volume_number AS volumeNumber, "
                + "       p.edition, p.item_condition AS itemCondition, p.language, p.status, "
                + "       p.rejection_reason AS rejectionReason, "
                + "       p.category_id AS categories_id, p.brand_id AS brandId "
                + "FROM products p "
                + "WHERE p.seller_id = :sellerId AND p.status <> 'DELETED' "
                + "ORDER BY p.id DESC";
        try {
            return JDBIConnector.get().withHandle(h -> h.createQuery(sql)
                    .bind("sellerId", sellerId)
                    .mapToBean(Product.class)
                    .list());
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public int addProduct(Product p) {
        if (p == null || p.getSellerId() <= 0) {
            System.err.println("[addProduct] sellerId không hợp lệ");
            return -1;
        }

        String status = "PENDING_APPROVAL";

        String condition = (p.getItemCondition() != null && !p.getItemCondition().trim().isEmpty())
                ? p.getItemCondition() : "NEW";
        String lang = (p.getLanguage() != null && !p.getLanguage().trim().isEmpty())
                ? p.getLanguage() : "Tiếng Việt";
        int stock = p.getStockQuantity() > 0 ? p.getStockQuantity() : 1;
        String img = (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty())
                ? p.getImageUrl() : "Image/manga_01.jpg";

        Integer categoryId = p.getCategories_id() > 0 ? p.getCategories_id() : null;
        Integer brandId = (p.getBrandId() != null && p.getBrandId() > 0) ? p.getBrandId() : null;

        String sql = "INSERT INTO products (seller_id, category_id, brand_id, title, description, price, "
                + "stock_quantity, image_url, series_name, author, volume_number, "
                + "edition, item_condition, language, is_auction, status) "
                + "VALUES (:sellerId, :categoryId, :brandId, :title, :description, :price, "
                + ":stockQuantity, :imageUrl, :seriesName, :author, :volumeNumber, "
                + ":edition, :itemCondition, :language, :isAuction, :status)";

        try {
            return JDBIConnector.get().withHandle(h -> h.createUpdate(sql)
                    .bind("sellerId", p.getSellerId())
                    .bind("categoryId", categoryId)
                    .bind("brandId", brandId)
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
                    .bind("isAuction", 0)
                    .bind("status", status)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one());
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // Cập nhật thông tin sản phẩm
    public boolean updateProduct(Product p, int sellerId) {
        if (p == null || p.getId() <= 0 || sellerId <= 0) return false;

        String condition = (p.getItemCondition() != null && !p.getItemCondition().trim().isEmpty())
                ? p.getItemCondition() : "NEW";
        String lang = (p.getLanguage() != null && !p.getLanguage().trim().isEmpty())
                ? p.getLanguage() : "Tiếng Việt";
        int stock = p.getStockQuantity() >= 0 ? p.getStockQuantity() : 0;
        Integer categoryId = p.getCategories_id() > 0 ? p.getCategories_id() : null;
        Integer brandId = (p.getBrandId() != null && p.getBrandId() > 0) ? p.getBrandId() : null;

        String sql = "UPDATE products SET "
                + " category_id = :categoryId,"
                + " brand_id = :brandId,"
                + " title = :title,"
                + " description = :description,"
                + " price = :price,"
                + " stock_quantity = :stockQuantity,"
                + " image_url = CASE WHEN :imageUrl IS NOT NULL AND :imageUrl <> '' THEN :imageUrl ELSE image_url END,"
                + " series_name = :seriesName,"
                + " author = :author,"
                + " volume_number = :volumeNumber,"
                + " edition = :edition,"
                + " item_condition = :itemCondition,"
                + " language = :language,"
                + " status = CASE WHEN status IN ('APPROVED','REJECTED') "
                + "               THEN 'PENDING_APPROVAL' ELSE status END "
                + " WHERE id = :id AND seller_id = :sellerId AND status <> 'DELETED'";

        try {
            return JDBIConnector.get().withHandle(h -> h.createUpdate(sql)
                    .bind("id", p.getId())
                    .bind("sellerId", sellerId)             // 🔒 ownership
                    .bind("categoryId", categoryId)
                    .bind("brandId", brandId)
                    .bind("title", p.getTitle())
                    .bind("description", p.getDescription())
                    .bind("price", p.getPrice())
                    .bind("stockQuantity", stock)
                    .bind("imageUrl", p.getImageUrl())
                    .bind("seriesName", p.getSeriesName())
                    .bind("author", p.getAuthor())
                    .bind("volumeNumber", p.getVolumeNumber())
                    .bind("edition", p.getEdition())
                    .bind("itemCondition", condition)
                    .bind("language", lang)
                    .execute() > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Ẩn / Hiện manga (Toggle trạng thái giữa APPROVED và HIDDEN)
    public boolean toggleProductStatus(int productId, int sellerId) {
        String sql = "UPDATE products SET status = CASE "
                + " WHEN status = 'APPROVED' THEN 'HIDDEN' "
                + " WHEN status = 'HIDDEN' THEN 'APPROVED' "
                + " ELSE status END "
                + " WHERE id = :id AND seller_id = :sellerId "
                + " AND status IN ('APPROVED','HIDDEN')";

        try {
            return JDBIConnector.get().withHandle(h -> h.createUpdate(sql)
                    .bind("id", productId)
                    .bind("sellerId", sellerId)
                    .execute() > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft Delete: Chuyển trạng thái sang DELETED
    public boolean deleteProduct(int productId, int sellerId) {
        String sql = "UPDATE products SET status = 'DELETED' "
                + " WHERE id = :id AND seller_id = :sellerId AND status <> 'DELETED'";
        try {
            return JDBIConnector.get().withHandle(h -> h.createUpdate(sql)
                    .bind("id", productId)
                    .bind("sellerId", sellerId)
                    .execute() > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // Overload cho Admin (không cần sellerId)
    public boolean deleteProduct(int productId) {
        String sql = "UPDATE products SET status = 'DELETED' WHERE id = :id";
        try {
            return JDBIConnector.get().withHandle(h ->
                    h.createUpdate(sql).bind("id", productId).execute() > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================================
// SELLER: lấy sản phẩm kèm ownership check + đầy đủ field
// ============================================================
    public Product getProductForSeller(int id, int sellerId) {
        String sql = "SELECT p.*, c.name AS categoriesName, b.name AS publisherName, "
                + "       u.full_name AS sellerName "
                + "FROM products p "
                + "LEFT JOIN users u ON p.seller_id = u.id "
                + "LEFT JOIN categories c ON p.category_id = c.id "
                + "LEFT JOIN brands b ON p.brand_id = b.id "
                + "WHERE p.id = :id AND p.seller_id = :sellerId AND p.status <> 'DELETED'";
        try {
            return JDBIConnector.get().withHandle(h -> h.createQuery(sql)
                    .bind("id", id)
                    .bind("sellerId", sellerId)
                    .map((rs, ctx) -> {
                        Product p = new Product();
                        p.setId(rs.getInt("id"));
                        p.setSellerId(rs.getInt("seller_id"));
                        p.setTitle(rs.getString("title"));
                        p.setDescription(rs.getString("description"));
                        p.setPrice(rs.getDouble("price"));
                        p.setStockQuantity(rs.getInt("stock_quantity"));
                        p.setImageUrl(rs.getString("image_url"));
                        p.setSeriesName(rs.getString("series_name"));
                        p.setAuthor(rs.getString("author"));
                        p.setVolumeNumber((Integer) rs.getObject("volume_number"));
                        p.setEdition(rs.getString("edition"));
                        p.setItemCondition(rs.getString("item_condition"));
                        p.setLanguage(rs.getString("language"));
                        p.setStatus(rs.getString("status"));
                        p.setRejectionReason(rs.getString("rejection_reason"));
                        int catId = rs.getInt("category_id"); if (!rs.wasNull()) p.setCategories_id(catId);
                        int brandId = rs.getInt("brand_id"); if (!rs.wasNull()) p.setBrandId(brandId);
                        p.setCategoriesName(rs.getString("categoriesName"));
                        p.setPublisherName(rs.getString("publisherName"));
                        p.setSellerName(rs.getString("sellerName"));
                        return p;
                    })
                    .findOne().orElse(null));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
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