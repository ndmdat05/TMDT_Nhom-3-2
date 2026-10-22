<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MangaVault - Sàn Giao Dịch & Sưu Tầm Manga</title>
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
    <style>
        .hero-banner {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
        }
    </style>
</head>
<body class="bg-gray-50 font-sans text-gray-900">

<jsp:include page="includes/header.jsp" />

<div class="hero-banner text-white py-20 mb-12 text-center">
    <div class="container mx-auto px-4">
        <h1 class="text-4xl md:text-5xl font-black mb-4 tracking-tight">Chào mừng đến với MangaVault</h1>
        <p class="text-lg md:text-xl text-indigo-100 mb-8 max-w-2xl mx-auto">Sàn lưu trữ, trao đổi & sưu tầm những ấn phẩm manga hiếm có giá trị cao!</p>
        <a href="#manga-list" class="inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-full transition-colors shadow-lg">
            <i class="fas fa-book-open"></i> Khám Phá Ngay
        </a>
    </div>
</div>


<div class="container mx-auto px-4 md:px-8 max-w-7xl mb-20" id="manga-list">

    <div class="flex justify-between items-center mb-6">
        <div class="flex items-center gap-3">
            <div class="w-1.5 h-6 bg-indigo-600 rounded-full"></div>
            <h3 class="text-xl font-bold uppercase tracking-wide m-0">Manga Mới Cập Nhật</h3>
        </div>
        <a href="#manga-list" class="text-indigo-600 font-semibold hover:text-indigo-700 flex items-center gap-1 text-sm">
            Xem tất cả <i class="fas fa-chevron-right text-[0.6rem]"></i>
        </a>
    </div>
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6 lg:gap-8 mb-16">
        <c:forEach var="p" items="${newMangaList}">
            <c:set var="pImg" value="${not empty p.imageUrl ? (p.imageUrl.startsWith('http') ? p.imageUrl : (p.imageUrl.startsWith('/') ? pageContext.request.contextPath.concat(p.imageUrl) : pageContext.request.contextPath.concat('/').concat(p.imageUrl))) : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" />

            <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="relative bg-gray-100 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden group">
                    <span class="absolute top-3 left-3 bg-gray-900/80 backdrop-blur-sm text-white text-[0.65rem] font-bold px-2 py-1 rounded z-10">MangaZ</span>
                    <img src="${pImg}" alt="<c:out value='${p.title}' />" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                </a>

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
    <div class="flex justify-between items-center mb-6">
        <div class="flex items-center gap-3">
            <div class="w-1.5 h-6 bg-amber-500 rounded-full"></div>
            <h3 class="text-xl font-bold uppercase tracking-wide m-0">Ấn Bản Sưu Tầm Nổi Bật</h3>
        </div>
    </div>
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6 lg:gap-8">
        <c:forEach var="p" items="${featuredMangaList}">
            <c:set var="pImg" value="${not empty p.imageUrl ? (p.imageUrl.startsWith('http') ? p.imageUrl : (p.imageUrl.startsWith('/') ? pageContext.request.contextPath.concat(p.imageUrl) : pageContext.request.contextPath.concat('/').concat(p.imageUrl))) : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" />

            <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="relative bg-gray-100 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden group">
                    <span class="absolute top-3 right-3 bg-amber-500 text-white text-[0.65rem] font-bold px-2 py-1 rounded z-10">HOT</span>
                    <img src="${pImg}" alt="<c:out value='${p.title}' />" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                </a>

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

</div>


<jsp:include page="includes/footer.jsp" />

</body>
</html>