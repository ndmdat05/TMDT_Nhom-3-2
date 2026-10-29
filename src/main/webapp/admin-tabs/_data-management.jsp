
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!-- TIÊU ĐỀ -->
<div class="mb-8 flex flex-col lg:flex-row lg:items-center justify-between gap-4">
    <div>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">
            Quản lý Dữ liệu Truyện
        </h1>

        <p class="text-gray-500 text-sm">
            Quản lý danh sách truyện, giá bán, tồn kho và trạng thái bài đăng.
        </p>
    </div>
</div>

<!-- THÔNG BÁO -->
<c:if test="${not empty sessionScope.adminSuccess}">
    <div class="mb-6 p-4 rounded-xl border border-green-200 bg-green-50 text-green-800 flex items-center gap-2">
        <i class="fas fa-check-circle"></i>
        <span>
            <c:out value="${sessionScope.adminSuccess}"/>
        </span>
    </div>
    <c:remove var="adminError" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.adminError}">
    <div class="mb-6 p-4 rounded-xl border border-red-200 bg-red-50 text-red-800 flex items-center gap-2">
        <i class="fas fa-exclamation-circle"></i>
        <span>
            <c:out value="${sessionScope.adminError}"/>
        </span>
    </div>
    <c:remove var="adminError" scope="session"/>
</c:if>

<!-- THỐNG KÊ NHANH -->
<div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">

    <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-sm text-gray-500">Tổng sản phẩm</p>
                <p class="text-2xl font-bold text-gray-900 mt-2">
                    ${fn:length(mangaList)}
                </p>
            </div>

            <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                <i class="fas fa-book text-xl"></i>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-sm text-gray-500">Đang được duyệt bán</p>
                <p class="text-2xl font-bold text-green-700 mt-2">
                    <c:set var="approvedCount" value="0"/>

                    <c:forEach var="item" items="${mangaList}">
                        <c:if test="${item.status eq 'APPROVED'}">
                            <c:set var="approvedCount"
                                   value="${approvedCount + 1}"/>
                        </c:if>
                    </c:forEach>

                    ${approvedCount}
                </p>
            </div>

            <div class="w-12 h-12 rounded-xl bg-green-50 text-green-600 flex items-center justify-center">
                <i class="fas fa-check-circle text-xl"></i>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-sm text-gray-500">Chờ kiểm duyệt</p>
                <p class="text-2xl font-bold text-amber-600 mt-2">
                    <c:set var="pendingCount" value="0"/>

                    <c:forEach var="item" items="${mangaList}">
                        <c:if test="${item.status eq 'PENDING_APPROVAL'}">
                            <c:set var="pendingCount"
                                   value="${pendingCount + 1}"/>
                        </c:if>
                    </c:forEach>

                    ${pendingCount}
                </p>
            </div>

            <div class="w-12 h-12 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                <i class="fas fa-clock text-xl"></i>
            </div>
        </div>
    </div>

</div>

<!-- DANH SÁCH SẢN PHẨM -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-5">
    <div>
        <h2 class="text-xl font-bold text-gray-900">
            Danh sách truyện
        </h2>

        <p class="text-sm text-gray-500 mt-1">
            Dữ liệu được lấy từ cơ sở dữ liệu MangaZ.
        </p>
    </div>

    <a href="${ctx}/admin/manage?tab=data-management"
       class="inline-flex items-center justify-center gap-2 px-4 py-2 rounded-lg border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 transition">
        <i class="fas fa-sync-alt"></i>
        Làm mới danh sách
    </a>
