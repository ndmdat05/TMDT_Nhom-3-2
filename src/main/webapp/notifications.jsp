<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo - MangaZ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-50">
<%@ include file="includes/header.jsp" %>

<div class="max-w-3xl mx-auto my-10 px-4">
    <h1 class="text-2xl font-bold mb-6"><i class="fas fa-bell text-indigo-600 mr-2"></i>Thông báo của bạn</h1>

    <div class="space-y-4">
        <c:if test="${empty notifications}">
            <div class="text-center text-gray-500 py-10">Bạn chưa có thông báo nào.</div>
        </c:if>

        <c:forEach var="n" items="${notifications}">
            <div class="bg-white p-4 rounded-xl shadow-sm border border-gray-200 flex gap-4 items-start">
                <div class="w-10 h-10 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-gavel"></i>
                </div>
                <div class="flex-1">
                    <h3 class="font-bold text-gray-900">${n.title}</h3>
                    <p class="text-gray-600 text-sm mt-1">${n.content}</p>
                    <p class="text-xs text-gray-400 mt-2"><fmt:formatDate value="${n.created_at}" pattern="dd/MM/yyyy HH:mm"/></p>

                    <c:if test="${not empty n.link}">
                        <a href="${pageContext.request.contextPath}${n.link}" class="inline-block mt-2 text-sm font-semibold text-indigo-600 hover:underline">Xem chi tiết &rarr;</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>