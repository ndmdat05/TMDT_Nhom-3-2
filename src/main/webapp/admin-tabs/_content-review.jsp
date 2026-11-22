
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="mb-6">
    <h1 class="text-2xl font-bold text-gray-900 mb-1">
        Kiểm duyệt bài đăng mới
    </h1>
    <p class="text-sm text-gray-500">
        Kiểm tra thông tin truyện và quyết định trước khi bài đăng được công khai.
    </p>
</div>

<c:if test="${not empty sessionScope.adminSuccess}">
    <div class="mb-4 rounded-lg border border-emerald-200 bg-emerald-50 p-4 text-sm font-medium text-emerald-800">
        <i class="fas fa-circle-check mr-2"></i>
        <c:out value="${sessionScope.adminSuccess}"/>
    </div>
    <c:remove var="adminSuccess" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.adminError}">
    <div class="mb-4 rounded-lg border border-red-200 bg-red-50 p-4 text-sm font-medium text-red-800">
        <i class="fas fa-circle-exclamation mr-2"></i>
        <c:out value="${sessionScope.adminError}"/>
    </div>
    <c:remove var="adminError" scope="session"/>
</c:if>

<c:if test="${not empty requestScope.reviewLoadError}">
    <div class="mb-4 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">
        <p class="font-bold">Không tải được dữ liệu kiểm duyệt.</p>
        <p class="mt-1">
            Hãy kiểm tra log của Tomcat và cấu hình database trong DBProperties.
        </p>
    </div>
</c:if>

<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 mb-6">

    <div class="rounded-xl border border-gray-200 bg-white p-5">
        <div class="flex items-center justify-between">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Chờ duyệt
            </p>
            <i class="fas fa-clock text-amber-500"></i>
        </div>
        <p class="mt-3 text-2xl font-bold text-gray-900">
            <c:out value="${empty pendingCount ? 0 : pendingCount}"/>
        </p>
        <p class="mt-1 text-xs text-gray-500">Bài đang đợi quyết định</p>
    </div>

    <div class="rounded-xl border border-gray-200 bg-white p-5">
        <div class="flex items-center justify-between">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Đã duyệt hôm nay
            </p>
            <i class="fas fa-check-circle text-emerald-500"></i>
        </div>
        <p class="mt-3 text-2xl font-bold text-gray-900">
            <c:out value="${empty approvedToday ? 0 : approvedToday}"/>
        </p>
        <p class="mt-1 text-xs text-gray-500">Theo ngày cập nhật trạng thái</p>
    </div>

    <div class="rounded-xl border border-gray-200 bg-white p-5">
        <div class="flex items-center justify-between">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Bị từ chối (7 ngày)
            </p>
            <i class="fas fa-ban text-red-500"></i>
        </div>
        <p class="mt-3 text-2xl font-bold text-gray-900">
            <c:out value="${empty rejectedThisWeek ? 0 : rejectedThisWeek}"/>
        </p>
        <p class="mt-1 text-xs text-gray-500">Trong 7 ngày gần nhất</p>
    </div>

    <div class="rounded-xl border border-gray-200 bg-white p-5">
        <div class="flex items-center justify-between">
            <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">
                Tỷ lệ duyệt
            </p>
            <i class="fas fa-chart-line text-indigo-500"></i>
        </div>
        <p class="mt-3 text-2xl font-bold text-gray-900">
            <fmt:formatNumber
                    value="${empty successRate ? 0 : successRate}"
                    minFractionDigits="0"
                    maxFractionDigits="1"/>%
        </p>
        <p class="mt-1 text-xs text-gray-500">Trong các quyết định 7 ngày gần nhất</p>
    </div>

</div>

