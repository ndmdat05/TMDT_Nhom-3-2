<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 11/8/2026
  Time: 8:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ví MangaVault</title>
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

    <!-- BREADCRUMB -->
    <div class="flex items-center justify-between mb-6">
        <nav class="flex text-sm text-gray-500 gap-2 items-center">
            <a href="${pageContext.request.contextPath}/" class="hover:text-indigo-600 transition">Trang chủ</a>
            <span>/</span>
            <span class="text-gray-900 font-semibold">Ví MangaVault</span>
        </nav>
        <a href="${pageContext.request.contextPath}/my-orders" class="text-sm text-indigo-600 hover:text-indigo-800 font-semibold inline-flex items-center gap-1.5 transition">
            <i class="fas fa-box-archive text-xs"></i> Lịch sử đơn hàng
        </a>
    </div>

    <!-- KHỐI 1: THẺ HIỂN THỊ SỐ DƯ TÀI KHOẢN -->
    <div class="bg-gradient-to-r from-indigo-700 via-indigo-600 to-blue-600 rounded-3xl p-8 text-white shadow-xl mb-8 flex flex-wrap items-center justify-between gap-6">
        <div>
            <div class="inline-flex items-center gap-2 px-3 py-1 bg-white/10 rounded-full text-xs font-semibold text-indigo-100 mb-3 border border-white/10">
                <i class="fas fa-shield-halved"></i> Số dư khả dụng
            </div>
            <p class="text-sm font-medium text-indigo-100 uppercase tracking-wider">Số dư Ví MangaVault</p>
            <h1 class="text-4xl md:text-5xl font-extrabold tracking-tight mt-1">
                <fmt:formatNumber value="${balance}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </h1>
            <p class="text-xs text-indigo-200 mt-3 flex items-center gap-1.5">
                <i class="fas fa-circle-info"></i> Tiền hoàn khi hủy đơn VNPAY sẽ được cộng trực tiếp vào ví này.
            </p>
        </div>

        <div class="flex flex-col sm:flex-row gap-3">
            <a href="${pageContext.request.contextPath}/product-list" class="px-5 py-3 bg-white text-indigo-700 hover:bg-gray-100 rounded-xl text-sm font-bold shadow transition text-center">
                <i class="fas fa-shopping-bag mr-1.5"></i> Mua sắm ngay
            </a>
        </div>
    </div>

    <!-- KHỐI 2: BẢNG LỊCH SỬ BIẾN ĐỘNG SỐ DƯ (AUDIT LOG) -->
    <div class="bg-white rounded-2xl border border-gray-200/80 p-6 md:p-8 shadow-sm">
        <div class="flex items-center justify-between pb-4 border-b border-gray-100 mb-4">
            <h2 class="text-lg font-bold text-gray-900 flex items-center gap-2.5">
                <i class="fas fa-clock-rotate-left text-indigo-600"></i> Lịch sử giao dịch ví
            </h2>
            <span class="text-xs font-semibold px-2.5 py-1 bg-gray-100 text-gray-600 rounded-full">
                ${not empty transactions ? transactions.size() : 0} giao dịch
            </span>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm">
                <thead>
                <tr class="text-gray-400 uppercase tracking-wider font-semibold border-b border-gray-100 text-xs">
                    <th class="pb-3.5">Thời gian</th>
                    <th class="pb-3.5">Loại giao dịch</th>
                    <th class="pb-3.5">Chi tiết nội dung</th>
                    <th class="pb-3.5 text-right">Biến động</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <c:choose>
                    <c:when test="${not empty transactions}">
                        <c:forEach items="${transactions}" var="tx">
                            <tr>
                                <td class="py-4 text-gray-500 text-xs whitespace-nowrap">
                                    <fmt:formatDate value="${tx.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td class="py-4">
                                    <c:choose>
                                        <c:when test="${tx.type eq 'REFUND'}">
                                            <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-600 border border-emerald-200">
                                                <i class="fas fa-arrow-down-left text-[0.65rem] mr-1"></i>Hoàn tiền
                                            </span>
                                        </c:when>
                                        <c:when test="${tx.type eq 'PAYMENT'}">
                                            <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-rose-50 text-rose-600 border border-rose-200">
                                                <i class="fas fa-arrow-up-right text-[0.65rem] mr-1"></i>Thanh toán
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-600 border border-blue-200">
                                                    ${tx.type}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="py-4 text-gray-800 font-medium">
                                        ${tx.description}
                                    <c:if test="${not empty tx.orderId}">
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${tx.orderId}" class="ml-1 text-xs text-indigo-600 hover:underline">
                                            [Xem đơn #${tx.orderId}]
                                        </a>
                                    </c:if>
                                </td>
                                <td class="py-4 text-right font-bold text-base ${tx.type eq 'PAYMENT' ? 'text-rose-600' : 'text-emerald-600'}">
                                        ${tx.type eq 'PAYMENT' ? '-' : '+'}<fmt:formatNumber value="${tx.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" class="py-12 text-center">
                                <div class="flex flex-col items-center justify-center text-gray-400">
                                    <i class="fas fa-wallet text-4xl mb-3 text-gray-300"></i>
                                    <p class="text-sm font-medium">Ví chưa phát sinh biến động số dư nào</p>
                                    <p class="text-xs text-gray-400 mt-1">Khi bạn hủy đơn hàng đã thanh toán, khoản tiền hoàn sẽ hiển thị tại đây.</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</main>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>
