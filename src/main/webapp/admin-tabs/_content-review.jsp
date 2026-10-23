<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Fragment: Kiểm duyệt bài đăng - dùng cùng class Tailwind với _manage.jsp --%>
<h1 class="text-2xl font-bold text-gray-900 mb-1">Kiểm duyệt bài đăng mới</h1>
<p class="text-sm text-gray-500 mb-6">Kiểm tra nội dung, tin nhắn và bài đăng trước khi hiển thị công khai.</p>

<c:if test="${not empty sessionScope.adminSuccess}">
    <div class="mb-4 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-lg text-sm font-semibold">
        ✓ <c:out value="${sessionScope.adminSuccess}"/>
    </div>
    <c:remove var="adminSuccess" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.adminError}">
    <div class="mb-4 p-4 bg-red-50 border border-red-200 text-red-800 rounded-lg text-sm font-semibold">
        <c:out value="${sessionScope.adminError}"/>
    </div>
    <c:remove var="adminError" scope="session"/>
</c:if>

<div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Chờ duyệt</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${pendingCount}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Đã duyệt hôm nay</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${approvedToday}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Bị từ chối (7 ngày)</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${rejectedThisWeek}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Tỷ lệ xử lý đạt</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${successRate}%</p>
    </div>
</div>

<div class="border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm">
            <thead class="bg-gray-50 text-gray-600 font-semibold border-b border-gray-200 text-xs uppercase">
            <tr>
                <th class="px-6 py-4">Mã bài</th>
                <th class="px-6 py-4">Người đăng</th>
                <th class="px-6 py-4">Nội dung</th>
                <th class="px-6 py-4">Giá</th>
                <th class="px-6 py-4">Trạng thái</th>
                <th class="px-6 py-4 text-center">Thao tác</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
            <c:forEach var="item" items="${pendingProducts}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-900">#MV-${item.id}</td>
                    <td class="px-6 py-4 font-medium"><c:out value="${empty item.sellerName ? 'Không xác định' : item.sellerName}"/></td>
                    <td class="px-6 py-4">
                        <div class="flex items-start gap-3">
                            <c:choose>
                                <c:when test="${not empty item.imageUrl}">
                                    <img class="w-12 h-16 object-cover rounded border border-gray-200 shrink-0" src="${item.imageUrl}" alt="">
                                </c:when>
                                <c:otherwise>
                                    <div class="w-12 h-16 rounded border border-gray-200 bg-gray-100 text-gray-400 text-xs flex items-center justify-center shrink-0">N/A</div>
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <p class="font-bold text-gray-900"><c:out value="${item.title}"/></p>
                                <p class="text-xs text-gray-500 line-clamp-2 max-w-xs"><c:out value="${item.description}"/></p>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 font-bold text-indigo-700">
                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ"/>
                    </td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 bg-orange-50 text-orange-700 border border-orange-200 rounded text-xs font-bold">Chờ duyệt</span>
                    </td>
                    <td class="px-6 py-4 text-center space-x-4 whitespace-nowrap">
                        <a href="${ctx}/admin/manage?tab=content-review&viewId=${item.id}"
                           class="text-indigo-500 hover:text-indigo-800 transition-colors" title="Xem chi tiết">
                            <i class="fas fa-eye text-lg"></i>
                        </a>
                        <form method="post" action="${ctx}/admin/manage" class="inline once-form">
                            <input type="hidden" name="tab" value="content-review">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="productId" value="${item.id}">
                            <button type="submit" class="text-emerald-500 hover:text-emerald-800 transition-colors" title="Duyệt bài">
                                <i class="fas fa-check-circle text-lg"></i>
                            </button>
                        </form>
                        <button type="button" class="text-red-500 hover:text-red-800 transition-colors" title="Từ chối"
                                data-id="${item.id}" data-title="<c:out value='${item.title}'/>" onclick="openRejectDialog(this)">
                            <i class="fas fa-times-circle text-lg"></i>
                        </button>
                        <button type="button" class="text-orange-500 hover:text-orange-800 transition-colors" title="Yêu cầu chỉnh sửa"
                                data-id="${item.id}" data-title="<c:out value='${item.title}'/>" onclick="openEditDialog(this)">
                            <i class="fas fa-pen-to-square text-lg"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty pendingProducts}">
                <tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">Không có bài đăng chờ duyệt.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<c:if test="${not empty selectedProduct}">
    <div class="mt-6 border border-gray-200 rounded-xl p-6 text-sm text-gray-700 space-y-2">
        <h2 class="text-lg font-bold text-gray-900 mb-2">Chi tiết bài đăng #MV-${selectedProduct.id}</h2>
        <p><span class="font-semibold text-gray-900">Người bán:</span> <c:out value="${selectedProduct.sellerName}"/></p>
        <p><span class="font-semibold text-gray-900">Tiêu đề:</span> <c:out value="${selectedProduct.title}"/></p>
        <p><span class="font-semibold text-gray-900">Giá:</span> <fmt:formatNumber value="${selectedProduct.price}" type="currency" currencySymbol="đ"/></p>
        <p><span class="font-semibold text-gray-900">Trạng thái:</span> <c:out value="${selectedProduct.status}"/></p>
        <p><span class="font-semibold text-gray-900">Ngày tạo:</span> <c:out value="${selectedProduct.createdAt}"/></p>
        <p><span class="font-semibold text-gray-900">Mô tả:</span> <c:out value="${selectedProduct.description}"/></p>
        <c:if test="${not empty selectedProduct.rejectionReason}">
            <p><span class="font-semibold text-gray-900">Lý do xử lý:</span> <c:out value="${selectedProduct.rejectionReason}"/></p>
        </c:if>
    </div>
</c:if>

<%-- Popup lý do (admin-modules.js bật/tắt bằng class "show" trên .modal) --%>
<div class="modal" id="decisionModal" aria-hidden="true">
    <div class="bg-white rounded-xl p-6 w-full max-w-md mx-3 shadow-xl">
        <div class="flex items-center justify-between mb-4">
            <h3 id="modalTitle" class="text-lg font-bold text-gray-900">Xử lý bài đăng</h3>
            <button type="button" class="text-gray-400 hover:text-gray-700 text-2xl leading-none" onclick="closeModal()">×</button>
        </div>
        <form method="post" action="${ctx}/admin/manage" class="once-form space-y-3">
            <input type="hidden" name="tab" value="content-review">
            <input type="hidden" id="modalProductId" name="productId">
            <input type="hidden" id="modalAction" name="action">
            <label for="reasonInput" class="block text-sm font-semibold text-gray-700">Lý do xử lý</label>
            <textarea id="reasonInput" name="reason" rows="5" required maxlength="1000"
                      class="w-full border border-gray-300 rounded-lg p-3 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-200"></textarea>
            <div class="flex justify-end gap-2 pt-2">
                <button type="button" class="px-4 py-2 rounded-lg text-sm font-semibold text-gray-600 bg-gray-100 hover:bg-gray-200" onclick="closeModal()">Hủy</button>
                <button type="submit" class="px-4 py-2 rounded-lg text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700">Xác nhận</button>
            </div>
        </form>
    </div>
</div>
