package com.tmdt.controller;

import com.tmdt.Model.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    // Hiển thị trang thanh toán
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getTotalQuantity() == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    // Nhận thông tin từ form checkout -> Chuyển sang Cổng thanh toán
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // 1. Nhận thông tin người nhận (chưa lưu DB, tạm giữ trong session)
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        session.setAttribute("order_name", fullName);
        session.setAttribute("order_phone", phone);
        session.setAttribute("order_address", address);

        // 2. Tạo mã đơn hàng mẫu (#MGV-XXXXXX)
        int randomNum = (int) (100000 + Math.random() * 900000);
        String orderCode = "#MGV-" + randomNum;
        session.setAttribute("order_code", orderCode);

        // 3. Chuyển hướng sang Controller của cổng thanh toán
        response.sendRedirect(request.getContextPath() + "/payment-gateway");
    }
}