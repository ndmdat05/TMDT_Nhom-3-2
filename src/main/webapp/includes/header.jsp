<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<header class="bg-white border-b border-gray-200 py-4 px-6 md:px-12 flex items-center justify-between sticky top-0 z-50">
    <!-- Khu vực Logo -->
    <a href="${pageContext.request.contextPath}/" class="flex items-center gap-3 no-underline">
        <div class="bg-orange-300 p-2 rounded-lg">
            <i class="fas fa-book text-gray-800 text-xl"></i>
        </div>
        <div>
            <h1 class="text-xl font-extrabold text-orange-400 m-0 leading-none">MANGAZ</h1>
            <span class="text-[0.65rem] font-bold text-gray-400 uppercase tracking-wider">Collector Exchange</span>
        </div>
    </a>

    <!-- Thanh tìm kiếm -->
    <div class="hidden md:flex flex-1 max-w-xl mx-8 relative">
        <div class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none">
            <i class="fas fa-search text-gray-400"></i>
        </div>
        <input type="text" class="w-full bg-indigo-50/50 border border-indigo-100 text-gray-900 text-sm rounded-full focus:ring-indigo-500 focus:border-indigo-500 block pl-10 p-2.5 placeholder-gray-400 font-medium" placeholder="Tìm kiếm truyện, bài đăng và users">
    </div>

    <!-- Menu Điều hướng & Nút Đăng bài -->
    <nav class="hidden lg:flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/" class="text-indigo-600 font-bold text-sm border-b-2 border-indigo-600 pb-1 no-underline">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/product-list" class="text-gray-700 font-bold text-sm hover:text-indigo-600 flex items-center gap-1 no-underline">
            Khám phá <i class="fas fa-chevron-down text-[0.6rem] text-gray-400"></i>
        </a>
        <a href="#" class="text-gray-700 font-bold text-sm hover:text-indigo-600 flex items-center gap-1 no-underline">
            <span class="w-2 h-2 rounded-full bg-indigo-600 inline-block"></span> Đấu giá
        </a>
        <a href="#" class="text-gray-700 font-bold text-sm hover:text-indigo-600 no-underline">Cộng đồng</a>

        <!-- Nút Đăng bài / Trade -->
        <a href="${pageContext.request.contextPath}/seller-manage" class="bg-emerald-500 hover:bg-emerald-600 text-white font-bold text-sm px-5 py-2.5 rounded-full flex items-center gap-2 transition-colors no-underline">
            <i class="fas fa-plus-circle"></i> Đăng bài / Trade
        </a>
    </nav>

    <!-- Khu vực Icons & Profile -->
    <div class="flex items-center gap-5 ml-6">
        <a href="${pageContext.request.contextPath}/wishlist" class="text-gray-600 hover:text-indigo-600 relative transition-colors no-underline" title="Kệ sách yêu thích">
            <i class="far fa-heart text-xl"></i>
            <c:if test="${not empty sessionScope.wishlist && fn:length(sessionScope.wishlist) > 0}">
                <span class="absolute -top-1 -right-2 bg-indigo-600 text-white text-[0.6rem] font-bold px-1.5 py-0.5 rounded-full border-2 border-white">
                        ${fn:length(sessionScope.wishlist)}
                </span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/cart" class="text-gray-600 hover:text-indigo-600 relative transition-colors no-underline" title="Giỏ hàng">
            <i class="fas fa-shopping-cart text-xl"></i>
            <c:if test="${not empty sessionScope.cart && sessionScope.cart.totalQuantity > 0}">
        <span class="absolute -top-1 -right-2 bg-indigo-600 text-white text-[0.6rem] font-bold px-1.5 py-0.5 rounded-full border-2 border-white">
                ${sessionScope.cart.totalQuantity}
        </span>
            </c:if>
        </a>
        <a href="#" class="text-gray-600 hover:text-indigo-600 relative transition-colors no-underline mr-2">
            <i class="far fa-bell text-xl"></i>
            <span class="absolute top-0 right-0 w-2.5 h-2.5 bg-indigo-600 border-2 border-white rounded-full"></span>
        </a>

        <div class="border-l pl-4 border-gray-200 relative group">
            <c:choose>
                <%-- NẾU ĐÃ ĐĂNG NHẬP (dùng sessionScope.user) --%>
                <c:when test="${not empty sessionScope.user}">
                    <c:set var="displayName" value="${not empty sessionScope.user.username ? sessionScope.user.username : (not empty sessionScope.user.full_name ? sessionScope.user.full_name : 'User')}" />

                    <div class="flex items-center gap-2 cursor-pointer">
                        <div class="relative">
                                <%-- Lấy 2 chữ cái đầu làm avatar đại diện --%>
                            <div class="w-10 h-10 rounded-full bg-indigo-900 text-white flex items-center justify-center font-bold text-sm border-2 border-gray-100">
                                    ${fn:toUpperCase(fn:substring(displayName, 0, 2))}
                            </div>
                            <div class="absolute -bottom-1 -right-1 bg-yellow-400 text-gray-900 rounded-full p-1 border-2 border-white flex items-center justify-center w-5 h-5">
                                <i class="fas fa-cog text-[0.5rem]"></i>
                            </div>
                        </div>
                        <i class="fas fa-chevron-down text-gray-400 text-xs transition-transform group-hover:rotate-180"></i>
                    </div>

                    <%-- Dropdown Menu khi hover chuột vào --%>
                    <div class="absolute right-0 top-full pt-2 w-52 bg-white rounded-lg shadow-lg py-2 hidden group-hover:block border border-gray-100 z-50">
                        <div class="px-4 py-2 border-b border-gray-100">
                            <p class="text-sm font-bold text-gray-900 truncate">
                                    ${not empty sessionScope.user.full_name ? sessionScope.user.full_name : sessionScope.user.username}
                            </p>
                            <p class="text-xs text-gray-500 truncate">${sessionScope.user.email}</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 no-underline">
                            <i class="fas fa-user mr-2"></i>Tài khoản của tôi
                        </a>
                        <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-2 text-sm text-indigo-600 hover:bg-indigo-50 font-semibold no-underline">
                                <i class="fas fa-chart-line mr-2"></i>Trang quản trị
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-sm text-red-600 hover:bg-red-50 font-semibold no-underline">
                            <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                        </a>
                    </div>
                </c:when>

                <%-- NẾU CHƯA ĐĂNG NHẬP --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="flex items-center gap-2 cursor-pointer text-gray-600 hover:text-indigo-600 no-underline">
                        <i class="fas fa-user-circle text-2xl"></i>
                        <span class="text-sm font-bold">Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>