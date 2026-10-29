
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
import com.tmdt.Model.User;
import com.tmdt.service.DashboardService;
import com.tmdt.Dao.CategoryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "AdminManageServlet", urlPatterns = {"/admin/manage"})
public class AdminManageServlet extends HttpServlet {

    private static final Set<String> TABS = Set.of(
            "dashboard",
            "users",
            "products",
            "orders",
            "content-review",
            "report-center",
            "support-center",
            "data-management",
            "categories"
    );

    private static final String DEFAULT_TAB = "dashboard";
    private final CategoryDao categoryDao = new CategoryDao();
    private final UserDao userDao = new UserDao();
    private final ProductDao productDao = new ProductDao();
    private final OrderDao orderDao = new OrderDao();
    private final ProductModerationDao productModerationDao =
            new ProductModerationDao();
    private final ReportDao reportDao = new ReportDao();
    private final SupportRequestDao supportRequestDao =
            new SupportRequestDao();
    private final DashboardService dashboardService =
            new DashboardService();
    private final Gson gson = new Gson();

    // =========================================================
    // GET: Tải dữ liệu và hiển thị tab quản trị
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String tab = normalizeTab(request.getParameter("tab"));

        try {
            switch (tab) {

                case "dashboard":
                    loadDashboard(request);
                    break;

                case "users":
                    request.setAttribute(
                            "userList",
                            userDao.getAllUsers()
                    );
                    break;

                case "products":
                    request.setAttribute(
                            "productList",
                            productDao.getAllProductsForAdmin()
                    );
                    break;

                case "orders":
                    request.setAttribute(
                            "orderList",
                            orderDao.getAllOrders()
                    );
                    break;

                case "content-review":
                    loadContentReview(request);
                    break;

                case "report-center":
                    loadReportCenter(request);
                    break;

                case "support-center":
                    loadSupportCenter(request);
                    break;
                case "data-management":
                    request.setAttribute(
                            "mangaList",
                            productDao.getAllProductsForAdmin()
                    );
                    break;

                case "categories":
                    request.setAttribute(
                            "categoryList",
                            categoryDao.getAllCategories()
                    );
                    break;

                default:
                    loadDashboard(request);
                    break;
            }

        } catch (Exception e) {
            getServletContext().log(
                    "Lỗi tải dữ liệu tab admin: " + tab,
                    e
            );

            request.setAttribute(
                    "adminError",
                    "Không thể tải dữ liệu. Vui lòng kiểm tra log của Tomcat."
            );

            if ("content-review".equals(tab)) {
                request.setAttribute("reviewLoadError", true);
                request.setAttribute(
                        "pendingProducts",
                        Collections.emptyList()
                );
                request.setAttribute("pendingCount", 0);
                request.setAttribute("approvedToday", 0);
                request.setAttribute("rejectedThisWeek", 0);
                request.setAttribute("successRate", 0);
            }

            if ("report-center".equals(tab)) {
                request.setAttribute(
                        "reports",
                        Collections.emptyList()
                );
                request.setAttribute("pendingCount", 0);
                request.setAttribute("resolvedCount", 0);
                request.setAttribute("dismissedCount", 0);
                request.setAttribute("totalReportCount", 0);
            }

            if ("support-center".equals(tab)) {
                request.setAttribute(
                        "tickets",
                        Collections.emptyList()
                );
                request.setAttribute("pendingCount", 0);
                request.setAttribute("inReviewCount", 0);
                request.setAttribute("resolvedCount", 0);
                request.setAttribute("totalTicketCount", 0);
            }

            if ("users".equals(tab)) {
                request.setAttribute(
                        "userList",
                        Collections.emptyList()
                );
            }

            if ("products".equals(tab)) {
                request.setAttribute(
                        "productList",
                        Collections.emptyList()
                );
            }

            if ("orders".equals(tab)) {
                request.setAttribute(
                        "orderList",
                        Collections.emptyList()
                );
            }
        }

        // Gửi tab đang chọn cho layout JSP.
        request.setAttribute("activeTab", tab);

