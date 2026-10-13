package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Dao.ProductDao;
import com.tmdt.Dao.UserDao;
import com.tmdt.Model.Order;
import com.tmdt.Model.Product;
import com.tmdt.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

// Đã cập nhật URL Pattern thành "/admin/manage" để khớp với JSP
@WebServlet(name = "AdminManageServlet", urlPatterns = {"/admin/manage"})
public class AdminManageServlet extends HttpServlet {

    private UserDao userDao = new UserDao();
    private ProductDao productDao = new ProductDao();
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ĐÃ TẮT KIỂM TRA ĐĂNG NHẬP ĐỂ TEST CHO NHANH
        /*
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null || !"ADMIN".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        */

        // Nhận tham số 'tab' từ JSP mới (mặc định là 'users')
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "users";
        }

        switch (tab) {
            case "users":
                List<User> userList = userDao.getAllUsers();
                request.setAttribute("userList", userList);
                break;

            case "products":
                List<Product> productList = productDao.getAllProducts();
                request.setAttribute("productList", productList);
                break;

            case "orders":
                List<Order> orderList = orderDao.getAllOrders();
                request.setAttribute("orderList", orderList);
                break;

            default:
                tab = "users";
                List<User> defaultUserList = userDao.getAllUsers();
                request.setAttribute("userList", defaultUserList);
                break;
        }

        // Truyền tab hiện tại xuống JSP để highlight menu
        request.setAttribute("activeTab", tab);

        // Trỏ về đúng tên file jsp của bạn (giả sử tên file là admin-manage.jsp)
        request.getRequestDispatcher("/admin-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // ĐÃ TẮT KIỂM TRA ĐĂNG NHẬP ĐỂ TEST CHO NHANH
        /*
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null || !"ADMIN".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        */

        // Nhận action và tab hiện tại từ các Form
        String action = request.getParameter("action");
        String currentTab = request.getParameter("tab");
        if (currentTab == null) currentTab = "users";

        if ("toggleUserStatus".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDao.toggleUserStatus(userId);
            request.getSession().setAttribute("message", "Cập nhật trạng thái người dùng thành công!");

        } else if ("deleteProduct".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            productDao.deleteProduct(productId);
            request.getSession().setAttribute("message", "Đã xóa sản phẩm thành công!");

        } else if ("cancelOrder".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            // Set trạng thái "CANCELLED" cho đơn hàng
            orderDao.updateOrderStatus(orderId, "CANCELLED");
            request.getSession().setAttribute("message", "Đã hủy đơn hàng thành công!");
        }

        // Chuyển hướng lại trang admin quản lý cùng với tab đang đứng
        response.sendRedirect(request.getContextPath() + "/admin/manage?tab=" + currentTab);
    }
}