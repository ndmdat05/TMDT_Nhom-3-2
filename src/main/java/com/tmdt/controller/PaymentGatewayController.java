package com.tmdt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "PaymentGatewayController", urlPatterns = {"/payment-gateway"})
public class PaymentGatewayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Kiểm tra nếu chưa qua bước checkout thì đá về giỏ hàng
        if (session.getAttribute("order_code") == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Chuyển tiếp ra giao diện cổng quét mã QR
        request.getRequestDispatcher("/payment-gateway.jsp").forward(request, response);
    }
}