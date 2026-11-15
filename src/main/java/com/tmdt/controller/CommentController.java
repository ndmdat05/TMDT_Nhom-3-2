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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * Xử lý bình luận ở trang chi tiết sản phẩm.
 * Tích hợp AI phân tích cảm xúc (Sentiment Analysis) cho bình luận.
 */
@WebServlet(name = "CommentController", urlPatterns = {"/comment"})
public class CommentController extends HttpServlet {

    private static final int MAX_LENGTH = 1000;
    private static final String AI_API_URL = "http://127.0.0.1:5000/predict";

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

        // 👉 PHÂN TÍCH CẢM XÚC: Chỉ phân tích bình luận gốc, câu trả lời mặc định là NEUTRAL
        String sentiment = "NEUTRAL";
        Double confidence = 1.0;
        if (!isReply) {
            SentimentResult result = analyzeSentimentWithAI(content);
            sentiment = result.sentiment;
            confidence = result.confidence;
        }

        int newId = commentDao.addComment(product.getId(), user.getId(), parentId, content, sentiment, confidence);
        if (newId > 0) {
            flash(session, "success", isReply ? "Đã gửi câu trả lời." : "Đã đăng bình luận.");
            return "comment-" + newId;
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
                return c.getParentId() != null ? "comment-" + c.getParentId() : "tab-comments";
            }
            flash(session, "error", "Không thể xoá bình luận.");
            return "comment-" + commentId;
        } catch (NumberFormatException e) {
            flash(session, "error", "Bình luận không hợp lệ.");
            return "tab-comments";
        }
    }

    // ==============================================================
    // KẾT NỐI SANG PYTHON SERVICE (FASTAPI / PHOBERT)
    // ==============================================================
    private static class SentimentResult {
        String sentiment;
        Double confidence;
        SentimentResult(String sentiment, Double confidence) {
            this.sentiment = sentiment;
            this.confidence = confidence;
        }
    }

    private SentimentResult analyzeSentimentWithAI(String text) {
        try {
            URL url = new URL(AI_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(3000); // 1.5s timeout nếu Python chưa bật
            conn.setReadTimeout(5000);
            conn.setDoOutput(true);

            // Escape chuỗi JSON an toàn
            String safeText = text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ");
            String jsonInput = "{\"text\": \"" + safeText + "\"}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInput.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            if (conn.getResponseCode() == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    String res = response.toString();

                    // Parse nhanh JSON kết quả {"sentiment":"POSITIVE", ...}
                    String sentiment = "NEUTRAL";
                    if (res.contains("\"POSITIVE\"")) sentiment = "POSITIVE";
                    else if (res.contains("\"NEGATIVE\"")) sentiment = "NEGATIVE";

                    double conf = 0.95;
                    java.util.regex.Matcher m = java.util.regex.Pattern.compile("\"confidence\"\\s*:\\s*([0-9.]+)").matcher(res);
                    if (m.find()) {
                        conf = Double.parseDouble(m.group(1));
                    }

                    return new SentimentResult(sentiment, conf);
                }
            }
        } catch (Exception e) {
            // Khi chưa chạy server Python: Dự phòng bằng từ khóa cơ bản để bạn test web trước
            String lower = text.toLowerCase();
            if (lower.contains("đẹp") || lower.contains("thích") || lower.contains("ưng") || lower.contains("tốt")
                    || lower.contains("mê") || lower.contains("nhanh") || lower.contains("khen") || lower.contains("tuyệt")) {
                return new SentimentResult("POSITIVE", 0.90);
            }
            if (lower.contains("rách") || lower.contains("tệ") || lower.contains("chán") || lower.contains("xấu")
                    || lower.contains("mờ") || lower.contains("lừa") || lower.contains("hỏng") || lower.contains("thất vọng")) {
                return new SentimentResult("NEGATIVE", 0.90);
            }
        }
        return new SentimentResult("NEUTRAL", 0.80);
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