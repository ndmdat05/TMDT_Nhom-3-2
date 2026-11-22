<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
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

                    <div class="form-group mb-4">
                        <label for="fullName">Tên</label>
                        <input type="text" id="fullName" name="fullName" required
                               value="${not empty sessionScope.user.full_name ? sessionScope.user.full_name : ''}"
                               placeholder="Nhập tên" class="form-control-input">
                    </div>
                    <div class="form-group mb-4">
                        <label for="email">Email nhận thông báo</label>
                        <input type="email" id="email" name="email" required
                               value="${not empty sessionScope.user.email ? sessionScope.user.email : ''}"
                               placeholder="Nhập địa chỉ email" class="form-control-input">
                    </div>

                    <div class="form-group mb-4">
                        <label for="phone">SĐT</label>
                        <input type="tel" id="phone" name="phone" required
                               value="${not empty sessionScope.user.phone_number ? sessionScope.user.phone_number : ''}"
                               placeholder="Nhập số điện thoại" class="form-control-input">
                    </div>

                    <div class="form-group mb-4">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" required
                               value="${not empty sessionScope.user.address ? sessionScope.user.address : ''}"
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

                    <!-- Tùy chọn COD -->
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

                    <!-- Tùy chọn ONLINE -->
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
                            <p class="payment-info-sub">Visa, Thẻ ngân hàng, VNPAY Sandbox</p>
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

<!-- ================= MODAL POP-UP CHỌN CỔNG ONLINE ================= -->
<div id="paymentModal" class="fixed inset-0 bg-black/50 backdrop-blur-xs z-50 flex items-center justify-center p-4 hidden">
    <div class="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl relative border border-gray-100">

        <!-- Nút đóng (X) -->
        <button type="button" onclick="closePaymentModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100 transition">
            <i class="fa-solid fa-xmark text-lg"></i>
        </button>

        <div class="text-center mb-5">
            <h3 class="text-lg font-black text-gray-900">Chọn cổng thanh toán trực tuyến</h3>
            <p class="text-xs text-gray-500 mt-1">Đơn hàng của bạn sẽ được chuyển tiếp an toàn</p>
        </div>

        <!-- Danh sách 4 cổng -->
        <div class="space-y-3 mb-6">
            <!-- 1. VNPAY Sandbox (Khả dụng - Click để đi tiếp) -->
            <div onclick="submitWithVNPay()"
                 class="border-2 border-blue-600 bg-blue-50/40 rounded-xl p-3.5 flex items-center justify-between cursor-pointer hover:bg-blue-50 transition shadow-xs">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-10 bg-white border border-gray-200 rounded-lg flex items-center justify-center shadow-xs">
                        <span class="font-black text-sm tracking-tight">
                            <span class="text-[#005baa]">VN</span><span class="text-[#ed1c24]">PAY</span>
                        </span>
                    </div>
                    <div class="text-left">
                        <div class="flex items-center gap-2">
                            <span class="font-bold text-gray-900 text-sm">VNPAY </span>
                            <span class="bg-blue-100 text-blue-700 text-[10px] font-bold px-2 py-0.5 rounded-full">Khuyên dùng</span>
                        </div>
                        <p class="text-[11px] text-gray-500">Quét mã QR, Thẻ ATM 40+ ngân hàng</p>
                    </div>
                </div>
                <i class="fa-solid fa-chevron-right text-blue-600 text-xs"></i>
            </div>

            <!-- 2. Thẻ Quốc tế (Bảo trì) -->
            <div onclick="alert('Cổng Thẻ quốc tế đang trong giai đoạn cấu hình.')"
                 class="border border-gray-200 bg-gray-50/70 rounded-xl p-3.5 flex items-center justify-between opacity-60 cursor-not-allowed">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-10 bg-white border border-gray-200 rounded-lg flex items-center justify-center shadow-xs">
                        <span class="italic font-black text-sm text-[#1a1f71]">VISA</span>
                    </div>
                    <div class="text-left">
                        <span class="font-semibold text-gray-700 text-sm">Thẻ Quốc tế (Visa / Master)</span>
                        <p class="text-[11px] text-gray-400">Tạm thời bảo trì</p>
                    </div>
                </div>
                <span class="text-[10px] bg-gray-200 text-gray-600 px-2 py-0.5 rounded font-bold">Bảo trì</span>
            </div>

            <!-- 3. Ví MoMo (Bảo trì) -->
            <div onclick="alert('Cổng MoMo đang trong giai đoạn cấu hình.')"
                 class="border border-gray-200 bg-gray-50/70 rounded-xl p-3.5 flex items-center justify-between opacity-60 cursor-not-allowed">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-10 bg-[#a50064] rounded-lg flex items-center justify-center text-white text-xs font-bold shadow-xs">
                        MoMo
                    </div>
                    <div class="text-left">
                        <span class="font-semibold text-gray-700 text-sm">Ví điện tử MoMo</span>
                        <p class="text-[11px] text-gray-400">Tạm thời bảo trì</p>
                    </div>
                </div>
                <span class="text-[10px] bg-gray-200 text-gray-600 px-2 py-0.5 rounded font-bold">Bảo trì</span>
            </div>
        </div>

        <button type="button" onclick="closePaymentModal()" class="w-full py-2.5 text-xs font-bold text-gray-500 hover:text-gray-800 transition">
            Hủy và chọn lại
        </button>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<!-- ================= SCRIPT XỬ LÝ SỰ KIỆN ================= -->
<script>
    function selectPayment(method) {
        const optCod = document.getElementById('opt-cod');
        const optOnline = document.getElementById('opt-online');
        const badgeCod = document.getElementById('badge-cod');
        const badgeOnline = document.getElementById('badge-online');
        const radioCod = optCod.querySelector('input[type="radio"]');
        const radioOnline = optOnline.querySelector('input[type="radio"]');

        if (method === 'COD') {
            optCod.classList.add('active');
            optOnline.classList.remove('active');
            badgeCod.classList.remove('hidden');
            badgeOnline.classList.add('hidden');
            radioCod.checked = true;
        } else {
            optOnline.classList.add('active');
            optCod.classList.remove('active');
            badgeOnline.classList.remove('hidden');
            badgeCod.classList.add('hidden');
            radioOnline.checked = true;
        }
    }

    // Bắt sự kiện bấm nút "Xác nhận đặt hàng"
    const checkoutForm = document.getElementById('checkoutForm');
    const paymentModal = document.getElementById('paymentModal');

    checkoutForm.addEventListener('submit', function (e) {
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

        // Nếu chọn thanh toán Online -> Chặn submit form và hiện pop-up lên
        if (paymentMethod === 'ONLINE') {
            e.preventDefault();
            if (checkoutForm.checkValidity()) {
                paymentModal.classList.remove('hidden');
            } else {
                checkoutForm.reportValidity();
            }
        }
        // Nếu chọn COD -> Form tự động submit bình thường
    });

    function closePaymentModal() {
        paymentModal.classList.add('hidden');
    }

    // Khi khách click vào thẻ VNPAY trên pop-up
    function submitWithVNPay() {
        checkoutForm.submit(); // Cho phép form gửi đi sang CheckoutController
    }
</script>

</body>
</html>