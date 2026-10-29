
package com.tmdt.controller;

import com.tmdt.Model.DashboardData;
import com.tmdt.Model.User;
import com.tmdt.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardService dashboardService = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra quyền quản trị
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Nhận bộ lọc từ giao diện
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String status = request.getParameter("status");
        String page = request.getParameter("page");

        // 3. Nạp dữ liệu qua Service hiện có
        DashboardData dashboardData = dashboardService.load(
                from,
                to,
                status,
                page
        );

        // 4. Đưa dữ liệu sang JSP
        request.setAttribute("dashboardData", dashboardData);

        // Giữ các thuộc tính tương thích với phần giao diện cũ
        request.setAttribute("stats", dashboardData.getStats());
        request.setAttribute("chartPoints", dashboardData.getEscrowByDay());
        request.setAttribute("categoryShares", dashboardData.getCategoryShares());
        request.setAttribute("transactions", dashboardData.getTransactions());
        request.setAttribute("currentPage", dashboardData.getPage());
        request.setAttribute("totalPages", dashboardData.getTotalPages());
        request.setAttribute("selectedStatus", dashboardData.getStatusFilter());
        request.setAttribute("fromDate", dashboardData.getFrom());
        request.setAttribute("toDate", dashboardData.getTo());

        request.setAttribute("activeTab", "dashboard");

        request.getRequestDispatcher("/admin-tabs/_manage.jsp")
                .forward(request, response);
    }
}
