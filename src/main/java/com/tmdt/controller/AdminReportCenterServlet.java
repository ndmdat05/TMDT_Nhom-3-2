package com.tmdt.controller;

import com.tmdt.Dao.ReportDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminReportCenterServlet", urlPatterns = {"/admin/report-center"})
public class AdminReportCenterServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("reports", reportDao.getAllReports());
        request.setAttribute("pendingCount", reportDao.countPending());
        request.setAttribute("resolvedCount", reportDao.countResolved());
        request.getRequestDispatcher("/report-center.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String redirect = request.getContextPath() + "/admin/report-center";
        try {
            String reportIdParam = request.getParameter("reportId");
            if (reportIdParam == null || reportIdParam.isBlank()) {
                response.sendRedirect(redirect);
                return;
            }
            int reportId = Integer.parseInt(reportIdParam.trim());
            String action = request.getParameter("action");
            String status = "RESOLVED";
            if ("dismiss".equals(action)) {
                status = "DISMISSED";
            }
            String adminNote = request.getParameter("adminNote");
            if (adminNote == null || adminNote.trim().isEmpty()) {
                adminNote = "Đã xử lý theo quy trình quản trị";
            }
            reportDao.updateStatus(reportId, status, adminNote, 1);
        } catch (NumberFormatException e) {
            // ID không hợp lệ
        }
        response.sendRedirect(redirect);
    }
}