        // Forward đến layout quản trị mới có sidebar.
        request.getRequestDispatcher(
                "/admin-tabs/_manage.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // Kiểm duyệt bài đăng
    // =========================================================

    private void loadContentReview(HttpServletRequest request) {

        /*
         * Chẩn đoán database mà ứng dụng thực sự kết nối.
         * Xem dòng [ADMIN CONTENT REVIEW] trong log Tomcat.
         */
        try {
            String diagnostic =
                    productModerationDao.getPendingDiagnostic();

            getServletContext().log(
                    "[ADMIN CONTENT REVIEW] " + diagnostic
            );

        } catch (Exception e) {
            getServletContext().log(
                    "Không lấy được thông tin chẩn đoán kiểm duyệt.",
                    e
            );
        }

        // Danh sách bài đang chờ duyệt.
        request.setAttribute(
                "pendingProducts",
                productModerationDao.getPendingProducts()
        );

        // Các thẻ thống kê.
        request.setAttribute(
                "pendingCount",
                productModerationDao.countPending()
        );

        request.setAttribute(
                "approvedToday",
                productModerationDao.countApprovedToday()
        );

        request.setAttribute(
                "rejectedThisWeek",
                productModerationDao.countRejectedThisWeek()
        );

        request.setAttribute(
                "successRate",
                productModerationDao.getApprovalRateThisWeek()
        );

        // Chi tiết bài đăng nếu quản trị viên chọn xem.
        String viewId = request.getParameter("viewId");

        if (viewId != null && !viewId.isBlank()) {
            try {
                int productId = Integer.parseInt(viewId.trim());

                request.setAttribute(
                        "selectedProduct",
                        productModerationDao.getById(productId)
                );

            } catch (NumberFormatException e) {
                request.setAttribute(
                        "adminError",
                        "Mã bài đăng không hợp lệ."
                );
            }
        }
    }

    // =========================================================
    // Trung tâm báo cáo
    // =========================================================

    private void loadReportCenter(HttpServletRequest request) {

        request.setAttribute(
                "reports",
                reportDao.getAllReports()
        );

        request.setAttribute(
                "pendingCount",
                reportDao.countPending()
        );

        request.setAttribute(
                "resolvedCount",
                reportDao.countResolved()
        );

        request.setAttribute(
                "dismissedCount",
                reportDao.countDismissed()
        );

        request.setAttribute(
                "totalReportCount",
                reportDao.countAll()
        );
    }

    // =========================================================
    // Hỗ trợ khách hàng
    // =========================================================

    private void loadSupportCenter(HttpServletRequest request) {

        request.setAttribute(
                "tickets",
                supportRequestDao.getAllTickets()
        );

        request.setAttribute(
                "pendingCount",
                supportRequestDao.countPending()
        );

        request.setAttribute(
                "inReviewCount",
                supportRequestDao.countInReview()
        );

        request.setAttribute(
                "resolvedCount",
                supportRequestDao.countResolved()
        );

        request.setAttribute(
                "totalTicketCount",
                supportRequestDao.countAll()
        );
    }

    // =========================================================
    // POST: Xử lý thao tác của quản trị viên
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String tab = normalizeTab(request.getParameter("tab"));
        String action = request.getParameter("action");

        HttpSession session = request.getSession();

        try {
            switch (tab) {

                case "users":
                    handleUsers(request, session, action);
                    break;

                case "products":
                case "data-management":
                    handleProducts(request, session, action);
                    break;
                case "categories":
                    handleCategories(request, session, action);
                    break;
                case "orders":
                    handleOrders(request, session, action);
                    break;

                case "content-review":
                    handleContentReviewPost(request, session, action);
                    break;

                case "report-center":
                    handleReports(request, session, action);
                    break;

                case "support-center":
                    handleSupport(request, session);
                    break;

                default:
                    session.setAttribute(
                            "adminError",
                            "Thao tác quản trị không hợp lệ."
                    );
                    break;
            }

        } catch (NumberFormatException e) {
            session.setAttribute(
                    "adminError",
                    "Mã ID không hợp lệ."
            );

        } catch (Exception e) {
            getServletContext().log(
                    "Lỗi xử lý POST tab=" + tab
                            + ", action=" + action,
                    e
            );

            session.setAttribute(
                    "adminError",
                    "Đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng kiểm tra log."
            );
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage?tab="
                        + tab
        );
    }

