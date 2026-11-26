package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.db.JDBIConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "NotificationController", urlPatterns = {"/notifications"})
public class NotificationController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách thông báo
        List<Map<String, Object>> notifs = JDBIConnector.get().withHandle(h ->
                h.createQuery("SELECT * FROM notifications WHERE user_id = :uid ORDER BY created_at DESC")
                        .bind("uid", user.getId()).mapToMap().list()
        );

        // Đánh dấu đã đọc
        JDBIConnector.get().useHandle(h ->
                h.createUpdate("UPDATE notifications SET is_read = 1 WHERE user_id = :uid")
                        .bind("uid", user.getId()).execute()
        );

        // Cập nhật lại session count
        session.setAttribute("unreadNotifCount", 0);

        request.setAttribute("notifications", notifs);
        request.getRequestDispatcher("/notifications.jsp").forward(request, response);
    }
}