<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderCode} - MangaVault</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'sans-serif'] }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50/50 font-sans text-gray-900 flex flex-col min-h-screen justify-between">

<jsp:include page="/includes/header.jsp" />

<main class="container mx-auto px-4 md:px-8 max-w-5xl my-10 flex-grow">

    <!-- BREADCRUMB & QUAY LẠI (TĂNG NHẸ SIZE CHỮ) -->
    <div class="flex items-center justify-between mb-6">
        <nav class="flex text-sm text-gray-500 gap-2 items-center">
            <a href="${pageContext.request.contextPath}/" class="hover:text-indigo-600 transition">Trang chủ</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/my-orders" class="hover:text-indigo-600 transition">Lịch sử đơn hàng</a>
            <span>/</span>
            <span class="text-gray-900 font-semibold">Chi tiết #${order.orderCode}</span>
        </nav>
        <a href="${pageContext.request.contextPath}/my-orders" class="text-sm text-indigo-600 hover:text-indigo-800 font-semibold inline-flex items-center gap-1.5 transition">
            <i class="fas fa-arrow-left text-xs"></i> Quay lại danh sách
        </a>
    </div>

    <!-- KHỐI 1: HEADER ĐƠN HÀNG + THANH STEPPER TIẾN TRÌNH -->
    <div class="bg-white rounded-2xl border border-gray-200/80 p-6 md:p-8 shadow-sm mb-8">
        <div class="flex flex-wrap items-center justify-between gap-4 pb-6 border-b border-gray-100">
            <div>
                <div class="flex items-center gap-3 mb-1.5">
                    <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">
                        Đơn hàng #${not empty order.orderCode ? order.orderCode : order.id}
                    </h1>
                    <!-- Badge trạng thái -->
                    <c:choose>
                        <c:when test="${order.status eq 'PENDING'}">
                            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-600 border border-amber-200">Chờ xác nhận</span>
                        </c:when>
                        <c:when test="${order.status eq 'CONFIRMED'}">
                            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-600 border border-blue-200">Đang xử lý</span>
                        </c:when>
                        <c:when test="${order.status eq 'SHIPPING'}">
                            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-indigo-50 text-indigo-600 border border-indigo-200">Đã giao vận</span>
                        </c:when>
                        <c:when test="${order.status eq 'COMPLETED'}">
                            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-600 border border-emerald-200">Đã giao hàng</span>
                        </c:when>
                        <c:otherwise>
                            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-rose-50 text-rose-600 border border-rose-200">Đã hủy</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <p class="text-sm text-gray-500">
                    Đặt lúc: <fmt:formatDate value="${order.createdAt}" pattern="HH:mm, dd/MM/yyyy"/>
                    <c:if test="${not empty order.estimatedDelivery}">
                        <span class="mx-1 text-gray-300">|</span> Dự kiến: <fmt:formatDate value="${order.estimatedDelivery}" pattern="dd/MM/yyyy"/>
                    </c:if>
                </p>
            </div>

            <!-- Nút Action góc trên -->
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/" class="px-4 py-2.5 border border-gray-200 hover:bg-gray-50 text-gray-700 rounded-xl text-sm font-semibold transition">
                    Mua lại
                </a>
                <button onclick="window.print()" class="px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold transition inline-flex items-center gap-2 shadow-sm">
                    <i class="fas fa-download text-xs"></i> Tải hóa đơn
                </button>
            </div>
        </div>

        <!-- STEPPER TIẾN TRÌNH (TĂNG KÍCH THƯỚC NÚT TRÒN & CỠ CHỮ) -->
        <c:set var="st" value="${order.status}" />
        <c:set var="stepNum" value="${st eq 'PENDING' ? 1 : (st eq 'CONFIRMED' ? 2 : (st eq 'SHIPPING' ? 3 : (st eq 'COMPLETED' ? 4 : 0)))}" />

        <div class="py-8 px-4">
            <div class="relative flex items-center justify-between max-w-3xl mx-auto">
                <div class="absolute left-0 top-1/2 -translate-y-1/2 w-full h-1 bg-gray-200 z-0"></div>
                <div class="absolute left-0 top-1/2 -translate-y-1/2 h-1 bg-blue-600 transition-all duration-500 z-0"
                     style="width: ${stepNum eq 1 ? '10%' : (stepNum eq 2 ? '38%' : (stepNum eq 3 ? '72%' : (stepNum eq 4 ? '100%' : '0%')))}">
                </div>

                <div class="relative z-10 flex flex-col items-center">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center border-4 bg-white ${stepNum >= 1 ? 'border-blue-600' : 'border-gray-300'}">
                        <span class="w-3 h-3 rounded-full ${stepNum >= 1 ? 'bg-blue-600' : 'bg-transparent'}"></span>
                    </div>
                    <span class="text-sm font-bold mt-2 text-gray-800">Đã đặt hàng</span>
                    <span class="text-xs text-gray-400 mt-0.5"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM • HH:mm"/></span>
                </div>

                <div class="relative z-10 flex flex-col items-center">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center border-4 bg-white ${stepNum >= 2 ? 'border-blue-600' : 'border-gray-300'}">
                        <span class="w-3 h-3 rounded-full ${stepNum >= 2 ? 'bg-blue-600' : 'bg-transparent'}"></span>
                    </div>
                    <span class="text-sm font-bold mt-2 ${stepNum >= 2 ? 'text-gray-800' : 'text-gray-400'}">Đang xử lý</span>
                    <span class="text-xs text-gray-400 mt-0.5">${stepNum >= 2 ? 'Đã duyệt kho' : 'Chờ shop'}</span>
                </div>

                <div class="relative z-10 flex flex-col items-center">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center border-4 bg-white ${stepNum >= 3 ? 'border-blue-600 bg-blue-600' : 'border-gray-300'}">
                        <span class="w-3 h-3 rounded-full ${stepNum >= 3 ? 'bg-white' : 'bg-transparent'}"></span>
                    </div>
                    <span class="text-sm font-bold mt-2 ${stepNum >= 3 ? 'text-gray-800' : 'text-gray-400'}">Đã giao vận</span>
                    <span class="text-xs text-gray-400 mt-0.5">${not empty order.trackingNumber and order.trackingNumber ne 'Đang cập nhật' ? order.trackingNumber : 'Đang chuyển'}</span>
                </div>

                <div class="relative z-10 flex flex-col items-center">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center border-4 bg-white ${stepNum eq 4 ? 'border-blue-600 bg-blue-600' : 'border-gray-300'}">
                        <span class="w-3 h-3 rounded-full ${stepNum eq 4 ? 'bg-white' : 'bg-transparent'}"></span>
                    </div>
                    <span class="text-sm font-bold mt-2 ${stepNum eq 4 ? 'text-gray-800' : 'text-gray-400'}">Đã giao hàng</span>
                    <span class="text-xs text-gray-400 mt-0.5">
                        <c:choose>
                            <c:when test="${not empty order.estimatedDelivery}">
                                Dự kiến <fmt:formatDate value="${order.estimatedDelivery}" pattern="dd/MM"/>
                            </c:when>
                            <c:otherwise>Hoàn tất</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <!-- DANH SÁCH SẢN PHẨM MUA (ẢNH BÌA VÀ CHỮ RÕ RÀNG HƠN) -->
        <div class="mt-4 pt-6 border-t border-gray-100">
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead>
                    <tr class="text-gray-400 uppercase tracking-wider font-semibold border-b border-gray-100 text-xs">
                        <th class="pb-3.5">SẢN PHẨM</th>
                        <th class="pb-3.5 text-right">ĐƠN GIÁ</th>
                        <th class="pb-3.5 text-right">THÀNH TIỀN</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:choose>
                        <c:when test="${not empty items}">
                            <c:forEach items="${items}" var="item">
                                <tr>
                                    <td class="py-4">
                                        <div class="flex items-center gap-3.5">
                                            <c:set var="rawImg" value="${item.imageUrl}" />
                                            <c:set var="finalImg" value="${fn:startsWith(rawImg, 'http') ? rawImg : pageContext.request.contextPath.concat('/').concat(fn:startsWith(rawImg, '/') ? fn:substring(rawImg, 1, fn:length(rawImg)) : rawImg)}" />

                                            <img src="${finalImg}"
                                                 alt="${item.productTitle}"
                                                 onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=150&auto=format&fit=crop&q=80';"
                                                 class="w-14 h-20 object-cover rounded-lg border border-gray-200 shadow-sm shrink-0">
                                            <div>
                                                <h4 class="font-bold text-gray-900 text-sm md:text-base">${item.productTitle}</h4>
                                                <p class="text-gray-400 text-xs mt-1">Số lượng: x${item.quantity}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-4 text-right text-gray-600 font-medium text-sm md:text-base">
                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </td>
                                    <td class="py-4 text-right font-bold text-gray-900 text-sm md:text-base">
                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td class="py-4">
                                    <div class="flex items-center gap-3.5">
                                        <img src="${pageContext.request.contextPath}/Image/manga_01.jpg"
                                             alt="${order.productTitle}"
                                             onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=150&auto=format&fit=crop&q=80';"
                                             class="w-14 h-20 object-cover rounded-lg border border-gray-200 shadow-sm shrink-0">
                                        <div>
                                            <h4 class="font-bold text-gray-900 text-sm md:text-base">${order.productTitle}</h4>
                                            <p class="text-gray-400 text-xs mt-1">Số lượng: x1</p>
                                        </div>
                                    </div>
                                </td>
                                <td class="py-4 text-right text-gray-600 font-medium text-sm md:text-base">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </td>
                                <td class="py-4 text-right font-bold text-gray-900 text-sm md:text-base">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- TỔNG KẾT TIỀN -->
            <div class="border-t border-gray-100 pt-5 flex justify-end">
                <div class="w-72 space-y-2.5 text-sm">
                    <div class="flex justify-between text-gray-500">
                        <span>Tạm tính</span>
                        <span class="font-medium text-gray-800">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="flex justify-between text-gray-500">
                        <span>Phí vận chuyển</span>
                        <span class="font-medium text-gray-800">0₫</span>
                    </div>
                    <div class="flex justify-between items-center pt-3 border-t border-gray-100 font-bold text-gray-900">
                        <span class="text-base">Tổng thanh toán</span>
                        <span class="text-lg text-blue-600 font-extrabold">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- KHỐI 2: 4 CARD NGHIỆP VỤ (ĐÃ XÓA 2 KHỐI THEO YÊU CẦU & TĂNG SIZE CHỮ) -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

        <!-- CARD 1: THÔNG TIN GIAO NHẬN -->
        <div class="bg-white rounded-2xl border border-gray-200/80 p-6 md:p-7 shadow-sm">
            <h3 class="font-bold text-base text-gray-900 mb-4 pb-2.5 border-b border-gray-100">Giao nhận</h3>
            <div class="space-y-4 text-sm">
                <div class="flex items-start gap-3">
                    <i class="fas fa-location-dot text-indigo-500 mt-1"></i>
                    <div>
                        <p class="font-bold text-gray-800">${not empty order.receiverName ? order.receiverName : 'Người nhận'} - ${not empty order.receiverPhone ? order.receiverPhone : ''}</p>
                        <p class="text-gray-500 mt-1 leading-relaxed">${order.shippingAddress}</p>
                    </div>
                </div>
                <div class="pt-3 border-t border-gray-100 grid grid-cols-2 gap-3 text-sm">
                    <div>
                        <span class="block text-xs text-gray-400">Đơn vị vận chuyển:</span>
                        <span class="font-semibold text-gray-800">Giao Hàng Nhanh</span>
                    </div>
                    <div>
                        <span class="block text-xs text-gray-400">Mã vận đơn:</span>
                        <span class="font-mono font-semibold text-blue-600">${not empty order.trackingNumber ? order.trackingNumber : 'Chưa có'}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- CARD 2: NGHIỆM THU / KIỂM TRA HÀNG (ĐÃ XÓA THANH BẢO CHỨNG ESCROW) -->
        <div class="bg-white rounded-2xl border border-gray-200/80 p-6 md:p-7 shadow-sm">
            <h3 class="font-bold text-base text-gray-900 mb-1">Nghiệm thu / Kiểm tra hàng</h3>
            <p class="text-xs text-gray-400 mb-4">Vui lòng kiểm tra sản phẩm cẩn thận trước khi nhận hàng.</p>
            <div class="space-y-3 text-sm">
                <label class="flex items-center gap-2.5 text-gray-700">
                    <i class="fas fa-check-circle text-emerald-500 text-base"></i> Đúng sản phẩm và phân loại đã đặt
                </label>
                <label class="flex items-center gap-2.5 text-gray-700">
                    <i class="fas fa-check-circle text-emerald-500 text-base"></i> Bao bì nguyên vẹn, không móp méo
                </label>
                <label class="flex items-center gap-2.5 text-gray-700">
                    <i class="fas fa-check-circle text-emerald-500 text-base"></i> Sản phẩm không trầy xước hoặc hư hỏng
                </label>
                <label class="flex items-center gap-2.5 text-gray-700">
                    <i class="fas fa-check-circle text-emerald-500 text-base"></i> Không bị ố vàng và rách trang truyện
                </label>
            </div>
        </div>

        <!-- CARD 3: KHIẾU NẠI / ĐỔI TRẢ (ĐÃ XÓA THANH CẢNH BÁO 24H) -->
        <div class="bg-white rounded-2xl border border-gray-200/80 p-6 md:p-7 shadow-sm flex flex-col justify-between">
            <div>
                <h3 class="font-bold text-base text-gray-900 mb-1">Khiếu nại / Đổi trả</h3>
                <p class="text-xs text-gray-400 mb-4">Hỗ trợ xử lý nhanh các sự cố về đơn hàng.</p>
                <form class="space-y-3.5 text-sm">
                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-gray-500 mb-1 text-xs font-medium">Lý do</label>
                            <select class="w-full border border-gray-200 rounded-xl px-3 py-2 bg-gray-50 focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm">
                                <option>Sách bị rách, gãy gáy</option>
                                <option>Giao sai tập truyện</option>
                                <option>Truyện bị ẩm mốc / ố vàng nặng</option>
                                <option>Khác</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-gray-500 mb-1 text-xs font-medium">Phương thức xử lý</label>
                            <select class="w-full border border-gray-200 rounded-xl px-3 py-2 bg-gray-50 focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm">
                                <option>Đổi cuốn mới</option>
                                <option>Hoàn tiền về ví</option>
                            </select>
                        </div>
                    </div>
                    <div>
                        <textarea rows="3" placeholder="Mô tả chi tiết tình trạng sản phẩm..." class="w-full border border-gray-200 rounded-xl p-3 bg-gray-50 focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm"></textarea>
                    </div>
                </form>
            </div>
            <div class="pt-4 border-t border-gray-100 flex justify-end mt-2">
                <button type="button" class="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold transition">
                    Gửi yêu cầu
                </button>
            </div>
        </div>

        <!-- CARD 4: ĐÁNH GIÁ ĐƠN HÀNG -->
        <div class="bg-white rounded-2xl border border-gray-200/80 p-6 md:p-7 shadow-sm flex flex-col justify-between">
            <div>
                <h3 class="font-bold text-base text-gray-900 mb-1">Đánh giá đơn hàng</h3>
                <p class="text-xs text-gray-400 mb-3 text-center">Trải nghiệm của bạn thế nào?</p>

                <!-- Sao đánh giá (tăng kích thước để dễ click) -->
                <div class="flex justify-center gap-2 text-amber-400 text-2xl mb-4 cursor-pointer">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star text-gray-200"></i>
                </div>

                <div>
                    <textarea rows="3" placeholder="Chia sẻ cảm nhận về độ bảo quản bìa, đóng gói và bọc góc..." class="w-full border border-gray-200 rounded-xl p-3 bg-gray-50 focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm"></textarea>
                </div>
            </div>
            <div class="pt-4 border-t border-gray-100 flex justify-end mt-4">
                <button type="button" class="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold transition">
                    Gửi đánh giá
                </button>
            </div>
        </div>

    </div>

</main>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>