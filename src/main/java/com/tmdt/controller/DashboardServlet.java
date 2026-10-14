package com.tmdt.controller;

import com.google.gson.Gson;
import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardData;
import com.tmdt.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Dashboard Thống kê (khu vực Admin). URL: /admin/dashboard
 * Tham số GET (đều tùy chọn): from, to (yyyy-MM-dd), status, page.
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final DashboardService dashboardService = new DashboardService();
    private final Gson gson = new Gson();   // Gson mặc định escape <,>,&,' nên an toàn khi nhúng vào <script>

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ĐÃ TẮT KIỂM TRA ĐĂNG NHẬP ĐỂ TEST CHO NHANH - giống AdminManageServlet hiện có.
        // Khi nhóm bật lại phân quyền Admin, mở khối dưới (cùng cách AdminManageServlet dùng):
        /*
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");
        if (acc == null || !"ADMIN".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        */

        DashboardData data;
        try {
            data = dashboardService.load(
                    request.getParameter("from"),
                    request.getParameter("to"),
                    request.getParameter("status"),
                    request.getParameter("page"));
        } catch (Exception e) {
            // Lỗi DB/SQL: ghi log, hiển thị trạng thái trống kèm thông báo (không đưa dữ liệu giả).
            getServletContext().log("Dashboard load failed", e);
            data = dashboardService.empty("Không tải được dữ liệu Dashboard.");
        }

        request.setAttribute("dash", data);
        request.setAttribute("chartJson", buildChartJson(data));
        request.setAttribute("activeTab", "dashboard");
        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
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
}
