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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String newPW = request.getParameter("new_password");
        String confirmPW = request.getParameter("confirm_new_password");
        String token = request.getParameter("token");

        PasswordValidator pv  = new PasswordValidator();
        UserService us = new UserService();

        if(!newPW.equals(confirmPW)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("ResetPW.jsp").forward(request, response);
            return;
        }

        if(!pv.isValid(newPW)){
            request.setAttribute("errorMessage", "Mật khẩu phải dài tối thiểu 9 ký tự, gồm ít nhất 1 chữ hoa và 1 chữ thường!");
            request.getRequestDispatcher("/Register.jsp").forward(request, response);
            return ;
        }


        if (token != null && !token.trim().isEmpty()) {
            String email = us.findEmailByToken(token);

            if (email != null) {
                String hashedPassword = BCrypt.hashpw(newPW, BCrypt.gensalt(12));
                us.updatePassword(email, hashedPassword);

                request.getSession().setAttribute("message", "Đổi mật khẩu thành công! Bạn có thể đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }
        request.getSession().setAttribute("message", "Đổi mật khẩu thành công! Bạn có thể đăng nhập ngay.");
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/ResetPW.jsp").forward(request, response);
    }
}
