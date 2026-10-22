<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 10/22/2026
  Time: 11:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thất bại - MangaVault</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-popup.css">
</head>
<body class="popup-page">

<div class="popup-box">
    <div class="icon-squircle failed">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4 4L20 20M20 4L4 20" stroke="#1F2937" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </div>

    <h1 class="popup-title">Đặt hàng thất bại</h1>
    <a href="${pageContext.request.contextPath}/checkout" class="btn-popup-action">
        Đóng
    </a>
</div>

</body>
</html>