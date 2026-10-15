package com.tmdt.controller;

import com.tmdt.service.UserService;
import com.tmdt.untils.EmailUntils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ForgotPasswordContronller", value = "/forgot-pw")
public class ForgotPasswordContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/ForgotPW.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        UserService us = new UserService();

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập địa chỉ email!");
            request.getRequestDispatcher("/ForgotPW.jsp").forward(request, response);
            return;
        }

        // Cắt khoảng trắng thừa nếu có
        email = email.trim();

        if (!us.existsByEmail(email)) {
            request.setAttribute("errorMessage", "Email này chưa được đăng ký!");
            request.getRequestDispatcher("/ForgotPW.jsp").forward(request, response);
            return;
        }

        String resetToken = UUID.randomUUID().toString();
        boolean isTokenUpdated = us.updateResetToken(email, resetToken);

        if (isTokenUpdated) {
            String resetLink = "http://localhost:8080" + request.getContextPath() + "/reset-pw?token=" + resetToken;

            String emailContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
                    + "<h3>Yêu cầu đặt lại mật khẩu - MangaZ</h3>"
                    + "<p>Bạn vừa yêu cầu đặt lại mật khẩu. Vui lòng bấm vào nút bên dưới để tiến hành đổi mật khẩu mới:</p>"
                    + "<div style='margin: 20px 0;'>"
                    + "    <a href='" + resetLink + "' style='background-color: #ff4757; color: #ffffff; padding: 12px 24px; text-decoration: none; font-weight: bold; border-radius: 6px; display: inline-block;'>Đặt lại mật khẩu</a>"
                    + "</div>"
                    + "<p style='font-size: 13px; color: #888;'>Nếu bạn không gửi yêu cầu này, vui lòng bỏ qua email để đảm bảo an toàn.</p>"
                    + "</div>";

            try {
                EmailUntils.sendMail(email, "Yêu cầu đặt lại mật khẩu - MangaZ", emailContent);
                // THÊM DÒNG NÀY: Báo chữ màu xanh cho người dùng biết email đã gửi
                request.setAttribute("message", "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư!");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Không thể gửi email, vui lòng thử lại sau!");
            }
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        request.getRequestDispatcher("/ForgotPW.jsp").forward(request, response);
    }}