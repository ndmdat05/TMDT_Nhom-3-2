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
import java.util.List;

@WebServlet(name = "SellerManageServlet", urlPatterns = {"/seller-manage"})
public class SellerManageServlet extends HttpServlet {

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

        if (acc == null || (!"SELLER".equalsIgnoreCase(acc.getRole()) && !"ADMIN".equalsIgnoreCase(acc.getRole()))) {
            response.sendRedirect("login");
            return;
        }
        */

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "products";
        }

        if ("edit".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDao.getProductById(productId);
            request.setAttribute("product", product);
            request.getRequestDispatcher("/seller-edit-product.jsp").forward(request, response);
            return;
        }

        // MOCK DATA: Gắn cứng dữ liệu của người bán (Tương ứng với "nguyenvana" trong dữ liệu mẫu)
        int sellerId = 1;                     // Thay cho: acc.getId();
        String sellerName = "nguyenvana";     // Thay cho: acc.getUsername();

        // Lấy danh sách sản phẩm & đơn hàng dựa theo user giả lập
        List<Product> sellerProducts = productDao.getProductsBySellerId(sellerId);
        List<Order> sellerOrders = orderDao.getOrdersBySellerName(sellerName);

        if (sellerOrders == null || sellerOrders.isEmpty()) {
            sellerOrders = orderDao.getOrdersBySellerId(sellerId);
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

        // ĐÃ TẮT KIỂM TRA ĐĂNG NHẬP ĐỂ TEST CHO NHANH
        /*
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null || (!"SELLER".equalsIgnoreCase(acc.getRole()) && !"ADMIN".equalsIgnoreCase(acc.getRole()))) {
            response.sendRedirect("login");
            return;
        }
        */

        String action = request.getParameter("action");

        // Gắn cứng ID và Name để test thêm dữ liệu giả lập
        int testSellerId = 1;
        String testSellerName = "nguyenvana";

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
            p.setSellerId(testSellerId);      // Thay cho: acc.getId()
            p.setSellerName(testSellerName);  // Thay cho: acc.getUsername()
            p.setStatus("ACTIVE");

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