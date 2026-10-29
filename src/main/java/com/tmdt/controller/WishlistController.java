package com.tmdt.controller;

import com.tmdt.Dao.WishlistDao;
import com.tmdt.Model.Product;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "WishlistController", urlPatterns = {"/wishlist"})
public class WishlistController extends HttpServlet {

    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Bắt buộc đăng nhập để lưu trữ vĩnh viễn theo tài khoản
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String productIdRaw = request.getParameter("productId");

        // Xử lý thêm/xóa khi gửi qua URL
        if (productIdRaw != null && !productIdRaw.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdRaw.trim());
                if ("add".equalsIgnoreCase(action)) {
                    wishlistDao.addToWishlist(user.getId(), productId);
                } else if ("remove".equalsIgnoreCase(action)) {
                    wishlistDao.removeFromWishlist(user.getId(), productId);
                }
                // Đồng bộ lại Session và chuyển hướng gọn URL
                syncSessionWishlist(session, user.getId());
                response.sendRedirect(request.getContextPath() + "/wishlist");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Tải danh sách truyện từ Database
        List<Product> wishlistItems = wishlistDao.getWishlistByUserId(user.getId());

        // Đồng bộ với session để Header hiển thị đúng số lượng
        syncSessionWishlist(session, user.getId());

        request.setAttribute("wishlistItems", wishlistItems);
        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String productIdRaw = request.getParameter("productId");
        String action = request.getParameter("action");

        if (productIdRaw != null && !productIdRaw.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdRaw.trim());
                if ("remove".equalsIgnoreCase(action)) {
                    wishlistDao.removeFromWishlist(user.getId(), productId);
                } else {
                    wishlistDao.addToWishlist(user.getId(), productId);
                }
                syncSessionWishlist(session, user.getId());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/wishlist");
    }

    // Hàm đồng bộ giỏ yêu thích từ Database vào Session để Header luôn cập nhật tức thì
    private void syncSessionWishlist(HttpSession session, int userId) {
        List<Product> list = wishlistDao.getWishlistByUserId(userId);
        Map<Integer, Product> wishlistMap = new LinkedHashMap<>();
        for (Product p : list) {
            wishlistMap.put(p.getId(), p);
        }
        session.setAttribute("wishlist", wishlistMap);
    }
}