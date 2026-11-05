package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Dao.ProductDao;
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
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "SellerManageServlet", urlPatterns = {"/seller-manage"})
public class SellerManageServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "products";
        }

        // Xử lý chỉnh sửa sản phẩm
        if ("edit".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDao.getProductById(productId);
            request.setAttribute("product", product);
            request.getRequestDispatcher("/seller-edit-product.jsp").forward(request, response);
            return;
        }

        // Lấy thông tin tài khoản đăng nhập (fallback về mock data nếu chưa login)
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            acc = (User) session.getAttribute("account");
        }

        int sellerId = 1;
        String sellerName = "nguyenvana";
        if (acc != null) {
            sellerId = acc.getId();
            sellerName = (acc.getUsername() != null && !acc.getUsername().isEmpty()) ? acc.getUsername() : "nguyenvana";
        }

        // 1. Lấy danh sách sản phẩm của Seller
        List<Product> sellerProducts = productDao.getProductsBySellerId(sellerId);

        // 2. Lấy toàn bộ đơn hàng của Seller từ CSDL
        List<Order> allOrders = orderDao.getOrdersBySellerId(sellerId);
        if (allOrders == null || allOrders.isEmpty()) {
            allOrders = orderDao.getOrdersBySellerName(sellerName);
        }
        if (allOrders == null) {
            allOrders = new ArrayList<>();
        }

        // 3. Phân loại đơn hàng theo từng Tab
        List<Order> sellerOrders;

        if ("cancelled".equalsIgnoreCase(action)) {
            // TAB 3: ĐƠN HỦY (Chỉ lấy các đơn CANCELLED)
            sellerOrders = allOrders.stream()
                    .filter(o -> o.getStatus() != null && "CANCELLED".equalsIgnoreCase(o.getStatus()))
                    .collect(Collectors.toList());

        } else if ("refunds".equalsIgnoreCase(action)) {
            // TAB 4: ĐƠN HOÀN TRẢ
            sellerOrders = allOrders.stream()
                    .filter(o -> (o.getStatus() != null && ("REFUND".equalsIgnoreCase(o.getStatus()) || "RETURNED".equalsIgnoreCase(o.getStatus())))
                            || (o.getPaymentStatus() != null && "REFUNDED".equalsIgnoreCase(o.getPaymentStatus())))
                    .collect(Collectors.toList());

        } else if ("orders".equalsIgnoreCase(action)) {
            // TAB 2: ĐƠN CẦN XỬ LÝ (PENDING, CONFIRMED, SHIPPING - Loại bỏ đơn hủy/hoàn)
            sellerOrders = allOrders.stream()
                    .filter(o -> o.getStatus() != null
                            && !"CANCELLED".equalsIgnoreCase(o.getStatus())
                            && !"REFUND".equalsIgnoreCase(o.getStatus())
                            && !"RETURNED".equalsIgnoreCase(o.getStatus()))
                    .collect(Collectors.toList());

        } else {
            // TAB 1: SẢN PHẨM CỦA TÔI
            sellerOrders = allOrders;
        }

        request.setAttribute("sellerProducts", sellerProducts);
        request.setAttribute("sellerOrders", sellerOrders);
        request.setAttribute("activeTab", action);

        request.getRequestDispatcher("/seller-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // Lấy đúng ID người bán từ session khi thao tác
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            acc = (User) session.getAttribute("account");
        }

        int currentSellerId = (acc != null) ? acc.getId() : 1;
        String currentSellerName = (acc != null && acc.getUsername() != null) ? acc.getUsername() : "nguyenvana";

        if ("add".equals(action)) {
            String title = request.getParameter("name");
            if (title == null) title = request.getParameter("title");

            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");

            String image = request.getParameter("image");
            if (image == null) image = request.getParameter("imageUrl");

            Product p = new Product();
            p.setTitle(title);
            p.setPrice(price);
            p.setDescription(description);
            p.setImageUrl(image);
            p.setSellerId(currentSellerId);
            p.setSellerName(currentSellerName);
            p.setStatus("PENDING_APPROVAL"); // Giữ trạng thái chờ duyệt

            productDao.addProduct(p);
            response.sendRedirect("seller-manage?action=products");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("name");
            if (title == null) title = request.getParameter("title");

            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");

            String image = request.getParameter("image");
            if (image == null) image = request.getParameter("imageUrl");

            Product p = new Product();
            p.setId(id);
            p.setTitle(title);
            p.setPrice(price);
            p.setDescription(description);
            p.setImageUrl(image);

            productDao.updateProduct(p);
            response.sendRedirect("seller-manage?action=products");

        } else if ("delete".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("id"));
            productDao.deleteProduct(productId);
            response.sendRedirect("seller-manage?action=products");

        } else if ("toggle-status".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("id"));
            productDao.toggleProductStatus(productId);
            response.sendRedirect("seller-manage?action=products");
        } else {
            response.sendRedirect("seller-manage");
        }
    }
}