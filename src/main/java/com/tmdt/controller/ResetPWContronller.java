package com.tmdt.controller;

import com.tmdt.service.UserService;
import com.tmdt.untils.PasswordValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "ResetPWContronller", value = "/reset-pw")
public class ResetPWContronller extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");

        // Kiểm tra token ngay khi người dùng bấm vào link mail
        if (token == null || token.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Liên kết đặt lại mật khẩu không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/forgot-pw");
            return;
        }

        UserService us = new UserService();
        String email = us.findEmailByToken(token.trim());
        if (email == null) {
            request.getSession().setAttribute("errorMessage", "Liên kết đặt lại mật khẩu đã hết hạn hoặc không tồn tại!");
            response.sendRedirect(request.getContextPath() + "/forgot-pw");
            return;
        }

        request.setAttribute("token", token.trim());
        request.getRequestDispatcher("/ResetPW.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String newPW = request.getParameter("new_password");
        String confirmPW = request.getParameter("confirm_new_password");
        String token = request.getParameter("token");

        PasswordValidator pv  = new PasswordValidator();
        UserService us = new UserService();

        // Giữ lại token trên form nếu gặp lỗi validate mật khẩu
        request.setAttribute("token", token);

        if (newPW == null || confirmPW == null || !newPW.equals(confirmPW)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/ResetPW.jsp").forward(request, response);
            return;
        }

        if (!pv.isValid(newPW)) {
            request.setAttribute("errorMessage", "Mật khẩu phải dài tối thiểu 9 ký tự, gồm ít nhất 1 chữ hoa và 1 chữ thường!");
            request.getRequestDispatcher("/ResetPW.jsp").forward(request, response);
            return;
        }

        if (token != null && !token.trim().isEmpty()) {
            String email = us.findEmailByToken(token.trim());

            if (email != null) {
                String hashedPassword = BCrypt.hashpw(newPW, BCrypt.gensalt(12));
                us.updatePassword(email, hashedPassword);

                // Chỉ dùng sendRedirect về /login (tránh lỗi duplicate response)
                request.getSession().setAttribute("message", "Đổi mật khẩu thành công! Bạn có thể đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        // Nếu token không hợp lệ hoặc đã qua sử dụng
        request.getSession().setAttribute("errorMessage", "Mã đặt lại mật khẩu không hợp lệ hoặc đã được sử dụng!");
        response.sendRedirect(request.getContextPath() + "/forgot-pw");
    }
}