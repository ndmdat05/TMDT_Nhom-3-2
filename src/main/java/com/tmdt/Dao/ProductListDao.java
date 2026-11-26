package com.tmdt.Dao;

import com.tmdt.Model.Category;
import com.tmdt.Model.Product;

import java.util.List;

public class ProductListDao extends BaseDao {

    public List<String> getAllLanguages() {
        String sql = "SELECT DISTINCT language FROM products "
                + "WHERE language IS NOT NULL AND language != ''";

        return get().withHandle(h ->
                h.createQuery(sql).mapTo(String.class).list()
        );
    }

    public List<String> getAllConditions() {
        String sql = "SELECT DISTINCT item_condition FROM products "
                + "WHERE item_condition IS NOT NULL AND item_condition != ''";

        return get().withHandle(h ->
                h.createQuery(sql).mapTo(String.class).list()
        );
    }

    public List<Category> getAllCategories() {
        String sql = "SELECT id, name FROM categories ORDER BY name ASC";

        return get().withHandle(h ->
                h.createQuery(sql).mapToBean(Category.class).list()
        );
    }

    private StringBuilder buildFilterQuery(
            String keyword,
            String sort,
            boolean isCount
    ) {
        boolean isPopular = !isCount && "popular".equals(sort);

        StringBuilder sql;
        if (isCount) {
            sql = new StringBuilder(
                    "SELECT COUNT(DISTINCT p.id) FROM products p "
                            + "LEFT JOIN brands b ON p.brand_id = b.id "
                            + "WHERE p.status = 'APPROVED'"
            );
        } else {
            sql = new StringBuilder(
                    "SELECT p.*, u.full_name AS sellerName, "
                            + "b.name AS publisherName, "
                            + "c.name AS categoriesName "
                            + "FROM products p "
                            + "LEFT JOIN users u ON p.seller_id = u.id "
                            + "LEFT JOIN brands b ON p.brand_id = b.id "
                            + "LEFT JOIN categories c ON p.category_id = c.id "
            );

            if (isPopular) {
                sql.append("LEFT JOIN order_items oi ON p.id = oi.product_id ");
            }

            sql.append("WHERE p.status = 'APPROVED'");
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(
                    " AND (p.title LIKE :keyword "
                            + "OR b.name LIKE :keyword)"
            );
        }

        if (!isCount) {
            if (isPopular) {
                sql.append(" GROUP BY p.id");
            }

            if ("price_asc".equals(sort)) {
                sql.append(" ORDER BY p.price ASC");
            } else if ("price_desc".equals(sort)) {
                sql.append(" ORDER BY p.price DESC");
            } else if ("popular".equals(sort)) {
                sql.append(" ORDER BY COALESCE(SUM(oi.quantity), 0) DESC, p.id DESC");
            } else {
                sql.append(" ORDER BY p.created_at DESC");
            }

            sql.append(" LIMIT :offset, :limit");
        }

        return sql;
    }

    public int countSearchProducts(String keyword) {
        StringBuilder sql = buildFilterQuery(keyword, null, true);

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString());
            bindKeyword(query, keyword);
            return query.mapTo(Integer.class).one();
        });
    }

    public List<Product> searchProducts(
            String keyword,
            String sort,
            int page,
            int limit
    ) {
        StringBuilder sql = buildFilterQuery(keyword, sort, false);
        int offset = (page - 1) * limit;

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString());
            bindKeyword(query, keyword);
            query.bind("offset", offset);
            query.bind("limit", limit);
            return query.mapToBean(Product.class).list();
        });
    }

    private void bindKeyword(
            org.jdbi.v3.core.statement.Query query,
            String keyword
    ) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.bind("keyword", "%" + keyword.trim() + "%");
        }
    }
}