package com.tmdt.controller;

import com.tmdt.Dao.DashboardDao;
import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardStats;
import com.tmdt.Model.DashboardTransaction;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDao dashboardDao = new DashboardDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra quyền Admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy bộ lọc thời gian & phân trang
        String timeFrame = request.getParameter("timeFrame"); // day, week, month, year
        if (timeFrame == null || timeFrame.isBlank()) timeFrame = "day";

        LocalDate to = LocalDate.now();
        LocalDate from = to.minusDays(30); // Mặc định xem 30 ngày gần nhất

        String statusFilter = request.getParameter("status");
        int page = 1;
        int limit = 10;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException ignored) {}
        int offset = (page - 1) * limit;

        // 3. Truy vấn dữ liệu từ DashboardDao
        DashboardStats stats = dashboardDao.getStats(from, to);
        List<DashboardChartPoint> chartPoints = dashboardDao.getEscrowValueByTimeFrame(timeFrame, from, to);
        List<DashboardCategoryShare> categoryShares = dashboardDao.getCategoryShares(from, to);
        List<DashboardTransaction> transactions = dashboardDao.getRecentTransactions(statusFilter, limit, offset);
        long totalTx = dashboardDao.countTransactions(statusFilter);

        // 4. Đưa dữ liệu sang JSP
        request.setAttribute("stats", stats);
        request.setAttribute("chartPoints", chartPoints);
        request.setAttribute("categoryShares", categoryShares);
        request.setAttribute("transactions", transactions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalTx / limit));
        request.setAttribute("selectedTimeFrame", timeFrame);
        request.setAttribute("activeTab", "dashboard");

        // FIX LỖI 404: Forward chính xác đến admin-manage.jsp
        request.getRequestDispatcher("/admin-manage.jsp").forward(request, response);
    }
}