package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.service.UserService;
import com.tmdt.untils.EmailUntils;
import com.tmdt.untils.PasswordValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "RegisterContronller", value = "/register")
public class RegisterContronller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/Register.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullname =  request.getParameter("fullname");
        String username = request.getParameter("username");
        String email= request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        UserService us = new UserService();
        PasswordValidator pv = new PasswordValidator();

        request.setAttribute("fullname", fullname);
        request.setAttribute("username", username);
        request.setAttribute("email", email);

        boolean existsUsername = us.existsByUsername(username);
        if(existsUsername){
            request.setAttribute("errorMessage", "Tên người dùng đã tồn tại!");

            request.getRequestDispatcher("/Register.jsp").forward(request, response);
            return ;
        }
        boolean existsEmail = us.existsByEmail(email);
        if(existsEmail){
            request.setAttribute("errorMessage", "Email đã tồn tại!");
            request.getRequestDispatcher("/Register.jsp").forward(request, response);
            return ;
        }

        if(!password.equals(confirmPassword)){
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/Register.jsp").forward(request, response);
            return ;
        }
        if(!pv.isValid(password)){
            request.setAttribute("errorMessage", "Mật khẩu phải dài tối thiểu 9 ký tự, gồm ít nhất 1 chữ hoa và 1 chữ thường!");
            request.getRequestDispatcher("/Register.jsp").forward(request, response);
            return ;
        }
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));



        String token = UUID.randomUUID().toString();
        User u = new User(fullname,username,email,hashedPassword,"BUYER",false,token,"LOCAL","ACTIVE");
        boolean isSaved = us.addUser(u);
        if (isSaved) {
            String verifyLink = "http://localhost:8080" + request.getContextPath() + "/verify-account?token=" + token;

            String emailContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
                    + "<h3>Cảm ơn bạn đã đăng ký tài khoản tại Manga Nè!</h3>"
                    + "<p>Vui lòng bấm vào nút bên dưới để kích hoạt tài khoản:</p>"
                    + "<div style='margin: 20px 0;'>"
                    + "    <a href='" + verifyLink + "' style='background-color: #ff4757; color: #ffffff; padding: 12px 24px; text-decoration: none; font-weight: bold; border-radius: 6px; display: inline-block;'>Xác thực ngay</a>"
                    + "</div>"
                    + "<p style='font-size: 13px; color: #888;'>Nếu không phải bạn đăng ký, vui lòng bỏ qua email này.</p>"
                    + "</div>";
            try {
                EmailUntils.sendMail(email, "Xác nhận tài khoản Manga Nè", emailContent);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.setAttribute("message", "Đăng ký thành công! Vui lòng kiểm tra email để xác nhận.");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        }
    else {

        request.setAttribute("errorMessage", "Đăng ký thất bại!");
        request.getRequestDispatcher("/Register.jsp").forward(request, response);
    }
    }
}
