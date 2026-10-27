<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- activeTab: users | products | orders | dashboard | content-review | report-center | support-center --%>
<c:set var="inGroup" value="${activeTab == 'content-review' || activeTab == 'report-center' || activeTab == 'support-center'}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MangaZ Admin - Quản lý Hệ thống</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/admin-tab-dashboard.css">
    <link rel="stylesheet" href="${ctx}/css/admin-tab-modules.css">
    <style> body { font-family: 'Inter', sans-serif; background-color: #FFFFFF; color: #111827; } </style>
</head>
<body class="min-h-screen flex flex-col bg-white" data-page="admin">

<header class="bg-white border-b border-gray-200 sticky top-0 z-50 h-[72px] flex items-center px-6">
    <div class="flex items-center gap-4 w-1/3">
        <span class="text-xl font-bold text-orange-500">MANGAZ</span>
        <span class="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded font-bold border border-gray-200">Admin Portal</span>
    </div>
    <div class="w-2/3 flex justify-end items-center gap-3">
        <a href="${ctx}/home" class="text-sm font-semibold text-gray-600 hover:text-gray-900 px-3 py-2">Trang chủ</a>
        <a href="${ctx}/seller-manage" class="text-sm font-bold text-white bg-green-600 hover:bg-green-700 px-4 py-2 rounded-lg">+ Đăng bài / Trade</a>
        <div class="w-9 h-9 rounded bg-indigo-600 flex items-center justify-center text-white font-bold text-sm">AD</div>
    </div>
</header>

<main class="flex-grow w-full flex">
    <!-- SIDEBAR -->
    <aside class="w-[260px] shrink-0 border-r border-gray-200 p-6 sticky top-[72px] h-[calc(100vh-72px)] overflow-y-auto">
        <nav class="space-y-2 text-sm font-semibold">

            <a href="${ctx}/admin/manage?tab=dashboard"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'dashboard' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                <i class="fas fa-chart-line w-5 text-center"></i> Dashboard
            </a>
            <a href="${ctx}/admin/manage?tab=users"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'users' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                <i class="fas fa-users w-5 text-center"></i> Quản lý Người dùng
            </a>
            <a href="${ctx}/admin/manage?tab=products"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'products' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                <i class="fas fa-book w-5 text-center"></i> Quản lý Sản phẩm
            </a>
            <a href="${ctx}/admin/manage?tab=orders"
               class="flex items-center gap-3 px-4 py-3 rounded-lg ${activeTab == 'orders' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                <i class="fas fa-shopping-bag w-5 text-center"></i> Quản lý Đơn hàng
            </a>

            <%-- TAB 5: DROPDOWN (bấm chỉ xổ ra/thu vào, KHÔNG chuyển trang) --%>
            <div>
                <button type="button" id="grpToggle" aria-expanded="${inGroup}" aria-controls="grpMenu"
                        class="w-full flex items-center justify-between gap-3 px-4 py-3 rounded-lg text-left ${inGroup ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                    <span class="flex items-center gap-3">
                        <i class="fas fa-layer-group w-5 text-center"></i> Quản lý nội dung &amp; hỗ trợ
                    </span>
                    <i id="grpChevron" class="fas fa-chevron-down text-xs transition-transform ${inGroup ? 'rotate-180' : ''}"></i>
                </button>

                <div id="grpMenu" class="${inGroup ? '' : 'hidden'} mt-1 ml-5 pl-3 border-l border-gray-200 space-y-1">
                    <a href="${ctx}/admin/manage?tab=content-review"
                       class="flex items-center gap-3 px-3 py-2 rounded-lg ${activeTab == 'content-review' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                        <i class="fas fa-clipboard-check w-4 text-center"></i> Kiểm duyệt bài đăng
                    </a>
                    <a href="${ctx}/admin/manage?tab=report-center"
                       class="flex items-center gap-3 px-3 py-2 rounded-lg ${activeTab == 'report-center' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                        <i class="fas fa-shield-halved w-4 text-center"></i> Báo cáo
                    </a>
                    <a href="${ctx}/admin/manage?tab=support-center"
                       class="flex items-center gap-3 px-3 py-2 rounded-lg ${activeTab == 'support-center' ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : 'text-gray-600 hover:bg-gray-50'}">
                        <i class="fas fa-headset w-4 text-center"></i> Hỗ trợ khách hàng
                    </a>
                </div>
            </div>

        </nav>
    </aside>

    <!-- CONTENT: mỗi tab là 1 fragment, cùng khung layout -->
    <section class="flex-grow min-w-0 p-8">
        <c:choose>
            <c:when test="${activeTab == 'dashboard'}">
                <jsp:include page="/WEB-INF/admin-tabs/_dashboard.jsp"/>
            </c:when>
            <c:when test="${activeTab == 'content-review'}">
                <jsp:include page="/WEB-INF/admin-tabs/_content-review.jsp"/>
            </c:when>
            <c:when test="${activeTab == 'report-center'}">
                <jsp:include page="/WEB-INF/admin-tabs/_report-center.jsp"/>
            </c:when>
            <c:when test="${activeTab == 'support-center'}">
                <jsp:include page="/WEB-INF/admin-tabs/_support-center.jsp"/>
            </c:when>
            <c:otherwise>
                <%-- users / products / orders --%>
                <jsp:include page="/WEB-INF/admin-tabs/_manage.jsp"/>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script>
    (function () {
        var btn = document.getElementById('grpToggle');
        var menu = document.getElementById('grpMenu');
        var chev = document.getElementById('grpChevron');
        btn.addEventListener('click', function (e) {
            e.preventDefault();               // chỉ xổ dropdown, không điều hướng
            var open = menu.classList.toggle('hidden') === false;
            btn.setAttribute('aria-expanded', open);
            chev.classList.toggle('rotate-180', open);
        });
    })();
</script>

<c:if test="${activeTab == 'dashboard'}">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
    <script src="${ctx}/js/dashboard.js"></script>
</c:if>
<c:if test="${activeTab == 'content-review'}">
    <script src="${ctx}/js/admin-modules.js"></script>
</c:if>
</body>
</html>
