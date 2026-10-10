<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quên mật khẩu | MangaZ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Space+Grotesk:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Css/Login.css">
</head>
<body>
<div class="mangaz-wrapper">

    <%@ include file="includes/header.jsp" %>

    <main class="mangaz-container">
        <%@ include file="includes/section.jsp" %>

        <div class="form-section">
            <div class="login-card">
                <h2 class="form-title">Quên mật khẩu?</h2>
                <p class="form-subtitle">Nhập email của bạn để nhận liên kết đặt lại mật khẩu.</p>

                <c:if test="${not empty message || not empty sessionScope.message}">
                    <p style="color: #10b981; font-weight: 600; margin-bottom: 15px;">${not empty message ? message : sessionScope.message}</p>
                    <c:remove var="message" scope="session"/>
                </c:if>

                <c:if test="${not empty errorMessage || not empty sessionScope.errorMessage}">
                    <p style="color: #ef4444; font-weight: 600; margin-bottom: 15px;">${not empty errorMessage ? errorMessage : sessionScope.errorMessage}</p>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <form class="login-form" action="${pageContext.request.contextPath}/forgot-pw" method="post">
                    <div class="input-group">
                        <label for="input-email">EMAIL ĐÃ ĐĂNG KÝ</label>
                        <div class="input-wrapper">
                            <img src="Image/@.svg" alt="@" class="icon-left">
                            <input type="email" id="input-email" name="email" placeholder="otaku@mangaz.vn" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary">
                        Gửi liên kết khôi phục <img src="Image/turnRight.svg" alt="->" class="arrow-icon">
                    </button>
                </form>

                <div class="terms-text" style="margin-top: 32px;">
                    Nhớ lại mật khẩu? <a href="${pageContext.request.contextPath}/login" style="font-weight: 700; color: #4648d4;">Quay lại đăng nhập</a>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="includes/footer.jsp" %>
</div>
</body>
</html>