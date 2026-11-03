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

@WebServlet(name = "SellerOrderDetailController", urlPatterns = {"/seller-order-detail"})
public class SellerOrderDetailController extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seller-manage?action=orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);

            // Lấy thông tin đơn hàng và danh sách sản phẩm
            Order order = orderDao.getOrderById(orderId);
            List<OrderItem> items = orderDao.getOrderItemsByOrderId(orderId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/seller-manage?action=orders");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.getRequestDispatcher("/seller-order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/seller-manage?action=orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String orderIdParam = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        if (orderIdParam != null && newStatus != null) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                // Cập nhật trạng thái mới vào CSDL
                orderDao.updateOrderStatus(orderId, newStatus);

                // Chuyển hướng lại chính trang chi tiết để thấy trạng thái vừa đổi
                response.sendRedirect(request.getContextPath() + "/seller-order-detail?id=" + orderId);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/seller-manage?action=orders");
    }
}