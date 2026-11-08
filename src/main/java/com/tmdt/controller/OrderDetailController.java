package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Model.Order;
import com.tmdt.Model.OrderItem;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-detail"})
public class OrderDetailController extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            Order order = orderDao.getOrderById(orderId, user.getId());

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("cancelReason", order.getCancelReason());
            request.setAttribute("items", items);
            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = (User) session.getAttribute("account");
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String orderIdRaw = request.getParameter("orderId");

        if ("cancel".equalsIgnoreCase(action) && orderIdRaw != null && !orderIdRaw.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdRaw.trim());

                // Lấy lý do hủy do người mua chọn từ modal
                String cancelReason = request.getParameter("cancelReason");
                if (cancelReason == null || cancelReason.trim().isEmpty()) {
                    cancelReason = "Đổi ý không muốn mua nữa";
                }

                // Gọi hàm hoàn tiền ví và cập nhật trạng thái CANCELLED
                orderDao.cancelOrderWithWalletRefund(orderId, user.getId(), cancelReason);

                // Tải lại trang chi tiết để hiển thị banner đã hủy và trạng thái ví
                response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/my-orders");
    }
}
