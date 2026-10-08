package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/seller/manage")
public class SellerManageServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "products";

        request.setAttribute("activeTab", tab);

        int currentSellerId = 1;
        String currentSellerName = "nguyenvana";

        if ("products".equals(tab)) {
            request.setAttribute("productList", productDao.getProductsBySellerId(currentSellerId));
        } else if ("orders".equals(tab) || "revenue".equals(tab)) {
            request.setAttribute("orderList", orderDao.getOrdersBySellerName(currentSellerName));
        }

        request.getRequestDispatcher("/WEB-INF/seller-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        HttpSession session = request.getSession();

        if ("createListing".equals(action)) {
            String title = request.getParameter("title");
            double price = Double.parseDouble(request.getParameter("price"));
            // productDao.addProduct(new Product(...));
            session.setAttribute("message", "Đã gửi bài đăng mới chờ Admin kiểm duyệt!");

        } else if ("enterTracking".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String trackingNum = request.getParameter("trackingNumber");
            // orderDao.updateTracking(orderId, trackingNum, "SHIPPING");
            session.setAttribute("message", "Đã cập nhật mã vận đơn " + trackingNum + " cho đơn hàng #" + orderId);

        } else if ("confirmOrder".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            orderDao.updateOrderStatus(orderId, "CONFIRMED");
            session.setAttribute("message", "Đã xác nhận đơn hàng #" + orderId);

        } else if ("cancelOrder".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            orderDao.updateOrderStatus(orderId, "CANCELLED");
            session.setAttribute("message", "Đã hủy đơn hàng #" + orderId);
        }

        response.sendRedirect(request.getContextPath() + "/seller/manage?tab=" + (tab != null ? tab : "products"));
    }
}