</div>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

    <c:forEach var="manga" items="${mangaList}">

        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden group hover:shadow-md transition">

            <!-- TRẠNG THÁI -->
            <div class="px-4 pt-4 flex items-center justify-between gap-2">

                <span class="text-xs font-bold text-gray-500">
                    Mã truyện #${manga.id}
                </span>

                <c:choose>
                    <c:when test="${manga.status eq 'APPROVED'}">
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-green-50 text-green-700 border border-green-200">
                            Đang hiển thị
                        </span>
                    </c:when>

                    <c:when test="${manga.status eq 'PENDING_APPROVAL'}">
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">
                            Chờ duyệt
                        </span>
                    </c:when>

                    <c:when test="${manga.status eq 'REJECTED'}">
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-red-50 text-red-700 border border-red-200">
                            Bị từ chối
                        </span>
                    </c:when>

                    <c:when test="${manga.status eq 'HIDDEN'}">
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-700 border border-gray-200">
                            Đang ẩn
                        </span>
                    </c:when>

                    <c:otherwise>
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-700 border border-gray-200">
                            <c:out value="${manga.status}"/>
                        </span>
                    </c:otherwise>
                </c:choose>

            </div>

            <!-- ẢNH SẢN PHẨM -->
            <div class="h-48 mt-3 bg-gray-100 overflow-hidden flex items-center justify-center">

                <c:choose>
                    <c:when test="${not empty manga.imageUrl
                                   and fn:contains(manga.imageUrl, '://')}">
                        <img src="<c:out value='${manga.imageUrl}'/>"
                             alt="Ảnh truyện"
                             class="w-full h-full object-cover group-hover:scale-105 transition duration-300"
                             loading="lazy">
                    </c:when>

                    <c:when test="${not empty manga.imageUrl}">
                        <img src="${ctx}/<c:out value='${manga.imageUrl}'/>"
                             alt="Ảnh truyện"
                             class="w-full h-full object-cover group-hover:scale-105 transition duration-300"
                             loading="lazy">
                    </c:when>

                    <c:otherwise>
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i class="fas fa-book-open text-4xl mb-2"></i>
                            <span class="text-xs">Chưa có ảnh</span>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

            <!-- THÔNG TIN SẢN PHẨM -->
            <div class="p-4">

                <h3 class="font-bold text-gray-900 text-base leading-6 min-h-12">
                    <c:out value="${manga.title}"/>
                </h3>

                <p class="text-sm text-gray-500 mt-2">
                    <i class="fas fa-bookmark mr-1"></i>

                    <c:choose>
                        <c:when test="${not empty manga.seriesName}">
                            <c:out value="${manga.seriesName}"/>
                        </c:when>
                        <c:otherwise>
                            Chưa có thông tin bộ truyện
                        </c:otherwise>
                    </c:choose>
                </p>

                <div class="mt-4 pt-4 border-t border-gray-100 flex items-end justify-between gap-3">

                    <div>
                        <p class="text-xs text-gray-500 mb-1">
                            Giá bán
                        </p>

                        <p class="text-lg font-bold text-[#106A57]">
                            <fmt:formatNumber
                                    value="${manga.price}"
                                    type="number"
                                    groupingUsed="true"
                                    maxFractionDigits="0"/>
                            đ
                        </p>

                        <p class="text-xs text-gray-500 mt-2">
                            Tồn kho:
                            <span class="font-semibold text-gray-700">
                                    ${manga.stockQuantity}
                            </span>
                        </p>

                        <p class="text-xs text-gray-500 mt-1">
                            Người bán:
                            <c:choose>
                                <c:when test="${not empty manga.sellerName}">
                                    <c:out value="${manga.sellerName}"/>
                                </c:when>
                                <c:otherwise>
                                    Chưa xác định
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <!-- FORM GỠ SẢN PHẨM -->
                    <form method="post"
                          action="${ctx}/admin/manage"
                          onsubmit="return confirm('Bạn có chắc chắn muốn gỡ sản phẩm này khỏi hệ thống?');">

                        <input type="hidden"
                               name="tab"
                               value="data-management">

                        <input type="hidden"
                               name="action"
                               value="deleteProduct">

                        <input type="hidden"
                               name="productId"
                               value="${manga.id}">

                        <button type="submit"
                                title="Gỡ sản phẩm"
                                class="w-10 h-10 rounded-lg bg-red-50 text-red-600 hover:bg-red-600 hover:text-white flex items-center justify-center transition">
                            <i class="fas fa-trash-alt"></i>
                        </button>

                    </form>

                </div>

            </div>
        </div>

    </c:forEach>

</div>

<!-- TRƯỜNG HỢP KHÔNG CÓ SẢN PHẨM -->
<c:if test="${empty mangaList}">
    <div class="mt-6 bg-white border border-dashed border-gray-300 rounded-2xl p-12 text-center">

        <div class="w-16 h-16 mx-auto rounded-full bg-gray-100 text-gray-400 flex items-center justify-center mb-4">
            <i class="fas fa-box-open text-2xl"></i>
        </div>

        <h3 class="text-lg font-bold text-gray-800">
            Chưa có sản phẩm
        </h3>

        <p class="text-sm text-gray-500 mt-2">
            Database chưa có sản phẩm phù hợp để hiển thị.
        </p>
    </div>
</c:if>
