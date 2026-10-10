package com.tmdt.controller;

import com.tmdt.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet(name = "VerifyAccountController", value = "/verify-account")
public class VerifyAccountContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token != null && !token.trim().isEmpty()) {
            UserService us = new UserService();
            Integer userId = us.findUserIdByToken(token);

            if (userId != null) {
                us.activateUser(userId);

                request.getSession().setAttribute("message", "Xác thực tài khoản thành công! Bạn có thể đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        request.getSession().setAttribute("errorMessage", "Mã xác thực không hợp lệ hoặc đã được sử dụng!");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
