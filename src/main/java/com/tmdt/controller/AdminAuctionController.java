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

        // Tính toán KPI cho các thẻ thống kê
        long totalAuctions = auctionList.size();
        long ongoingCount = auctionList.stream().filter(a -> "ONGOING".equals(a.get("status"))).count();
        long endedCount = auctionList.stream().filter(a -> "ENDED".equals(a.get("status"))).count();

        // Gửi dữ liệu sang JSP
        request.setAttribute("auctionList", auctionList);
        request.setAttribute("totalAuctions", totalAuctions);
        request.setAttribute("ongoingCount", ongoingCount);
        request.setAttribute("endedCount", endedCount);

        // QUAN TRỌNG: Đánh dấu tab đang chọn và forward về layout chính
        request.setAttribute("activeTab", "auctions");
        request.getRequestDispatcher("/admin-manage.jsp").forward(request, response);
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
        // Sau khi xử lý xong, quay lại chính trang này
        response.sendRedirect(request.getContextPath() + "/admin/auctions");
    }
}