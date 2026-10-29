<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - MangaVault</title>
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

<jsp:include page="includes/header.jsp" />

<main class="container mx-auto px-4 md:px-8 max-w-6xl my-8 flex-grow">

    <nav class="flex mb-6 text-sm text-gray-500 gap-2">
        <a href="${pageContext.request.contextPath}/" class="hover:text-indigo-600">Trang chủ</a>
        <span>/</span>
        <span class="text-gray-900 font-semibold">Trang cá nhân</span>
    </nav>

    <c:set var="user" value="${sessionScope.user}" />
    <c:set var="displayName" value="${not empty user.full_name ? user.full_name : user.username}" />

    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

        <aside class="lg:col-span-1">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-center">
                <div class="relative w-24 h-24 mx-auto mb-4">
                    <c:choose>
                        <c:when test="${not empty user.avatar_url}">
                            <img src="${user.avatar_url}" alt="Avatar" class="w-full h-full rounded-full object-cover border-4 border-indigo-50 shadow">
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-full rounded-full bg-indigo-900 text-white flex items-center justify-center font-bold text-2xl border-4 border-indigo-50 shadow">
                                    ${fn:toUpperCase(fn:substring(user.username, 0, 2))}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <span class="absolute bottom-1 right-1 w-5 h-5 bg-emerald-500 border-2 border-white rounded-full" title="Đang hoạt động"></span>
                </div>

                <h2 class="text-lg font-bold text-gray-900 truncate">${displayName}</h2>
                <p class="text-xs text-gray-500 mb-3 truncate">@${user.username}</p>

                <div class="inline-block px-3 py-1 text-xs font-semibold rounded-full
                        ${user.role eq 'ADMIN' ? 'bg-purple-100 text-purple-700' : (user.role eq 'SELLER' ? 'bg-amber-100 text-amber-700' : 'bg-blue-100 text-blue-700')}">
                    <i class="fas ${user.role eq 'ADMIN' ? 'fa-shield-alt' : (user.role eq 'SELLER' ? 'fa-store' : 'fa-user')} mr-1"></i>
                    ${user.role}
                </div>

                <hr class="my-6 border-gray-100">
                <nav class="space-y-1 text-left">
                    <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 px-4 py-2.5 rounded-xl bg-indigo-50 text-indigo-600 font-semibold text-sm">
                        <i class="fas fa-user-circle w-5"></i> Hồ sơ cá nhân
                    </a>
                    <a href="${pageContext.request.contextPath}/my-orders" class="flex items-center gap-3 px-4 py-2.5 rounded-xl text-gray-600 hover:bg-gray-50 hover:text-indigo-600 font-medium text-sm transition-colors">
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

        <section class="lg:col-span-3">
            <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-gray-100">

                <div class="flex items-center justify-between pb-6 border-b border-gray-100 mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-900">Thông tin tài khoản</h1>
                        <p class="text-sm text-gray-500 mt-1">Quản lý thông tin hồ sơ bảo mật của bạn</p>
                    </div>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="mb-6 p-4 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-sm flex items-center gap-2">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="mb-6 p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-sm flex items-center gap-2">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/profile" method="POST" class="space-y-6">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div>
                            <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                                Tên đăng nhập
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                                    <i class="fas fa-at"></i>
                                </div>
                                <input type="text" value="${user.username}" readonly
                                       class="w-full bg-gray-50 border border-gray-200 text-gray-500 text-sm rounded-xl pl-10 p-3 cursor-not-allowed focus:outline-none">
                            </div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                                Địa chỉ Email
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <input type="email" name="email" value="${user.email}" readonly
                                       class="w-full bg-gray-50 border border-gray-200 text-gray-500 text-sm rounded-xl pl-10 p-3 cursor-not-allowed focus:outline-none">
                            </div>
                        </div>

                        <div>
                            <label for="full_name" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                                Họ và Tên
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                                    <i class="fas fa-id-card"></i>
                                </div>
                                <input type="text" id="full_name" name="full_name" value="${user.full_name}"
                                       placeholder="Nhập họ và tên đầy đủ"
                                       class="w-full bg-white border border-gray-200 text-gray-900 text-sm rounded-xl pl-10 p-3 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all outline-none">
                            </div>
                        </div>

                        <div>
                            <label for="phone_number" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                                Số điện thoại
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <input type="text" id="phone_number" name="phone_number" value="${user.phone_number}"
                                       placeholder="Nhập số điện thoại"
                                       class="w-full bg-white border border-gray-200 text-gray-900 text-sm rounded-xl pl-10 p-3 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all outline-none">
                            </div>
                        </div>

                    </div>

                    <div>
                        <label for="avatar_url" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                            Đường dẫn Ảnh đại diện (Avatar URL)
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-400">
                                <i class="fas fa-image"></i>
                            </div>
                            <input type="text" id="avatar_url" name="avatar_url" value="${user.avatar_url}"
                                   placeholder="https://example.com/avatar.jpg"
                                   class="w-full bg-white border border-gray-200 text-gray-900 text-sm rounded-xl pl-10 p-3 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all outline-none">
                        </div>
                    </div>

                    <div>
                        <label for="address" class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                            Địa chỉ nhận hàng
                        </label>
                        <div class="relative">
                            <div class="absolute top-3.5 left-0 pl-3.5 flex items-start pointer-events-none text-gray-400">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <textarea id="address" name="address" rows="3"
                                      placeholder="Nhập địa chỉ nhận hàng chi tiết (Số nhà, đường, phường/xã, quận/huyện...)"
                                      class="w-full bg-white border border-gray-200 text-gray-900 text-sm rounded-xl pl-10 p-3 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all outline-none">${user.address}</textarea>
                        </div>
                    </div>

                    <div class="bg-gray-50 rounded-xl p-4 grid grid-cols-1 sm:grid-cols-2 gap-4 border border-gray-100 text-xs">
                        <div class="flex items-center gap-2">
                            <span class="font-bold text-gray-600">Trạng thái xác minh:</span>
                            <c:choose>
                                <c:when test="${user.is_verified}">
                                    <span class="text-emerald-600 font-bold flex items-center gap-1">
                                        <i class="fas fa-check-circle"></i> Đã xác thực
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-amber-600 font-bold flex items-center gap-1">
                                        <i class="fas fa-exclamation-circle"></i> Chưa xác thực
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flex items-center gap-2">
                            <span class="font-bold text-gray-600">Nguồn đăng nhập:</span>
                            <span class="text-indigo-600 font-semibold uppercase">${not empty user.auth_provider ? user.auth_provider : 'Hệ thống'}</span>
                        </div>
                    </div>

                    <div class="flex justify-end gap-3 pt-4 border-t border-gray-100">
                        <button type="submit" class="px-6 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold shadow-sm transition-colors flex items-center gap-2">
                            <i class="fas fa-save"></i> Lưu thông tin
                        </button>
                    </div>

                </form>

            </div>
        </section>

    </div>
</main>

<jsp:include page="includes/footer.jsp" />

</body>
</html>