    // =========================================================
    // Quản lý người dùng
    // =========================================================

    private void handleUsers(
            HttpServletRequest request,
            HttpSession session,
            String action
    ) {

        if ("toggleUserStatus".equals(action)) {

            String idParam = request.getParameter("userId");

            if (idParam == null || idParam.isBlank()) {
                session.setAttribute(
                        "adminError",
                        "Thiếu mã người dùng."
                );
                return;
            }

            boolean updated = userDao.toggleUserStatus(
                    Integer.parseInt(idParam.trim())
            );

            session.setAttribute(
                    updated ? "adminSuccess" : "adminError",
                    updated
                            ? "Cập nhật trạng thái người dùng thành công."
                            : "Không thể cập nhật tài khoản này."
            );
        }
    }

    // =========================================================
    // Quản lý sản phẩm
    // =========================================================

    private void handleProducts(
            HttpServletRequest request,
            HttpSession session,
            String action
    ) {

        if ("deleteProduct".equals(action)) {

            String idParam = request.getParameter("productId");

            if (idParam == null || idParam.isBlank()) {
                session.setAttribute(
                        "adminError",
                        "Thiếu mã sản phẩm."
                );
                return;
            }

            boolean deleted = productDao.deleteProduct(
                    Integer.parseInt(idParam.trim())
            );

            session.setAttribute(
                    deleted ? "adminSuccess" : "adminError",
                    deleted
                            ? "Đã gỡ bài đăng khỏi hệ thống."
                            : "Không thể gỡ bài đăng này."
            );
        }
    }

    // =========================================================
    // Quản lý đơn hàng
    // =========================================================

    private void handleOrders(
            HttpServletRequest request,
            HttpSession session,
            String action
    ) {

        if ("cancelOrder".equals(action)) {

            String idParam = request.getParameter("orderId");

            if (idParam == null || idParam.isBlank()) {
                session.setAttribute(
                        "adminError",
                        "Thiếu mã đơn hàng."
                );
                return;
            }

            boolean updated = orderDao.updateOrderStatus(
                    Integer.parseInt(idParam.trim()),
                    "CANCELLED"
            );

            session.setAttribute(
                    updated ? "adminSuccess" : "adminError",
                    updated
                            ? "Đã hủy đơn hàng."
                            : "Không thể hủy đơn hàng này."
            );
        }
    }

    // =========================================================
    // POST kiểm duyệt bài đăng
    // =========================================================

    private void handleContentReviewPost(
            HttpServletRequest request,
            HttpSession session,
            String action
    ) {

        String idParam = request.getParameter("productId");

        if (action == null || idParam == null || idParam.isBlank()) {
            session.setAttribute(
                    "adminError",
                    "Thiếu thông tin thao tác kiểm duyệt."
            );
            return;
        }

        int productId = Integer.parseInt(idParam.trim());
        String reason = request.getParameter("reason");

        switch (action) {

            case "approve": {
                boolean updated =
                        productModerationDao.approveProduct(productId);

                if (updated) {
                    session.setAttribute(
                            "adminSuccess",
                            "Đã duyệt bài đăng #MV-" + productId
                                    + ". Bài đăng đã được phép hiển thị."
                    );
                } else {
                    session.setAttribute(
                            "adminError",
                            "Bài đăng không còn ở trạng thái chờ duyệt "
                                    + "hoặc không tồn tại."
                    );
                }
                break;
            }

            case "reject": {
                if (reason == null || reason.trim().length() < 5) {
                    session.setAttribute(
                            "adminError",
                            "Vui lòng nhập lý do từ chối ít nhất 5 ký tự."
                    );
                    return;
                }

                boolean updated =
                        productModerationDao.rejectProduct(
                                productId,
                                reason.trim()
                        );

                session.setAttribute(
                        updated ? "adminSuccess" : "adminError",
                        updated
                                ? "Đã từ chối bài đăng #MV-" + productId + "."
                                : "Không thể từ chối bài đăng này. "
                                + "Hãy tải lại danh sách."
                );
                break;
            }

            case "requestEdit": {
                if (reason == null || reason.trim().length() < 5) {
                    session.setAttribute(
                            "adminError",
                            "Vui lòng nêu rõ nội dung cần chỉnh sửa."
                    );
                    return;
                }

                boolean updated =
                        productModerationDao.requestEdit(
                                productId,
                                reason.trim()
                        );

                session.setAttribute(
                        updated ? "adminSuccess" : "adminError",
                        updated
                                ? "Đã gửi yêu cầu chỉnh sửa bài đăng #MV-"
                                + productId + "."
                                : "Không thể gửi yêu cầu chỉnh sửa."
                );
                break;
            }

            default:
                session.setAttribute(
                        "adminError",
                        "Hành động kiểm duyệt không hợp lệ."
                );
                break;
        }
    }

