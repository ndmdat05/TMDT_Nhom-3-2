
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="mb-6">
    <h1 class="text-2xl font-bold text-gray-900 mb-1">
        Báo cáo & Khiếu nại
    </h1>
    <p class="text-sm text-gray-500">
        Tiếp nhận, kiểm tra và xử lý báo cáo về bài đăng hoặc người dùng trên MangaZ.
    </p>
</div>

<c:if test="${not empty sessionScope.adminSuccess}">
    <div class="mb-4 p-4 bg-emerald-50 border border-emerald-200
                text-emerald-800 rounded-lg text-sm font-semibold">
        <i class="fas fa-check-circle mr-2"></i>
        <c:out value="${sessionScope.adminSuccess}"/>
    </div>
    <c:remove var="adminSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.adminError}">
    <div class="mb-4 p-4 bg-red-50 border border-red-200
                text-red-800 rounded-lg text-sm font-semibold">
        <i class="fas fa-exclamation-circle mr-2"></i>
        <c:out value="${sessionScope.adminError}"/>
    </div>
    <c:remove var="adminError" scope="session"/>
</c:if>

<c:set var="reportTotal" value="${totalReportCount}"/>
<c:set var="reportResolved" value="${resolvedCount}"/>

<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 mb-6">

    <div class="bg-white border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">
            Tổng báo cáo
        </p>
        <p class="mt-2 text-2xl font-bold text-gray-900">
            <c:out value="${totalReportCount}"/>
        </p>
    </div>

    <div class="bg-white border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">
            Đang chờ xử lý
        </p>
        <p class="mt-2 text-2xl font-bold text-orange-600">
            <c:out value="${pendingCount}"/>
        </p>
    </div>

    <div class="bg-white border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">
            Đã giải quyết
        </p>
        <p class="mt-2 text-2xl font-bold text-emerald-600">
            <c:out value="${resolvedCount}"/>
        </p>
    </div>

    <div class="bg-white border border-gray-200 rounded-xl p-5">
        <p class="text-xs font-semibold text-gray-500 uppercase">
            Đã bác bỏ
        </p>
        <p class="mt-2 text-2xl font-bold text-gray-700">
            <c:out value="${dismissedCount}"/>
        </p>
    </div>

</div>

