package com.tmdt.Dao;

import com.tmdt.Model.Product;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {
    private static List<Product> productList = new ArrayList<>();

    static {
        productList.add(new Product(101, "Slam Dunk Deluxe Tập 1", 120000, 1, "nguyenvana", "ACTIVE", null, null));
        productList.add(new Product(102, "One Piece Tập 1 (Bản in 1997)", 550000, 1, "nguyenvana", "ACTIVE", null, null));
        productList.add(new Product(103, "Dragon Ball Full Boxset", 2500000, 2, "tranvanb", "HIDDEN", null, null));
        productList.add(new Product(104, "Naruto Tập 1 (Tái bản)", 45000, 1, "nguyenvana", "ACTIVE", null, null));
    }

    // Lọc bỏ sản phẩm bị Soft Delete khi lấy tất cả
    public List<Product> getAllProducts() {
        List<Product> result = new ArrayList<>();
        for (Product p : productList) {
            if (!"DELETED".equalsIgnoreCase(p.getStatus())) {
                result.add(p);
            }
        }
        return result;
    }

    // Lọc bỏ sản phẩm bị Soft Delete khi lấy theo Seller
    public List<Product> getProductsBySellerId(int sellerId) {
        List<Product> result = new ArrayList<>();
        for (Product p : productList) {
            if (p.getSellerId() == sellerId && !"DELETED".equalsIgnoreCase(p.getStatus())) {
                result.add(p);
            }
        }
        return result;
    }

    // SOFT DELETE: Không xóa thật, chỉ đổi trạng thái thành DELETED
    public boolean deleteProduct(int productId) {
        for (Product p : productList) {
            if (p.getId() == productId) {
                p.setStatus("DELETED"); // Dữ liệu vẫn còn, chỉ bị ẩn
                return true;
            }
        }
        return false;
    }

    // Ẩn / Hiện sản phẩm (Dành cho Seller)
    public boolean toggleProductStatus(int productId) {
        for (Product p : productList) {
            if (p.getId() == productId) {
                if ("ACTIVE".equalsIgnoreCase(p.getStatus())) {
                    p.setStatus("HIDDEN");
                } else {
                    p.setStatus("ACTIVE");
                }
                return true;
            }
        }
        return false;
    }

    // 1. Đếm tổng số lượng sản phẩm (Bỏ qua sản phẩm DELETED)
    public int countProducts() {
        int count = 0;
        for (Product p : productList) {
            if (!"DELETED".equalsIgnoreCase(p.getStatus())) {
                count++;
            }
        }
        return count;
    }

    // 2. Lấy sản phẩm theo ID (Cho trang Edit / Chi tiết)
    public Product getProductById(int id) {
        for (Product p : productList) {
            if (p.getId() == id && !"DELETED".equalsIgnoreCase(p.getStatus())) {
                return p;
            }
        }
        return null;
    }

    // 3. Thêm mới sản phẩm (Tự sinh ID tăng dần)
    public void addProduct(Product p) {
        int maxId = 100;
        for (Product item : productList) {
            if (item.getId() > maxId) {
                maxId = item.getId();
            }
        }
        p.setId(maxId + 1);
        if (p.getStatus() == null) {
            p.setStatus("PENDING_APPROVAL");
        }
        productList.add(p);
    }

    // 4. Cập nhật thông tin sản phẩm
    public void updateProduct(Product updatedProduct) {
        for (int i = 0; i < productList.size(); i++) {
            Product p = productList.get(i);
            if (p.getId() == updatedProduct.getId()) {
                if (updatedProduct.getTitle() != null) p.setTitle(updatedProduct.getTitle());
                if (updatedProduct.getPrice() > 0) p.setPrice(updatedProduct.getPrice());
                if (updatedProduct.getImageUrl() != null) p.setImageUrl(updatedProduct.getImageUrl());
                if (updatedProduct.getDescription() != null) p.setDescription(updatedProduct.getDescription());
                break;
            }
        }
    }

    // 5. Lấy danh sách sản phẩm mới nhất (Bỏ qua sản phẩm DELETED)
    public List<Product> getTopNewProducts(int limit) {
        List<Product> list = new ArrayList<>();
        int count = 0;
        for (int i = productList.size() - 1; i >= 0; i--) {
            Product p = productList.get(i);
            if (!"DELETED".equalsIgnoreCase(p.getStatus())) {
                list.add(p);
                count++;
                if (count >= limit) break;
            }
        }
        return list;
    }

    // 6. Lấy danh sách sản phẩm nổi bật (Bỏ qua sản phẩm DELETED)
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        for (Product p : productList) {
            if (!"DELETED".equalsIgnoreCase(p.getStatus())) {
                list.add(p);
                if (list.size() >= limit) break;
            }
        }
        return list;
    }
}