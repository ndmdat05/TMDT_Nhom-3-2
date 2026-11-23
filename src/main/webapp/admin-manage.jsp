<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MangaVault Admin Portal</title>

    <!-- Tailwind CSS CDN & FontAwesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        vault: {
                            sidebar: '#0f172a',
                            card: '#1e1b4b',
                            primary: '#4f46e5',
                            hover: '#4338ca'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50 font-sans text-gray-800 antialiased min-h-screen flex">

<!-- SIDEBAR BÊN TRÁI -->
<aside class="w-64 bg-vault-sidebar text-white flex-shrink-0 min-h-screen flex flex-col justify-between p-4 border-r border-slate-800">
    <div>
        <!-- LOGO BRANDING -->
        <div class="flex items-center gap-3 px-3 py-4 border-b border-slate-800 mb-6">
            <div class="w-9 h-9 rounded-xl bg-indigo-600 flex items-center justify-center font-black text-lg text-white shadow-lg shadow-indigo-500/30">
                <i class="fa-solid fa-book-open"></i>
            </div>
            <div>
                <h1 class="font-extrabold text-base tracking-tight leading-tight text-white">MangaVault</h1>
                <span class="text-[11px] text-indigo-400 font-semibold uppercase tracking-wider">Admin Portal</span>
            </div>
        </div>

        <!-- MENU TÍNH NĂNG MANAGEMENT -->
        <nav class="space-y-1.5 text-sm font-semibold">
            <!-- 1. Tổng quan -->
            <a href="${pageContext.request.contextPath}/dashboard"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'dashboard' || empty activeTab ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-chart-line w-5"></i> Tổng quan sàn
            </a>

            <!-- 2. Quản lý người dùng -->
            <a href="${pageContext.request.contextPath}/admin/manage?tab=users"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'users' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-users w-5"></i> Quản lý người dùng
            </a>

            <!-- 3. Quản lý dữ liệu truyện -->
            <a href="${pageContext.request.contextPath}/admin/manage?tab=data-management"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'data-management' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-book w-5"></i> Quản lý dữ liệu truyện
            </a>

            <!-- 4. Quản lý danh mục -->
            <a href="${pageContext.request.contextPath}/admin/manage?tab=categories"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'categories' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-layer-group w-5"></i> Quản lý danh mục
            </a>

            <!-- 5. Duyệt bài đăng -->
            <a href="${pageContext.request.contextPath}/admin/content-review"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'content-review' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-square-check w-5"></i> Duyệt bài đăng manga
            </a>

            <!-- 6. QUẢN LÝ ĐẤU GIÁ (MỚI THÊM VÀO ĐÂY) -->
            <a href="${pageContext.request.contextPath}/admin/auctions"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'auctions' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-gavel w-5"></i> Quản lý Đấu giá
            </a>

            <!-- 7. Báo cáo & Khiếu nại -->
            <a href="${pageContext.request.contextPath}/admin/report-center"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'report-center' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-shield-cat w-5"></i> Báo cáo & Khiếu nại
            </a>

            <!-- 8. Hỗ trợ khách hàng -->
            <a href="${pageContext.request.contextPath}/admin/support-center"
               class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${activeTab == 'support-center' ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20' : 'text-slate-400 hover:bg-slate-800/60 hover:text-slate-200'}">
                <i class="fa-solid fa-headset w-5"></i> Hỗ trợ khách hàng
            </a>
        </nav>
    </div>

    <!-- FOOTER USER PROFILE & LOGOUT -->
    <div class="pt-4 border-t border-slate-800">
        <div class="flex items-center gap-3 px-2 mb-3">
            <div class="w-8 h-8 rounded-full bg-indigo-950 text-indigo-400 font-bold flex items-center justify-center text-xs border border-indigo-800">
                AD
            </div>
            <div class="min-w-0 flex-1">
                <div class="text-xs font-bold text-slate-200 truncate">${sessionScope.user.full_name != null ? sessionScope.user.full_name : sessionScope.user.username}</div>
                <div class="text-[10px] text-slate-400 truncate">Administrator</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-center gap-2 px-4 py-2 rounded-lg bg-slate-800 hover:bg-rose-950/60 text-slate-300 hover:text-rose-400 text-xs font-bold transition-all border border-slate-700">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</aside>

<!-- CONTAINER NỘI DUNG CHÍNH -->
<div class="flex-grow flex flex-col min-w-0">

    <!-- HEADER TRÊN CÙNG -->
    <header class="bg-white border-b border-gray-200 px-8 py-3.5 flex items-center justify-between shadow-xs">
        <div class="flex items-center gap-2 text-xs text-gray-400">
            <a href="${pageContext.request.contextPath}/home" target="_blank" class="hover:text-indigo-600 flex items-center gap-1 font-semibold text-gray-600">
                <i class="fa-solid fa-globe"></i> Xem Trang Chủ Sàn
            </a>
        </div>

        <div class="flex items-center gap-3">
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 border border-indigo-100">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span> HỆ THỐNG HOẠT ĐỘNG BÌNH THƯỜNG
                </span>
        </div>
    </header>

    <!-- KHU VỰC NHÚNG CÁC TAB -->
    <main class="p-8 flex-grow">
        <c:choose>
            <c:when test="${activeTab == 'dashboard' || empty activeTab}">
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

            <!-- NHÚNG TAB ĐẤU GIÁ -->
            <c:when test="${activeTab == 'auctions'}">
                <jsp:include page="/admin-tabs/_auctions.jsp"/>
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
    </main>
</div>

</body>
</html>