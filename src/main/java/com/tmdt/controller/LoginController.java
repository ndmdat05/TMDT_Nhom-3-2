package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "LoginContronller", value = "/login")
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       String  username = request.getParameter("username");
       String password = request.getParameter("password");


       UserService userService = new UserService();

       User user = userService.login(username, password);

       if(user!=null){
           if (!user.isIs_verified()) {
               request.setAttribute("errorMessage", "Tài khoản của bạn chưa được xác nhận Email. Vui lòng kiểm tra hộp thư!");
               request.getRequestDispatcher("/Login.jsp").forward(request, response);
               return;
           }
           if(user.getStatus().equals("LOCKED")){
               request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khoá!");
               request.getRequestDispatcher("/Login.jsp").forward(request, response);
               return;
           }

           request.getSession().setAttribute("user",user);
           response.sendRedirect(request.getContextPath() + "/home");
       }
       else{
           request.setAttribute("errorMessage", "Mật khẩu hoặc tên đăng nhập sai!");
           request.setAttribute("username", username);
           request.getRequestDispatcher("/Login.jsp").forward(request, response);
           return;
       }
    }
}

