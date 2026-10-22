package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProfileController", value = "/profile")
public class ProfileController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UserService userService = new UserService();

        User currentUser = userService.findById(loginUser.getId());

        if (currentUser != null) {
            session.setAttribute("user", currentUser);
        }

        request.getRequestDispatcher("/my-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }


        String fullName = request.getParameter("full_name");
        String phoneNumber = request.getParameter("phone_number");
        String address = request.getParameter("address");


        loginUser.setFull_name(fullName);
        loginUser.setPhone_number(phoneNumber);
        loginUser.setAddress(address);

       UserService userService = new UserService();
        boolean success = userService.updateProfile(loginUser);

        if (success) {

            session.setAttribute("user", loginUser);
            request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("errorMessage", "Cập nhật thất bại, vui lòng thử lại.");
        }


        request.getRequestDispatcher("/my-profile.jsp").forward(request, response);
    }
}