<div class="rounded-xl border border-gray-200 bg-white overflow-hidden">

    <div class="flex flex-col gap-3 border-b border-gray-200 p-4 md:flex-row md:items-center md:justify-between">
        <div>
            <h2 class="font-bold text-gray-900">Danh sách chờ duyệt</h2>
            <p class="mt-1 text-xs text-gray-500">
                Dữ liệu được lấy trực tiếp từ cơ sở dữ liệu.
            </p>
        </div>

        <div class="relative w-full md:w-80">
            <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
            <input
                    id="reviewSearch"
                    type="search"
                    placeholder="Tìm tên truyện hoặc người đăng..."
                    class="w-full rounded-lg border border-gray-300 py-2 pl-9 pr-3 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100">
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full min-w-[900px] text-left text-sm">
            <thead class="border-b border-gray-200 bg-gray-50 text-xs uppercase text-gray-600">
            <tr>
                <th class="px-5 py-4">Mã bài</th>
                <th class="px-5 py-4">Người đăng</th>
                <th class="px-5 py-4">Thông tin truyện</th>
                <th class="px-5 py-4">Giá bán</th>
                <th class="px-5 py-4">Ngày gửi</th>
                <th class="px-5 py-4">Trạng thái</th>
                <th class="px-5 py-4 text-center">Thao tác</th>
            </tr>
            </thead>

            <tbody id="reviewTableBody" class="divide-y divide-gray-100">

            <c:forEach var="item" items="${pendingProducts}">
                <tr class="review-row hover:bg-gray-50"
                    data-search="<c:out value='${item.title}'/> <c:out value='${item.sellerName}'/>">

                    <td class="whitespace-nowrap px-5 py-4 font-bold text-gray-900">
                        #MV-<c:out value="${item.id}"/>
                    </td>

                    <td class="px-5 py-4">
                        <p class="font-semibold text-gray-800">
                            <c:out value="${empty item.sellerName ? 'Người bán #' : item.sellerName}"/>
                        </p>
                        <p class="mt-1 text-xs text-gray-400">
                            ID: <c:out value="${item.sellerId}"/>
                        </p>
                    </td>

                    <td class="px-5 py-4">
                        <div class="flex items-start gap-3">
                            <c:choose>
                                <c:when test="${not empty item.imageUrl}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(item.imageUrl, 'http://') || fn:startsWith(item.imageUrl, 'https://')}">
                                            <img
                                                    class="h-16 w-12 shrink-0 rounded border border-gray-200 object-cover"
                                                    src="<c:out value='${item.imageUrl}'/>"
                                                    alt="Ảnh bìa"
                                                    loading="lazy"
                                                    onerror="this.style.display='none';">
                                        </c:when>
                                        <c:otherwise>
                                            <img
                                                    class="h-16 w-12 shrink-0 rounded border border-gray-200 object-cover"
                                                    src="${ctx}/<c:out value='${item.imageUrl}'/>"
                                                    alt="Ảnh bìa"
                                                    loading="lazy"
                                                    onerror="this.style.display='none';">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="flex h-16 w-12 shrink-0 items-center justify-center rounded border border-gray-200 bg-gray-100 text-gray-400">
                                        <i class="fas fa-book"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="min-w-0 max-w-sm">
                                <p class="font-bold text-gray-900">
                                    <c:out value="${item.title}"/>
                                </p>
                                <p class="mt-1 line-clamp-2 text-xs text-gray-500">
                                    <c:out value="${empty item.description ? 'Chưa có mô tả.' : item.description}"/>
                                </p>
                            </div>
                        </div>
                    </td>

                    <td class="whitespace-nowrap px-5 py-4 font-bold text-indigo-700">
                        <fmt:formatNumber value="${item.price}" pattern="#,##0"/> đ
                    </td>

                    <td class="whitespace-nowrap px-5 py-4 text-xs text-gray-500">
                        <c:out value="${item.createdAt}"/>
                    </td>

                    <td class="px-5 py-4">
                        <span class="inline-flex items-center gap-1 rounded-full border border-amber-200 bg-amber-50 px-2.5 py-1 text-xs font-semibold text-amber-700">
                            <i class="fas fa-clock"></i>
                            Chờ duyệt
                        </span>
                    </td>

                    <td class="whitespace-nowrap px-5 py-4">
                        <div class="flex items-center justify-center gap-3">

                            <a
                                    href="${ctx}/admin/manage?tab=content-review&amp;viewId=${item.id}"
                                    class="text-indigo-600 hover:text-indigo-800"
                                    title="Xem chi tiết"
                                    aria-label="Xem chi tiết bài đăng">
                                <i class="fas fa-eye text-base"></i>
                            </a>

                            <form method="post" action="${ctx}/admin/manage"
                                  class="inline"
                                  onsubmit="return confirm('Duyệt bài đăng này?');">
                                <input type="hidden" name="tab" value="content-review">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="productId" value="${item.id}">
                                <button
                                        type="submit"
                                        class="text-emerald-600 hover:text-emerald-800"
                                        title="Duyệt bài"
                                        aria-label="Duyệt bài đăng">
                                    <i class="fas fa-circle-check text-base"></i>
                                </button>
                            </form>

                            <button
                                    type="button"
                                    class="text-red-600 hover:text-red-800"
                                    title="Từ chối"
                                    aria-label="Từ chối bài đăng"
                                    data-id="${item.id}"
                                    data-title="<c:out value='${item.title}'/>"
                                    onclick="openReviewDialog(this, 'reject')">
                                <i class="fas fa-circle-xmark text-base"></i>
                            </button>

                            <button
                                    type="button"
                                    class="text-orange-600 hover:text-orange-800"
                                    title="Yêu cầu chỉnh sửa"
                                    aria-label="Yêu cầu chỉnh sửa bài đăng"
                                    data-id="${item.id}"
                                    data-title="<c:out value='${item.title}'/>"
                                    onclick="openReviewDialog(this, 'requestEdit')">
                                <i class="fas fa-pen-to-square text-base"></i>
                            </button>

                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty pendingProducts}">
                <tr>
                    <td colspan="7" class="px-6 py-12 text-center">
                        <div class="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-gray-100 text-gray-400">
                            <i class="fas fa-inbox text-xl"></i>
                        </div>
                        <p class="font-semibold text-gray-700">
                            Chưa có bài đăng chờ duyệt
                        </p>
                        <p class="mt-1 text-sm text-gray-500">
                            Nếu database có bài PENDING_APPROVAL, hãy kiểm tra kết nối database của ứng dụng.
                        </p>
                    </td>
                </tr>
            </c:if>

            <tr id="reviewNoSearchResult" style="display:none;">
                <td colspan="7" class="px-6 py-8 text-center text-sm text-gray-500">
                    Không tìm thấy bài đăng phù hợp.
                </td>
            </tr>

            </tbody>
        </table>
    </div>
