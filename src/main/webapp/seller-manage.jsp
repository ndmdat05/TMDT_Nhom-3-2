<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kênh Người Bán - MangaZ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* FIX: Ép modal body cuộn được khi nội dung dài */
        .modal-dialog-scrollable .modal-body {
            max-height: calc(100vh - 200px);
            overflow-y: auto;
        }
    </style>
</head>
<body class="bg-light">

<jsp:include page="includes/header.jsp" />

<!-- FLASH MESSAGES -->
<div class="container mt-3">
    <c:if test="${not empty sessionScope.sellerFlash_success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-circle-check me-2"></i>
            <c:out value="${sessionScope.sellerFlash_success}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="sellerFlash_success" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.sellerFlash_error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-circle-exclamation me-2"></i>
            <c:out value="${sessionScope.sellerFlash_error}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="sellerFlash_error" scope="session"/>
    </c:if>
</div>

<div class="container my-4">
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

    <!-- TABS -->
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'products' ? 'active fw-bold' : 'text-dark'}" href="seller-manage?action=products">Sản phẩm của tôi</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'orders' ? 'active fw-bold' : 'text-dark'}" href="seller-manage?action=orders">Đơn hàng cần xử lý</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'cancelled' ? 'active fw-bold text-danger' : 'text-dark'}" href="seller-manage?action=cancelled">Đơn hủy</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'refunds' ? 'active fw-bold text-warning' : 'text-dark'}" href="seller-manage?action=refunds">Đơn hoàn trả</a>
        </li>
    </ul>

    <div class="bg-white p-4 border rounded shadow-sm">
        <c:choose>
            <%-- TAB SẢN PHẨM --%>
            <c:when test="${activeTab == 'products'}">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 80px;">Hình ảnh</th>
                        <th>Tên Truyện</th>
                        <th>Giá bán</th>
                        <th style="min-width: 240px;">Trạng thái & Ghi chú</th>
                        <th class="text-end" style="min-width: 220px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${sellerProducts}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="${p.imageUrl}" alt="${p.title}" class="w-[50px] h-[70px] object-cover rounded border border-gray-200" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="w-[50px] h-[70px] bg-orange-200 rounded border border-orange-300 items-center justify-center" style="display: none;"><i class="fas fa-book text-gray-800 text-xl"></i></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-[50px] h-[70px] bg-orange-200 rounded border border-orange-300 flex items-center justify-center"><i class="fas fa-book text-gray-800 text-xl"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="fw-bold"><c:out value="${p.title}"/></td>
                            <td class="text-danger fw-semibold"><fmt:formatNumber value="${p.price}" pattern="#,###"/> đ</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 'APPROVED'}"><span class="badge bg-success">Đang hiển thị</span></c:when>
                                    <c:when test="${p.status == 'PENDING_APPROVAL'}"><span class="badge bg-warning text-dark"><i class="fas fa-clock me-1"></i>Chờ duyệt</span></c:when>
                                    <c:when test="${p.status == 'REJECTED'}">
                                        <span class="badge bg-danger"><i class="fas fa-circle-xmark me-1"></i>Bị từ chối</span>
                                        <c:if test="${not empty p.rejectionReason}">
                                            <div class="small text-danger mt-1 p-1 bg-red-50 rounded border border-red-100"><b>Lý do:</b> <c:out value="${p.rejectionReason}"/></div>
                                        </c:if>
                                    </c:when>
                                    <c:when test="${p.status == 'HIDDEN'}"><span class="badge bg-secondary"><i class="fas fa-eye-slash me-1"></i>Đang ẩn</span></c:when>
                                    <c:otherwise><span class="badge bg-dark">${p.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <a href="seller-manage?action=edit&id=${p.id}" class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i> Sửa</a>
                                <c:if test="${p.status == 'APPROVED' || p.status == 'HIDDEN'}">
                                    <form action="seller-manage" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="toggle-status">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button type="submit" class="btn btn-sm ${p.status == 'APPROVED' ? 'btn-outline-warning' : 'btn-outline-success'}">
                                            <i class="fas ${p.status == 'APPROVED' ? 'fa-eye-slash' : 'fa-eye'}"></i> ${p.status == 'APPROVED' ? 'Ẩn' : 'Hiện'}
                                        </button>
                                    </form>
                                </c:if>
                                <form action="seller-manage" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i> Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sellerProducts}">
                        <tr><td colspan="5" class="text-center text-muted py-5"><i class="fas fa-box-open fa-2x mb-2 text-secondary"></i><div>Bạn chưa đăng bán sản phẩm nào.</div></td></tr>
                    </c:if>
                    </tbody>
                </table>
            </c:when>

            <%-- TAB ĐƠN HÀNG --%>
            <c:when test="${activeTab == 'orders' or activeTab == 'cancelled' or activeTab == 'refunds'}">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th><th>Người Mua</th><th>Sản phẩm</th><th>Tổng tiền</th><th>Trạng thái</th><th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${sellerOrders}">
                        <tr>
                            <td class="fw-bold">#ORD-${not empty o.orderCode ? o.orderCode : o.id}</td>
                            <td>${not empty o.receiverName ? o.receiverName : o.buyerName}</td>
                            <td>${o.productTitle}</td>
                            <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> đ</td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'PENDING'}"><span class="badge bg-warning text-dark">PENDING</span></c:when>
                                    <c:when test="${o.status == 'CONFIRMED'}"><span class="badge bg-primary">CONFIRMED</span></c:when>
                                    <c:when test="${o.status == 'SHIPPING'}"><span class="badge bg-info text-dark">SHIPPING</span></c:when>
                                    <c:when test="${o.status == 'COMPLETED'}"><span class="badge bg-success">COMPLETED</span></c:when>
                                    <c:when test="${o.status == 'CANCELLED'}"><span class="badge bg-danger">CANCELLED</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${o.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <a href="seller-order-detail?id=${o.id}" class="btn btn-sm btn-outline-danger fw-semibold"><i class="fas fa-eye me-1"></i> Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sellerOrders}">
                        <tr><td colspan="6" class="text-center text-muted py-5"><i class="fas fa-box-open fa-2x mb-2 text-secondary"></i><div>Chưa có đơn hàng nào trong danh mục này.</div></td></tr>
                    </c:if>
                    </tbody>
                </table>
            </c:when>
        </c:choose>
    </div>
