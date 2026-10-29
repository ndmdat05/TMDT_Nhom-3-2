
package com.tmdt.Dao;

import com.tmdt.db.JDBIConnector;
import java.util.List;
import java.util.Map;

public class CategoryDao {

    public List<Map<String, Object>> getAllCategories() {
        String sql =
                "SELECT c.id, c.name, COUNT(p.id) AS productCount " +
                        "FROM categories c " +
                        "LEFT JOIN products p ON p.category_id = c.id " +
                        "AND p.status <> 'DELETED' " +
                        "GROUP BY c.id, c.name " +
                        "ORDER BY c.id";

        return JDBIConnector.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToMap()
                        .list()
        );
    }

    public boolean addCategory(String name) {
        String sql = "INSERT INTO categories (name) VALUES (:name)";

        return JDBIConnector.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", name.trim())
                        .execute() > 0
        );
    }

    public boolean updateCategory(int id, String name) {
        String sql = "UPDATE categories SET name = :name WHERE id = :id";

        return JDBIConnector.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .bind("name", name.trim())
                        .execute() > 0
        );
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = :id";

        return JDBIConnector.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }
}
