package com.tmdt.controller;

import com.tmdt.Model.User;
import com.tmdt.Model.WalletTransaction;
import com.tmdt.db.JDBIConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "WalletController", urlPatterns = {"/wallet"})
public class WalletController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = (User) session.getAttribute("account");
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Tạo biến final userId để dùng an toàn trong Lambda expression
        final int userId = user.getId();

        // Lấy số dư ví hiện tại từ bảng users
        double balance = JDBIConnector.get().withHandle(handle ->
                handle.createQuery("SELECT COALESCE(wallet_balance, 0.0) FROM users WHERE id = :userId")
                        .bind("userId", userId)
                        .mapTo(Double.class)
                        .findOne()
                        .orElse(0.0)
        );

        // Lấy danh sách lịch sử biến động số dư ví
        List<WalletTransaction> transactions = JDBIConnector.get().withHandle(handle ->
                handle.createQuery("SELECT id, user_id AS userId, order_id AS orderId, amount, type, description, created_at AS createdAt "
                                + "FROM wallet_transactions WHERE user_id = :userId ORDER BY created_at DESC")
                        .bind("userId", userId)
                        .mapToBean(WalletTransaction.class)
                        .list()
        );

        request.setAttribute("balance", balance);
        request.setAttribute("transactions", transactions);
        request.getRequestDispatcher("/wallet.jsp").forward(request, response);
    }
}