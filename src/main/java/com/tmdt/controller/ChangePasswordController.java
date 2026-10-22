package com.tmdt.controller;

import com.tmdt.Dao.UserDao;
import com.tmdt.Model.User;
import com.tmdt.untils.PasswordValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "ChangePasswordController", value = "/change-password")
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
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

        String currentPassword = request.getParameter("current_password");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        UserDao userDao = new UserDao();
        User currentUser = userDao.findById(loginUser.getId());

        if (currentUser.getHash_password() == null || !BCrypt.checkpw(currentPassword, currentUser.getHash_password())) {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không chính xác!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        if (currentPassword.equals(newPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        PasswordValidator pv = new PasswordValidator();
        if (!pv.isValid(newPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu phải dài tối thiểu 9 ký tự, gồm ít nhất 1 chữ hoa và 1 chữ thường!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

        boolean success = userDao.updatePassword(currentUser.getEmail(), hashedNewPassword);

        if (success) {
            currentUser.setHash_password(hashedNewPassword);
            session.setAttribute("user", currentUser);
            request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("errorMessage", "Đổi mật khẩu thất bại, vui lòng thử lại sau.");
        }

        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }
}