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

<jsp:include page="includes/header.jsp"/>

<div class="hero-banner text-white py-12 mb-8 text-center">
    <div class="container mx-auto px-4">
        <h1 class="text-3xl md:text-4xl font-black mb-2 tracking-tight">Khám Phá Kệ Sách MangaZ</h1>
        <p class="text-sm md:text-base text-indigo-100 max-w-xl mx-auto">
            Tìm kiếm những ấn phẩm truyện tranh, bản in giới hạn và vật phẩm sưu tầm độc quyền từ cộng đồng collector.
        </p>
    </div>
</div>

<main class="container mx-auto max-w-7xl px-4 md:px-8 mb-16 flex-1">
    <nav class="flex text-sm text-gray-500 mb-6" aria-label="Breadcrumb">
        <ol class="inline-flex items-center space-x-1 md:space-x-3">
            <li class="inline-flex items-center">
                <a href="${pageContext.request.contextPath}/"
                   class="hover:text-indigo-600 flex items-center gap-1">
                    <i class="fas fa-house text-xs text-indigo-600"></i> Trang chủ
                </a>
            </li>
            <li>
                <div class="flex items-center">
                    <i class="fas fa-chevron-right text-xs text-gray-400 mx-2"></i>
                    <span class="text-gray-800 font-semibold">
                        <c:choose>
                            <c:when test="${not empty param.q}">
                                Kết quả tìm kiếm: "${param.q}"
                            </c:when>
                            <c:otherwise>Khám phá sản phẩm</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </li>
        </ol>
    </nav>

    <div class="grid grid-cols-1 gap-8">
        <section class="space-y-6">
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
                <c:choose>
                    <c:when test="${not empty productList}">
                        <c:forEach var="p" items="${productList}">
                            <div class="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100 flex flex-col h-full">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
                                   class="relative bg-gray-100 rounded-xl aspect-[3/4] mb-4 flex items-center justify-center overflow-hidden group">

                                    <span class="absolute top-3 left-3 bg-white/90 backdrop-blur-sm text-indigo-900 text-[0.65rem] font-bold px-2 py-1 rounded z-10">
                                            ${not empty p.categoriesName ? p.categoriesName : 'Chưa phân loại'}
                                    </span>

                                    <img src="${pageContext.request.contextPath}/${p.imageUrl}"
                                         alt="${p.title}"
                                         class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                         onerror="this.src='https://images.unsplash.com/photo-1618336753974-aae8e04506aa?auto=format&fit=crop&q=80&w=400'">
                                </a>

                                <div class="flex-grow flex flex-col justify-between">
                                    <div>
                                        <div class="flex items-center justify-between text-[11px] text-gray-400 mb-1">
                                            <span class="truncate max-w-[110px]">
                                                Tác giả: <strong class="text-gray-700">${p.author}</strong>
                                            </span>

                                            <span class="text-indigo-600 font-bold">
                                                <c:choose>
                                                    <c:when test="${p.item_condition == 'NEW'}">Mới 100% (SEAL)</c:when>
                                                    <c:when test="${p.item_condition == 'LIKE_NEW'}">Like New (Sưu tầm)</c:when>
                                                    <c:when test="${p.item_condition == 'USED'}">Đã qua sử dụng</c:when>
                                                    <c:otherwise>${p.item_condition}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <h4 class="font-bold text-gray-900 text-sm md:text-base leading-tight mb-2 line-clamp-2">
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
                                               class="hover:text-indigo-600 transition-colors">
                                                    ${p.title}
                                            </a>
                                        </h4>

                                        <p class="text-xs text-gray-500 mb-1 truncate"
                                           title="${p.publisherName}">
                                            <i class="fas fa-book-open text-indigo-500 mr-1"></i>
                                            NXB:
                                            <span class="font-semibold text-gray-700">
                                                    ${not empty p.publisherName ? p.publisherName : 'Chưa cập nhật'}
                                            </span>
                                        </p>

                                        <p class="text-xs text-gray-500 mb-2 truncate">
                                            Shop:
                                            <span class="font-semibold text-gray-700">${p.sellerName}</span>
                                        </p>

                                        <p class="text-indigo-600 font-extrabold text-sm md:text-base mb-4">
                                            <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ
                                        </p>
                                    </div>

                                    <div class="w-full mt-auto flex flex-row items-center gap-2">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}"
                                           class="flex-1 min-w-0 h-12 flex items-center justify-center bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs md:text-sm rounded-xl transition shadow-sm">
                                            Xem Chi Tiết
                                        </a>

                                        <form action="${pageContext.request.contextPath}/cart"
                                              method="post"
                                              class="m-0 shrink-0">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">

                                            <button type="submit"
                                                    class="h-12 w-12 flex items-center justify-center rounded-xl border border-gray-200 bg-gray-50 hover:bg-indigo-50 hover:border-indigo-200 text-gray-500 hover:text-indigo-600 transition"
                                                    title="Thêm vào giỏ hàng">
                                                <i class="fa-solid fa-cart-plus text-base"></i>
                                            </button>
                                        </form>

                                        <a href="${pageContext.request.contextPath}/wishlist?action=add&productId=${p.id}"
                                           class="h-12 w-12 shrink-0 flex items-center justify-center rounded-xl border transition ${not empty sessionScope.wishlist[p.id] ? 'bg-rose-50 border-rose-200 text-rose-600' : 'bg-gray-50 hover:bg-rose-50 border-gray-200 hover:border-rose-200 text-gray-500 hover:text-rose-500'}"
                                           title="${not empty sessionScope.wishlist[p.id] ? 'Đã có trong kệ sách' : 'Lưu vào kệ sách'}">
                                            <i class="${not empty sessionScope.wishlist[p.id] ? 'fa-solid text-rose-500' : 'fa-regular'} fa-heart text-lg"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <div class="col-span-full bg-white rounded-2xl border border-gray-200 p-10 text-center">
                            <i class="fas fa-book-open text-4xl text-gray-300 mb-4"></i>
                            <h3 class="text-lg font-bold text-gray-700 mb-2">Không tìm thấy sản phẩm</h3>

                            <c:choose>
                                <c:when test="${not empty param.q}">
                                    <p class="text-sm text-gray-500">
                                        Không có sản phẩm nào khớp với từ khóa
                                        "<strong>${param.q}</strong>".
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-sm text-gray-500">Chưa có sản phẩm nào.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="flex justify-center items-center space-x-2 mt-8">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:url var="pageUrl" value="/product-list">
                            <c:param name="page" value="${i}"/>
                            <c:param name="q" value="${param.q}"/>
                            <c:param name="sort" value="${param.sort}"/>
                        </c:url>

                        <a href="${pageContext.request.contextPath}${pageUrl}"
                           class="px-4 py-2 rounded-xl text-xs font-bold transition ${currentPage == i ? 'bg-indigo-600 text-white shadow-md' : 'bg-white text-gray-700 border border-gray-200 hover:bg-indigo-50'}">
                                ${i}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </section>
    </div>
</main>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>