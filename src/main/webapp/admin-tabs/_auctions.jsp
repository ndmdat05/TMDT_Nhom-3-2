<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setLocale value="vi_VN"/>

<div class="space-y-6">

  <!-- Tiêu đề -->
  <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
    <div>
      <h1 class="text-2xl font-extrabold text-gray-900">
        Quản lý Phiên Đấu Giá
      </h1>
      <p class="text-sm text-gray-500 mt-1">
        Theo dõi, quản lý và chốt các phiên đấu giá trên sàn.
      </p>
    </div>
  </div>

  <!-- Thông báo -->
  <c:if test="${not empty sessionScope.adminSuccess}">
    <div class="p-4 rounded-xl border border-emerald-200 bg-emerald-50 text-emerald-800 text-sm font-semibold">
      <i class="fa-solid fa-circle-check mr-1"></i> <c:out value="${sessionScope.adminSuccess}" />
    </div>
    <c:remove var="adminSuccess" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.adminError}">
    <div class="p-4 rounded-xl border border-rose-200 bg-rose-50 text-rose-800 text-sm font-semibold">
      <i class="fa-solid fa-circle-exclamation mr-1"></i> <c:out value="${sessionScope.adminError}" />
    </div>
    <c:remove var="adminError" scope="session"/>
  </c:if>

  <!-- Các chỉ số KPI -->
  <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
    <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
      <div class="flex items-center justify-between">
        <p class="text-sm text-gray-500 font-semibold">Tổng số phiên</p>
        <span class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                    <i class="fa-solid fa-gavel"></i>
                </span>
      </div>
      <p class="text-3xl font-extrabold text-gray-900 mt-4">${totalAuctions}</p>
    </div>

    <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
      <div class="flex items-center justify-between">
        <p class="text-sm text-gray-500 font-semibold">Đang diễn ra</p>
        <span class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                    <i class="fa-solid fa-fire"></i>
                </span>
      </div>
      <p class="text-3xl font-extrabold text-gray-900 mt-4">${ongoingCount}</p>
    </div>

    <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
      <div class="flex items-center justify-between">
        <p class="text-sm text-gray-500 font-semibold">Đã kết thúc</p>
        <span class="w-10 h-10 rounded-xl bg-gray-100 text-gray-600 flex items-center justify-center">
                    <i class="fa-solid fa-flag-checkered"></i>
                </span>
      </div>
      <p class="text-3xl font-extrabold text-gray-900 mt-4">${endedCount}</p>
    </div>
  </div>

  <!-- Bảng dữ liệu -->
  <section class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
    <div class="p-5 border-b border-gray-100">
      <h2 class="font-bold text-gray-900 text-lg">Danh sách phiên đấu giá</h2>
      <p class="text-sm text-gray-500 mt-1">Các phiên đang chạy được ưu tiên hiển thị lên đầu.</p>
    </div>

    <div class="overflow-x-auto">
      <table class="w-full text-sm text-left">
        <thead class="bg-gray-50 text-gray-500">
        <tr>
          <th class="px-5 py-3 font-semibold">Sản phẩm</th>
          <th class="px-5 py-3 font-semibold">Người bán</th>
          <th class="px-5 py-3 font-semibold text-right">Giá hiện tại</th>
          <th class="px-5 py-3 font-semibold">Người dẫn đầu</th>
          <th class="px-5 py-3 font-semibold">Kết thúc</th>
          <th class="px-5 py-3 font-semibold">Trạng thái</th>
          <th class="px-5 py-3 font-semibold text-center">Thao tác</th>
        </tr>
        </thead>

        <tbody class="divide-y divide-gray-100">
        <c:forEach var="a" items="${auctionList}">
          <tr class="hover:bg-gray-50">
            <td class="px-5 py-4 min-w-48">
              <div class="font-semibold text-gray-800 line-clamp-2"><c:out value="${a.title}" /></div>
              <div class="text-xs text-gray-400 mt-1">Mã phiên: #AUC-${a.id}</div>
            </td>
            <td class="px-5 py-4">
              <c:out value="${a.sellerName}" />
            </td>
            <td class="px-5 py-4 text-right font-semibold whitespace-nowrap text-red-600">
              <fmt:formatNumber value="${a.current_highest_price > 0 ? a.current_highest_price : a.starting_price}" maxFractionDigits="0" /> ₫
            </td>
            <td class="px-5 py-4">
              <c:choose>
                <c:when test="${not empty a.winnerName}">
                  <span class="font-semibold text-emerald-600"><c:out value="${a.winnerName}" /></span>
                </c:when>
                <c:otherwise>
                  <span class="text-gray-400 italic">Chưa có</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="px-5 py-4 whitespace-nowrap text-gray-600">
                ${a.end_time_formatted}
            </td>
            <td class="px-5 py-4 whitespace-nowrap">
              <c:choose>
                <c:when test="${a.status eq 'ONGOING'}">
                                    <span class="rounded-full bg-emerald-50 text-emerald-700 px-3 py-1 text-xs font-bold">
                                        Đang diễn ra
                                    </span>
                </c:when>
                <c:when test="${a.status eq 'UPCOMING'}">
                                    <span class="rounded-full bg-sky-50 text-sky-700 px-3 py-1 text-xs font-bold">
                                        Sắp diễn ra
                                    </span>
                </c:when>
                <c:when test="${a.status eq 'ENDED'}">
                                    <span class="rounded-full bg-gray-100 text-gray-700 px-3 py-1 text-xs font-bold">
                                        Đã kết thúc
                                    </span>
                </c:when>
                <c:otherwise>
                                    <span class="rounded-full bg-rose-50 text-rose-700 px-3 py-1 text-xs font-bold">
                                        Đã hủy
                                    </span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="px-5 py-4 text-center whitespace-nowrap">
              <c:if test="${a.status eq 'ONGOING'}">
                <form action="${ctx}/admin/auctions" method="POST" onsubmit="return confirm('Chốt phiên này và tạo đơn hàng cho người thắng?');" class="inline">
                  <input type="hidden" name="auctionId" value="${a.id}">
                  <button type="submit" class="px-3 py-1.5 bg-indigo-600 text-white font-bold rounded-lg hover:bg-indigo-700 transition text-xs">
                    <i class="fa-solid fa-check-circle mr-1"></i> Chốt phiên
                  </button>
                </form>
              </c:if>
              <c:if test="${a.status eq 'ENDED'}">
                <span class="text-xs text-gray-400">Đã xử lý</span>
              </c:if>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty auctionList}">
          <tr>
            <td colspan="7" class="px-5 py-10 text-center text-gray-400">
              Chưa có phiên đấu giá nào trong hệ thống.
            </td>
          </tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </section>

</div>