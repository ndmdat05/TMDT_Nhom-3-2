<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/22/2026
  Time: 11:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - MangaVault</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-popup.css">
</head>
<body class="popup-page">

<div class="popup-box">
    <div class="icon-squircle success">
        <svg width="34" height="26" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M2 9.5L8.5 16L22 2" stroke="#0E7048" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </div>
    <h1 class="popup-title">Đặt hàng thành công</h1>
    <a href="${pageContext.request.contextPath}/home" class="btn-popup-action">
        Đóng
    </a>
</div>

</body>
</html>
