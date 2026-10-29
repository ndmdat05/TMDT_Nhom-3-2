package com.tmdt.controller;

import com.tmdt.Dao.SupportRequestDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(
        name = "AdminSupportTicketServlet",
        urlPatterns = {"/admin/support-center"}
)
public class AdminSupportTicketServlet extends HttpServlet {

    private final SupportRequestDao supportRequestDao =
            new SupportRequestDao();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage?tab=support-center"
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String redirect = request.getContextPath()
                + "/admin/manage?tab=support-center";

        try {
            String ticketIdRaw = request.getParameter("ticketId");
            String status = request.getParameter("status");

            if (ticketIdRaw == null || ticketIdRaw.trim().isEmpty()) {
                throw new IllegalArgumentException(
                        "Mã yêu cầu hỗ trợ không hợp lệ."
                );
            }

            int ticketId = Integer.parseInt(ticketIdRaw.trim());

            if (status == null
                    || !status.matches(
                    "PENDING|IN_REVIEW|RESOLVED|REJECTED|CLOSED")) {

                throw new IllegalArgumentException(
                        "Trạng thái hỗ trợ không hợp lệ."
                );
            }

            String adminNote = request.getParameter("adminNote");

            if (adminNote == null || adminNote.trim().isEmpty()) {
                adminNote = "Đã cập nhật yêu cầu hỗ trợ.";
            }

            supportRequestDao.updateStatus(
                    ticketId,
                    status,
                    adminNote
            );

            request.getSession().setAttribute(
                    "adminSuccess",
                    "Đã cập nhật yêu cầu hỗ trợ."
            );

        } catch (NumberFormatException e) {
            request.getSession().setAttribute(
                    "adminError",
                    "Mã yêu cầu hỗ trợ không hợp lệ."
            );

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute(
                    "adminError",
                    e.getMessage()
            );

        } catch (Exception e) {
            getServletContext().log(
                    "Lỗi xử lý yêu cầu hỗ trợ.",
                    e
            );

            request.getSession().setAttribute(
                    "adminError",
                    "Không thể cập nhật yêu cầu hỗ trợ."
            );
        }

        response.sendRedirect(redirect);
    }
}