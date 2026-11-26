package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.service.UserService;
import com.tmdt.db.JDBIConnector; // Thêm import này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tmdt.Dao.WishlistDao;
import com.tmdt.Model.Product;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            WishlistDao wishlistDao = new WishlistDao();
            List<Product> wishList = wishlistDao.getWishlistByUserId(user.getId());
            Map<Integer, Product> wishlistMap = new LinkedHashMap<>();
            for (Product p : wishList) {
                wishlistMap.put(p.getId(), p);
            }
            session.setAttribute("wishlist", wishlistMap);

            // =========================================================
            // THÊM ĐOẠN NÀY: ĐẾM SỐ THÔNG BÁO CHƯA ĐỌC KHI ĐĂNG NHẬP
            // =========================================================
            try {
                int unreadCount = JDBIConnector.get().withHandle(h ->
                        h.createQuery("SELECT COUNT(*) FROM notifications WHERE user_id = :uid AND is_read = 0")
                                .bind("uid", user.getId())
                                .mapTo(Integer.class)
                                .one()
                );
                session.setAttribute("unreadNotifCount", unreadCount);
            } catch (Exception e) {
                System.out.println("Lỗi khi đếm thông báo: " + e.getMessage());
                session.setAttribute("unreadNotifCount", 0);
            }
            // =========================================================

            // PHÂN QUYỀN CHUYỂN HƯỚNG MỤC TIÊU:
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        }
    }
}