package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Dao.ProductDao;
import com.tmdt.Dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/manage")
public class AdminManageServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private ProductDao productDao = new ProductDao();
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "users";

        String keyword = request.getParameter("search");
        String filterStatus = request.getParameter("status");

        request.setAttribute("activeTab", tab);

        if ("users".equals(tab)) {
            request.setAttribute("userList", userDao.getAllUsers());
        } else if ("products".equals(tab)) {
            request.setAttribute("productList", productDao.getAllProducts());
        } else if ("orders".equals(tab)) {
            request.setAttribute("orderList", orderDao.getAllOrders());
        }

        request.getRequestDispatcher("/WEB-INF/admin-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        HttpSession session = request.getSession();

        if ("toggleUserStatus".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDao.toggleUserStatus(userId);
            session.setAttribute("message", "Đã cập nhật trạng thái người dùng #" + userId);

        } else if ("changeRole".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newRole = request.getParameter("role");
            // userDao.changeRole(userId, newRole);
            session.setAttribute("message", "Đã đổi vai trò người dùng #" + userId + " thành " + newRole);

        } else if ("approveProduct".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            // productDao.updateStatus(productId, "APPROVED");
            session.setAttribute("message", "Đã duyệt bài đăng #" + productId);

        } else if ("rejectProduct".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String reason = request.getParameter("reason");
            // productDao.rejectProduct(productId, reason);
            session.setAttribute("message", "Đã từ chối duyệt bài đăng #" + productId);

        } else if ("cancelOrder".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            orderDao.updateOrderStatus(orderId, "CANCELLED");
            session.setAttribute("message", "Đã hủy đơn hàng #" + orderId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage?tab=" + (tab != null ? tab : "users"));
    }
}