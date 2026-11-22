package com.tmdt.controller;

import com.tmdt.Dao.AuctionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminAuctionController", urlPatterns = {"/admin/auctions"})
public class AdminAuctionController extends HttpServlet {
    private final AuctionDao auctionDao = new AuctionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("auctionList", auctionDao.getActiveAuctions());
        request.getRequestDispatcher("/admin-auctions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int auctionId = Integer.parseInt(request.getParameter("auctionId"));
        String result = auctionDao.closeAuction(auctionId);

        if ("SUCCESS".equals(result)) {
            request.getSession().setAttribute("adminSuccess", "Đã chốt phiên đấu giá và tạo đơn hàng thành công!");
        } else {
            request.getSession().setAttribute("adminError", result);
        }
        response.sendRedirect(request.getContextPath() + "/admin/auctions");
    }
}