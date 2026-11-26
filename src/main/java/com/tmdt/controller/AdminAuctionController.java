package com.tmdt.controller;

import com.tmdt.Dao.AuctionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminAuctionController", urlPatterns = {"/admin/auctions"})
public class AdminAuctionController extends HttpServlet {
    private final AuctionDao auctionDao = new AuctionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> auctionList = auctionDao.getAllAuctionsForAdmin();

        long totalAuctions = auctionList.size();
        long ongoingCount = auctionList.stream().filter(a -> "ONGOING".equals(a.get("status"))).count();
        long endedCount = auctionList.stream().filter(a -> "ENDED".equals(a.get("status"))).count();

        request.setAttribute("auctionList", auctionList);
        request.setAttribute("totalAuctions", totalAuctions);
        request.setAttribute("ongoingCount", ongoingCount);
        request.setAttribute("endedCount", endedCount);
        request.setAttribute("activeTab", "auctions");

        // SỬA DÒNG NÀY: Trỏ đúng vào file layout Admin của bạn
        request.getRequestDispatcher("/admin-tabs/_manage.jsp").forward(request, response);
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