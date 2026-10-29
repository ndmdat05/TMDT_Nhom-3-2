<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử & Theo dõi đơn hàng - MangaVault</title>
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
<body class="bg-gray-50 font-sans text-gray-900 flex flex-col min-h-screen justify-between">

<jsp:include page="/includes/header.jsp" />

<main class="container mx-auto px-4 md:px-8 max-w-6xl my-8 flex-grow">

    <!-- BREADCRUMB -->
    <nav class="flex mb-6 text-sm text-gray-500 gap-2">
        <a href="${pageContext.request.contextPath}/" class="hover:text-indigo-600">Trang chủ</a>
        <span>/</span>
        <a href="${pageContext.request.contextPath}/profile" class="hover:text-indigo-600">Trang cá nhân</a>
        <span>/</span>
        <span class="text-gray-900 font-semibold">Đơn hàng của tôi</span>
    </nav>

    <c:set var="user" value="${sessionScope.user}" />
    <c:set var="displayName" value="${not empty user.full_name ? user.full_name : (not empty user.username ? user.username : 'Người dùng')}" />

    <!-- LƯỚI 4 CỘT: 1 CỘT CHO SIDEBAR + 3 CỘT CHO NỘI DUNG -->
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-6 lg:gap-8 items-start">

        <!-- 1. SIDEBAR BÊN TRÁI (GIỮ NGUYÊN FORM CHUẨN) -->
        <aside class="lg:col-span-1">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-center sticky top-6">
                <div class="relative w-24 h-24 mx-auto mb-4">
                    <c:choose>
                        <c:when test="${not empty user.avatar_url}">
                            <img src="${user.avatar_url}" alt="Avatar" class="w-full h-full rounded-full object-cover border-4 border-indigo-50 shadow">
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-full rounded-full bg-indigo-900 text-white flex items-center justify-center font-bold text-2xl border-4 border-indigo-50 shadow">
                                    ${fn:toUpperCase(fn:substring(displayName, 0, 2))}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <span class="absolute bottom-1 right-1 w-5 h-5 bg-emerald-500 border-2 border-white rounded-full" title="Đang hoạt động"></span>
                </div>

                <h2 class="text-lg font-bold text-gray-900 truncate">${displayName}</h2>
                <p class="text-xs text-gray-500 mb-3 truncate">@${not empty user.username ? user.username : 'mangavault_user'}</p>

                <div class="inline-block px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-700">
                    <i class="fas fa-user mr-1"></i>
                    ${not empty user.role ? user.role : 'BUYER'}
                </div>

                <hr class="my-6 border-gray-100">
                <nav class="space-y-1 text-left">
                    <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 px-4 py-2.5 rounded-xl text-gray-600 hover:bg-gray-50 hover:text-indigo-600 font-medium text-sm transition-colors">
                        <i class="fas fa-user-circle w-5"></i> Hồ sơ cá nhân
                    </a>
                    <!-- Mục đang chọn: Đơn hàng của tôi -->
                    <a href="${pageContext.request.contextPath}/my-orders" class="flex items-center gap-3 px-4 py-2.5 rounded-xl bg-indigo-50 text-indigo-600 font-semibold text-sm">
                        <i class="fas fa-shopping-bag w-5"></i> Đơn hàng của tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/change-password" class="flex items-center gap-3 px-4 py-2.5 rounded-xl text-gray-600 hover:bg-gray-50 hover:text-indigo-600 font-medium text-sm transition-colors">
                        <i class="fas fa-key w-5"></i> Đổi mật khẩu
                    </a>
                    <c:if test="${user.role eq 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center gap-3 px-4 py-2.5 rounded-xl text-purple-600 hover:bg-purple-50 font-semibold text-sm transition-colors">
                            <i class="fas fa-chart-line w-5"></i> Trang quản trị
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 px-4 py-2.5 rounded-xl text-rose-600 hover:bg-rose-50 font-semibold text-sm transition-colors">
                        <i class="fas fa-sign-out-alt w-5"></i> Đăng xuất
                    </a>
                </nav>
            </div>
        </aside>

        <!-- 2. PHẦN NỘI DUNG BÊN PHẢI (CHIẾM 3/4 CHIỀU RỘNG) -->
        <section class="lg:col-span-3 space-y-6">

            <!-- TIÊU ĐỀ KHỐI NỘI DUNG -->
            <div>
                <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Lịch sử & Theo dõi đơn hàng</h1>
                <p class="text-xs text-gray-500 mt-1">Xem lại các đơn hàng trước đây và cập nhật hành trình giao hàng mới nhất.</p>
            </div>

            <c:choose>
                <%-- KHI CHƯA CÓ ĐƠN HÀNG --%>
                <c:when test="${empty orders}">
                    <div class="bg-white rounded-2xl border border-gray-100 p-12 text-center shadow-sm">
                        <div class="w-14 h-14 bg-gray-50 text-gray-400 rounded-full flex items-center justify-center mx-auto mb-3 text-xl">
                            <i class="fas fa-box-open"></i>
                        </div>
                        <h3 class="text-base font-bold text-gray-800">Bạn chưa có đơn hàng nào</h3>
                        <p class="text-xs text-gray-400 mt-1 mb-5">Bạn chưa đặt mua truyện nào tại MangaVault.</p>
                        <a href="${pageContext.request.contextPath}/" class="inline-flex items-center gap-2 px-5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold transition">
                            <i class="fas fa-shopping-bag"></i> Khám phá Manga ngay
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- THẺ 1: TIẾN TRÌNH ĐƠN HÀNG GẦN NHẤT (CARD TRACKING STEPPER) -->
                    <c:if test="${not empty latestOrder}">
                        <div class="bg-white rounded-2xl border border-gray-100 p-5 md:p-6 shadow-sm">
                            <div class="flex flex-wrap items-center justify-between gap-3 pb-4 border-b border-gray-100">
                                <div>
                                    <div class="flex items-center gap-1.5 text-[11px] font-bold text-emerald-600 uppercase tracking-wide mb-0.5">
                                        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                                        <c:choose>
                                            <c:when test="${latestOrder.status eq 'PENDING'}">CHỜ XÁC NHẬN</c:when>
                                            <c:when test="${latestOrder.status eq 'CONFIRMED'}">ĐANG XỬ LÝ</c:when>
                                            <c:when test="${latestOrder.status eq 'SHIPPING'}">ĐANG GIAO VẬN</c:when>
                                            <c:when test="${latestOrder.status eq 'COMPLETED'}">ĐÃ GIAO HÀNG</c:when>
                                            <c:otherwise>ĐÃ HỦY ĐƠN</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h2 class="text-lg md:text-xl font-bold text-gray-900">
                                        Đơn hàng #${not empty latestOrder.orderCode ? latestOrder.orderCode : latestOrder.id}
                                    </h2>
                                </div>
                                <div class="text-right">
                                    <span class="text-[11px] text-gray-400 block font-medium">Dự kiến giao hàng</span>
                                    <span class="text-xs md:text-sm font-bold text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty latestOrder.estimatedDelivery}">
                                                <fmt:formatDate value="${latestOrder.estimatedDelivery}" pattern="dd 'tháng' MM, yyyy"/>
                                            </c:when>
                                            <c:otherwise>Đang cập nhật</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- STEPPER RÚT GỌN GỌN GÀNG CHO CỘT 3/4 -->
                            <c:set var="st" value="${latestOrder.status}" />
                            <c:set var="stepNum" value="${st eq 'PENDING' ? 1 : (st eq 'CONFIRMED' ? 2 : (st eq 'SHIPPING' ? 3 : (st eq 'COMPLETED' ? 4 : 0)))}" />

                            <div class="py-6 px-2">
                                <div class="relative flex items-center justify-between max-w-2xl mx-auto">
                                    <!-- Đường kết nối xám -->
                                    <div class="absolute left-0 top-1/2 -translate-y-1/2 w-full h-1 bg-gray-200 z-0"></div>
                                    <!-- Đường kết nối xanh (chạy theo tiến độ) -->
                                    <div class="absolute left-0 top-1/2 -translate-y-1/2 h-1 bg-indigo-600 transition-all duration-500 z-0"
                                         style="width: ${stepNum eq 1 ? '10%' : (stepNum eq 2 ? '38%' : (stepNum eq 3 ? '72%' : (stepNum eq 4 ? '100%' : '0%')))}">
                                    </div>

                                    <!-- BƯỚC 1: ĐÃ ĐẶT HÀNG -->
                                    <div class="relative z-10 flex flex-col items-center">
                                        <div class="w-6 h-6 rounded-full flex items-center justify-center border-2 bg-white ${stepNum >= 1 ? 'border-indigo-600' : 'border-gray-300'}">
                                            <span class="w-2 h-2 rounded-full ${stepNum >= 1 ? 'bg-indigo-600' : 'bg-transparent'}"></span>
                                        </div>
                                        <span class="text-[11px] font-bold mt-1.5 text-gray-800">Đã đặt hàng</span>
                                        <span class="text-[10px] text-gray-400">
                                            <fmt:formatDate value="${latestOrder.createdAt}" pattern="dd/MM • HH:mm"/>
                                        </span>
                                    </div>

                                    <!-- BƯỚC 2: ĐANG XỬ LÝ -->
                                    <div class="relative z-10 flex flex-col items-center">
                                        <div class="w-6 h-6 rounded-full flex items-center justify-center border-2 bg-white ${stepNum >= 2 ? 'border-indigo-600' : 'border-gray-300'}">
                                            <span class="w-2 h-2 rounded-full ${stepNum >= 2 ? 'bg-indigo-600' : 'bg-transparent'}"></span>
                                        </div>
                                        <span class="text-[11px] font-bold mt-1.5 ${stepNum >= 2 ? 'text-gray-800' : 'text-gray-400'}">Đang xử lý</span>
                                        <span class="text-[10px] text-gray-400">${stepNum >= 2 ? 'Đã duyệt' : 'Chờ shop'}</span>
                                    </div>

                                    <!-- BƯỚC 3: ĐÃ GIAO VẬN -->
                                    <div class="relative z-10 flex flex-col items-center">
                                        <div class="w-6 h-6 rounded-full flex items-center justify-center border-2 bg-white ${stepNum >= 3 ? 'border-indigo-600 bg-indigo-600' : 'border-gray-300'}">
                                            <span class="w-2 h-2 rounded-full ${stepNum >= 3 ? 'bg-white' : 'bg-transparent'}"></span>
                                        </div>
                                        <span class="text-[11px] font-bold mt-1.5 ${stepNum >= 3 ? 'text-gray-800' : 'text-gray-400'}">Đã giao vận</span>
                                        <span class="text-[10px] text-gray-400">
                                                ${not empty latestOrder.trackingNumber and latestOrder.trackingNumber ne 'Đang cập nhật' ? latestOrder.trackingNumber : 'Đang chuyển'}
                                        </span>
                                    </div>

                                    <!-- BƯỚC 4: ĐÃ GIAO HÀNG -->
                                    <div class="relative z-10 flex flex-col items-center">
                                        <div class="w-6 h-6 rounded-full flex items-center justify-center border-2 bg-white ${stepNum eq 4 ? 'border-indigo-600 bg-indigo-600' : 'border-gray-300'}">
                                            <span class="w-2 h-2 rounded-full ${stepNum eq 4 ? 'bg-white' : 'bg-transparent'}"></span>
                                        </div>
                                        <span class="text-[11px] font-bold mt-1.5 ${stepNum eq 4 ? 'text-gray-800' : 'text-gray-400'}">Đã giao</span>
                                        <span class="text-[10px] text-gray-400">
                                            <c:choose>
                                                <c:when test="${not empty latestOrder.estimatedDelivery}">
                                                    Dự kiến <fmt:formatDate value="${latestOrder.estimatedDelivery}" pattern="dd/MM"/>
                                                </c:when>
                                                <c:otherwise>Hoàn tất</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- ĐỊA CHỈ NHẬN HÀNG -->
                            <div class="pt-3 border-t border-gray-100 flex items-center gap-2 text-xs text-gray-500">
                                <i class="fas fa-location-dot text-gray-400"></i>
                                <span class="truncate">${not empty latestOrder.shippingAddress ? latestOrder.shippingAddress : 'Địa chỉ giao hàng mặc định của bạn'}</span>
                            </div>
                        </div>
                    </c:if>

                    <!-- THẺ 2: BẢNG LỊCH SỬ ĐƠN HÀNG (CÓ TÌM KIẾM & BỘ LỌC) -->
                    <div class="bg-white rounded-2xl border border-gray-100 p-5 md:p-6 shadow-sm">

                        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-5 border-b border-gray-100">
                            <div>
                                <h2 class="text-base font-bold text-gray-900">Lịch sử đơn hàng</h2>
                                <p class="text-xs text-gray-400 mt-0.5">${fn:length(orders)} đơn hàng gần đây</p>
                            </div>

                            <div class="flex items-center gap-2">
                                <!-- Ô NHẬP TÌM MÃ ĐƠN -->
                                <div class="relative">
                                    <input type="text" id="orderSearchInput" onkeyup="filterOrders()"
                                           placeholder="Nhập mã đơn"
                                           class="pl-3 pr-7 py-1.5 text-xs border border-gray-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 w-32 sm:w-40 bg-gray-50/50">
                                    <i class="fas fa-search absolute right-2.5 top-2.5 text-gray-400 text-xs pointer-events-none"></i>
                                </div>

                                <!-- DROPDOWN LỌC TRẠNG THÁI -->
                                <select id="orderStatusFilter" onchange="filterOrders()"
                                        class="text-xs border border-gray-200 rounded-xl px-2.5 py-1.5 bg-gray-50/50 text-gray-700 focus:outline-none focus:ring-1 focus:ring-indigo-500">
                                    <option value="ALL">Tất cả đơn hàng</option>
                                    <option value="PENDING">Chờ xử lý</option>
                                    <option value="CONFIRMED">Đang xử lý</option>
                                    <option value="SHIPPING">Đang giao vận</option>
                                    <option value="COMPLETED">Hoàn tất</option>
                                    <option value="CANCELLED">Đã hủy</option>
                                </select>
                            </div>
                        </div>

                        <!-- DANH SÁCH BẢNG -->
                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-xs" id="orderTable">
                                <thead>
                                <tr class="text-gray-400 uppercase tracking-wider font-semibold border-b border-gray-100">
                                    <th class="py-3 px-2">MÃ ĐƠN</th>
                                    <th class="py-3 px-2">NGÀY MUA</th>
                                    <th class="py-3 px-2">TỔNG TIỀN</th>
                                    <th class="py-3 px-2">TRẠNG THÁI</th>
                                    <th class="py-3 px-2 text-right">THAO TÁC</th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-50">
                                <c:forEach items="${orders}" var="o">
                                    <tr class="hover:bg-gray-50/70 transition-colors order-row" data-status="${o.status}">
                                        <td class="py-3.5 px-2 font-bold text-gray-900 order-code-col">
                                            #${not empty o.orderCode ? o.orderCode : o.id}
                                        </td>
                                        <td class="py-3.5 px-2 text-gray-500">
                                            <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td class="py-3.5 px-2 font-bold text-gray-900">
                                            <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td class="py-3.5 px-2">
                                            <c:choose>
                                                <c:when test="${o.status eq 'PENDING'}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-amber-50 text-amber-600">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span> Chờ xử lý
                                                        </span>
                                                </c:when>
                                                <c:when test="${o.status eq 'CONFIRMED'}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-blue-50 text-blue-600">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-blue-500"></span> Đang xử lý
                                                        </span>
                                                </c:when>
                                                <c:when test="${o.status eq 'SHIPPING'}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-indigo-50 text-indigo-600">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-indigo-500"></span> Đang giao vận
                                                        </span>
                                                </c:when>
                                                <c:when test="${o.status eq 'COMPLETED'}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-emerald-50 text-emerald-600">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Hoàn tất
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-medium bg-rose-50 text-rose-600">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500"></span> Đã hủy
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-3.5 px-2 text-right">
                                            <a href="${pageContext.request.contextPath}/order-detail?id=${o.id}" class="font-medium text-indigo-600 hover:text-indigo-800 transition inline-flex items-center gap-1 text-xs">
                                                Xem chi tiết <i class="fas fa-arrow-right text-[10px]"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </section>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />

<!-- SCRIPT LỌC BẢNG NHANH THEO MÃ ĐƠN VÀ TRẠNG THÁI -->
<script>
    function filterOrders() {
        const searchInput = document.getElementById('orderSearchInput').value.toLowerCase().trim();
        const statusFilter = document.getElementById('orderStatusFilter').value;
        const rows = document.querySelectorAll('.order-row');

        rows.forEach(row => {
            const code = row.querySelector('.order-code-col').innerText.toLowerCase();
            const status = row.getAttribute('data-status');

            const matchCode = code.includes(searchInput);
            const matchStatus = (statusFilter === 'ALL') || (status === statusFilter);

            if (matchCode && matchStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>

</body>
</html>