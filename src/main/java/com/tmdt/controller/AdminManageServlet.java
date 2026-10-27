package com.tmdt.controller;

import com.google.gson.Gson;
import com.tmdt.Dao.OrderDao;
import com.tmdt.Dao.ProductDao;
import com.tmdt.Dao.ProductModerationDao;
import com.tmdt.Dao.ReportDao;
import com.tmdt.Dao.SupportRequestDao;
import com.tmdt.Dao.UserDao;
import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardData;
import com.tmdt.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Servlet duy nhất cho toàn bộ khu Admin: /admin/manage?tab=...
 * tab = dashboard | users | products | orders | content-review | report-center | support-center
 */
@WebServlet(name = "AdminManageServlet", urlPatterns = {"/admin/manage"})
public class AdminManageServlet extends HttpServlet {

    private static final Set<String> TABS = Set.of(
            "dashboard", "users", "products", "orders",
            "content-review", "report-center", "support-center");
    private static final String DEFAULT_TAB = "dashboard";

    private final UserDao userDao = new UserDao();
    private final ProductDao productDao = new ProductDao();
    private final OrderDao orderDao = new OrderDao();
    private final ProductModerationDao productModerationDao = new ProductModerationDao();
    private final ReportDao reportDao = new ReportDao();
    private final SupportRequestDao supportRequestDao = new SupportRequestDao();
    private final DashboardService dashboardService = new DashboardService();
    private final Gson gson = new Gson();   // mặc định escape <,>,&,' nên an toàn khi nhúng vào <script>

    // ======================= GET =======================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ĐÃ TẮT KIỂM TRA ĐĂNG NHẬP ĐỂ TEST CHO NHANH (bật lại khi cần):
        /*
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null || !"ADMIN".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        */

        String tab = normalizeTab(request.getParameter("tab"));

        switch (tab) {
            case "dashboard":
                loadDashboard(request);
                break;
            case "users":
                request.setAttribute("userList", userDao.getAllUsers());
                break;
            case "products":
                request.setAttribute("productList", productDao.getAllProducts());
                break;
            case "orders":
                request.setAttribute("orderList", orderDao.getAllOrders());
                break;
            case "content-review":
                request.setAttribute("pendingProducts", productModerationDao.getPendingProducts());
                request.setAttribute("pendingCount", productModerationDao.countPending());
                request.setAttribute("approvedToday", productModerationDao.countApprovedToday());
                request.setAttribute("rejectedThisWeek", productModerationDao.countRejectedThisWeek());
                break;
            case "report-center":
                request.setAttribute("reports", reportDao.getAllReports());
                request.setAttribute("pendingCount", reportDao.countPending());
                request.setAttribute("resolvedCount", reportDao.countResolved());
                break;
            case "support-center":
                request.setAttribute("tickets", supportRequestDao.getAllTickets());
                request.setAttribute("pendingCount", supportRequestDao.countPending());
                request.setAttribute("inReviewCount", supportRequestDao.countInReview());
                break;
            default:
                break;
        }

