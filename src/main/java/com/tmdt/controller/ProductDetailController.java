package com.tmdt.controller;

import com.tmdt.Dao.ProductDao;
import com.tmdt.Model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ProductDetailController", urlPatterns = {"/chi-tiet-san-pham"})
public class ProductDetailController extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. Nhận tham số id từ URL (?id=...)
        String idParam = request.getParameter("id");
        int productId = 1; //

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                productId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException e) {
                productId = 1;
            }
        }

        // 2. Lấy dữ liệu sản phẩm từ DAO
        Product product = productDao.getProductById(productId);

        // 3. Nếu id tìm không thấy, lấy sản phẩm id = 1
        if (product == null) {
            product = productDao.getProductById(1);
        }

        // 4. Gửi dữ liệu đối tượng product sang JSP
        request.setAttribute("product", product);

        // Chuyển tiếp tới TrangChiTiet.jsp
        request.getRequestDispatcher("/TrangChiTiet.jsp").forward(request, response);
    }
}