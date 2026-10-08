<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MangaVault Admin - Quản lý Hệ thống</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Inter', sans-serif; background-color: #FFFFFF; color: #111827; } </style>
</head>
<body class="min-h-screen flex flex-col bg-white">

<header class="bg-white border-b border-gray-200 sticky top-0 z-50 h-[72px] flex items-center px-6">
    <div class="flex items-center gap-4 w-1/3">
        <span class="text-xl font-bold text-orange-500">MANGA NÈ</span>
        <span class="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded font-bold border border-gray-200">Admin Portal</span>
    </div>
    <div class="w-2/3 flex justify-end">
        <div class="w-9 h-9 rounded bg-indigo-600 flex items-center justify-center text-white font-bold text-sm">AD</div>
    </div>
</header>

<main class="flex-grow w-full flex">
    <!-- SIDEBAR -->
    <aside class="w-[260px] border-r border-gray-200 p-6 sticky top-[72px] h-[calc(100vh-72px)]">
        <nav class="space-y-2 text-sm font-semibold">
            <a href="${pageContext.request.contextPath}/admin/manage?tab=users"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'users' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                Quản lý Người dùng
            </a>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=products"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'products' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                Quản lý Sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/admin/manage?tab=orders"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'orders' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                Quản lý Đơn hàng
            </a>
        </nav>
    </aside>

    <!-- CONTENT -->
    <section class="flex-grow p-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-6">
            <c:if test="${activeTab == 'users'}">Danh sách Người dùng</c:if>
            <c:if test="${activeTab == 'products'}">Danh sách Sản phẩm Toàn sàn</c:if>
            <c:if test="${activeTab == 'orders'}">Danh sách Đơn hàng Toàn sàn</c:if>
        </h1>
        <%-- Khối hiển thị thông báo thao tác thành công --%>
        <c:if test="${not empty sessionScope.message}">
            <div class="mb-4 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-lg text-sm font-semibold flex justify-between items-center">
                <span>✓ ${sessionScope.message}</span>
                    <%-- Xóa thông báo khỏi session sau khi hiển thị --%>
                <c:remove var="message" scope="session" />
            </div>
        </c:if>
        <div class="border border-gray-200 rounded-xl overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead class="bg-gray-50 text-gray-600 font-semibold border-b border-gray-200 text-xs uppercase">
                <tr>
                    <th class="px-6 py-4">ID</th>
                    <th class="px-6 py-4">
                        <c:choose>
                            <c:when test="${activeTab == 'users'}">Tên / Email</c:when>
                            <c:when test="${activeTab == 'products'}">Tên truyện / Người đăng</c:when>
                            <c:otherwise>Sản phẩm / Người Mua & Bán</c:otherwise>
                        </c:choose>
                    </th>
                    <th class="px-6 py-4">
                        <c:choose>
                            <c:when test="${activeTab == 'users'}">Vai trò</c:when>
                            <c:otherwise>Giá trị</c:otherwise>
                        </c:choose>
                    </th>
                    <th class="px-6 py-4">Trạng thái</th>
                    <th class="px-6 py-4 text-right">Thao tác</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">

                <%-- TAB 1: USERS --%>
                <c:if test="${activeTab == 'users'}">
                    <c:forEach var="u" items="${userList}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 font-bold text-gray-900">#USR-${u.id}</td>
                            <td class="px-6 py-4">
                                <p class="font-bold text-gray-900">${u.username}</p>
                                <p class="text-xs text-gray-500">${u.email}</p>
                            </td>
                            <td class="px-6 py-4 font-medium">${u.role}</td>
                            <td class="px-6 py-4">
                                        <span class="px-2 py-1 ${u.status == 'ACTIVE' ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-red-50 text-red-700 border-red-200'} border rounded text-xs font-bold">
                                                ${u.status}
                                        </span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline">
                                    <input type="hidden" name="action" value="toggleUserStatus">
                                    <input type="hidden" name="tab" value="users">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="text-indigo-600 font-bold hover:underline">
                                            ${u.status == 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>

                <%-- TAB 2: PRODUCTS --%>
                <c:if test="${activeTab == 'products'}">
                    <c:forEach var="p" items="${productList}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 font-bold text-gray-900">#PRD-${p.id}</td>
                            <td class="px-6 py-4">
                                <p class="font-bold text-gray-900">${p.title}</p>
                                <p class="text-xs text-gray-500">Seller: ${p.sellerName}</p>
                            </td>
                            <td class="px-6 py-4 font-bold text-indigo-700">
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 bg-blue-50 text-blue-700 border border-blue-200 rounded text-xs font-bold">${p.status}</span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                    <input type="hidden" name="action" value="deleteProduct">
                                    <input type="hidden" name="tab" value="products">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <button type="submit" class="text-red-600 font-bold hover:underline">Xóa sản phẩm</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>

                <%-- TAB 3: ORDERS --%>
                <c:if test="${activeTab == 'orders'}">
                    <c:forEach var="o" items="${orderList}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 font-bold text-gray-900">#ORD-${o.id}</td>
                            <td class="px-6 py-4">
                                <p class="font-bold text-gray-900">${o.productTitle}</p>
                                <p class="text-xs text-gray-500">Mua: ${o.buyerName} | Bán: ${o.sellerName}</p>
                            </td>
                            <td class="px-6 py-4 font-bold text-indigo-700">
                                <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 bg-orange-50 text-orange-700 border border-orange-200 rounded text-xs font-bold">${o.status}</span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline">
                                    <input type="hidden" name="action" value="cancelOrder">
                                    <input type="hidden" name="tab" value="orders">
                                    <input type="hidden" name="orderId" value="${o.id}">
                                    <button type="submit" class="text-red-600 font-bold hover:underline">Hủy đơn</button>
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
</body>
</html>