<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MangaVault - Sàn giao dịch Manga</title>
    <!-- Nhúng Tailwind CSS (Quan trọng cho Header/Footer mới) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Cấu hình Font cho Tailwind -->
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

<!-- Header Include -->
<jsp:include page="includes/header.jsp" />

<!-- Hero Banner -->
<div class="hero-banner text-white py-20 mb-12 text-center">
    <div class="container mx-auto px-4">
        <h1 class="text-4xl md:text-5xl font-extrabold mb-4">Chào mừng đến với MangaVault</h1>
        <p class="text-lg md:text-xl text-indigo-100 mb-8 max-w-2xl mx-auto">Nơi sưu tầm những bộ truyện tranh, manga HOT nhất hiện nay!</p>
        <a href="#manga-list" class="inline-flex items-center gap-2 bg-rose-500 hover:bg-rose-600 text-white font-bold py-3 px-8 rounded-full transition-colors">
            <i class="fas fa-book-open"></i> Khám Phá Ngay
        </a>
    </div>
</div>

<!-- Main Content -->
<div class="container mx-auto px-4 md:px-8 max-w-7xl mb-20" id="manga-list">

    <!-- Section Manga Mới -->
    <div class="flex justify-between items-center mb-6">
        <div class="flex items-center gap-3">
            <div class="w-1.5 h-6 bg-rose-500 rounded-full"></div>
            <h3 class="text-xl font-bold uppercase tracking-wide m-0">Manga Mới Cập Nhật</h3>
        </div>
        <a href="products" class="text-rose-500 font-semibold hover:text-rose-600 flex items-center gap-1 text-sm">
            Xem tất cả <i class="fas fa-chevron-right text-[0.6rem]"></i>
        </a>
    </div>

    <!-- Grid Layout: 2 cột (Mobile), 3 cột (Tablet), 4 cột (Desktop) -->
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6 lg:gap-8 mb-16">
        <c:forEach var="p" items="${newMangaList}">
            <!-- Thẻ Manga -->
            <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full">
                <div class="relative bg-orange-200 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden group">
                    <span class="absolute top-3 left-3 bg-gray-800 text-white text-[0.65rem] font-bold px-2 py-1 rounded">MangaVault</span>
                    <!-- Nếu có URL ảnh thật thì dùng img, đây là icon hiển thị tạm -->
                    <i class="fas fa-book text-6xl text-gray-800 group-hover:scale-110 transition-transform duration-300"></i>
                </div>

                <div class="flex-grow flex flex-col justify-between">
                    <div>
                        <h6 class="font-bold text-gray-900 text-sm md:text-base leading-tight mb-2 line-clamp-2" title="${p.name}">${p.name}</h6>
                        <p class="text-rose-500 font-extrabold text-sm md:text-base mb-4"><fmt:formatNumber value="${p.price}" pattern="#,###"/> đ</p>
                    </div>

                    <div class="grid grid-cols-2 gap-2 mt-auto">
                        <a href="product-detail?id=${p.id}" class="text-center py-2 border border-gray-200 text-gray-700 font-semibold text-xs md:text-sm rounded-lg hover:bg-gray-50 transition-colors">Chi tiết</a>
                        <a href="cart-add?id=${p.id}" class="text-center py-2 bg-rose-500 text-white font-semibold text-xs md:text-sm rounded-lg hover:bg-rose-600 transition-colors flex justify-center items-center gap-1">
                            <i class="fas fa-cart-plus"></i> <span class="hidden sm:inline">Thêm</span>
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Section Manga Nổi Bật -->
    <div class="flex justify-between items-center mb-6">
        <div class="flex items-center gap-3">
            <div class="w-1.5 h-6 bg-yellow-400 rounded-full"></div>
            <h3 class="text-xl font-bold uppercase tracking-wide m-0">Bộ Truyện Nổi Bật</h3>
        </div>
    </div>

    <!-- Grid Layout tương tự -->
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6 lg:gap-8">
        <c:forEach var="p" items="${featuredMangaList}">
            <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full">
                <div class="relative bg-orange-200 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden group">
                    <span class="absolute top-3 right-3 bg-yellow-400 text-gray-900 text-[0.65rem] font-bold px-2 py-1 rounded">HOT</span>
                    <i class="fas fa-book text-6xl text-gray-800 group-hover:scale-110 transition-transform duration-300"></i>
                </div>

                <div class="flex-grow flex flex-col justify-between">
                    <div>
                        <h6 class="font-bold text-gray-900 text-sm md:text-base leading-tight mb-2 line-clamp-2" title="${p.name}">${p.name}</h6>
                        <p class="text-rose-500 font-extrabold text-sm md:text-base mb-4"><fmt:formatNumber value="${p.price}" pattern="#,###"/> đ</p>
                    </div>

                    <div class="w-full mt-auto">
                        <a href="product-detail?id=${p.id}" class="block w-full text-center py-2 border border-rose-500 text-rose-500 font-semibold text-sm rounded-lg hover:bg-rose-50 transition-colors">Xem Chi Tiết</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</div>

<!-- Footer Include -->
<jsp:include page="includes/footer.jsp" />

</body>
</html>