    // =========================================================
    // Xử lý báo cáo
    // =========================================================

    private void handleReports(
            HttpServletRequest request,
            HttpSession session,
            String action
    ) {

        String reportIdParam = request.getParameter("reportId");

        if (reportIdParam == null || reportIdParam.isBlank()) {
            session.setAttribute(
                    "adminError",
                    "Thiếu mã báo cáo."
            );
            return;
        }

        if (!"resolve".equals(action) && !"dismiss".equals(action)) {
            session.setAttribute(
                    "adminError",
                    "Thao tác xử lý báo cáo không hợp lệ."
            );
            return;
        }

        int reportId = Integer.parseInt(reportIdParam.trim());

        String status;

        if ("resolve".equals(action)) {
            status = "RESOLVED";
        } else {
            status = "DISMISSED";
        }

        String adminNote = request.getParameter("adminNote");

        if (adminNote == null || adminNote.trim().isEmpty()) {
            adminNote = "Đã xử lý theo quy trình quản trị.";
        } else {
            adminNote = adminNote.trim();
        }

        // Lấy ID quản trị viên hiện đang đăng nhập.
        Object sessionUser = session.getAttribute("user");

        if (!(sessionUser instanceof User)) {
            sessionUser = session.getAttribute("account");
        }

        Integer adminId = null;

        if (sessionUser instanceof User) {
            User admin = (User) sessionUser;
            adminId = admin.getId();
        }

        boolean updated = reportDao.updateStatus(
                reportId,
                status,
                adminNote,
                adminId
        );

        if (updated) {
            session.setAttribute(
                    "adminSuccess",
                    "Đã cập nhật báo cáo #RP-" + reportId + "."
            );
        } else {
            session.setAttribute(
                    "adminError",
                    "Không thể cập nhật báo cáo. Báo cáo có thể không tồn tại "
                            + "hoặc đã được xử lý trước đó."
            );
        }
    }

    // =========================================================
    // Hỗ trợ khách hàng
    // =========================================================

    private void handleSupport(
            HttpServletRequest request,
            HttpSession session
    ) {

        String idParam = request.getParameter("ticketId");
        String status = request.getParameter("status");

        if (idParam == null || idParam.isBlank()
                || status == null || status.isBlank()) {

            session.setAttribute(
                    "adminError",
                    "Thiếu mã yêu cầu hoặc trạng thái."
            );
            return;
        }

        if (!status.matches(
                "PENDING|IN_REVIEW|RESOLVED|REJECTED|CLOSED"
        )) {
            session.setAttribute(
                    "adminError",
                    "Trạng thái yêu cầu không hợp lệ."
            );
            return;
        }

        int ticketId = Integer.parseInt(idParam.trim());

        String adminNote = request.getParameter("adminNote");

        if (adminNote == null || adminNote.trim().isEmpty()) {
            adminNote = "Xử lý theo quy trình hỗ trợ khách hàng.";
        }

        supportRequestDao.updateStatus(
                ticketId,
                status,
                adminNote.trim()
        );

        session.setAttribute(
                "adminSuccess",
                "Đã cập nhật yêu cầu #CS-" + ticketId + "."
        );
    }

    // =========================================================
    // Dashboard
    // =========================================================

