<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Fragment: Báo cáo nội dung - dùng cùng class Tailwind với _manage.jsp --%>
<h1 class="text-2xl font-bold text-gray-900 mb-1">Xử lý báo cáo và bài viết khi cần</h1>
<p class="text-sm text-gray-500 mb-6">Danh sách báo cáo liên quan đến bài đăng, bình luận hoặc người dùng, kèm trạng thái xử lý.</p>

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
        <p class="text-xs font-semibold text-gray-500 uppercase">Báo cáo mới</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${pendingCount}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Đã xử lý</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">${resolvedCount}</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Tỷ lệ giải quyết</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">81%</p>
    </div>
    <div class="border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">Khẩn cấp</p>
        <p class="mt-2 text-2xl font-bold text-gray-900">4</p>
    </div>
</div>

<div class="border border-gray-200 rounded-xl overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm">
            <thead class="bg-gray-50 text-gray-600 font-semibold border-b border-gray-200 text-xs uppercase">
            <tr>
                <th class="px-6 py-4">Mã báo cáo</th>
                <th class="px-6 py-4">Người báo cáo</th>
                <th class="px-6 py-4">Đối tượng</th>
                <th class="px-6 py-4">Lý do</th>
                <th class="px-6 py-4">Trạng thái</th>
                <th class="px-6 py-4 text-center">Thao tác</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
            <c:forEach var="report" items="${reports}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-900">#RP-${report.id}</td>
                    <td class="px-6 py-4 font-medium">${report.reporterName}</td>
                    <td class="px-6 py-4">
                        <p class="font-bold text-gray-900">${report.targetType}</p>
                        <p class="text-xs text-gray-500">${report.targetTitle}</p>
                    </td>
                    <td class="px-6 py-4 font-medium">${report.reasonType}</td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 ${report.status == 'RESOLVED' ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : (report.status == 'DISMISSED' ? 'bg-gray-100 text-gray-600 border-gray-200' : 'bg-orange-50 text-orange-700 border-orange-200')} border rounded text-xs font-bold">
                                ${report.status}
                        </span>
                    </td>
                    <td class="px-6 py-4 text-center space-x-4 whitespace-nowrap">
                        <form method="post" action="${ctx}/admin/manage" class="inline">
                            <input type="hidden" name="tab" value="report-center">
                            <input type="hidden" name="reportId" value="${report.id}">
                            <input type="hidden" name="action" value="resolve">
                            <input type="hidden" name="adminNote" value="Đã kiểm tra và xử lý theo quy định nội dung.">
                            <button type="submit" class="text-emerald-500 hover:text-emerald-800 transition-colors" title="Giải quyết">
                                <i class="fas fa-check-circle text-lg"></i>
                            </button>
                        </form>
                        <form method="post" action="${ctx}/admin/manage" class="inline">
                            <input type="hidden" name="tab" value="report-center">
                            <input type="hidden" name="reportId" value="${report.id}">
                            <input type="hidden" name="action" value="dismiss">
                            <input type="hidden" name="adminNote" value="Báo cáo không đủ căn cứ hoặc không vi phạm quy định.">
                            <button type="submit" class="text-gray-400 hover:text-gray-700 transition-colors" title="Bác bỏ">
                                <i class="fas fa-ban text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reports}">
                <tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">Chưa có báo cáo.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
