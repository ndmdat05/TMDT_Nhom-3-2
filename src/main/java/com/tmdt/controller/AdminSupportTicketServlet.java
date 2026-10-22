package com.tmdt.controller;

import com.tmdt.Dao.SupportRequestDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminSupportTicketServlet", urlPatterns = {"/admin/support-center"})
public class AdminSupportTicketServlet extends HttpServlet {
    private final SupportRequestDao supportRequestDao = new SupportRequestDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("tickets", supportRequestDao.getAllTickets());
        request.setAttribute("pendingCount", supportRequestDao.countPending());
        request.setAttribute("inReviewCount", supportRequestDao.countInReview());
        request.getRequestDispatcher("/support-center.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String redirect = request.getContextPath() + "/admin/support-center";
        try {
            String ticketIdParam = request.getParameter("ticketId");
            String status = request.getParameter("status");
            if (ticketIdParam == null || ticketIdParam.isBlank() || status == null || status.isBlank()) {
                response.sendRedirect(redirect);
                return;
            }
            int ticketId = Integer.parseInt(ticketIdParam.trim());
            if (!status.matches("PENDING|IN_REVIEW|RESOLVED|REJECTED|CLOSED")) {
                response.sendRedirect(redirect);
                return;
            }
            String adminNote = request.getParameter("adminNote");
            if (adminNote == null || adminNote.trim().isEmpty()) {
                adminNote = "Xử lý theo hỗ trợ khách hàng";
            }
            supportRequestDao.updateStatus(ticketId, status, adminNote);
        } catch (NumberFormatException e) {
            // ID không hợp lệ
        }
        response.sendRedirect(redirect);
    }
}
