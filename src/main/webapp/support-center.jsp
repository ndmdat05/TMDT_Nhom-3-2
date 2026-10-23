<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hỗ trợ khách hàng - MangaZ</title>
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
                <div class="brand-role">Support Staff</div>
            </div>
        </div>

        <nav class="menu-group">
            <div class="menu-heading">Quản trị</div>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=users" class="nav-item"><i class="fa-solid fa-user"></i> Người dùng</a>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=products" class="nav-item"><i class="fa-solid fa-book"></i> Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=orders" class="nav-item"><i class="fa-solid fa-truck"></i> Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/admin/content-review" class="nav-item"><i class="fa-solid fa-clipboard-check"></i> Kiểm duyệt bài đăng</a>
            <a href="${pageContext.request.contextPath}/admin/report-center" class="nav-item"><i class="fa-solid fa-shield-halved"></i> Báo cáo</a>
            <a href="${pageContext.request.contextPath}/admin/support-center" class="nav-item active"><i class="fa-solid fa-headset"></i> Hỗ trợ khách hàng</a>
        </nav>

        <div class="sidebar-footer">
            <button class="logout-btn">Báo cáo kiểm toán</button>
        </div>
    </aside>

    <main class="main-panel">
        <header class="topbar">
            <div class="search-box">Tìm kiếm yêu cầu hỗ trợ...</div>
            <div class="toolbar-actions">
                <button class="ghost-btn">Trang chủ</button>
                <button class="primary-btn">+ Đăng bài / Trade</button>
            </div>
        </header>

        <section class="page-title-box">
            <div class="title-label">Hệ thống quản trị</div>
            <h1>Quản lý khiếu nại & đổi trả / hoàn tiền</h1>
            <p>Hiển thị các yêu cầu hỗ trợ theo đơn hàng, thanh toán và hủy đơn hiện có trong hệ thống.</p>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Khởi tạo mới</span>
                <strong>${pendingCount}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Đang chờ xử lý</span>
                <strong>${inReviewCount}</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Đã hoàn tất</span>
                <strong>18</strong>
            </div>
            <div class="stat-card">
                <span class="stat-label">Vấn đề cần ưu tiên</span>
                <strong>5</strong>
            </div>
        </section>

        <section class="table-panel">
            <table>
                <thead>
                <tr>
                    <th>Mã yêu cầu</th>
                    <th>Khách hàng</th>
                    <th>Đơn hàng</th>
                    <th>Loại</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ticket" items="${tickets}">
                    <tr>
                        <td>#CS-${ticket.id}</td>
                        <td>${ticket.buyerName}</td>
                        <td>${ticket.orderCode}</td>
                        <td>${ticket.type}</td>
                        <td><span class="badge ${ticket.status == 'RESOLVED' ? 'success' : 'pending'}">${ticket.status}</span></td>
                        <td>
                            <div class="table-actions">
                                <form method="post" action="${pageContext.request.contextPath}/admin/support-center" style="display:inline;">
                                    <input type="hidden" name="ticketId" value="${ticket.id}">
                                    <input type="hidden" name="status" value="IN_REVIEW">
                                    <input type="hidden" name="adminNote" value="Đã tiếp nhận yêu cầu hỗ trợ và đang xác minh.">
                                    <button class="mini-btn success">Nhận xử lý</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/support-center" style="display:inline;">
                                    <input type="hidden" name="ticketId" value="${ticket.id}">
                                    <input type="hidden" name="status" value="RESOLVED">
                                    <input type="hidden" name="adminNote" value="Đã xác nhận và hoàn tất xử lý theo dữ liệu đơn hàng và thanh toán.">
                                    <button class="mini-btn neutral">Đánh dấu xong</button>
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
