<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kệ Sách Yêu Thích - MangaVault</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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

<main class="container mx-auto px-4 md:px-8 max-w-7xl my-8 flex-grow">

    <!-- BREADCRUMB -->
    <nav class="flex text-xs text-gray-500 gap-2 items-center mb-6">
        <a href="${pageContext.request.contextPath}/" class="hover:text-indigo-600 transition">Trang chủ</a>
        <span>/</span>
        <span class="text-gray-900 font-semibold">Kệ sách yêu thích</span>
    </nav>

    <!-- TIÊU ĐỀ KỆ SÁCH -->
    <div class="flex justify-between items-center mb-8 pb-4 border-b border-gray-200">
        <div class="flex items-center gap-3">
            <div class="w-1.5 h-7 bg-rose-500 rounded-full"></div>
            <div>
                <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Kệ Sách Yêu Thích</h1>
                <p class="text-xs md:text-sm text-gray-500 mt-0.5">Những ấn phẩm manga sưu tầm bạn đã lưu</p>
            </div>
        </div>
        <span class="bg-rose-50 text-rose-600 border border-rose-200 text-xs md:text-sm font-bold px-3 py-1.5 rounded-xl flex items-center gap-1.5">
            <i class="fa-solid fa-heart text-rose-500"></i> ${not empty wishlistItems ? wishlistItems.size() : 0} ấn phẩm
        </span>
    </div>

    <!-- DANH SÁCH THẺ TRUYỆN -->
    <c:choose>
        <c:when test="${not empty wishlistItems}">
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6 lg:gap-8 mb-16">
                <c:forEach var="p" items="${wishlistItems}">
                    <c:set var="pImg" value="${not empty p.imageUrl ? (p.imageUrl.startsWith('http') ? p.imageUrl : (p.imageUrl.startsWith('/') ? pageContext.request.contextPath.concat(p.imageUrl) : pageContext.request.contextPath.concat('/').concat(p.imageUrl))) : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" />

                    <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full relative group">

                        <!-- Nút xóa nhanh khỏi wishlist -->
                        <a href="${pageContext.request.contextPath}/wishlist?action=remove&productId=${p.id}"
                           title="Bỏ thích khỏi danh sách"
                           class="absolute top-6 right-6 z-20 w-8 h-8 rounded-full bg-white/90 hover:bg-rose-500 text-rose-500 hover:text-white flex items-center justify-center shadow-md transition duration-200 border border-rose-100">
                            <i class="fa-solid fa-heart text-xs"></i>
                        </a>

                        <!-- Ảnh bìa -->
                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="relative bg-gray-100 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden">
                            <span class="absolute top-3 left-3 bg-gray-900/80 backdrop-blur-sm text-white text-[0.65rem] font-bold px-2 py-1 rounded z-10">MangaZ</span>
                            <img src="${pImg}" alt="<c:out value='${p.title}' />" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                        </a>

                        <!-- Thông tin & Giá -->
                        <div class="flex-grow flex flex-col justify-between">
                            <div>
                                <h4 class="font-bold text-gray-900 text-sm md:text-base leading-tight mb-2 line-clamp-2" title="<c:out value='${p.title}' />">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="hover:text-indigo-600 transition-colors">
                                        <c:out value="${p.title}" />
                                    </a>
                                </h4>
                                <p class="text-indigo-600 font-extrabold text-sm md:text-base mb-4">
                                    <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ
                                </p>
                            </div>

                            <div class="w-full mt-auto">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
                                   class="block w-full text-center py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs md:text-sm rounded-xl transition duration-200 shadow-sm">
                                    Xem Chi Tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="bg-white rounded-3xl border border-gray-100 p-12 text-center max-w-md mx-auto shadow-sm my-12">
                <div class="w-20 h-20 bg-rose-50 text-rose-500 rounded-full flex items-center justify-center mx-auto mb-4 text-3xl">
                    <i class="fa-regular fa-heart"></i>
                </div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Kệ sách đang trống</h3>
                <p class="text-xs md:text-sm text-gray-500 mb-6 leading-relaxed">Bạn chưa lưu ấn phẩm nào. Hãy bấm trái tim ở trang chi tiết sản phẩm để lưu lại theo dõi!</p>
                <a href="${pageContext.request.contextPath}/"
                   class="inline-flex items-center gap-2 px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs md:text-sm rounded-xl transition shadow-sm">
                    <i class="fa-solid fa-book-open"></i> Khám phá Manga ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>