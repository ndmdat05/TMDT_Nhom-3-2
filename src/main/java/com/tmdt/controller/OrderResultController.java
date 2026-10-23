package com.tmdt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "OrderResultController", urlPatterns = {"/order-result"})
public class OrderResultController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("success".equals(action)) {
            // Thanh toán xong -> Xóa sạch giỏ hàng trong session
            session.removeAttribute("cart");
            request.getRequestDispatcher("/order-success.jsp").forward(request, response);
        } else {
            // Thanh toán thất bại hoặc bấm hủy
            request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
        }
    }
}