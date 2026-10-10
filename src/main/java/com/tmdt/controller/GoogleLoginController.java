package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.service.UserService;
import com.tmdt.untils.GoogleUntils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "GoogleLoginController", value = "/google-login")
public class GoogleLoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Không nhận được mã đăng nhập từ Google."
            );

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        try {
            String accessToken = GoogleUntils.getToken(code);

            User googleUser =
                    GoogleUntils.getUserInfo(accessToken);

            UserService us = new UserService();

            User existingUser =
                    us.findByEmail(googleUser.getEmail());

            if (existingUser != null) {
                String provider = existingUser.getAuth_provider();

                if (provider == null
                        || "LOCAL".equalsIgnoreCase(provider)) {

                    request.getSession().setAttribute(
                            "errorMessage",
                            "Email này đã được sử dụng. "
                                    + "Vui lòng đăng nhập bằng tài khoản đã đăng ký."
                    );

                    response.sendRedirect(
                            request.getContextPath() + "/login"
                    );
                    return;
                }

                if ("GOOGLE".equalsIgnoreCase(provider)) {
                    if ("LOCKED".equalsIgnoreCase(
                            existingUser.getStatus())) {

                        request.getSession().setAttribute(
                                "errorMessage",
                                "Tài khoản của bạn đã bị khóa."
                        );

                        response.sendRedirect(
                                request.getContextPath() + "/login"
                        );
                        return;
                    }

                    request.getSession().setAttribute(
                            "user",
                            existingUser
                    );

                    response.sendRedirect(
                            request.getContextPath() + "/home"
                    );
                    return;
                }

                request.getSession().setAttribute(
                        "errorMessage",
                        "Phương thức đăng nhập không hợp lệ."
                );

                response.sendRedirect(
                        request.getContextPath() + "/login"
                );
                return;
            }

            boolean added = us.addUser(googleUser);

            if (!added) {
                throw new Exception(
                        "Không thể tạo tài khoản Google trong database."
                );
            }

            User user =
                    us.findByEmail(googleUser.getEmail());

            if (user == null) {
                throw new Exception(
                        "Không tìm thấy tài khoản Google vừa tạo."
                );
            }

            request.getSession().setAttribute("user", user);

            response.sendRedirect(
                    request.getContextPath() + "/home"
            );

        } catch (Exception e) {
            e.printStackTrace();

            request.getSession().setAttribute(
                    "errorMessage",
                    "Đăng nhập Google thất bại. Vui lòng thử lại."
            );

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
        }
    }
}