<div class="bg-white border border-gray-200 rounded-xl overflow-hidden">

    <div class="p-5 border-b border-gray-200 flex flex-col sm:flex-row
                sm:items-center sm:justify-between gap-3">
        <div>
            <h2 class="font-bold text-gray-900">
                Danh sách báo cáo
            </h2>
            <p class="text-sm text-gray-500 mt-1">
                Các báo cáo mới nhất được hiển thị trước.
            </p>
        </div>

        <span class="text-sm text-gray-500">
            Tổng số:
            <strong><c:out value="${totalReportCount}"/></strong>
        </span>
    </div>

    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">

            <thead class="bg-gray-50">
            <tr class="text-left text-xs font-semibold uppercase
                       tracking-wide text-gray-500">
                <th class="px-5 py-4">Mã báo cáo</th>
                <th class="px-5 py-4">Người báo cáo</th>
                <th class="px-5 py-4">Đối tượng</th>
                <th class="px-5 py-4">Lý do</th>
                <th class="px-5 py-4">Ngày tạo</th>
                <th class="px-5 py-4">Trạng thái</th>
                <th class="px-5 py-4 text-center">Thao tác</th>
            </tr>
            </thead>

            <tbody class="divide-y divide-gray-100">

            <c:forEach var="report" items="${reports}">
                <tr class="hover:bg-gray-50 align-top">

                    <td class="px-5 py-4 whitespace-nowrap">
                        <span class="font-bold text-gray-900">
                            #RP-<c:out value="${report.id}"/>
                        </span>
                    </td>

                    <td class="px-5 py-4">
                        <p class="font-semibold text-gray-800">
                            <c:out value="${report.reporterName}"
                                   default="Người dùng không xác định"/>
                        </p>
                        <p class="text-xs text-gray-500 mt-1">
                            ID:
                            <c:out value="${report.reporterId}"/>
                        </p>
                    </td>

                    <td class="px-5 py-4 min-w-48">
                        <p class="font-semibold text-gray-800">
                            <c:choose>
                                <c:when test="${not empty report.targetTitle}">
                                    <c:out value="${report.targetTitle}"/>
                                </c:when>
                                <c:when test="${not empty report.reportedUserName}">
                                    <c:out value="${report.reportedUserName}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${report.targetType}"
                                           default="Không xác định"/>
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <p class="text-xs text-gray-500 mt-1">
                            Loại:
                            <c:out value="${report.targetType}"
                                   default="Chưa phân loại"/>
                            <c:if test="${not empty report.targetId}">
                                · ID:
                                <c:out value="${report.targetId}"/>
                            </c:if>
                        </p>

                        <c:if test="${not empty report.description}">
                            <p class="text-sm text-gray-600 mt-2 whitespace-normal
                                      break-words max-w-xs">
                                <c:out value="${report.description}"/>
                            </p>
                        </c:if>
                    </td>

                    <td class="px-5 py-4 min-w-40">
                        <p class="text-sm font-semibold text-gray-800">
                            <c:out value="${report.reasonType}"
                                   default="Không có lý do"/>
                        </p>

                        <c:if test="${not empty report.adminNote}">
                            <p class="text-xs text-gray-500 mt-2">
                                Ghi chú:
                                <c:out value="${report.adminNote}"/>
                            </p>
                        </c:if>
                    </td>

                    <td class="px-5 py-4 whitespace-nowrap text-sm text-gray-600">
                        <c:out value="${report.createdAt}"
                               default="Không rõ"/>
                    </td>

                    <td class="px-5 py-4 whitespace-nowrap">
                        <c:choose>
                            <c:when test="${report.status == 'PENDING'}">
                                <span class="inline-flex px-2.5 py-1 rounded-full
                                             text-xs font-bold bg-orange-50
                                             text-orange-700 border border-orange-200">
                                    Đang chờ
                                </span>
                            </c:when>

                            <c:when test="${report.status == 'RESOLVED'}">
                                <span class="inline-flex px-2.5 py-1 rounded-full
                                             text-xs font-bold bg-emerald-50
                                             text-emerald-700 border border-emerald-200">
                                    Đã giải quyết
                                </span>
                            </c:when>

                            <c:when test="${report.status == 'DISMISSED'}">
                                <span class="inline-flex px-2.5 py-1 rounded-full
                                             text-xs font-bold bg-gray-100
                                             text-gray-700 border border-gray-200">
                                    Đã bác bỏ
                                </span>
                            </c:when>

                            <c:otherwise>
                                <span class="inline-flex px-2.5 py-1 rounded-full
                                             text-xs font-bold bg-gray-100
                                             text-gray-700">
                                    <c:out value="${report.status}"
                                           default="Không xác định"/>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="px-5 py-4">
                        <c:if test="${report.status == 'PENDING'}">
                            <div class="flex flex-col gap-2 min-w-36">

                                <form method="post"
                                      action="${ctx}/admin/manage"
                                      onsubmit="return confirm('Bạn xác nhận giải quyết báo cáo #RP-${report.id}?');">

                                    <input type="hidden" name="tab"
                                           value="report-center"/>
                                    <input type="hidden" name="action"
                                           value="resolve"/>
                                    <input type="hidden" name="reportId"
                                           value="${report.id}"/>

                                    <label class="block text-xs text-gray-500 mb-1">
                                        Ghi chú xử lý
                                    </label>
                                    <input type="text"
                                           name="adminNote"
                                           maxlength="500"
                                           placeholder="Nhập ghi chú (nếu có)"
                                           class="w-full border border-gray-300
                                                  rounded-lg px-2 py-1.5 text-xs mb-2"/>

                                    <button type="submit"
                                            class="w-full rounded-lg bg-emerald-600
                                                   hover:bg-emerald-700 text-white
                                                   px-3 py-2 text-xs font-semibold">
                                        <i class="fas fa-check mr-1"></i>
                                        Giải quyết
                                    </button>
                                </form>

                                <form method="post"
                                      action="${ctx}/admin/manage"
                                      onsubmit="return confirm('Bạn xác nhận bác bỏ báo cáo #RP-${report.id}?');">

                                    <input type="hidden" name="tab"
                                           value="report-center"/>
                                    <input type="hidden" name="action"
                                           value="dismiss"/>
                                    <input type="hidden" name="reportId"
                                           value="${report.id}"/>

                                    <input type="text"
                                           name="adminNote"
                                           maxlength="500"
                                           placeholder="Lý do bác bỏ"
                                           class="w-full border border-gray-300
                                                  rounded-lg px-2 py-1.5 text-xs mb-2"/>

                                    <button type="submit"
                                            class="w-full rounded-lg border
                                                   border-gray-300 hover:bg-gray-100
                                                   text-gray-700 px-3 py-2
                                                   text-xs font-semibold">
                                        <i class="fas fa-times mr-1"></i>
                                        Bác bỏ
                                    </button>
                                </form>

                            </div>
                        </c:if>

                        <c:if test="${report.status != 'PENDING'}">
                            <span class="text-xs text-gray-400">
                                Đã xử lý
                            </span>
                        </c:if>
                    </td>

                </tr>
            </c:forEach>

            <c:if test="${empty reports}">
                <tr>
                    <td colspan="7" class="px-5 py-12 text-center">
                        <div class="text-gray-400 mb-3">
                            <i class="fas fa-flag text-3xl"></i>
                        </div>
                        <p class="font-semibold text-gray-700">
                            Chưa có báo cáo nào
                        </p>
                        <p class="text-sm text-gray-500 mt-1">
                            Khi có báo cáo mới, dữ liệu sẽ xuất hiện tại đây.
                        </p>
                    </td>
                </tr>
            </c:if>

            </tbody>
        </table>
    </div>
</div>
