<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Fragment: Hỗ trợ khách hàng - dùng cùng class Tailwind với _manage.jsp --%>
<h1 class="text-2xl font-bold text-gray-900 mb-1">Quản lý khiếu nại &amp; đổi trả / hoàn tiền</h1>
<p class="text-sm text-gray-500 mb-6">Hiển thị các yêu cầu hỗ trợ theo đơn hàng, thanh toán và hủy đơn hiện có trong hệ thống.</p>

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
        <p class="text-xs font-semibold text-gray-500 uppercase">Khởi tạo mới</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${pendingCount}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Đang chờ xử lý</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${inReviewCount}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Đã hoàn tất</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">18</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Vấn đề cần ưu tiên</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">5</p>
    </div>
</div>

<div class="border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm">
            <thead class="bg-gray-50 text-gray-600 font-semibold border-b border-gray-200 text-xs uppercase">
            <tr>
                <th class="px-6 py-4">Mã yêu cầu</th>
                <th class="px-6 py-4">Khách hàng</th>
                <th class="px-6 py-4">Đơn hàng</th>
                <th class="px-6 py-4">Loại</th>
                <th class="px-6 py-4">Trạng thái</th>
                <th class="px-6 py-4 text-center">Thao tác</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
            <c:forEach var="ticket" items="${tickets}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-900">#CS-${ticket.id}</td>
                    <td class="px-6 py-4 font-bold text-gray-900">${ticket.buyerName}</td>
                    <td class="px-6 py-4 font-medium">${ticket.orderCode}</td>
                    <td class="px-6 py-4 font-medium">${ticket.type}</td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 ${ticket.status == 'RESOLVED' ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : (ticket.status == 'REJECTED' || ticket.status == 'CLOSED' ? 'bg-gray-100 text-gray-600 border-gray-200' : 'bg-orange-50 text-orange-700 border-orange-200')} border rounded text-xs font-bold">
                                ${ticket.status}
                        </span>
                    </td>
                    <td class="px-6 py-4 text-center space-x-4 whitespace-nowrap">
                        <form method="post" action="${ctx}/admin/manage" class="inline">
                            <input type="hidden" name="tab" value="support-center">
                            <input type="hidden" name="ticketId" value="${ticket.id}">
                            <input type="hidden" name="status" value="IN_REVIEW">
                            <input type="hidden" name="adminNote" value="Đã tiếp nhận yêu cầu hỗ trợ và đang xác minh.">
                            <button type="submit" class="text-indigo-500 hover:text-indigo-800 transition-colors" title="Nhận xử lý">
                                <i class="fas fa-user-check text-lg"></i>
                            </button>
                        </form>
                        <form method="post" action="${ctx}/admin/manage" class="inline">
                            <input type="hidden" name="tab" value="support-center">
                            <input type="hidden" name="ticketId" value="${ticket.id}">
                            <input type="hidden" name="status" value="RESOLVED">
                            <input type="hidden" name="adminNote" value="Đã xác nhận và hoàn tất xử lý theo dữ liệu đơn hàng và thanh toán.">
                            <button type="submit" class="text-emerald-500 hover:text-emerald-800 transition-colors" title="Đánh dấu xong">
                                <i class="fas fa-check-double text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty tickets}">
                <tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">Chưa có yêu cầu hỗ trợ.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
