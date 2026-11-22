<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đấu giá - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-50 p-8">
<div class="max-w-6xl mx-auto">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold text-gray-900"><i class="fas fa-gavel text-orange-500"></i> Quản lý Phiên Đấu Giá</h1>
        <a href="${pageContext.request.contextPath}/admin/manage" class="text-sm text-indigo-600 font-bold hover:underline">Quay lại Admin</a>
    </div>

    <c:if test="${not empty sessionScope.adminSuccess}">
        <div class="mb-4 p-4 bg-emerald-50 text-emerald-700 border border-emerald-200 rounded-lg font-semibold"><c:out value="${sessionScope.adminSuccess}"/></div>
        <c:remove var="adminSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.adminError}">
        <div class="mb-4 p-4 bg-red-50 text-red-700 border border-red-200 rounded-lg font-semibold"><c:out value="${sessionScope.adminError}"/></div>
        <c:remove var="adminError" scope="session"/>
    </c:if>

    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        <table class="w-full text-left text-sm">
            <thead class="bg-gray-50 border-b border-gray-200 text-xs uppercase text-gray-500">
            <tr>
                <th class="px-6 py-4">Sản phẩm</th>
                <th class="px-6 py-4">Giá hiện tại</th>
                <th class="px-6 py-4">Người dẫn đầu</th>
                <th class="px-6 py-4">Kết thúc</th>
                <th class="px-6 py-4 text-center">Thao tác</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
            <c:forEach var="a" items="${auctionList}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-semibold text-gray-900">
                        <c:out value="${a.title}"/>
                    </td>
                    <td class="px-6 py-4 text-red-600 font-bold">
                        <fmt:formatNumber value="${a.current_highest_price > 0 ? a.current_highest_price : a.starting_price}" pattern="#,##0"/> đ
                    </td>
                    <td class="px-6 py-4 text-gray-700">
                            ${a.winner_id != null ? 'Đã có người đặt' : 'Chưa có ai'}
                    </td>
                    <td class="px-6 py-4 text-gray-500">
                        <fmt:formatDate value="${a.end_time}" pattern="HH:mm - dd/MM/yyyy"/>
                    </td>
                    <td class="px-6 py-4 text-center">
                        <form action="${pageContext.request.contextPath}/admin/auctions" method="POST" onsubmit="return confirm('Chốt phiên này và tạo đơn hàng cho người thắng?');">
                            <input type="hidden" name="auctionId" value="${a.id}">
                            <button type="submit" class="px-4 py-2 bg-indigo-600 text-white font-bold rounded-lg hover:bg-indigo-700 transition">
                                <i class="fas fa-check-circle mr-1"></i> Chốt phiên
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty auctionList}">
                <tr><td colspan="5" class="text-center py-8 text-gray-500">Không có phiên đấu giá nào đang diễn ra.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>