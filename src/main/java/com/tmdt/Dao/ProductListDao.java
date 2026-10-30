package com.tmdt.Dao;

import com.tmdt.Model.Product;
import com.tmdt.Model.Category;
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

    private StringBuilder buildFilterQuery(String publisher, String seller, String condition, String language, Integer categoryId, Double minPrice, Double maxPrice, String sort, boolean isCount) {
        StringBuilder sql;
        if (isCount) {
            sql = new StringBuilder("SELECT COUNT(p.id) FROM products p LEFT JOIN users u ON p.seller_id = u.id LEFT JOIN brands b ON p.brand_id = b.id LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 'APPROVED'");
        } else {
            sql = new StringBuilder("SELECT p.*, u.full_name AS sellerName, b.name AS publisherName, c.name AS categoriesName FROM products p LEFT JOIN users u ON p.seller_id = u.id LEFT JOIN brands b ON p.brand_id = b.id LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 'APPROVED'");
        }

        if (publisher != null && !publisher.trim().isEmpty()) {
            sql.append(" AND b.name LIKE :publisher");
        }

        if (seller != null && !seller.trim().isEmpty()) {
            sql.append(" AND u.full_name LIKE :seller");
        }

        if (condition != null && !condition.trim().isEmpty()) {
            sql.append(" AND p.item_condition = :condition");
        }

        if (language != null && !language.trim().isEmpty()) {
            sql.append(" AND p.language = :language");
        }

        if (categoryId != null) {
            sql.append(" AND p.category_id = :categoryId");
        }

        if (minPrice != null) {
            sql.append(" AND p.price >= :minPrice");
        }

        if (maxPrice != null) {
            sql.append(" AND p.price <= :maxPrice");
        }

        if (!isCount) {
            if (sort != null) {
                switch (sort) {
                    case "price_asc":
                        sql.append(" ORDER BY p.price ASC");
                        break;
                    case "price_desc":
                        sql.append(" ORDER BY p.price DESC");
                        break;
                    case "popular":
                        sql.append(" ORDER BY p.id DESC");
                        break;
                    case "newest":
                    default:
                        sql.append(" ORDER BY p.created_at DESC");
                        break;
                }
            } else {
                sql.append(" ORDER BY p.id DESC");
            }
            sql.append(" LIMIT :offset, :limit");
        }

        return sql;
    }

    public int countFilterProducts(String publisher, String seller, String condition, String language, Integer categoryId, Double minPrice, Double maxPrice) {
        StringBuilder sql = buildFilterQuery(publisher, seller, condition, language, categoryId, minPrice, maxPrice, null, true);

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString());
            bindParameters(query, publisher, seller, condition, language, categoryId, minPrice, maxPrice);
            return query.mapTo(Integer.class).one();
        });
    }

    public List<Product> filterProducts(String publisher, String seller, String condition, String language, Integer categoryId, Double minPrice, Double maxPrice, String sort, int page, int limit) {
        StringBuilder sql = buildFilterQuery(publisher, seller, condition, language, categoryId, minPrice, maxPrice, sort, false);
        int offset = (page - 1) * limit;

        return get().withHandle(h -> {
            var query = h.createQuery(sql.toString());
            bindParameters(query, publisher, seller, condition, language, categoryId, minPrice, maxPrice);
            query.bind("offset", offset);
            query.bind("limit", limit);
            return query.mapToBean(Product.class).list();
        });
    }

    private void bindParameters(org.jdbi.v3.core.statement.Query query, String publisher, String seller, String condition, String language, Integer categoryId, Double minPrice, Double maxPrice) {
        if (publisher != null && !publisher.trim().isEmpty()) {
            query.bind("publisher", "%" + publisher.trim() + "%");
        }
        if (seller != null && !seller.trim().isEmpty()) {
            query.bind("seller", "%" + seller.trim() + "%");
        }
        if (condition != null && !condition.trim().isEmpty()) {
            query.bind("condition", condition);
        }
        if (language != null && !language.trim().isEmpty()) {
            query.bind("language", language);
        }
        if (categoryId != null) {
            query.bind("categoryId", categoryId);
        }
        if (minPrice != null) {
            query.bind("minPrice", minPrice);
        }
        if (maxPrice != null) {
            query.bind("maxPrice", maxPrice);
        }
    }
}