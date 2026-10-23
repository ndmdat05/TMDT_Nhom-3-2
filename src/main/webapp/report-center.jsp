<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo nội dung - MangaZ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-modules.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="admin-shell">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-mark">M</div>
            <div>
                <div class="brand-name">MangaVault Admin</div>
                <div class="brand-role">Content Manager</div>
            </div>
        </div>

        <nav class="menu-group">
            <div class="menu-heading">Quản trị</div>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=users" class="nav-item"><i class="fa-solid fa-user"></i> Người dùng</a>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=products" class="nav-item"><i class="fa-solid fa-book"></i> Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=orders" class="nav-item"><i class="fa-solid fa-truck"></i> Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin/content-review" class="nav-item"><i class="fa-solid fa-clipboard-check"></i> Kiểm duyệt bài đăng</a>
            <a href="${pageContext.request.contextPath}/admin/report-center" class="nav-item active"><i class="fa-solid fa-shield-halved"></i> Báo cáo</a>
            <a href="${pageContext.request.contextPath}/admin/support-center" class="nav-item"><i class="fa-solid fa-headset"></i> Hỗ trợ khách hàng</a>
        </nav>

        <div class="sidebar-footer">
            <button class="logout-btn">Báo cáo kiểm toán</button>
        </div>
    </aside>

    <main class="main-panel">
        <header class="topbar">
            <div class="search-box">Tìm kiếm báo cáo...</div>
            <div class="toolbar-actions">
                <button class="ghost-btn">Trang chủ</button>
                <button class="primary-btn">+ Đăng bài / Trade</button>
            </div>
        </header>

        <section class="page-title-box">
            <div class="title-label">Hệ thống quản trị</div>
            <h1>Xử lý báo cáo và bài viết khi cần</h1>
            <p>Danh sách báo cáo liên quan đến bài đăng, bình luận hoặc người dùng, kèm trạng thái xử lý.</p>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Báo cáo mới</span>
                <strong>${pendingCount}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Đã xử lý</span>
                <strong>${resolvedCount}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Tỷ lệ giải quyết</span>
                <strong>81%</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Khẩn cấp</span>
                <strong>4</strong>
            </div>
        </section>

        <section class="table-panel">
            <table>
                <thead>
                <tr>
                    <th>Mã báo cáo</th>
                    <th>Người báo cáo</th>
                    <th>Đối tượng</th>
                    <th>Lý do</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="report" items="${reports}">
                    <tr>
                        <td>#RP-${report.id}</td>
                        <td>${report.reporterName}</td>
                        <td>
                            <div class="content-cell">
                                <strong>${report.targetType}</strong>
                                <span>${report.targetTitle}</span>
                            </div>
                        </td>
                        <td>${report.reasonType}</td>
                        <td><span class="badge ${report.status == 'RESOLVED' ? 'success' : 'pending'}">${report.status}</span></td>
                        <td>
                            <div class="table-actions">
                                <form method="post" action="${pageContext.request.contextPath}/admin/report-center" style="display:inline;">
                                    <input type="hidden" name="reportId" value="${report.id}">
                                    <input type="hidden" name="action" value="resolve">
                                    <input type="hidden" name="adminNote" value="Đã kiểm tra và xử lý theo quy định nội dung.">
                                    <button class="mini-btn success">Giải quyết</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/report-center" style="display:inline;">
                                    <input type="hidden" name="reportId" value="${report.id}">
                                    <input type="hidden" name="action" value="dismiss">
                                    <input type="hidden" name="adminNote" value="Báo cáo không đủ căn cứ hoặc không vi phạm quy định.">
                                    <button class="mini-btn neutral">Bác bỏ</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
