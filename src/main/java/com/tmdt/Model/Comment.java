package com.tmdt.Model;

import java.sql.Timestamp;
/** Bình luận / hỏi đáp công khai của một sản phẩm (bảng product_comments). */
public class Comment {
    private int id;
    private int productId;
    private int userId;
    private Integer parentId;
    private String content;
    private String status;
    private Timestamp createdAt;

    // Thông tin join thêm để hiển thị
    private String userName;
    private String userRole;     // ADMIN | SELLER | BUYER
    private String userAvatar;
    private boolean productSeller; // true nếu người viết là chủ shop của sản phẩm này

    private int depth;               // 0 = bình luận gốc, 1 = trả lời cấp 1, 2 = cấp 2 ...
    private String parentUserName;   // tên người được trả lời (null nếu là bình luận gốc)

    public Comment() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

    public boolean isProductSeller() { return productSeller; }
    public void setProductSeller(boolean productSeller) { this.productSeller = productSeller; }

    public int getDepth() { return depth; }
    public void setDepth(int depth) { this.depth = depth; }

    public String getParentUserName() { return parentUserName; }
    public void setParentUserName(String parentUserName) { this.parentUserName = parentUserName; }
}
