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
        String email = request.getParameter("email");
        UserService us = new UserService();

        if (!us.existsByEmail(email)) {
            request.setAttribute("errorMessage", "Email này chưa được đăng ký !");
            request.getRequestDispatcher("/ForgotPW.jsp").forward(request, response);
            return;
        }
        String resetToken = UUID.randomUUID().toString();
        boolean isTokenUpdated = us.updateResetToken(email, resetToken);

        if (isTokenUpdated) {
            String resetLink = "http://localhost:8080" + request.getContextPath() + "/reset-pw?token=" + resetToken;

            String emailContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
                    + "<h3>Yêu cầu đặt lại mật khẩu - Manga Nè</h3>"
                    + "<p>Bạn vừa yêu cầu đặt lại mật khẩu. Vui lòng bấm vào nút bên dưới để tiến hành đổi mật khẩu mới:</p>"
                    + "<div style='margin: 20px 0;'>"
                    + "    <a href='" + resetLink + "' style='background-color: #ff4757; color: #ffffff; padding: 12px 24px; text-decoration: none; font-weight: bold; border-radius: 6px; display: inline-block;'>Đặt lại mật khẩu</a>"
                    + "</div>"
                    + "<p style='font-size: 13px; color: #888;'>Nếu bạn không gửi yêu cầu này, vui lòng bỏ qua email để đảm bảo an toàn.</p>"
                    + "</div>";

            try {
                EmailUntils.sendMail(email, "Yêu cầu đặt lại mật khẩu - Manga Nè", emailContent);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        request.getRequestDispatcher("/ForgotPW.jsp").forward(request, response);
    }
}
