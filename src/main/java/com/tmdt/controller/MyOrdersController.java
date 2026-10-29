package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Model.Order;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyOrdersController", urlPatterns = {"/my-orders"})
public class MyOrdersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        OrderDao orderDao = new OrderDao();
        List<Order> orders = orderDao.getOrdersByBuyerId(user.getId());

        // Lấy đơn hàng mới nhất đang trong tiến trình giao nhận
        Order latestOrder = null;
        if (!orders.isEmpty()) {
            for (Order o : orders) {
                if (!"COMPLETED".equalsIgnoreCase(o.getStatus()) && !"CANCELLED".equalsIgnoreCase(o.getStatus())) {
                    latestOrder = o;
                    break;
                }
            }
            // Nếu không có đơn nào đang giao, lấy đơn mới nhất
            if (latestOrder == null) {
                latestOrder = orders.get(0);
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("latestOrder", latestOrder);
        request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
    }
}