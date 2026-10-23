package com.tmdt.controller;

import com.tmdt.Dao.ProductModerationDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminContentReviewServlet", urlPatterns = {"/admin/content-review"})
public class AdminContentReviewServlet extends HttpServlet {
    private final ProductModerationDao productModerationDao = new ProductModerationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("pendingProducts", productModerationDao.getPendingProducts());
        request.setAttribute("pendingCount", productModerationDao.countPending());
        request.setAttribute("approvedToday", productModerationDao.countApprovedToday());
        request.setAttribute("rejectedThisWeek", productModerationDao.countRejectedThisWeek());
        request.getRequestDispatcher("/content-approval.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String redirect = request.getContextPath() + "/admin/content-review";
        try {
            String action = request.getParameter("action");
            String productIdParam = request.getParameter("productId");
            if (action == null || productIdParam == null || productIdParam.isBlank()) {
                response.sendRedirect(redirect);
                return;
            }
            int productId = Integer.parseInt(productIdParam.trim());
            String reason = request.getParameter("reason");

            switch (action) {
                case "approve":
                    productModerationDao.approveProduct(productId);
                    break;
                case "reject":
                    productModerationDao.rejectProduct(productId, reason != null ? reason : "Từ chối bởi admin");
                    break;
                case "requestEdit":
                    productModerationDao.requestEdit(productId, reason != null ? reason : "Cần chỉnh sửa thông tin");
                    break;
                default:
                    break;
            }
        } catch (NumberFormatException e) {
            // ID không hợp lệ → bỏ qua, redirect an toàn
        }
        response.sendRedirect(redirect);
    }
}
