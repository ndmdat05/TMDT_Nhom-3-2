package com.tmdt.controller;

import com.tmdt.Dao.CommentDao;
import com.tmdt.Dao.ProductDao;
import com.tmdt.Model.Comment;
import com.tmdt.Model.Product;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Xử lý bình luận ở trang chi tiết sản phẩm.
 * Người mua, người bán, admin (đã đăng nhập) đều có thể bình luận / trả lời.
 * POST /comment  action = add | reply | delete
 */
@WebServlet(name = "CommentController", urlPatterns = {"/comment"})
public class CommentController extends HttpServlet {

    private static final int MAX_LENGTH = 1000;

    private final CommentDao commentDao = new CommentDao();
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        int productId;
        try {
            productId = Integer.parseInt(request.getParameter("productId"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getStatus() != null && "LOCKED".equalsIgnoreCase(user.getStatus())) {
            flash(session, "error", "Tài khoản của bạn đang bị khoá, không thể bình luận.");
            redirectBack(request, response, productId, "tab-comments");
            return;
        }

        Product product = productDao.getProductById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) action = "add";

        String anchor;
        switch (action) {
            case "delete":
                anchor = handleDelete(request, session, user, product);
                break;
            case "reply":
                anchor = handleAdd(request, session, user, product, true);
                break;
            default:
                anchor = handleAdd(request, session, user, product, false);
        }
        redirectBack(request, response, productId, anchor);
    }

    /** Trả về id phần tử để trang cuộn tới sau khi redirect. */
    private String handleAdd(HttpServletRequest request, HttpSession session, User user,
                             Product product, boolean isReply) {
        String content = request.getParameter("content");
        content = content == null ? "" : content.trim();

        if (content.isEmpty()) {
            flash(session, "error", "Nội dung bình luận không được để trống.");
            return "tab-comments";
        }
        if (content.length() > MAX_LENGTH) {
            flash(session, "error", "Bình luận tối đa " + MAX_LENGTH + " ký tự.");
            return "tab-comments";
        }

        Integer parentId = null;
        if (isReply) {
            try {
                int pid = Integer.parseInt(request.getParameter("parentId"));
                Comment parent = commentDao.getById(pid);
                // Trả lời được BẤT KỲ bình luận nào (mọi tầng) của cùng sản phẩm
                if (parent == null || parent.getProductId() != product.getId()) {
                    flash(session, "error", "Bình luận cần trả lời không tồn tại.");
                    return "tab-comments";
                }
                parentId = pid;
            } catch (NumberFormatException e) {
                flash(session, "error", "Bình luận cần trả lời không hợp lệ.");
                return "tab-comments";
            }
        }

        int newId = commentDao.addComment(product.getId(), user.getId(), parentId, content);
        if (newId > 0) {
            flash(session, "success", isReply ? "Đã gửi câu trả lời." : "Đã đăng bình luận.");
            return "comment-" + newId;   // cuộn tới đúng bình luận vừa gửi
        }
        flash(session, "error", "Không thể lưu bình luận, vui lòng thử lại.");
        return "tab-comments";
    }

    private String handleDelete(HttpServletRequest request, HttpSession session, User user, Product product) {
        try {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            Comment c = commentDao.getById(commentId);
            if (c == null || c.getProductId() != product.getId()) {
                flash(session, "error", "Bình luận không tồn tại.");
                return "tab-comments";
            }
            boolean isOwner = c.getUserId() == user.getId();
            boolean isAdmin = "ADMIN".equalsIgnoreCase(user.getRole());
            boolean isProductSeller = product.getSellerId() == user.getId();
            if (!(isOwner || isAdmin || isProductSeller)) {
                flash(session, "error", "Bạn không có quyền xoá bình luận này.");
                return "comment-" + commentId;
            }
            if (commentDao.deleteComment(commentId, product.getId())) {
                flash(session, "success", "Đã xoá bình luận.");
                // ở lại đúng chỗ: về bình luận cha (nếu có), không thì về đầu tab
                return c.getParentId() != null ? "comment-" + c.getParentId() : "tab-comments";
            }
            flash(session, "error", "Không thể xoá bình luận.");
            return "comment-" + commentId;
        } catch (NumberFormatException e) {
            flash(session, "error", "Bình luận không hợp lệ.");
            return "tab-comments";
        }
    }

    private void flash(HttpSession session, String type, String message) {
        session.setAttribute("commentFlashType", type);
        session.setAttribute("commentFlash", message);
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response,
                              int productId, String anchor) throws IOException {
        response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId
                + "&tab=comments#" + (anchor == null ? "tab-comments" : anchor));
    }
}