        request.setAttribute("activeTab", tab);
        // admin-manage.jsp = layout chung, tự include fragment theo activeTab
        request.getRequestDispatcher("/admin-manage.jsp").forward(request, response);
    }

    // ======================= POST =======================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // ĐÃ TẮT KIỂM TRA ĐĂNG NHẬP ĐỂ TEST CHO NHANH (bật lại cùng chỗ doGet).

        String tab = normalizeTab(request.getParameter("tab"));
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            switch (tab) {
                case "users":
                    handleUsers(request, session, action);
                    break;
                case "products":
                    handleProducts(request, session, action);
                    break;
                case "orders":
                    handleOrders(request, session, action);
                    break;
                case "content-review":
                    handleContentReview(request, session, action);
                    break;
                case "report-center":
                    handleReports(request, session, action);
                    break;
                case "support-center":
                    handleSupport(request, session);
                    break;
                default:
                    break;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("adminError", "Mã (ID) không hợp lệ.");
        }

        // Quay lại đúng tab đang đứng (tab đã được whitelist nên an toàn)
        response.sendRedirect(request.getContextPath() + "/admin/manage?tab=" + tab);
    }

    // ---------- users / products / orders (giữ nguyên hành vi cũ) ----------
    private void handleUsers(HttpServletRequest req, HttpSession session, String action) {
        if ("toggleUserStatus".equals(action)) {
            userDao.toggleUserStatus(Integer.parseInt(req.getParameter("userId")));
            session.setAttribute("message", "Cập nhật trạng thái người dùng thành công!");
        }
        // LƯU Ý: form "deleteUser" trong JSP trước đây cũng chưa được servlet xử lý.
        // Khi UserDao có hàm xóa mềm, thêm vào đây: else if ("deleteUser".equals(action)) { ... }
    }

    private void handleProducts(HttpServletRequest req, HttpSession session, String action) {
        if ("deleteProduct".equals(action)) {
            productDao.deleteProduct(Integer.parseInt(req.getParameter("productId")));
            session.setAttribute("message", "Đã xóa sản phẩm thành công!");
        }
    }

    private void handleOrders(HttpServletRequest req, HttpSession session, String action) {
        if ("cancelOrder".equals(action)) {
            orderDao.updateOrderStatus(Integer.parseInt(req.getParameter("orderId")), "CANCELLED");
            session.setAttribute("message", "Đã hủy đơn hàng thành công!");
        }
    }

    // ---------- kiểm duyệt bài đăng ----------
    private void handleContentReview(HttpServletRequest req, HttpSession session, String action) {
        String idParam = req.getParameter("productId");
        if (action == null || idParam == null || idParam.isBlank()) return;
        int productId = Integer.parseInt(idParam.trim());
        String reason = req.getParameter("reason");

        switch (action) {
            case "approve":
                productModerationDao.approveProduct(productId);
                session.setAttribute("adminSuccess", "Đã duyệt bài đăng #MV-" + productId);
                break;
            case "reject":
                productModerationDao.rejectProduct(productId, reason != null ? reason : "Từ chối bởi admin");
                session.setAttribute("adminSuccess", "Đã từ chối bài đăng #MV-" + productId);
                break;
            case "requestEdit":
                productModerationDao.requestEdit(productId, reason != null ? reason : "Cần chỉnh sửa thông tin");
                session.setAttribute("adminSuccess", "Đã yêu cầu chỉnh sửa bài đăng #MV-" + productId);
                break;
            default:
                break;
        }
    }

    // ---------- báo cáo ----------
    private void handleReports(HttpServletRequest req, HttpSession session, String action) {
        String idParam = req.getParameter("reportId");
        if (idParam == null || idParam.isBlank()) return;
        int reportId = Integer.parseInt(idParam.trim());

        String status = "dismiss".equals(action) ? "DISMISSED" : "RESOLVED";
        String adminNote = req.getParameter("adminNote");
        if (adminNote == null || adminNote.trim().isEmpty()) {
            adminNote = "Đã xử lý theo quy trình quản trị";
        }
        reportDao.updateStatus(reportId, status, adminNote, 1);
        session.setAttribute("adminSuccess", "Đã cập nhật báo cáo #RP-" + reportId);
    }

    // ---------- hỗ trợ khách hàng ----------
    private void handleSupport(HttpServletRequest req, HttpSession session) {
        String idParam = req.getParameter("ticketId");
        String status = req.getParameter("status");
        if (idParam == null || idParam.isBlank() || status == null || status.isBlank()) return;
        if (!status.matches("PENDING|IN_REVIEW|RESOLVED|REJECTED|CLOSED")) return;

        int ticketId = Integer.parseInt(idParam.trim());
        String adminNote = req.getParameter("adminNote");
        if (adminNote == null || adminNote.trim().isEmpty()) {
            adminNote = "Xử lý theo hỗ trợ khách hàng";
        }
        supportRequestDao.updateStatus(ticketId, status, adminNote);
        session.setAttribute("adminSuccess", "Đã cập nhật yêu cầu #CS-" + ticketId);
    }

    // ---------- dashboard (chuyển từ DashboardServlet cũ) ----------
    private void loadDashboard(HttpServletRequest request) {
        DashboardData data;
        try {
            data = dashboardService.load(
                    request.getParameter("from"),
                    request.getParameter("to"),
                    request.getParameter("status"),
                    request.getParameter("page"));
        } catch (Exception e) {
            getServletContext().log("Dashboard load failed", e);
            data = dashboardService.empty("Không tải được dữ liệu Dashboard.");
        }
        request.setAttribute("dash", data);
        request.setAttribute("chartJson", buildChartJson(data));
    }

    /** JSON cho dashboard.js: chỉ chứa dữ liệu thật từ Service (rỗng nếu chưa có). */
    private String buildChartJson(DashboardData data) {
        List<String> days = new ArrayList<>();
        List<Double> values = new ArrayList<>();
        for (DashboardChartPoint p : data.getEscrowByDay()) {
            if (p.getDay() == null || p.getValue() == null) continue;
            days.add(p.getDay().toString());
            values.add(p.getValue().doubleValue());
        }
        List<Map<String, Object>> cats = new ArrayList<>();
        for (DashboardCategoryShare c : data.getCategoryShares()) {
            if (c.getName() == null || c.getValue() == null) continue;
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("name", c.getName());
            m.put("value", c.getValue().doubleValue());
            m.put("percent", c.getPercent());
            cats.add(m);
        }
        Map<String, Object> root = new LinkedHashMap<>();
        root.put("days", days);
        root.put("values", values);
        root.put("categories", cats);
        return gson.toJson(root);
    }

    private static String normalizeTab(String tab) {
        if (tab == null) return DEFAULT_TAB;
        tab = tab.trim();
        return TABS.contains(tab) ? tab : DEFAULT_TAB;
    }
}
