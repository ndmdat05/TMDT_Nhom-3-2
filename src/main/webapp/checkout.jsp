<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/22/2026
  Time: 10:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoàn thành thanh toán - MangaVault</title>

    <!-- Tailwind Grid & Font Awesome 6 Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">
</head>
<body class="bg-gray-50 font-sans text-gray-900 min-h-screen flex flex-col justify-between">

<!-- Header Include -->
<jsp:include page="includes/header.jsp" />

<div class="container mx-auto px-4 md:px-8 max-w-6xl py-8 flex-grow">

    <div class="checkout-breadcrumb">
        <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> / <span>Thanh toán</span>
    </div>

    <h1 class="checkout-title">Hoàn thành thanh toán</h1>

    <c:set var="cartItems" value="${not empty sessionScope.cart.items ? sessionScope.cart.items : (not empty cart.items ? cart.items : null)}" />
    <c:set var="totalMoney" value="${not empty sessionScope.cart.totalMoney ? sessionScope.cart.totalMoney : (not empty cart.totalMoney ? cart.totalMoney : 0)}" />
    <c:set var="itemCount" value="${not empty sessionScope.cart.totalQuantity ? sessionScope.cart.totalQuantity : (not empty cartItems ? cartItems.size() : 0)}" />

    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

            <div class="lg:col-span-7">
                <div class="checkout-step-card">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <span class="step-badge">BƯỚC 1</span>
                            <h2 class="step-heading">Thông tin giao hàng</h2>
                        </div>
                        <div class="text-gray-400 text-lg">
                            <i class="fa-solid fa-location-dot"></i>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <div class="form-group">
                            <label for="fullName">Tên</label>
                            <input type="text" id="fullName" name="fullName" required
                                   value="${not empty sessionScope.user.full_name ? sessionScope.user.full_name : ''}"
                                   placeholder="Nhập tên" class="form-control-input">
                        </div>
                        <div class="form-group">
                            <label for="phone">SĐT</label>
                            <input type="tel" id="phone" name="phone" required
                                   placeholder="Nhập số điện thoại" class="form-control-input">
                        </div>
                    </div>

                    <div class="form-group mb-2">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" required
                               placeholder="Nhập địa chỉ nhận hàng" class="form-control-input">
                    </div>

                    <label class="custom-checkbox-label">
                        <input type="checkbox" name="isDefault" value="true">
                        <span>Đặt làm mặc định</span>
                    </label>
                </div>
                <div class="checkout-step-card">
                    <div class="mb-4">
                        <span class="step-badge">BƯỚC 2</span>
                        <h2 class="step-heading">Phương thức thanh toán</h2>
                    </div>
                    <label class="payment-option-card active" id="opt-cod" onclick="selectPayment('COD')">
                        <input type="radio" name="paymentMethod" value="COD" checked>
                        <div class="payment-icon-box">
                            <i class="fa-solid fa-money-bill-wave"></i>
                        </div>
                        <div class="flex-grow min-w-0">
                            <div class="payment-info-title">
                                <span>Thanh toán trực tiếp (COD)</span>
                                <span class="badge-selected" id="badge-cod">Đã chọn</span>
                            </div>
                            <p class="payment-info-sub">Trả tiền mặt sau khi hàng giao tới bạn</p>
                        </div>
                    </label>

                    <label class="payment-option-card" id="opt-online" onclick="selectPayment('ONLINE')">
                        <input type="radio" name="paymentMethod" value="ONLINE">
                        <div class="payment-icon-box">
                            <i class="fa-regular fa-credit-card"></i>
                        </div>
                        <div class="flex-grow min-w-0">
                            <div class="payment-info-title">
                                <span>Thanh toán trực tuyến / Cổng thanh toán</span>
                                <span class="badge-selected hidden" id="badge-online">Đã chọn</span>
                            </div>
                            <p class="payment-info-sub">Visa, Thẻ ngân hàng</p>
                        </div>
                    </label>
                </div>

            </div>

            <div class="lg:col-span-5">
                <div class="order-summary-card">
                    <div class="summary-card-header">
                        <h3>Tổng quan đơn hàng</h3>
                        <span class="badge-item-count">${itemCount} sản phẩm</span>
                    </div>

                    <div class="order-item-list">
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <c:forEach var="item" items="${cartItems}" varStatus="loop">
                                    <c:set var="prod" value="${not empty item.product ? item.product : item.value.product}" />
                                    <c:set var="qty" value="${not empty item.quantity ? item.quantity : item.value.quantity}" />
                                    <c:set var="subTotal" value="${prod.price * qty}" />

                                    <div class="order-item-row">
                                        <div class="order-item-title">
                                                ${loop.index + 1}. <c:out value="${prod.title}" />
                                            <c:if test="${not empty prod.edition}">
                                                (<c:out value="${prod.edition}" />)
                                            </c:if>
                                            <c:if test="${qty > 1}">
                                                <span class="text-blue-600 font-semibold ml-1">x${qty}</span>
                                            </c:if>
                                        </div>
                                        <div class="order-item-price">
                                            <fmt:formatNumber value="${subTotal}" pattern="#,###"/> đ
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-sm text-gray-400 italic text-center py-2">Không có sản phẩm nào để thanh toán.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="price-row">
                        <span>Tạm tính</span>
                        <span><fmt:formatNumber value="${totalMoney}" pattern="#,###"/> đ</span>
                    </div>

                    <div class="price-row">
                        <span>Phí vận chuyển</span>
                        <span>0 đ</span>
                    </div>

                    <div class="price-row">
                        <span>Thuế</span>
                        <span>0 đ</span>
                    </div>

                    <div class="price-row total-final">
                        <span class="total-label">Tổng</span>
                        <span class="total-value"><fmt:formatNumber value="${totalMoney}" pattern="#,###"/> đ</span>
                    </div>

                    <c:choose>
                        <c:when test="${itemCount > 0}">
                            <button type="submit" class="btn-confirm-order">
                                <span>Xác nhận đặt hàng</span>
                                <i class="fa-solid fa-arrow-right"></i>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" disabled class="btn-confirm-order opacity-50 cursor-not-allowed">
                                <span>Giỏ hàng trống</span>
                            </button>
                        </c:otherwise>
                    </c:choose>

                    <div class="secure-note">
                        <i class="fa-solid fa-shield-halved"></i>
                        <span>Encrypted payment - 30-day returns</span>
                    </div>
                </div>
            </div>

        </div>
    </form>
</div>

<jsp:include page="includes/footer.jsp" />

<script>
    function selectPayment(method) {
        const optCod = document.getElementById('opt-cod');
        const optOnline = document.getElementById('opt-online');
        const badgeCod = document.getElementById('badge-cod');
        const badgeOnline = document.getElementById('badge-online');

        if (method === 'COD') {
            optCod.classList.add('active');
            optOnline.classList.remove('active');
            badgeCod.classList.remove('hidden');
            badgeOnline.classList.add('hidden');
        } else {
            optOnline.classList.add('active');
            optCod.classList.remove('active');
            badgeOnline.classList.remove('hidden');
            badgeCod.classList.add('hidden');
        }
    }
</script>

</body>
</html>
