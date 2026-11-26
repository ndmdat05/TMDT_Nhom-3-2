package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.db.JDBIConnector;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"}) // Chạy trên mọi trang
public class NotificationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                try {
                    // Đếm số thông báo chưa đọc
                    int unreadCount = JDBIConnector.get().withHandle(h ->
                            h.createQuery("SELECT COUNT(*) FROM notifications WHERE user_id = :uid AND is_read = 0")
                                    .bind("uid", user.getId()).mapTo(Integer.class).one()
                    );
                    session.setAttribute("unreadNotifCount", unreadCount);
                } catch (Exception e) {
                    // Bỏ qua lỗi nếu chưa có bảng
                }
            }
        }
        chain.doFilter(request, response);
    }
}