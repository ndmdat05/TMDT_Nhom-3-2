<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MangaZ Admin</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; margin: 0; }
        .wrap { max-width: 1100px; margin: 32px auto; padding: 24px; background: #fff; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        h1 { margin-top: 0; }
        .nav { display: flex; gap: 12px; flex-wrap: wrap; margin: 20px 0; }
        .nav a { text-decoration: none; background: #eef2ff; padding: 10px 14px; border-radius: 10px; color: #3730a3; font-weight: 700; }
    </style>
</head>
<body>
<div class="wrap">
    <h1>Admin Management</h1>
    <p>Quản trị nội dung & hỗ trợ MangaZ.</p>
    <div class="nav">
        <a href="${pageContext.request.contextPath}/admin/content-review">Kiểm duyệt bài đăng</a>
        <a href="${pageContext.request.contextPath}/admin/report-center">Báo cáo nội dung</a>
        <a href="${pageContext.request.contextPath}/admin/support-center">Hỗ trợ khách hàng</a>
    </div>
</div>
</body>
</html>
