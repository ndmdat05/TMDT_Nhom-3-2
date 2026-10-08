<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Seller Center - MangaVault</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Inter', sans-serif; background-color: #FFFFFF; color: #111827; } </style>
</head>
<body class="min-h-screen flex flex-col bg-white">

<header class="bg-white border-b border-gray-200 sticky top-0 z-50 h-[72px] flex items-center px-6 justify-between">
    <div class="flex items-center gap-4">
        <span class="text-xl font-bold text-orange-500">MANGAVAULT</span>
        <span class="text-xs border-l border-gray-300 pl-4 font-bold text-gray-500">SELLER CENTER</span>
    </div>
    <div class="w-9 h-9 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">MK</div>
</header>

<main class="flex-grow w-full flex">
    <!-- SIDEBAR -->
    <aside class="w-[260px] border-r border-gray-200 p-6 sticky top-[72px] h-[calc(100vh-72px)]">
        <nav class="space-y-2 text-sm font-semibold">
            <a href="${pageContext.request.contextPath}/seller/manage?tab=products"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'products' ? 'bg-gray-100 text-gray-900 border border-gray-200' : 'text-gray-600 hover:bg-gray-50'}">
                Sản phẩm của tôi
            </a>
            <a href="${pageContext.request.contextPath}/seller/manage?tab=orders"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'orders' ? 'bg-gray-100 text-gray-900 border border-gray-200' : 'text-gray-600 hover:bg-gray-50'}">
                Đơn hàng & Vận chuyển
            </a>
            <a href="${pageContext.request.contextPath}/seller/manage?tab=revenue"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'revenue' ? 'bg-gray-100 text-gray-900 border border-gray-200' : 'text-gray-600 hover:bg-gray-50'}">
                Quản lý Doanh thu
            </a>
        </nav>
    </aside>

    <!-- CONTENT -->
    <section class="flex-grow p-8">

        <!-- THÔNG BÁO -->
        <c:if test="${not empty sessionScope.message}">
            <div class="mb-4 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-lg text-sm font-semibold flex justify-between items-center">
                <span>✓ ${sessionScope.message}</span>
                <c:remove var="message" scope="session" />
            </div>
        </c:if>

        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-900">
                <c:if test="${activeTab == 'products'}">Quản lý Sản phẩm / Bài đăng</c:if>
                <c:if test="${activeTab == 'orders'}">Quản lý Đơn hàng & Cập nhật Vận đơn</c:if>
                <c:if test="${activeTab == 'revenue'}">Lịch sử Doanh thu & Sao kê</c:if>
            </h1>

            <%-- NÚT ĐĂNG BÀI MỚI --%>
            <c:if test="${activeTab == 'products'}">
                <button onclick="document.getElementById('modalNewListing').classList.remove('hidden')" class="bg-gray-900 hover:bg-black text-white px-4 py-2 rounded-lg text-sm font-bold shadow-sm">
                    + Tạo bài đăng mới
                </button>
            </c:if>
        </div>

        <!-- THANH TÌM KIẾM & BỘ LỌC -->
        <div class="p-4 bg-gray-50 border border-gray-200 rounded-xl mb-6 flex gap-4 items-center">
            <input type="text" placeholder="Tìm kiếm theo mã, tiêu đề..." class="bg-white border border-gray-200 rounded-lg px-4 py-2 text-sm flex-grow focus:outline-none focus:border-indigo-500">
            <select class="bg-white border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-600 outline-none">
                <option value="">Tất cả trạng thái</option>
                <option value="ACTIVE">Hoạt động / Đã duyệt</option>
                <option value="PENDING">Chờ xử lý</option>
                <option value="CANCELLED">Đã hủy</option>
            </select>
            <button class="bg-white border border-gray-200 hover:bg-gray-100 px-4 py-2 rounded-lg text-sm font-semibold text-gray-700">Lọc</button>
        </div>

        <!-- BẢNG DỮ LIỆU -->
        <div class="border border-gray-200 rounded-xl overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead class="bg-gray-50 text-gray-600 font-semibold border-b border-gray-200 text-xs uppercase">
                <tr>
                    <c:choose>
                        <c:when test="${activeTab == 'products'}">
                            <th class="px-6 py-4">Mã SP</th>
                            <th class="px-6 py-4">Tên sản phẩm</th>
                            <th class="px-6 py-4">Giá bán</th>
                            <th class="px-6 py-4">Trạng thái</th>
                            <th class="px-6 py-4 text-right">Thao tác</th>
                        </c:when>
                        <c:when test="${activeTab == 'orders'}">
                            <th class="px-6 py-4">Mã Đơn</th>
                            <th class="px-6 py-4">Sản phẩm</th>
                            <th class="px-6 py-4">Mã vận đơn</th>
                            <th class="px-6 py-4">Trạng thái</th>
                            <th class="px-6 py-4 text-right">Thao tác</th>
                        </c:when>
                        <c:when test="${activeTab == 'revenue'}">
                            <th class="px-6 py-4">Mã Đơn</th>
                            <th class="px-6 py-4">Nội dung</th>
                            <th class="px-6 py-4">Trạng thái Escrow</th>
                            <th class="px-6 py-4 text-right">Thực nhận</th>
                        </c:when>
                    </c:choose>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">

                <%-- TAB ORDERS SELLER --%>
                <c:if test="${activeTab == 'orders'}">
                    <c:forEach var="o" items="${orderList}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 font-bold text-gray-900">#ORD-${o.id}</td>
                            <td class="px-6 py-4 font-medium text-gray-900">${o.productTitle}</td>
                            <td class="px-6 py-4 text-gray-600 font-mono">
                                <c:choose>
                                    <c:when test="${not empty o.trackingNumber}">${o.trackingNumber}</c:when>
                                    <c:otherwise><span class="text-gray-400 italic">Chưa nhập</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 bg-orange-50 text-orange-700 border border-orange-200 rounded text-xs font-bold">${o.status}</span>
                            </td>
                            <td class="px-6 py-4 text-right space-x-2">
                                    <%-- Form Nhập Mã Vận Đơn --%>
                                <form action="${pageContext.request.contextPath}/seller/manage" method="POST" class="inline-flex gap-1">
                                    <input type="hidden" name="action" value="enterTracking">
                                    <input type="hidden" name="tab" value="orders">
                                    <input type="hidden" name="orderId" value="${o.id}">
                                    <input type="text" name="trackingNumber" placeholder="Mã vận đơn..." required class="w-28 border border-gray-200 rounded px-2 py-1 text-xs">
                                    <button type="submit" class="bg-indigo-600 text-white px-2 py-1 rounded text-xs font-bold">Lưu</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/seller/manage" method="POST" class="inline">
                                    <input type="hidden" name="action" value="cancelOrder">
                                    <input type="hidden" name="tab" value="orders">
                                    <input type="hidden" name="orderId" value="${o.id}">
                                    <button type="submit" class="text-red-600 font-bold hover:underline text-xs">Hủy</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>

                </tbody>
            </table>
        </div>
    </section>
