<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám phá kho tàng Manga - MangaZ Collector Exchange</title>
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
<body class="bg-gray-50 font-sans text-gray-900 min-h-screen flex flex-col justify-between">

<jsp:include page="includes/header.jsp" />

<div class="hero-banner text-white py-12 mb-8 text-center">
    <div class="container mx-auto px-4">
        <h1 class="text-3xl md:text-4xl font-black mb-2 tracking-tight">Khám Phá Kệ Sách MangaZ</h1>
        <p class="text-sm md:text-base text-indigo-100 max-w-xl mx-auto">Tìm kiếm những ấn phẩm truyện tranh, bản in giới hạn và vật phẩm sưu tầm độc quyền từ cộng đồng collector.</p>
    </div>
</div>

<main class="container mx-auto max-w-7xl px-4 md:px-8 mb-16 flex-1">

    <nav class="flex text-sm text-gray-500 mb-6" aria-label="Breadcrumb">
        <ol class="inline-flex items-center space-x-1 md:space-x-3">
            <li class="inline-flex items-center">
                <a href="${pageContext.request.contextPath}/" class="hover:text-indigo-600 flex items-center gap-1">
                    <i class="fas fa-house text-xs text-indigo-600"></i> Trang chủ
                </a>
            </li>
            <li>
                <div class="flex items-center">
                    <i class="fas fa-chevron-right text-xs text-gray-400 mx-2"></i>
                    <span class="text-gray-800 font-semibold">Khám phá sản phẩm</span>
                </div>
            </li>
        </ol>
    </nav>

    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

        <aside class="lg:col-span-1">
            <div class="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm sticky top-24">
                <div class="flex items-center justify-between pb-4 mb-5 border-b border-gray-100">
                    <h3 class="font-extrabold text-gray-900 flex items-center gap-2 text-base">
                        <i class="fas fa-filter text-indigo-600"></i> Bộ Lọc Tìm Kiếm
                    </h3>
                    <a href="${pageContext.request.contextPath}/product-list" class="text-xs font-bold text-indigo-600 hover:underline">Đặt lại</a>
                </div>

                <form action="${pageContext.request.contextPath}/product-list" method="GET" class="space-y-5">

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Nhà Xuất Bản</label>
                        <div class="relative">
                            <i class="fas fa-building absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                            <input type="text" name="publisher" value="${param.publisher}" placeholder="Nhập nhà xuất bản..."
                                   class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl pl-9 pr-3 py-2.5 focus:ring-2 focus:ring-indigo-500 outline-none">
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Tên Người Bán / Shop</label>
                        <div class="relative">
                            <i class="fas fa-store absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                            <input type="text" name="seller" value="${param.seller}" placeholder="Nhập tên shop..."
                                   class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl pl-9 pr-3 py-2.5 focus:ring-2 focus:ring-indigo-500 outline-none">
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Tình Trạng</label>
                        <select name="condition" class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="">Tất cả tình trạng</option>
                            <c:forEach var="cond" items="${conditionList}">
                                <option value="${cond}" ${param.condition == cond ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${cond == 'NEW'}">Mới 100% (NEW)</c:when>
                                        <c:when test="${cond == 'LIKE_NEW'}">Like New (Sưu tầm)</c:when>
                                        <c:when test="${cond == 'USED'}">Đã qua sử dụng (USED)</c:when>
                                        <c:otherwise>${cond}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Ngôn Ngữ Ấn Bản</label>
                        <select name="language" class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="">Tất cả ngôn ngữ</option>
                            <c:forEach var="lang" items="${languageList}">
                                <option value="${lang}" ${param.language == lang ? 'selected' : ''}>
                                        ${lang}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Thể Loại</label>
                        <select name="categoryId" class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="">Tất cả thể loại</option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>
                                        ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Khoảng Giá (VNĐ)</label>
                        <div class="grid grid-cols-2 gap-2">
                            <input type="number" name="minPrice" value="${param.minPrice}" placeholder="Từ giá"
                                   class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-500">
                            <input type="number" name="maxPrice" value="${param.maxPrice}" placeholder="Đến giá"
                                   class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-500">
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Sắp Xếp Theo</label>
                        <select name="sort" class="w-full bg-indigo-50/30 border border-gray-200 text-gray-900 text-xs rounded-xl px-3 py-2.5 outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Cập nhật mới nhất</option>
                            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá: Cao xuống Thấp</option>
                            <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>Phổ biến / Sưu tầm nổi bật</option>
                        </select>
                    </div>

                    <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs py-3 rounded-xl shadow-md transition flex items-center justify-center gap-2">
                        <i class="fas fa-check"></i> Áp Dụng Lọc
                    </button>
                </form>
            </div>
        </aside>

        <section class="lg:col-span-3 space-y-6">

            <div class="grid grid-cols-2 md:grid-cols-3 gap-4 md:gap-6">

                <c:choose>
                    <c:when test="${not empty productList}">
                        <c:forEach var="p" items="${productList}">
                            <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="relative bg-gray-100 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden group">
                                    <span class="absolute top-3 left-3 bg-white/90 backdrop-blur-sm text-indigo-900 text-[0.65rem] font-bold px-2 py-1 rounded z-10">
                                            ${not empty p.categoriesName ? p.categoriesName : 'Chưa phân loại'}
                                    </span>
                                    <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.title}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" onerror="this.src='https://images.unsplash.com/photo-1618336753974-aae8e04506aa?auto=format&fit=crop&q=80&w=400'">
                                </a>
                                <div class="flex-grow flex flex-col justify-between">
                                    <div>
                                        <div class="flex items-center justify-between text-[11px] text-gray-400 mb-1">
                                            <span class="truncate max-w-[110px]">Tác giả: <strong class="text-gray-700">${p.author}</strong></span>
                                            <span class="text-indigo-600 font-bold">${p.item_condition}</span>
                                        </div>
                                        <h4 class="font-bold text-gray-900 text-sm md:text-base leading-tight mb-2 line-clamp-2">
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="hover:text-indigo-600 transition-colors">${p.title}</a>
                                        </h4>
                                        <p class="text-xs text-gray-500 mb-1 truncate" title="${p.publisherName}">
                                            <i class="fas fa-book-open text-indigo-500 mr-1"></i>
                                            NXB:
                                            <span class="font-semibold text-gray-700">
                                                    ${not empty p.publisherName ? p.publisherName : 'Chưa cập nhật'}
                                            </span>
                                        </p>
                                        <p class="text-xs text-gray-500 mb-2 truncate">
                                            Shop: <span class="font-semibold text-gray-700">${p.sellerName}</span>
                                        </p>
                                        <p class="text-indigo-600 font-extrabold text-sm md:text-base mb-4"><fmt:formatNumber value="${p.price}" pattern="#,###" /> đ</p>
                                    </div>
                                    <div class="w-full mt-auto">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="block w-full text-center py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs md:text-sm rounded-xl transition shadow-sm">Xem Chi Tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full bg-white rounded-2xl border border-gray-200 p-10 text-center">
                            <i class="fas fa-book-open text-4xl text-gray-300 mb-4"></i>
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Chưa có sản phẩm nào</h3>
                            <p class="text-sm text-gray-500">Không tìm thấy sản phẩm nào phù hợp .</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

            <c:if test="${totalPages > 1}">
                <div class="flex justify-center items-center space-x-2 mt-8">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="${pageContext.request.contextPath}/product-list?page=${i}&publisher=${param.publisher}&seller=${param.seller}&condition=${param.condition}&language=${param.language}&categoryId=${param.categoryId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${param.sort}"
                           class="px-4 py-2 rounded-xl text-xs font-bold transition ${currentPage == i ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-gray-700 border border-gray-200 hover:bg-indigo-50'}">
                                ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>

        </section>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />

</body>
</html>