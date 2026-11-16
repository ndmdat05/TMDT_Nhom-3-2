package com.tmdt.Dao;

import com.tmdt.Model.Comment;
import com.tmdt.db.JDBIConnector;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CommentDao {

    private static volatile boolean tableChecked = false;

    /** Tự tạo bảng nếu chưa có (đã bổ sung cột sentiment & confidence_score). */
    private void ensureTable() {
        if (tableChecked) return;
        synchronized (CommentDao.class) {
            if (tableChecked) return;
            String ddl = "CREATE TABLE IF NOT EXISTS product_comments ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "product_id INT NOT NULL, "
                    + "user_id INT NOT NULL, "
                    + "parent_id INT NULL, "
                    + "content VARCHAR(1000) NOT NULL, "
                    + "sentiment VARCHAR(20) NOT NULL DEFAULT 'NEUTRAL', "
                    + "confidence_score DECIMAL(5, 4) NULL, "
                    + "status VARCHAR(20) NOT NULL DEFAULT 'VISIBLE', "
                    + "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, "
                    + "INDEX idx_pc_product (product_id, status, created_at), "
                    + "INDEX idx_pc_parent (parent_id), "
                    + "INDEX idx_pc_user (user_id)"
                    + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
            try {
                JDBIConnector.get().useHandle(h -> h.execute(ddl));
                tableChecked = true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /** Thêm bình luận có lưu kết quả phân tích cảm xúc từ AI. */
    public int addComment(int productId, int userId, Integer parentId, String content, String sentiment, Double confidenceScore) {
        ensureTable();
        String sql = "INSERT INTO product_comments (product_id, user_id, parent_id, content, sentiment, confidence_score, status, created_at) "
                + "VALUES (:productId, :userId, :parentId, :content, :sentiment, :confidenceScore, 'VISIBLE', NOW())";
        try {
            return JDBIConnector.get().withHandle(h ->
                    h.createUpdate(sql)
                            .bind("productId", productId)
                            .bind("userId", userId)
                            .bind("parentId", parentId)
                            .bind("content", content)
                            .bind("sentiment", (sentiment != null ? sentiment : "NEUTRAL"))
                            .bind("confidenceScore", confidenceScore)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /** Hàm quá tải dự phòng trường hợp không truyền sentiment. */
    public int addComment(int productId, int userId, Integer parentId, String content) {
        return addComment(productId, userId, parentId, content, "NEUTRAL", 1.0);
    }

    /** Lấy 1 bình luận (chưa bị xoá) theo id. */
    public Comment getById(int id) {
        ensureTable();
        String sql = "SELECT id, product_id AS productId, user_id AS userId, parent_id AS parentId, "
                + "content, sentiment, confidence_score AS confidenceScore, status, created_at AS createdAt "
                + "FROM product_comments WHERE id = :id AND status = 'VISIBLE'";
        try {
            return JDBIConnector.get().withHandle(h ->
                    h.createQuery(sql).bind("id", id)
                            .mapToBean(Comment.class).findOne().orElse(null));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Lấy toàn bộ bình luận của sản phẩm kèm nhãn cảm xúc và điểm tin cậy.
     */
    public List<Comment> getCommentsByProduct(int productId) {
        ensureTable();
        String sql = "SELECT c.id, c.product_id AS productId, c.user_id AS userId, c.parent_id AS parentId, "
                + "       c.content, c.sentiment, c.confidence_score AS confidenceScore, c.status, c.created_at AS createdAt, "
                + "       COALESCE(NULLIF(u.full_name, ''), u.username, 'Người dùng') AS userName, "
                + "       u.role AS userRole, u.avatar_url AS userAvatar, "
                + "       (c.user_id = p.seller_id) AS productSeller "
                + "FROM product_comments c "
                + "LEFT JOIN users u ON c.user_id = u.id "
                + "LEFT JOIN products p ON c.product_id = p.id "
                + "WHERE c.product_id = :productId AND c.status = 'VISIBLE' "
                + "ORDER BY c.created_at ASC, c.id ASC";
        List<Comment> all;
        try {
            all = JDBIConnector.get().withHandle(h ->
                    h.createQuery(sql).bind("productId", productId)
                            .mapToBean(Comment.class).list());
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }

        Map<Integer, Comment> byId = new HashMap<>();
        Map<Integer, List<Comment>> children = new HashMap<>();
        List<Comment> roots = new ArrayList<>();
        for (Comment c : all) byId.put(c.getId(), c);
        for (Comment c : all) {
            Integer pid = c.getParentId();
            if (pid == null || !byId.containsKey(pid)) {
                roots.add(c);
            } else {
                children.computeIfAbsent(pid, k -> new ArrayList<>()).add(c);
            }
        }
        java.util.Collections.reverse(roots);

        List<Comment> flat = new ArrayList<>();
        for (Comment root : roots) {
            root.setDepth(0);
            flatten(root, children, byId, flat);
        }
        return flat;
    }

    private void flatten(Comment root, Map<Integer, List<Comment>> children,
                         Map<Integer, Comment> byId, List<Comment> out) {
        java.util.Deque<Comment> stack = new java.util.ArrayDeque<>();
        stack.push(root);
        while (!stack.isEmpty()) {
            Comment cur = stack.pop();
            out.add(cur);
            List<Comment> kids = children.get(cur.getId());
            if (kids == null) continue;
            for (int i = kids.size() - 1; i >= 0; i--) {
                Comment k = kids.get(i);
                k.setDepth(cur.getDepth() + 1);
                Comment parent = byId.get(k.getParentId());
                k.setParentUserName(parent != null ? parent.getUserName() : null);
                stack.push(k);
            }
        }
    }

    public int countByProduct(int productId) {
        ensureTable();
        String sql = "SELECT COUNT(*) FROM product_comments WHERE product_id = :productId AND status = 'VISIBLE'";
        try {
            return JDBIConnector.get().withHandle(h ->
                    h.createQuery(sql).bind("productId", productId).mapTo(Integer.class).one());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean deleteComment(int id, int productId) {
        ensureTable();
        try {
            return JDBIConnector.get().withHandle(h -> {
                List<int[]> rows = h.createQuery(
                                "SELECT id, parent_id FROM product_comments WHERE product_id = :pid AND status = 'VISIBLE'")
                        .bind("pid", productId)
                        .map((rs, ctx) -> new int[]{rs.getInt(1), rs.getObject(2) == null ? -1 : rs.getInt(2)})
                        .list();
                Map<Integer, List<Integer>> kids = new HashMap<>();
                for (int[] r : rows) kids.computeIfAbsent(r[1], k -> new ArrayList<>()).add(r[0]);

                List<Integer> toDelete = new ArrayList<>();
                java.util.Deque<Integer> stack = new java.util.ArrayDeque<>();
                stack.push(id);
                while (!stack.isEmpty()) {
                    int cur = stack.pop();
                    toDelete.add(cur);
                    List<Integer> ch = kids.get(cur);
                    if (ch != null) for (int c : ch) stack.push(c);
                }
                return h.createUpdate("UPDATE product_comments SET status = 'DELETED' WHERE id IN (<ids>)")
                        .bindList("ids", toDelete)
                        .execute() > 0;
            });
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}