</main>

<!-- MODAL TẠO BÀI ĐĂNG MỚI (POPUP HTML/TAILWIND) -->
<div id="modalNewListing" class="fixed inset-0 bg-black/40 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl max-w-md w-full p-6 shadow-xl border border-gray-200">
        <h3 class="font-bold text-lg text-gray-900 mb-4">Tạo bài đăng Manga mới</h3>
        <form action="${pageContext.request.contextPath}/seller/manage" method="POST" class="space-y-4">
            <input type="hidden" name="action" value="createListing">
            <input type="hidden" name="tab" value="products">

            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase mb-1">Tên bộ truyện / Tác phẩm</label>
                <input type="text" name="title" required placeholder="Ví dụ: Vagabond Vol 1-12 Deluxe" class="w-full border border-gray-200 rounded-lg p-2.5 text-sm outline-none focus:border-indigo-500">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-700 uppercase mb-1">Giá bán (VNĐ)</label>
                <input type="number" name="price" required placeholder="120000" class="w-full border border-gray-200 rounded-lg p-2.5 text-sm outline-none focus:border-indigo-500">
            </div>
            <div class="flex justify-end gap-2 pt-2">
                <button type="button" onclick="document.getElementById('modalNewListing').classList.add('hidden')" class="px-4 py-2 border border-gray-200 text-gray-600 rounded-lg text-sm font-semibold">Hủy</button>
                <button type="submit" class="px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm font-bold hover:bg-indigo-700">Gửi duyệt bài</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>