</div>

<c:if test="${not empty selectedProduct}">
    <div class="mt-6 rounded-xl border border-gray-200 bg-white p-6">
        <div class="mb-4 flex items-center justify-between">
            <h2 class="text-lg font-bold text-gray-900">
                Chi tiết bài đăng #MV-<c:out value="${selectedProduct.id}"/>
            </h2>
            <a href="${ctx}/admin/manage?tab=content-review"
               class="text-sm text-gray-500 hover:text-gray-800">
                Đóng chi tiết
            </a>
        </div>

        <div class="grid grid-cols-1 gap-3 text-sm text-gray-700 md:grid-cols-2">
            <p><strong>Người bán:</strong>
                <c:out value="${selectedProduct.sellerName}"/>
            </p>
            <p><strong>Giá:</strong>
                <fmt:formatNumber value="${selectedProduct.price}" pattern="#,##0"/> đ
            </p>
            <p><strong>Trạng thái:</strong>
                <c:out value="${selectedProduct.status}"/>
            </p>
            <p><strong>Ngày tạo:</strong>
                <c:out value="${selectedProduct.createdAt}"/>
            </p>
        </div>

        <div class="mt-4">
            <p class="mb-1 font-semibold text-gray-900">Tiêu đề</p>
            <p class="text-sm text-gray-700">
                <c:out value="${selectedProduct.title}"/>
            </p>
        </div>

        <div class="mt-4">
            <p class="mb-1 font-semibold text-gray-900">Mô tả</p>
            <p class="whitespace-pre-line text-sm text-gray-700">
                <c:out value="${selectedProduct.description}"/>
            </p>
        </div>

        <c:if test="${not empty selectedProduct.rejectionReason}">
            <div class="mt-4 rounded-lg bg-red-50 p-3 text-sm text-red-800">
                <strong>Lý do xử lý:</strong>
                <c:out value="${selectedProduct.rejectionReason}"/>
            </div>
        </c:if>
    </div>
</c:if>

