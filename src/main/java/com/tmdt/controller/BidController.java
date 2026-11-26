package com.tmdt.controller;

import com.tmdt.Dao.AuctionDao;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "BidController", urlPatterns = {"/place-bid"})
public class BidController extends HttpServlet {
    private final AuctionDao auctionDao = new AuctionDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int auctionId = Integer.parseInt(request.getParameter("auctionId"));
            double bidAmount = Double.parseDouble(request.getParameter("bidAmount"));

            String result = auctionDao.placeBid(auctionId, user.getId(), bidAmount);

            if ("SUCCESS".equals(result)) {
                session.setAttribute("message", "Đặt giá thành công! Bạn đang là người dẫn đầu.");
            } else {
                session.setAttribute("errorMessage", result); // Gửi lỗi sang JSP
            }
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Dữ liệu đặt giá không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}