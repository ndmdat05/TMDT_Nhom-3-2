package com.tmdt.controller;

import com.tmdt.Model.PurchaseHistoryData;
import com.tmdt.Model.User;
import com.tmdt.service.PurchaseHistoryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Trang Lịch sử & Theo dõi đơn hàng của người dùng. URL (truy cập trực tiếp): /order-history
 * Tham số GET (tùy chọn): q (mã đơn), status (ship | done | cancel | pay).
 */
@WebServlet(name = "PurchaseHistoryServlet", urlPatterns = {"/order-history"})
public class PurchaseHistoryServlet extends HttpServlet {

    /**
     * true  = bắt buộc đăng nhập (chưa đăng nhập -> chuyển về /login). Đây là hành vi đúng cho dữ liệu riêng của người dùng.
     * false = chỉ để xem thử giao diện khi chưa có DB/đăng nhập: không có userId nên Service trả về dữ liệu rỗng.
     */
    private static final boolean REQUIRE_LOGIN = true;

    private final PurchaseHistoryService purchaseHistoryService = new PurchaseHistoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Dùng đúng cơ chế session hiện có: LoginController lưu User vào session với key "user"
        // (header.jsp/AdminManageServlet đang đọc key "account" - nên đọc cả hai, không tạo cơ chế mới).
        User currentUser = findCurrentUser(request.getSession(false));
        if (currentUser == null && REQUIRE_LOGIN) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Integer userId = currentUser != null ? currentUser.getId() : null;

        PurchaseHistoryData data;
        try {
            data = purchaseHistoryService.load(userId, request.getParameter("q"), request.getParameter("status"));
        } catch (Exception e) {
            getServletContext().log("Purchase history load failed", e);
            data = new PurchaseHistoryData();
            data.setKeyword(request.getParameter("q") == null ? "" : request.getParameter("q").trim());
            data.setStatusFilter(request.getParameter("status") == null ? "" : request.getParameter("status").trim());
            request.setAttribute("errorMessage", "Không tải được lịch sử đơn hàng.");
        }

        request.setAttribute("history", data);
        request.getRequestDispatcher("/order-history.jsp").forward(request, response);
    }

    private User findCurrentUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        if (!(u instanceof User)) u = session.getAttribute("account");
        return (u instanceof User) ? (User) u : null;
    }
}
