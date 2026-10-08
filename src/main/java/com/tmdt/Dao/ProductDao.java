package com.tmdt.Dao;

import com.tmdt.Model.Product;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {
    private static List<Product> productList = new ArrayList<>();

    static {
        productList.add(new Product(101, "Slam Dunk Deluxe Tập 1", 120000, 1, "nguyenvana", "ACTIVE", null,   null
        ));

        productList.add(new Product(102, "One Piece Tập 1 (Bản in 1997)", 550000, 1, "nguyenvana", "ACTIVE", null,   null
        ));

        productList.add(new Product(103, "Dragon Ball Full Boxset",     2500000,     2,     "tranvanb",  "HIDDEN", null,   null));
    }

    public List<Product> getAllProducts() {
        return productList;
    }

    public List<Product> getProductsBySellerId(int sellerId) {
        List<Product> result = new ArrayList<>();
        for (Product p : productList) {
            if (p.getSellerId() == sellerId) {
                result.add(p);
            }
        }
        return result;
    }

    // Xóa sản phẩm khỏi danh sách (Dành cho Admin)
    public boolean deleteProduct(int productId) {
        return productList.removeIf(p -> p.getId() == productId);
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
}