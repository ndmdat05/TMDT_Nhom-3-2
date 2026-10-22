<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - MangaVault</title>

    <!-- Tailwind CDN cho Grid Layout & Font Awesome 6 Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
</head>
<body class="bg-gray-50 font-sans text-gray-900 min-h-screen flex flex-col justify-between">


<jsp:include page="includes/header.jsp" />
<div class="container mx-auto px-4 md:px-8 max-w-6xl py-8 flex-grow">
    <c:set var="cartItems" value="${not empty sessionScope.cart.items ? sessionScope.cart.items : (not empty cart.items ? cart.items : null)}" />
    <c:set var="totalMoney" value="${not empty sessionScope.cart.totalMoney ? sessionScope.cart.totalMoney : (not empty cart.totalMoney ? cart.totalMoney : 0)}" />
    <c:set var="itemCount" value="${not empty sessionScope.cart.totalQuantity ? sessionScope.cart.totalQuantity : (not empty cartItems ? cartItems.size() : 0)}" />

    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        <div class="lg:col-span-7">
            <div class="mb-5">
                <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Giỏ hàng</h1>
                <p class="text-sm text-gray-500 mt-1">Sản phẩm : <span class="font-semibold text-gray-700">${itemCount}</span></p>
            </div>

            <c:choose>
                <c:when test="${not empty cartItems && itemCount > 0}">
                    <div class="cart-list-wrapper">
                        <c:forEach var="item" items="${cartItems}">
                            <c:set var="prod" value="${not empty item.product ? item.product : item.value.product}" />
                            <c:set var="qty" value="${not empty item.quantity ? item.quantity : item.value.quantity}" />
                            <c:set var="subTotal" value="${prod.price * qty}" />

                            <c:set var="pImg" value="${not empty prod.imageUrl ? (prod.imageUrl.startsWith('http') ? prod.imageUrl : (prod.imageUrl.startsWith('/') ? pageContext.request.contextPath.concat(prod.imageUrl) : pageContext.request.contextPath.concat('/').concat(prod.imageUrl))) : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" />

                            <div class="cart-item-card">
                                <div class="flex items-center gap-4 min-w-0">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}" class="cart-thumb-box">
                                        <img src="${pImg}" alt="<c:out value='${prod.title}' />">
                                    </a>

                                    <div class="cart-item-info">
                                        <h3 class="cart-item-title" title="<c:out value='${prod.title}' />">
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}">
                                                <c:out value="${prod.title}" />
                                            </a>
                                        </h3>
                                        <p class="cart-item-meta">
                                            <c:choose>
                                                <c:when test="${not empty prod.edition}"><c:out value="${prod.edition}" /></c:when>
                                                <c:when test="${not empty prod.author}">Tác giả: <c:out value="${prod.author}" /></c:when>
                                                <c:otherwise>Ấn bản MangaZ</c:otherwise>
                                            </c:choose>
                                            <c:if test="${qty > 1}">
                                                <span class="text-indigo-600 font-semibold ml-1">(x${qty})</span>
                                            </c:if>
                                        </p>
                                    </div>
                                </div>
                                <div class="cart-action-group">
                                    <span class="cart-item-price">
                                        <fmt:formatNumber value="${subTotal}" pattern="#,###"/> đ
                                    </span>
                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="productId" value="${prod.id}">
                                        <button type="submit" class="btn-trash" title="Xóa khỏi giỏ hàng">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-white rounded-2xl p-10 border border-gray-100 text-center shadow-sm">
                        <div class="w-16 h-16 bg-indigo-50 text-indigo-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">
                            <i class="fa-solid fa-basket-shopping"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-800">Giỏ hàng của bạn đang trống</h3>
                        <p class="text-sm text-gray-400 mt-1 mb-6">Hãy dạo quanh sàn MangaVault và chọn ấn phẩm yêu thích nhé!</p>
                        <a href="${pageContext.request.contextPath}/home" class="inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 px-6 rounded-xl text-sm transition shadow-sm">
                            <i class="fa-solid fa-arrow-left"></i> Khám phá Manga ngay
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="lg:col-span-5">
            <div class="cart-summary-box">
                <div>
                    <div class="summary-header">
                        <h2>Chi tiết giỏ hàng</h2>
                        <div class="summary-user-avatar">
                            <c:set var="userAvatar" value="${not empty sessionScope.account.avatarUrl ? sessionScope.account.avatarUrl : pageContext.request.contextPath.concat('/Image/avatar_placeholder.jpg')}" />
                            <img src="${userAvatar}" alt="User Avatar">
                        </div>
                    </div>
                    <div class="summary-row">
                        <span>Tạm tính :</span>
                        <span class="price-val">
                            <fmt:formatNumber value="${totalMoney}" pattern="#,###"/> đ
                        </span>
                    </div>
                    <div class="summary-row">
                        <span>Phí vận chuyển :</span>
                        <span class="price-val">0 đ</span>
                    </div>
                    <div class="summary-row total-row">
                        <span>Tổng (Tax incl.) :</span>
                        <span class="price-val">
                            <fmt:formatNumber value="${totalMoney}" pattern="#,###"/> đ
                        </span>
                    </div>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${itemCount > 0}">
                            <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">
                                <span>Thanh Toán</span>
                                <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button type="button" disabled class="btn-checkout">
                                <span>Thanh Toán</span>
                                <i class="fa-solid fa-arrow-right"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </div>
</div>
<jsp:include page="includes/footer.jsp" />
</body>
</html>