<div id="decisionModal"
     class="modal"
     aria-hidden="true"
     style="display:none;">
    <div class="mx-3 w-full max-w-md rounded-xl bg-white p-6 shadow-xl"
         role="dialog"
         aria-modal="true"
         aria-labelledby="decisionModalTitle">

        <div class="mb-4 flex items-center justify-between">
            <div>
                <h3 id="decisionModalTitle" class="text-lg font-bold text-gray-900">
                    Xử lý bài đăng
                </h3>
                <p id="decisionModalProduct" class="mt-1 text-xs text-gray-500"></p>
            </div>
            <button
                    type="button"
                    class="text-2xl leading-none text-gray-400 hover:text-gray-700"
                    onclick="closeReviewDialog()"
                    aria-label="Đóng hộp thoại">
                &times;
            </button>
        </div>

        <form method="post" action="${ctx}/admin/manage" id="decisionForm">
            <input type="hidden" name="tab" value="content-review">
            <input type="hidden" id="modalProductId" name="productId">
            <input type="hidden" id="modalAction" name="action">

            <label for="reasonInput" class="mb-2 block text-sm font-semibold text-gray-700">
                Lý do xử lý <span class="text-red-500">*</span>
            </label>

            <textarea
                    id="reasonInput"
                    name="reason"
                    rows="5"
                    required
                    minlength="5"
                    maxlength="1000"
                    placeholder="Nhập lý do cụ thể để người bán biết cần xử lý điều gì..."
                    class="w-full rounded-lg border border-gray-300 p-3 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"></textarea>

            <p class="mt-1 text-xs text-gray-400">
                Tối đa 1.000 ký tự.
            </p>

            <div class="mt-5 flex justify-end gap-2">
                <button
                        type="button"
                        class="rounded-lg bg-gray-100 px-4 py-2 text-sm font-semibold text-gray-600 hover:bg-gray-200"
                        onclick="closeReviewDialog()">
                    Hủy
                </button>
                <button
                        id="decisionSubmit"
                        type="submit"
                        class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-bold text-white hover:bg-indigo-700">
                    Xác nhận
                </button>
            </div>
        </form>
    </div>
</div>

<style>
    #decisionModal {
        position: fixed;
        inset: 0;
        z-index: 1000;
        align-items: center;
        justify-content: center;
        padding: 20px;
        background: rgba(15, 23, 42, .45);
    }

    #decisionModal.is-open {
        display: flex !important;
    }

    #decisionModal textarea {
        resize: vertical;
    }
</style>

<script>
    (function () {
        var searchInput = document.getElementById("reviewSearch");
        var rows = document.querySelectorAll(".review-row");
        var noResult = document.getElementById("reviewNoSearchResult");

        if (searchInput) {
            searchInput.addEventListener("input", function () {
                var keyword = this.value.trim().toLocaleLowerCase("vi");
                var visibleCount = 0;

                rows.forEach(function (row) {
                    var content = (row.getAttribute("data-search") || "")
                        .toLocaleLowerCase("vi");
                    var matched = content.indexOf(keyword) !== -1;

                    row.style.display = matched ? "" : "none";

                    if (matched) {
                        visibleCount++;
                    }
                });

                if (noResult) {
                    noResult.style.display =
                        rows.length > 0 && visibleCount === 0 ? "" : "none";
                }
            });
        }

        // Đóng modal khi tải trang, kể cả khi CSS bên ngoài định nghĩa .modal.
        var modal = document.getElementById("decisionModal");
        if (modal) {
            modal.classList.remove("show");
            modal.classList.remove("is-open");
            modal.style.display = "none";
            modal.setAttribute("aria-hidden", "true");
        }
    })();

    function openReviewDialog(button, action) {
        var modal = document.getElementById("decisionModal");
        var title = document.getElementById("decisionModalTitle");
        var productText = document.getElementById("decisionModalProduct");
        var productId = document.getElementById("modalProductId");
        var actionInput = document.getElementById("modalAction");
        var reason = document.getElementById("reasonInput");
        var submit = document.getElementById("decisionSubmit");

        var id = button.getAttribute("data-id");
        var name = button.getAttribute("data-title") || ("Bài đăng #" + id);

        productId.value = id;
        actionInput.value = action;
        reason.value = "";

        if (action === "reject") {
            title.textContent = "Từ chối bài đăng";
            submit.textContent = "Xác nhận từ chối";
            submit.className =
                "rounded-lg bg-red-600 px-4 py-2 text-sm font-bold text-white hover:bg-red-700";
        } else {
            title.textContent = "Yêu cầu chỉnh sửa";
            submit.textContent = "Gửi yêu cầu";
            submit.className =
                "rounded-lg bg-orange-600 px-4 py-2 text-sm font-bold text-white hover:bg-orange-700";
        }

        productText.textContent = "#" + id + " — " + name;
        modal.style.display = "flex";
        modal.classList.add("is-open");
        modal.setAttribute("aria-hidden", "false");
        reason.focus();
    }

    function closeReviewDialog() {
        var modal = document.getElementById("decisionModal");

        if (modal) {
            modal.classList.remove("is-open");
            modal.classList.remove("show");
            modal.style.display = "none";
            modal.setAttribute("aria-hidden", "true");
        }
    }

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeReviewDialog();
        }
    });

    document.getElementById("decisionModal").addEventListener("click", function (event) {
        if (event.target === this) {
            closeReviewDialog();
        }
    });
</script>
