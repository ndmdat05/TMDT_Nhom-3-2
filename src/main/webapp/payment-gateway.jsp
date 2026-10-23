<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng thanh toán VNPAY - MangaVault</title>

    <!-- Tailwind CDN cho Header/Footer & Font Awesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- CSS RIÊNG CỔNG THANH TOÁN -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment-gateway.css">
</head>
<body class="gateway-page">

<!-- 1. HEADER INCLUDE -->
<jsp:include page="includes/header.jsp" />

<c:set var="orderCode" value="${not empty orderCode ? orderCode : (not empty param.orderCode ? param.orderCode : '#MGV-241108')}" />
<c:set var="totalMoney" value="${not empty sessionScope.cart.totalMoney ? sessionScope.cart.totalMoney : 2320000}" />

<!-- 2. KHUNG NỘI DUNG CHÍNH (CĂN GIỮA) -->
<main class="gateway-wrapper">
    <div class="gateway-card">
        <!-- HEADER VNPAY -->
        <div class="gateway-header">
            <div class="brand-vnpay-logo">
                VN<span>PAY</span><sup>®</sup>
            </div>
            <div class="order-badge-code">
                ${orderCode}
            </div>
        </div>

        <!-- THÂN NỘI DUNG VNPAY QR -->
        <div class="gateway-body">
            <div class="amount-label">Số tiền cần thanh toán</div>
            <div class="amount-value">
                <fmt:formatNumber value="${totalMoney}" pattern="#,###"/> đ
            </div>

            <!-- Khung mã QR VNPAY -->
            <div class="qr-frame">
                <svg viewBox="0 0 100 100" class="w-full h-full text-slate-900" fill="currentColor">
                    <rect x="5" y="5" width="28" height="28" rx="3" fill="none" stroke="currentColor" stroke-width="5"/>
                    <rect x="11" y="11" width="16" height="16" rx="1" fill="currentColor"/>
                    <rect x="67" y="5" width="28" height="28" rx="3" fill="none" stroke="currentColor" stroke-width="5"/>
                    <rect x="73" y="11" width="16" height="16" rx="1" fill="currentColor"/>
                    <rect x="5" y="67" width="28" height="28" rx="3" fill="none" stroke="currentColor" stroke-width="5"/>
                    <rect x="11" y="73" width="16" height="16" rx="1" fill="currentColor"/>
                    <rect x="40" y="8" width="6" height="6"/>
                    <rect x="52" y="18" width="6" height="6"/>
                    <rect x="42" y="28" width="6" height="6"/>
                    <rect x="10" y="42" width="6" height="6"/>
                    <rect x="22" y="48" width="6" height="6"/>
                    <rect x="72" y="42" width="6" height="6"/>
                    <rect x="84" y="50" width="6" height="6"/>
                    <rect x="42" y="68" width="6" height="6"/>
                    <rect x="54" y="78" width="6" height="6"/>
                    <rect x="70" y="84" width="6" height="6"/>
                    <rect x="82" y="70" width="6" height="6"/>
                </svg>

                <div class="qr-vnpay-badge">
                    VN<span>PAY</span>
                </div>
            </div>

            <div class="qr-instruction">Quét mã VNPAY-QR để thanh toán</div>
            <p class="qr-sub">Sử dụng ứng dụng ngân hàng hoặc ví điện tử VNPAY để quét mã</p>

            <div class="timer-pill">
                <span class="timer-dot"></span>
                <span>Giao dịch hết hạn sau: <strong id="timer">05:00</strong></span>
            </div>
        </div>

        <!-- CÁC HÀNH ĐỘNG -->
        <div class="gateway-footer">
            <a href="${pageContext.request.contextPath}/order-result?action=success" class="btn-vnpay-pay">
                <i class="fa-solid fa-circle-check mr-1"></i> Đã hoàn tất thanh toán VNPAY
            </a>

            <a href="${pageContext.request.contextPath}/order-result?action=failed" class="btn-cancel-link">
                Hủy bỏ giao dịch
            </a>
        </div>
    </div>
</main>

<!-- 3. FOOTER INCLUDE -->
<jsp:include page="includes/footer.jsp" />


</body>
</html>