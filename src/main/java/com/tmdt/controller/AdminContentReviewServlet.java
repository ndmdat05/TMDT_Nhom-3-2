package com.tmdt.controller;

import com.tmdt.Dao.ProductModerationDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(
        name = "AdminContentReviewServlet",
        urlPatterns = {"/admin/content-review"}
)
public class AdminContentReviewServlet extends HttpServlet {

    private final ProductModerationDao productModerationDao =
            new ProductModerationDao();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage?tab=content-review"
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String redirect = request.getContextPath()
                + "/admin/manage?tab=content-review";

        try {
            String action = request.getParameter("action");
            String productIdRaw = request.getParameter("productId");

            if (action == null
                    || productIdRaw == null
                    || productIdRaw.trim().isEmpty()) {

                request.getSession().setAttribute(
                        "adminError",
                        "Thông tin bài đăng không hợp lệ."
                );

                response.sendRedirect(redirect);
                return;
            }

            int productId = Integer.parseInt(productIdRaw.trim());

            String reason = request.getParameter("reason");

            if (reason == null || reason.trim().isEmpty()) {
                reason = "Đã xử lý bởi quản trị viên";
            }

            switch (action) {
                case "approve":
                    productModerationDao.approveProduct(productId);
                    break;

                case "reject":
                    productModerationDao.rejectProduct(productId, reason);
                    break;

                case "requestEdit":
                    productModerationDao.requestEdit(productId, reason);
                    break;

                default:
                    throw new IllegalArgumentException(
                            "Thao tác kiểm duyệt không hợp lệ."
                    );
            }

            request.getSession().setAttribute(
                    "adminSuccess",
                    "Đã xử lý bài đăng thành công."
            );

        } catch (NumberFormatException e) {
            request.getSession().setAttribute(
                    "adminError",
                    "Mã bài đăng không hợp lệ."
            );

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute(
                    "adminError",
                    e.getMessage()
            );

        } catch (Exception e) {
            getServletContext().log(
                    "Lỗi xử lý kiểm duyệt bài đăng.",
                    e
            );

            request.getSession().setAttribute(
                    "adminError",
                    "Không thể xử lý bài đăng. Vui lòng thử lại."
            );
        }

        response.sendRedirect(redirect);
    }
}