</div>

<!-- MODAL THÊM SẢN PHẨM (Đã thêm enctype và Upload ảnh) -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <!-- QUAN TRỌNG: enctype multipart/form-data để upload file -->
            <form action="seller-manage" method="post" id="addProductForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>Đăng Bán Truyện</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <!-- NHÓM 1 -->
                    <h6 class="fw-bold text-danger border-bottom pb-2 mb-3"><i class="fas fa-book me-1"></i> Thông tin cơ bản</h6>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên truyện <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required maxlength="255" placeholder="VD: One Piece - Tập 1 (Bản in đầu 2003)">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Thể loại</label>
                            <select name="categoryId" class="form-select">
                                <option value="">-- Chọn thể loại --</option>
                                <c:forEach var="c" items="${categoryList}">
                                    <option value="${c.id}"><c:out value="${c.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Nhà xuất bản</label>
                            <select name="brandId" class="form-select">
                                <option value="">-- Chọn NXB --</option>
                                <c:forEach var="b" items="${brandList}">
                                    <option value="${b.id}"><c:out value="${b.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- NHÓM 2 -->
                    <h6 class="fw-bold text-danger border-bottom pb-2 mb-3 mt-4"><i class="fas fa-info-circle me-1"></i> Chi tiết ấn phẩm</h6>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Tên bộ truyện (Series)</label>
                            <input type="text" name="seriesName" class="form-control" maxlength="255" placeholder="VD: One Piece">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Tác giả</label>
                            <input type="text" name="author" class="form-control" maxlength="255" placeholder="VD: Eiichiro Oda">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-semibold">Tập số</label>
                            <input type="number" name="volumeNumber" class="form-control" min="1" placeholder="VD: 1">
                        </div>
                        <div class="col-md-8 mb-3">
                            <label class="form-label fw-semibold">Phiên bản</label>
                            <input type="text" name="edition" class="form-control" maxlength="100" placeholder="VD: Bản in đầu 2003">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Tình trạng <span class="text-danger">*</span></label>
                            <select name="itemCondition" class="form-select" required>
                                <option value="NEW">Mới 100% (Nguyên seal)</option>
                                <option value="LIKE_NEW">Like New (Sưu tầm)</option>
                                <option value="USED">Đã qua sử dụng</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Ngôn ngữ</label>
                            <select name="language" class="form-select">
                                <option value="Tiếng Việt">Tiếng Việt</option>
                                <option value="Tiếng Nhật">Tiếng Nhật</option>
                                <option value="Tiếng Anh">Tiếng Anh</option>
                            </select>
                        </div>
                    </div>

                    <!-- NHÓM 3 -->
                    <h6 class="fw-bold text-danger border-bottom pb-2 mb-3 mt-4"><i class="fas fa-tag me-1"></i> Giá & Tồn kho</h6>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" name="price" class="form-control" required min="0" step="1000" placeholder="VD: 450000">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Số lượng trong kho</label>
                            <input type="number" name="stockQuantity" class="form-control" min="0" value="1">
                        </div>
                    </div>

                    <!-- NHÓM 4: UPLOAD ẢNH -->
                    <h6 class="fw-bold text-danger border-bottom pb-2 mb-3 mt-4"><i class="fas fa-image me-1"></i> Ảnh & Mô tả</h6>
                    <div class="mb-3 p-3 bg-light rounded border">
                        <label class="form-label fw-semibold d-block mb-1">Ảnh bìa</label>

                        <div class="mb-2">
                            <label class="small text-muted mb-1">Tải ảnh lên từ máy (Khuyên dùng)</label>
                            <!-- Input File Upload -->
                            <input type="file" name="imageFile" class="form-control" accept="image/*" onchange="previewImage(event)">
                        </div>

                        <div class="text-center my-2 text-muted small">--- HOẶC ---</div>

                        <div class="mb-2">
                            <label class="small text-muted mb-1">Dán URL ảnh</label>
                            <input type="text" name="imageUrl" class="form-control" placeholder="https://...">
                        </div>

                        <!-- Khung xem trước ảnh -->
                        <div class="mt-2 text-center">
                            <img id="imagePreview" src="" alt="Preview" class="img-thumbnail d-none" style="max-height: 150px;">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mô tả sản phẩm</label>
                        <textarea name="description" class="form-control" rows="4" maxlength="5000" placeholder="Mô tả tình trạng thực tế: gáy sách, mép bìa, ố vàng, có seal không..."></textarea>
                    </div>

                    <div class="alert alert-info py-2 small mb-0">
                        <i class="fas fa-info-circle me-1"></i> Bài đăng sẽ ở trạng thái <b>Chờ duyệt</b> cho đến khi Admin phê duyệt.
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"><i class="fas fa-paper-plane me-1"></i> Gửi duyệt</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPT XEM TRƯỚC ẢNH KHI CHỌN FILE -->
<script>
    function previewImage(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('imagePreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.remove('d-none');
            }
            reader.readAsDataURL(file);
        } else {
            preview.src = "";
            preview.classList.add('d-none');
        }
    }
</script>
</body>
</html>