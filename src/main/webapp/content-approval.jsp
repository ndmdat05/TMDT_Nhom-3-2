<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MangaZ Admin - Kiểm duyệt bài đăng</title>
    <link rel="stylesheet" href="${ctx}/css/admin-modules.css">
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
            <a href="${ctx}/admin/manage?tab=users" class="nav-item"><i class="fa-solid fa-user"></i> Người dùng</a>
            <a href="${ctx}/admin/manage?tab=products" class="nav-item"><i class="fa-solid fa-book"></i> Sản phẩm</a>
            <a href="${ctx}/admin/manage?tab=orders" class="nav-item"><i class="fa-solid fa-truck"></i> Đơn hàng</a>
            <a href="${ctx}/admin/content-review" class="nav-item active"><i class="fa-solid fa-clipboard-check"></i> Kiểm duyệt bài đăng</a>
            <a href="${ctx}/admin/report-center" class="nav-item"><i class="fa-solid fa-shield-halved"></i> Báo cáo</a>
            <a href="${ctx}/admin/support-center" class="nav-item"><i class="fa-solid fa-headset"></i> Hỗ trợ khách hàng</a>
        </nav>
        <div class="sidebar-footer">
            <a class="logout-btn" href="${ctx}/admin/dashboard">Báo cáo kiểm toán</a>
        </div>
    </aside>

    <main class="main-panel">
        <header class="topbar">
            <div class="search-box">Tìm kiếm truyện, bài đăng...</div>
            <div class="toolbar-actions">
                <a class="ghost-btn" href="${ctx}/home">Trang chủ</a>
                <a class="primary-btn" href="${ctx}/seller-manage">+ Đăng bài / Trade</a>
            </div>
        </header>

        <section class="page-title-box">
            <div class="title-label">Hệ thống quản trị</div>
            <h1>Kiểm duyệt bài đăng mới</h1>
            <p>Kiểm tra nội dung, tin nhắn và bài đăng trước khi hiển thị công khai.</p>
        </section>

        <c:if test="${not empty sessionScope.adminSuccess}">
            <div class="flash ok"><c:out value="${sessionScope.adminSuccess}"/></div>
            <c:remove var="adminSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.adminError}">
            <div class="flash err"><c:out value="${sessionScope.adminError}"/></div>
            <c:remove var="adminError" scope="session"/>
        </c:if>

        <section class="stats-grid">
            <div class="stat-card"><span class="stat-label">Chờ duyệt</span><strong>${pendingCount}</strong></div>
            <div class="stat-card"><span class="stat-label">Đã duyệt hôm nay</span><strong>${approvedToday}</strong></div>
            <div class="stat-card"><span class="stat-label">Bị từ chối (7 ngày)</span><strong>${rejectedThisWeek}</strong></div>
            <div class="stat-card"><span class="stat-label">Tỷ lệ xử lý đạt</span><strong>${successRate}%</strong></div>
        </section>

        <section class="table-panel">
            <div class="table-header-row">
                <div class="tab-group">
                    <button type="button" class="active tab-btn">Bài đăng chờ duyệt</button>
                </div>
            </div>
            <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Mã bài</th>
                    <th>Người đăng</th>
                    <th>Nội dung</th>
                    <th>Giá</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${pendingProducts}">
                    <tr>
                        <td>#MV-${item.id}</td>
                        <td><c:out value="${empty item.sellerName ? 'Không xác định' : item.sellerName}"/></td>
                        <td>
                            <div class="content-cell media">
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <img class="thumb" src="${item.imageUrl}" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="thumb placeholder">N/A</div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <strong><c:out value="${item.title}"/></strong>
                                    <span class="clamp"><c:out value="${item.description}"/></span>
                                </div>
                            </div>
                        </td>
                        <td><fmt:formatNumber value="${item.price}" pattern="#,##0"/> đ</td>
                        <td><span class="badge pending">Chờ duyệt</span></td>
                        <td>
                            <div class="table-actions">
                                <a class="mini-btn neutral" href="${ctx}/admin/content-review?viewId=${item.id}">Xem</a>
                                <form method="post" action="${ctx}/admin/content-review" class="once-form" style="display:inline;">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="productId" value="${item.id}">
                                    <button class="mini-btn success" type="submit">Duyệt</button>
                                </form>
                                <button type="button" class="mini-btn warn" data-id="${item.id}" data-title="<c:out value='${item.title}'/>" onclick="openRejectDialog(this)">Từ chối</button>
                                <button type="button" class="mini-btn neutral" data-id="${item.id}" data-title="<c:out value='${item.title}'/>" onclick="openEditDialog(this)">Yêu cầu chỉnh sửa</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pendingProducts}">
                    <tr><td colspan="6" class="empty-row">Không có bài đăng chờ duyệt.</td></tr>
                </c:if>
                </tbody>
            </table>
            </div>
        </section>

        <c:if test="${not empty selectedProduct}">
            <section class="detail-card">
                <h2>Chi tiết bài đăng #MV-${selectedProduct.id}</h2>
                <p><b>Người bán:</b> <c:out value="${selectedProduct.sellerName}"/></p>
                <p><b>Tiêu đề:</b> <c:out value="${selectedProduct.title}"/></p>
                <p><b>Giá:</b> <fmt:formatNumber value="${selectedProduct.price}" pattern="#,##0"/> đ</p>
                <p><b>Trạng thái:</b> <c:out value="${selectedProduct.status}"/></p>
                <p><b>Ngày tạo:</b> <c:out value="${selectedProduct.createdAt}"/></p>
                <p><b>Mô tả:</b> <c:out value="${selectedProduct.description}"/></p>
                <c:if test="${not empty selectedProduct.rejectionReason}">
                    <p><b>Lý do xử lý:</b> <c:out value="${selectedProduct.rejectionReason}"/></p>
                </c:if>
            </section>
        </c:if>
    </main>
</div>

<div class="modal" id="decisionModal" aria-hidden="true">
    <div class="modal-card">
        <div class="modal-header">
            <h3 id="modalTitle">Xử lý bài đăng</h3>
            <button type="button" class="close-btn" onclick="closeModal()">×</button>
        </div>
        <form method="post" action="${ctx}/admin/content-review" class="once-form">
            <input type="hidden" id="modalProductId" name="productId">
            <input type="hidden" id="modalAction" name="action">
            <label for="reasonInput">Lý do xử lý</label>
            <textarea id="reasonInput" name="reason" rows="5" required maxlength="1000"></textarea>
            <div class="modal-actions">
                <button type="button" class="ghost-btn" onclick="closeModal()">Hủy</button>
                <button type="submit" class="primary-btn">Xác nhận</button>
            </div>
        </form>
    </div>
</div>
<script src="${ctx}/js/admin-modules.js"></script>
</body>
</html>
