package com.tmdt.controller;

import com.tmdt.Dao.AuctionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AuctionController", urlPatterns = {"/auctions"})
public class AuctionController extends HttpServlet {
    private final AuctionDao auctionDao = new AuctionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // Lấy danh sách đấu giá đang diễn ra (ONGOING) và đã duyệt
        request.setAttribute("auctionList", auctionDao.getActiveAuctions());
        request.getRequestDispatcher("/auctions.jsp").forward(request, response);
    }
}