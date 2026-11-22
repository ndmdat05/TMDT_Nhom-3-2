<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 11/3/2026
  Time: 3:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xử lý đơn hàng #${order.orderCode} - MangaZ Seller</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-[#f8f9fa] font-sans text-gray-800 flex flex-col min-h-screen justify-between">

<!-- Header Include -->
<jsp:include page="includes/header.jsp" />

<main class="container my-5 max-w-5xl flex-grow">

    <!-- QUAY LẠI KÊNH NGƯỜI BÁN -->
    <div class="d-flex align-items-center justify-content-between mb-4">
        <a href="seller-manage?action=orders" class="text-decoration-none text-muted fw-semibold small d-inline-flex align-items-center gap-2 hover:text-danger transition">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn hàng
        </a>
        <span class="badge bg-light text-dark border">Kênh Người Bán</span>
    </div>

    <!-- BANNER CẢNH BÁO: HIỂN THỊ KHI ĐƠN HÀNG BỊ HỦY -->
    <c:if test="${order.status == 'CANCELLED'}">
        <div class="alert alert-danger border-0 rounded-4 shadow-sm p-4 mb-4 d-flex align-items-start gap-3">
            <div class="w-10 h-10 rounded-circle bg-danger bg-opacity-10 text-danger d-flex align-items-center justify-content-center flex-shrink-0 mt-1">
                <i class="fas fa-ban fs-5"></i>
            </div>
            <div class="flex-grow-1">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
                    <h5 class="fw-bold mb-1 text-danger">Đơn hàng này đã bị hủy</h5>
                    <span class="badge bg-danger text-white rounded-pill px-3 py-1.5 font-monospace">CANCELLED</span>
                </div>
                <p class="mb-1 small text-dark mt-2">
                    <strong>Lý do từ người mua:</strong>
                    <span class="text-danger fw-bold ms-1">
                            ${not empty order.cancelReason ? order.cancelReason : 'Đổi ý không muốn mua nữa'}
                    </span>
                </p>
                <c:choose>
                    <c:when test="${order.paymentStatus == 'REFUNDED'}">
                        <p class="mb-0 text-muted small mt-1">
                            <i class="fas fa-circle-check text-success me-1"></i>
                            Đơn thanh toán trước đã được hoàn tiền vào Ví MangaVault của người mua và số lượng truyện đã được tự động hoàn lại kho.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p class="mb-0 text-muted small mt-1">
                            <i class="fas fa-circle-info text-secondary me-1"></i>
                            Đơn hàng COD chưa thanh toán. Số lượng truyện đã được hoàn lại kho.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

    <!-- KHỐI 1: TỔNG QUAN ĐƠN HÀNG & TRẠNG THÁI HIỆN TẠI -->
    <div class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4 md:p-5">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 border-bottom pb-4 mb-4">
                <div>
                    <div class="d-flex align-items-center gap-3 mb-1">
                        <h3 class="fw-bold mb-0 text-dark">
                            Đơn hàng #${not empty order.orderCode ? order.orderCode : order.id}
                        </h3>
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}">
                                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill font-monospace"><i class="fas fa-clock me-1"></i> PENDING (Chờ xác nhận)</span>
                            </c:when>
                            <c:when test="${order.status == 'CONFIRMED'}">
                                <span class="badge bg-primary px-3 py-2 rounded-pill font-monospace"><i class="fas fa-box me-1"></i> CONFIRMED (Đang đóng gói)</span>
                            </c:when>
                            <c:when test="${order.status == 'SHIPPING'}">
                                <span class="badge bg-info text-dark px-3 py-2 rounded-pill font-monospace"><i class="fas fa-truck-fast me-1"></i> SHIPPING (Đang giao hàng)</span>
                            </c:when>
                            <c:when test="${order.status == 'COMPLETED'}">
                                <span class="badge bg-success px-3 py-2 rounded-pill font-monospace"><i class="fas fa-check-double me-1"></i> COMPLETED (Hoàn tất)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger px-3 py-2 rounded-pill font-monospace"><i class="fas fa-ban me-1"></i> CANCELLED (Đã hủy)</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p class="text-muted small mb-0">Thời gian tạo: <span class="fw-semibold text-dark">${order.createdAt}</span></p>
                </div>

                <div>
                    <button onclick="window.print()" class="btn btn-outline-secondary btn-sm rounded-3">
                        <i class="fas fa-print me-1"></i> In phiếu đóng gói
                    </button>
                </div>
            </div>

            <!-- THÔNG TIN VẬN CHUYỂN & THANH TOÁN -->
            <div class="row g-4">
                <div class="col-md-6 border-end-md">
                    <h6 class="fw-bold text-uppercase text-muted text-xs tracking-wider mb-3">
                        <i class="fas fa-location-dot text-danger me-1"></i> Địa chỉ giao nhận
                    </h6>
                    <div class="space-y-1">
                        <p class="mb-1 fw-bold text-dark">${not empty order.receiverName ? order.receiverName : 'Người nhận chưa cập nhật'}</p>
                        <p class="mb-1 text-muted small"><i class="fas fa-phone text-secondary me-1.5"></i> ${not empty order.receiverPhone ? order.receiverPhone : '---'}</p>
                        <p class="text-muted small mb-0"><i class="fas fa-map-pin text-secondary me-1.5"></i> ${order.shippingAddress}</p>
                    </div>
                </div>

                <div class="col-md-6">
                    <h6 class="fw-bold text-uppercase text-muted text-xs tracking-wider mb-3">
                        <i class="fas fa-credit-card text-danger me-1"></i> Thanh toán & Vận chuyển
                    </h6>
                    <div class="space-y-1 small">
                        <p class="mb-1">
                            Phương thức: <b class="text-uppercase text-dark">${not empty order.paymentMethod ? order.paymentMethod : 'COD'}</b>
                        </p>
                        <p class="mb-1">
                            Trạng thái tiền:
                            <span class="fw-bold ${order.paymentStatus == 'PAID' ? 'text-success' : (order.paymentStatus == 'REFUNDED' ? 'text-danger' : 'text-warning')}">
                                ${not empty order.paymentStatus ? order.paymentStatus : 'UNPAID'}
                            </span>
                        </p>
                        <p class="mb-0 text-muted">
                            Mã vận đơn GHN: <b class="font-monospace text-primary">${not empty order.trackingNumber ? order.trackingNumber : 'Chờ shop bàn giao'}</b>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- KHỐI 2: SẢN PHẨM CẦN ĐÓNG GÓI -->
    <div class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4 md:p-5">
            <h5 class="fw-bold mb-4 text-dark d-flex align-items-center gap-2">
                <i class="fas fa-boxes-packing text-danger"></i> Danh sách truyện cần đóng gói
            </h5>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead class="table-light text-muted small text-uppercase">
                    <tr>
                        <th class="ps-2">Sản phẩm</th>
                        <th class="text-center">Số lượng</th>
                        <th class="text-end">Đơn giá</th>
                        <th class="text-end pe-2">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y">
                    <c:choose>
                        <c:when test="${not empty items}">
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td class="ps-2 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <c:set var="rawImg" value="${item.imageUrl}" />
                                            <c:set var="finalImg" value="${fn:startsWith(rawImg, 'http') ? rawImg : pageContext.request.contextPath.concat('/').concat(fn:startsWith(rawImg, '/') ? fn:substring(rawImg, 1, fn:length(rawImg)) : rawImg)}" />

                                            <img src="${finalImg}"
                                                 alt="${item.productTitle}"
                                                 onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=150';"
                                                 class="w-12 h-16 object-cover rounded-2 border shadow-sm flex-shrink-0">
                                            <div>
                                                <div class="fw-bold text-dark">${item.productTitle}</div>
                                                <small class="text-muted">Mã truyện: #${item.productId}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center fw-bold text-dark">x${item.quantity}</td>
                                    <td class="text-end text-muted font-monospace">
                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/> đ
                                    </td>
                                    <td class="text-end pe-2 fw-bold text-dark font-monospace">
                                        <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/> đ
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td class="ps-2 py-3 fw-bold">${order.productTitle}</td>
                                <td class="text-center fw-bold">x1</td>
                                <td class="text-end text-muted font-monospace"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ</td>
                                <td class="text-end pe-2 fw-bold font-monospace"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- TỔNG TIỀN ĐƠN BÁN -->
            <div class="d-flex justify-content-end pt-3 border-top mt-2">
                <div class="text-end">
                    <span class="text-muted small">Tổng thu của đơn này:</span>
                    <span class="fs-4 fw-bold text-danger ms-2 font-monospace">
                        <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- KHỐI 3: THANH THAO TÁC CẬP NHẬT TRẠNG THÁI (BẢNG ĐIỀU KHIỂN SELLER) -->
    <div class="card border-0 shadow-sm rounded-4 border-start border-danger border-4">
        <div class="card-body p-4 md:p-5">
            <h5 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                <i class="fas fa-sliders text-danger"></i> Cập nhật tiến độ đơn hàng
            </h5>
            <p class="text-muted small mb-4">Chọn thao tác để chuyển trạng thái cho đơn hàng theo tiến trình xử lý tại kho của bạn.</p>

            <form action="seller-order-detail" method="post" class="d-flex flex-wrap align-items-center gap-3 m-0">
                <input type="hidden" name="orderId" value="${order.id}">

                <!-- BƯỚC 1: XÁC NHẬN ĐÓNG GÓI KHI ĐANG PENDING -->
                <c:if test="${order.status == 'PENDING'}">
                    <button type="submit" name="newStatus" value="CONFIRMED" class="btn btn-primary px-4 py-2.5 fw-bold rounded-3 shadow-sm">
                        Xác nhận đóng gói
                    </button>
                </c:if>

                <!-- BƯỚC 2: BÀN GIAO VẬN CHUYỂN KHI ĐÃ CONFIRMED -->
                <c:if test="${order.status == 'CONFIRMED'}">
                    <button type="submit" name="newStatus" value="SHIPPING" class="btn btn-info text-white px-4 py-2.5 fw-bold rounded-3 shadow-sm">
                        Bàn giao cho GHN
                    </button>
                </c:if>

                <!-- BƯỚC 3: XÁC NHẬN GIAO THÀNH CÔNG KHI ĐANG SHIPPING -->
                <c:if test="${order.status == 'SHIPPING'}">
                    <button type="submit" name="newStatus" value="COMPLETED" class="btn btn-success px-4 py-2.5 fw-bold rounded-3 shadow-sm">
                        Xác nhận giao thành công
                    </button>
                </c:if>

                <!-- NÚT TỪ CHỐI / HỦY ĐƠN: Chỉ cho phép hủy khi đơn chưa giao (PENDING hoặc CONFIRMED) -->
                <c:if test="${order.status == 'PENDING' or order.status == 'CONFIRMED'}">
                    <button type="submit" name="newStatus" value="CANCELLED" class="btn btn-outline-danger px-4 py-2.5 fw-bold rounded-3"
                            onclick="return confirm('Bạn có chắc chắn muốn TỪ CHỐI / HỦY đơn hàng này không? Sách sẽ được hoàn lại kho.')">
                        Từ chối / Hủy đơn
                    </button>
                </c:if>

                <!-- KHI ĐƠN ĐÃ COMPLETED HOẶC CANCELLED -->
                <c:if test="${order.status == 'COMPLETED'}">
                    <span class="text-success small fw-semibold"><i class="fas fa-circle-check me-1"></i> Đơn hàng đã hoàn tất giao dịch. Không thể chỉnh sửa thêm.</span>
                </c:if>
                <c:if test="${order.status == 'CANCELLED'}">
                    <span class="text-danger small fw-semibold">
                        <i class="fas fa-circle-xmark me-1"></i> Đơn hàng này đã bị hủy. Lý do: <b class="ms-1">${not empty order.cancelReason ? order.cancelReason : 'Người mua hủy'}</b>
                    </span>
                </c:if>
            </form>
        </div>
    </div>

</main>

<!-- Footer Include -->
<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>