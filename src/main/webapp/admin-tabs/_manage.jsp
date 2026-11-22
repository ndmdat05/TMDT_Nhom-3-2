
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MangaVault Admin Portal</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-track {
            background: transparent;
        }

        ::-webkit-scrollbar-thumb {
            background: #334155;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #475569;
        }
    </style>
</head>

<body class="bg-gray-50 text-gray-800 font-sans h-screen flex overflow-hidden">

<%-- SIDEBAR --%>
<aside class="w-[280px] bg-[#0f172a] text-slate-300 flex flex-col h-full border-r border-slate-800 shrink-0">

    <%-- LOGO --%>
    <div class="h-[80px] flex items-center px-6 border-b border-slate-800/50 mb-4">
        <div class="w-10 h-10 bg-indigo-500 rounded-xl flex items-center justify-center
                    text-white text-xl shadow-[0_0_15px_rgba(99,102,241,0.5)] mr-3">
            <i class="fas fa-book-open"></i>
        </div>

        <div class="flex flex-col">
            <span class="text-white font-black text-xl tracking-wide leading-none">
                MangaVault
            </span>
            <span class="text-indigo-400 font-bold text-[10px] tracking-widest mt-1">
                ADMIN PORTAL
            </span>
        </div>
    </div>

    <%-- MENU --%>
    <nav class="flex-1 px-4 space-y-1.5 overflow-y-auto">

        <a href="${ctx}/admin/manage?tab=dashboard"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'dashboard' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-chart-line w-5 text-center text-lg"></i>
            Tổng quan sàn
        </a>

        <div class="h-px bg-slate-800/50 my-4"></div>

        <a href="${ctx}/admin/manage?tab=users"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'users' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-users w-5 text-center text-lg"></i>
            Quản lý người dùng
        </a>

        <%-- QUẢN LÝ DỮ LIỆU TRUYỆN --%>
        <a href="${ctx}/admin/manage?tab=data-management"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'data-management' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-book w-5 text-center text-lg"></i>
            Quản lý dữ liệu truyện
        </a>

        <%-- QUẢN LÝ DANH MỤC --%>
        <a href="${ctx}/admin/manage?tab=categories"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'categories' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-layer-group w-5 text-center text-lg"></i>
            Quản lý danh mục
        </a>

        <div class="h-px bg-slate-800/50 my-4"></div>

        <a href="${ctx}/admin/manage?tab=content-review"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'content-review' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-check-square w-5 text-center text-lg"></i>
            Duyệt bài đăng manga
        </a>

        <a href="${ctx}/admin/manage?tab=report-center"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'report-center' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-shield-alt w-5 text-center text-lg"></i>
            Báo cáo &amp; Khiếu nại
        </a>

        <a href="${ctx}/admin/manage?tab=support-center"
           class="flex items-center gap-4 px-4 py-3.5 rounded-xl font-semibold transition-all duration-200
           ${activeTab == 'support-center' ? 'bg-[#5b52f6] text-white shadow-lg shadow-indigo-500/30' : 'hover:bg-slate-800 hover:text-white'}">
            <i class="fas fa-headset w-5 text-center text-lg"></i>
            Hỗ trợ khách hàng
        </a>

    </nav>

    <%-- THÔNG TIN ADMIN --%>
    <div class="p-4 bg-slate-900 border-t border-slate-800 flex items-center gap-3">

        <c:set var="adminName"
               value="${not empty sessionScope.user.full_name
                       ? sessionScope.user.full_name
                       : sessionScope.user.username}"/>

        <div class="w-10 h-10 rounded-full bg-indigo-600 flex items-center justify-center
                    text-white font-bold border-2 border-indigo-400">
            <c:choose>
                <c:when test="${not empty adminName}">
                    ${fn:toUpperCase(fn:substring(adminName, 0, 2))}
                </c:when>
                <c:otherwise>AD</c:otherwise>
            </c:choose>
        </div>

        <div class="flex-1 overflow-hidden">
            <p class="text-white text-sm font-bold truncate">
                <c:out value="${not empty adminName ? adminName : 'Administrator'}"/>
            </p>
            <p class="text-slate-500 text-xs">Administrator</p>
        </div>

        <a href="${ctx}/logout"
           class="text-slate-400 hover:text-white transition"
           title="Đăng xuất">
            <i class="fas fa-sign-out-alt"></i>
        </a>
    </div>

</aside>

<%-- MAIN CONTENT --%>
<main class="flex-1 flex flex-col h-full bg-[#f8fafc] overflow-y-auto">

    <header class="bg-white border-b border-gray-200 h-[60px] flex items-center
                   justify-between px-8 shrink-0">

        <h2 class="font-bold text-gray-700">
            <a href="${ctx}/home" class="hover:text-indigo-600">
                <i class="fas fa-globe text-indigo-500 mr-2"></i>
                Xem Trang Chủ Sàn
            </a>
        </h2>

        <div class="flex items-center gap-2 px-3 py-1.5 bg-emerald-50
                    text-emerald-600 rounded-full text-xs font-bold border border-emerald-100">
            <div class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></div>
            HỆ THỐNG HOẠT ĐỘNG BÌNH THƯỜNG
        </div>
    </header>

    <%-- RENDER TAB --%>
    <div class="p-8">

        <c:choose>

            <c:when test="${activeTab == 'dashboard' or empty activeTab}">
                <jsp:include page="/admin-tabs/_dashboard.jsp"/>
            </c:when>

            <c:when test="${activeTab == 'users'}">
                <jsp:include page="/admin-tabs/_users.jsp"/>
            </c:when>

            <c:when test="${activeTab == 'data-management'}">
                <jsp:include page="/admin-tabs/_data-management.jsp"/>
            </c:when>

            <c:when test="${activeTab == 'categories'}">
                <jsp:include page="/admin-tabs/_categories.jsp"/>
            </c:when>

            <c:when test="${activeTab == 'content-review'}">
                <jsp:include page="/admin-tabs/_content-review.jsp"/>
            </c:when>

            <c:when test="${activeTab == 'report-center'}">
                <jsp:include page="/admin-tabs/_report-center.jsp"/>
            </c:when>

            <c:when test="${activeTab == 'support-center'}">
                <jsp:include page="/admin-tabs/_support-center.jsp"/>
            </c:when>

            <c:otherwise>
                <jsp:include page="/admin-tabs/_dashboard.jsp"/>
            </c:otherwise>

        </c:choose>

    </div>
</main>

</body>
</html>
```