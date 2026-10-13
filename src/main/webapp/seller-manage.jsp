<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kênh Người Bán - MangaZ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

<!-- Header Include -->
<jsp:include page="includes/header.jsp" />

<div class="container my-5">
    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <h2 class="fw-bold"><i class="fas fa-store text-danger me-2"></i>Kênh Người Bán</h2>
        </div>
        <div class="col-md-6 text-md-end">
            <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#addProductModal">
                <i class="fas fa-plus me-1"></i> Đăng bán truyện mới
            </button>
        </div>
    </div>

    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'products' ? 'active fw-bold' : 'text-dark'}" href="seller-manage?action=products">Sản phẩm của tôi</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'orders' ? 'active fw-bold' : 'text-dark'}" href="seller-manage?action=orders">Đơn hàng cần xử lý</a>
        </li>
    </ul>

    <div class="bg-white p-4 border rounded shadow-sm">
        <c:choose>
            <%-- TAB: SẢN PHẨM --%>
            <c:when test="${activeTab == 'products'}">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên Truyện</th>
                        <th>Giá bán</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${sellerProducts}">
                        <tr>
                            <td>
                                <c:choose>
                                    <%-- Nếu có URL ảnh được lưu trong database --%>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="${p.imageUrl}" alt="${p.title}" class="w-[50px] h-[70px] object-cover rounded border border-gray-200" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <%-- Icon dự phòng: Sẽ tự động hiện lên nhờ javascript ở 'onerror' phía trên nếu link ảnh bị chết --%>
                                        <div class="w-[50px] h-[70px] bg-orange-200 rounded border border-orange-300 items-center justify-center" style="display: none;">
                                            <i class="fas fa-book text-gray-800 text-xl"></i>
                                        </div>
                                    </c:when>

                                    <%-- Nếu sản phẩm hoàn toàn không có URL ảnh --%>
                                    <c:otherwise>
                                        <div class="w-[50px] h-[70px] bg-orange-200 rounded border border-orange-300 flex items-center justify-center">
                                            <i class="fas fa-book text-gray-800 text-xl"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="fw-bold">${p.title}</td>
                            <td class="text-danger fw-semibold">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 'ACTIVE'}"><span class="badge bg-success">Đang hiển thị</span></c:when>
                                    <c:when test="${p.status == 'HIDDEN'}"><span class="badge bg-secondary">Đã ẩn</span></c:when>
                                    <c:otherwise><span class="badge bg-warning text-dark">${p.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <!-- Nút Sửa -->
                                <a href="seller-manage?action=edit&id=${p.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i> Sửa
                                </a>

                                <!-- Nút Ẩn/Hiện -->
                                <form action="seller-manage" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="toggle-status">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn btn-sm ${p.status == 'ACTIVE' ? 'btn-outline-warning' : 'btn-outline-success'}">
                                        <i class="fas ${p.status == 'ACTIVE' ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                            ${p.status == 'ACTIVE' ? 'Ẩn' : 'Hiện'}
                                    </button>
                                </form>

                                <!-- Nút XÓA MỀM -->
                                <form action="seller-manage" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sellerProducts}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">Bạn chưa đăng bán sản phẩm nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </c:when>

            <%-- TAB: ĐƠN HÀNG --%>
            <c:when test="${activeTab == 'orders'}">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Người Mua</th>
                        <th>Sản phẩm</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${sellerOrders}">
                        <tr>
                            <td class="fw-bold">#ORD-${o.id}</td>
                            <td>${o.buyerName}</td>
                            <td>${o.productTitle}</td>
                            <td class="text-danger fw-semibold">
                                <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> đ
                            </td>
                            <td>
                                <span class="badge ${o.status == 'PENDING' ? 'bg-warning text-dark' : 'bg-primary'}">${o.status}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sellerOrders}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">Chưa có đơn hàng nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </c:when>
        </c:choose>
    </div>
</div>

<!-- Modal Thêm Sản Phẩm -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="seller-manage" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Đăng Bán Truyện</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên truyện</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Giá bán (VNĐ)</label>
                        <input type="number" name="price" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đường dẫn Hình ảnh (URL)</label>
                        <input type="text" name="image" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Đăng Bán</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Footer Include -->
<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>