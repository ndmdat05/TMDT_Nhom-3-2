<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Sàn Đấu Giá - MangaZ</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-[#fcfcfd] text-[#141b2b] font-sans">
<%@ include file="includes/header.jsp" %>

<div class="max-w-[1184px] mx-auto px-4 py-8 min-h-[70vh]">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-orange-100 text-orange-600 rounded-xl flex items-center justify-center text-xl">
      <i class="fa-solid fa-gavel"></i>
    </div>
    <div>
      <h1 class="text-2xl font-black text-gray-900">Sàn Đấu Giá MangaZ</h1>
      <p class="text-sm text-gray-500">Nơi hội tụ những ấn phẩm sưu tầm độc đáo.</p>
    </div>
  </div>

  <c:if test="${empty auctionList}">
    <div class="text-center py-20 bg-white rounded-2xl border border-gray-200">
      <i class="fa-solid fa-box-open text-4xl text-gray-300 mb-3"></i>
      <p class="text-gray-500">Hiện chưa có phiên đấu giá nào đang diễn ra.</p>
    </div>
  </c:if>

  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
    <c:forEach var="item" items="${auctionList}">
      <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden hover:shadow-lg transition group flex flex-col">
        <div class="relative h-56 bg-gray-100 overflow-hidden">
          <img src="${pageContext.request.contextPath}/${item.image_url}" class="w-full h-full object-cover group-hover:scale-105 transition duration-300">
          <div class="absolute top-2 left-2 bg-red-600 text-white text-[10px] font-bold px-2 py-1 rounded">
            ĐANG ĐẤU GIÁ
          </div>
        </div>
        <div class="p-4 flex-1 flex flex-col">
          <h3 class="font-bold text-gray-900 line-clamp-2 mb-2 flex-1">${item.title}</h3>

          <div class="bg-orange-50 rounded-lg p-3 mt-2 border border-orange-100">
            <p class="text-xs text-gray-500 mb-1">Giá hiện tại:</p>
            <p class="text-lg font-black text-red-600">
              <fmt:formatNumber value="${item.current_highest_price > 0 ? item.current_highest_price : item.starting_price}" pattern="#,##0"/> đ
            </p>
          </div>

          <div class="mt-3 flex items-center justify-between text-xs text-gray-500">
            <span><i class="fa-regular fa-clock mr-1"></i> Kết thúc:</span>
            <span class="font-bold text-gray-700"><fmt:formatDate value="${item.end_time}" pattern="HH:mm - dd/MM"/></span>
          </div>

          <a href="${pageContext.request.contextPath}/product-detail?id=${item.product_id}"
             class="mt-4 w-full block text-center bg-gray-900 hover:bg-black text-white font-bold py-2 rounded-lg transition">
            Xem & Đặt Giá
          </a>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<%@ include file="includes/footer.jsp" %>
</body>
</html>