    private void handleCategories(
            HttpServletRequest request,
            HttpSession session,
            String action
    ) {
        String name = request.getParameter("categoryName");

        try {
            if ("add".equals(action)) {
                if (name == null || name.trim().isEmpty()) {
                    session.setAttribute(
                            "adminError",
                            "Vui lòng nhập tên danh mục."
                    );
                    return;
                }

                if (categoryDao.addCategory(name)) {
                    session.setAttribute(
                            "adminSuccess",
                            "Thêm danh mục thành công."
                    );
                } else {
                    session.setAttribute(
                            "adminError",
                            "Không thể thêm danh mục."
                    );
                }

            } else if ("update".equals(action)) {
                String idParam = request.getParameter("categoryId");

                if (idParam == null || idParam.isBlank()
                        || name == null || name.trim().isEmpty()) {
                    session.setAttribute(
                            "adminError",
                            "Vui lòng kiểm tra mã và tên danh mục."
                    );
                    return;
                }

                boolean updated = categoryDao.updateCategory(
                        Integer.parseInt(idParam.trim()),
                        name
                );

                session.setAttribute(
                        updated ? "adminSuccess" : "adminError",
                        updated
                                ? "Cập nhật danh mục thành công."
                                : "Không tìm thấy danh mục cần cập nhật."
                );

            } else if ("delete".equals(action)) {
                String idParam = request.getParameter("categoryId");

                if (idParam == null || idParam.isBlank()) {
                    session.setAttribute(
                            "adminError",
                            "Thiếu mã danh mục."
                    );
                    return;
                }

                boolean deleted = categoryDao.deleteCategory(
                        Integer.parseInt(idParam.trim())
                );

                session.setAttribute(
                        deleted ? "adminSuccess" : "adminError",
                        deleted
                                ? "Đã xóa danh mục."
                                : "Không tìm thấy danh mục cần xóa."
                );

            } else {
                session.setAttribute(
                        "adminError",
                        "Thao tác danh mục không hợp lệ."
                );
            }

        } catch (NumberFormatException e) {
            session.setAttribute("adminError", "Mã danh mục không hợp lệ.");

        } catch (Exception e) {
            getServletContext().log("Lỗi quản lý danh mục.", e);

            session.setAttribute(
                    "adminError",
                    "Không thể thực hiện thao tác. "
                            + "Tên danh mục có thể đã tồn tại."
            );
        }
    }
    private void loadDashboard(HttpServletRequest request) {
        DashboardData data;

        try {
            data = dashboardService.load(
                    request.getParameter("from"),
                    request.getParameter("to"),
                    request.getParameter("status"),
                    request.getParameter("page")
            );
        } catch (Exception e) {
            getServletContext().log("Dashboard load failed", e);
            data = dashboardService.empty(
                    "Không tải được dữ liệu Dashboard."
            );
        }

        request.setAttribute("dash", data);
        request.setAttribute("chartJson", buildChartJson(data));
    }

    private String buildChartJson(DashboardData data) {

        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();

        if (data != null && data.getEscrowByDay() != null) {
            for (DashboardChartPoint point : data.getEscrowByDay()) {
                if (point.getValue() == null) {
                    continue;
                }

                String label = point.getDay() != null
                        ? point.getDay().toString()
                        : "";

                if (label.isEmpty()) {
                    continue;
                }

                labels.add(label);
                values.add(point.getValue().doubleValue());
            }
        }

        List<Map<String, Object>> categories = new ArrayList<>();

        if (data.getCategoryShares() != null) {
            for (DashboardCategoryShare category
                    : data.getCategoryShares()) {

                if (category.getName() == null
                        || category.getValue() == null) {
                    continue;
                }

                Map<String, Object> item = new LinkedHashMap<>();

                item.put("name", category.getName());
                item.put("value", category.getValue().doubleValue());
                item.put("percent", category.getPercent());

                categories.add(item);
            }
        }

        Map<String, Object> root = new LinkedHashMap<>();

        root.put("labels", labels);
        root.put("values", values);
        root.put("categories", categories);

        return gson.toJson(root);
    }

    // =========================================================
    // Chuẩn hóa tab để tránh chuyển hướng tới tab không hợp lệ
    // =========================================================

    private static String normalizeTab(String tab) {

        if (tab == null || tab.isBlank()) {
            return DEFAULT_TAB;
        }

        tab = tab.trim();

        if (TABS.contains(tab)) {
            return tab;
        }

        return DEFAULT_TAB;
    }
}
