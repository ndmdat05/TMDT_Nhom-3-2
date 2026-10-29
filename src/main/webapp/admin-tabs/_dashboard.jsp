
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="space-y-6">

    <!-- Tiêu đề -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-extrabold text-gray-900">
                Tổng quan sàn MangaZ
            </h1>
            <p class="text-sm text-gray-500 mt-1">
                Theo dõi giao dịch, giá trị ký quỹ và hoạt động của sàn.
            </p>
        </div>

        <div class="text-sm text-gray-500">
            Kỳ thống kê:
            <strong>
                <c:out value="${dashboardData.from}" />
                –
                <c:out value="${dashboardData.to}" />
            </strong>
        </div>
    </div>

    <!-- Thông báo kiểm tra bộ lọc -->
    <c:if test="${not empty dashboardData.errorMessage}">
        <div class="p-4 rounded-xl border border-amber-200 bg-amber-50 text-amber-800 text-sm">
            <c:out value="${dashboardData.errorMessage}" />
        </div>
    </c:if>

    <!-- Bộ lọc -->
    <form method="get" action="${ctx}/dashboard"
          class="bg-white border border-gray-200 rounded-2xl p-5 shadow-sm">

        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 items-end">

            <div>
                <label for="from" class="block text-sm font-semibold text-gray-700 mb-2">
                    Từ ngày
                </label>
                <input id="from" type="date" name="from"
                       value="${dashboardData.from}"
                       required
                       class="w-full rounded-lg border border-gray-300 px-3 py-2.5 text-sm">
            </div>

            <div>
                <label for="to" class="block text-sm font-semibold text-gray-700 mb-2">
                    Đến ngày
                </label>
                <input id="to" type="date" name="to"
                       value="${dashboardData.to}"
                       required
                       class="w-full rounded-lg border border-gray-300 px-3 py-2.5 text-sm">
            </div>

            <div>
                <label for="status" class="block text-sm font-semibold text-gray-700 mb-2">
                    Trạng thái giao dịch
                </label>
                <select id="status" name="status"
                        class="w-full rounded-lg border border-gray-300 px-3 py-2.5 text-sm">
                    <option value="" ${empty dashboardData.statusFilter ? 'selected' : ''}>
                        Tất cả giao dịch
                    </option>
                    <option value="released" ${dashboardData.statusFilter eq 'released' ? 'selected' : ''}>
                        Đã hoàn tất
                    </option>
                    <option value="holding" ${dashboardData.statusFilter eq 'holding' ? 'selected' : ''}>
                        Đang giữ ký quỹ
                    </option>
                    <option value="reviewing" ${dashboardData.statusFilter eq 'reviewing' ? 'selected' : ''}>
                        Đang xử lý
                    </option>
                    <option value="dispute" ${dashboardData.statusFilter eq 'dispute' ? 'selected' : ''}>
                        Tranh chấp
                    </option>
                </select>
            </div>

            <div class="flex gap-2">
                <button type="submit"
                        class="flex-1 rounded-lg bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-sm px-4 py-2.5">
                    <i class="fa-solid fa-filter mr-1"></i>
                    Lọc dữ liệu
                </button>

                <a href="${ctx}/dashboard"
                   class="rounded-lg border border-gray-300 hover:bg-gray-50 text-gray-700 font-semibold text-sm px-4 py-2.5">
                    Đặt lại
                </a>
            </div>

        </div>

        <p class="text-xs text-gray-400 mt-3">
            Khoảng ngày tối đa 90 ngày. Thống kê biểu đồ và KPI sử dụng dữ liệu trong kỳ được chọn;
            một số chỉ số cảnh báo là số liệu hiện tại của toàn hệ thống.
        </p>
    </form>

    <!-- Các chỉ số chính -->
    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">

        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
            <div class="flex items-center justify-between">
                <p class="text-sm text-gray-500 font-semibold">Giá trị đơn hoàn tất</p>
                <span class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                    <i class="fa-solid fa-coins"></i>
                </span>
            </div>
            <p class="text-2xl font-extrabold text-gray-900 mt-4 break-words">
                <c:choose>
                    <c:when test="${not empty stats.totalEscrowValue}">
                        <fmt:formatNumber value="${stats.totalEscrowValue}" maxFractionDigits="0" />
                        <span class="text-sm font-semibold text-gray-500">₫</span>
                    </c:when>
                    <c:otherwise>Chưa có dữ liệu</c:otherwise>
                </c:choose>
            </p>
            <p class="text-xs text-gray-400 mt-2">Tổng tiền đơn COMPLETED trong kỳ</p>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
            <div class="flex items-center justify-between">
                <p class="text-sm text-gray-500 font-semibold">Đơn thành công</p>
                <span class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                    <i class="fa-solid fa-circle-check"></i>
                </span>
            </div>
            <p class="text-3xl font-extrabold text-gray-900 mt-4">
                <c:choose>
                    <c:when test="${not empty stats.successfulOrders}">
                        <fmt:formatNumber value="${stats.successfulOrders}" maxFractionDigits="0" />
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </p>
            <p class="text-xs text-gray-400 mt-2">Số đơn đã hoàn tất trong kỳ</p>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
            <div class="flex items-center justify-between">
                <p class="text-sm text-gray-500 font-semibold">Tỷ lệ hoàn tất</p>
                <span class="w-10 h-10 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center">
                    <i class="fa-solid fa-chart-line"></i>
                </span>
            </div>
            <p class="text-3xl font-extrabold text-gray-900 mt-4">
                <c:choose>
                    <c:when test="${not empty stats.successRatePercent}">
                        <fmt:formatNumber value="${stats.successRatePercent}" maxFractionDigits="1" />%
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </p>
            <p class="text-xs text-gray-400 mt-2">Đơn hoàn tất trên tổng đơn trong kỳ</p>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
            <div class="flex items-center justify-between">
                <p class="text-sm text-gray-500 font-semibold">Người mua hoạt động</p>
                <span class="w-10 h-10 rounded-xl bg-violet-50 text-violet-600 flex items-center justify-center">
                    <i class="fa-solid fa-users"></i>
                </span>
            </div>
            <p class="text-3xl font-extrabold text-gray-900 mt-4">
                <c:choose>
                    <c:when test="${not empty stats.activeCollectors}">
                        <fmt:formatNumber value="${stats.activeCollectors}" maxFractionDigits="0" />
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </p>
            <p class="text-xs text-gray-400 mt-2">Người mua có đơn trong kỳ</p>
        </div>

    </div>

    <!-- Chỉ số cần chú ý -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

        <div class="rounded-xl border border-amber-200 bg-amber-50 p-4">
            <p class="text-sm font-semibold text-amber-800">Hồ sơ chờ thẩm định</p>
            <p class="text-2xl font-extrabold text-amber-900 mt-2">
                <c:out value="${stats.pendingAppraisals != null ? stats.pendingAppraisals : 0}" />
            </p>
        </div>

        <div class="rounded-xl border border-rose-200 bg-rose-50 p-4">
            <p class="text-sm font-semibold text-rose-800">Tranh chấp chờ xử lý</p>
            <p class="text-2xl font-extrabold text-rose-900 mt-2">
                <c:out value="${stats.disputeCount != null ? stats.disputeCount : 0}" />
            </p>
        </div>

        <div class="rounded-xl border border-sky-200 bg-sky-50 p-4">
            <p class="text-sm font-semibold text-sky-800">Người dùng mới hôm nay</p>
            <p class="text-2xl font-extrabold text-sky-900 mt-2">
                <c:out value="${stats.newCollectorsToday != null ? stats.newCollectorsToday : 0}" />
            </p>
        </div>

    </div>

    <!-- Biểu đồ -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">

        <section class="xl:col-span-2 bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mb-5">
                <div>
                    <h2 class="font-bold text-gray-900 text-lg">Giá trị đơn hoàn tất theo ngày</h2>
                    <p class="text-sm text-gray-500 mt-1">Dữ liệu theo khoảng ngày đã lọc</p>
                </div>
            </div>

            <div class="relative h-80">
                <canvas id="revenueChart"></canvas>
            </div>

            <c:if test="${empty chartPoints}">
                <p class="text-sm text-gray-400 text-center mt-3">
                    Không có dữ liệu giao dịch hoàn tất trong khoảng ngày này.
                </p>
            </c:if>
        </section>

        <section class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">
            <h2 class="font-bold text-gray-900 text-lg">Cơ cấu danh mục</h2>
            <p class="text-sm text-gray-500 mt-1 mb-4">Giá trị sản phẩm theo danh mục</p>

            <div class="relative h-64">
                <canvas id="categoryChart"></canvas>
            </div>

            <div class="mt-4 space-y-2">
                <c:forEach var="category" items="${categoryShares}">
                    <div class="flex justify-between items-center gap-3 text-sm">
                        <span class="text-gray-600 truncate">
                            <c:out value="${category.name}" />
                        </span>
                        <span class="font-semibold text-gray-900 whitespace-nowrap">
                            <fmt:formatNumber value="${category.percent}" maxFractionDigits="1" />%
                        </span>
                    </div>
                </c:forEach>

                <c:if test="${empty categoryShares}">
                    <p class="text-sm text-gray-400">Chưa có dữ liệu danh mục.</p>
                </c:if>
            </div>
        </section>

    </div>

    <!-- Bảng giao dịch -->
    <section class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">

        <div class="p-5 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
            <div>
                <h2 class="font-bold text-gray-900 text-lg">Giao dịch gần đây</h2>
                <p class="text-sm text-gray-500 mt-1">Danh sách được lọc theo trạng thái đã chọn</p>
            </div>
            <span class="text-sm text-gray-500">
                Tổng:
                <strong><c:out value="${dashboardData.totalTransactions}" /></strong>
                giao dịch
            </span>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 text-gray-500">
                <tr>
                    <th class="px-5 py-3 font-semibold">Mã giao dịch</th>
                    <th class="px-5 py-3 font-semibold">Sản phẩm</th>
                    <th class="px-5 py-3 font-semibold">Người mua</th>
                    <th class="px-5 py-3 font-semibold">Người bán</th>
                    <th class="px-5 py-3 font-semibold text-right">Giá trị</th>
                    <th class="px-5 py-3 font-semibold">Trạng thái</th>
                </tr>
                </thead>

                <tbody class="divide-y divide-gray-100">
                <c:forEach var="tx" items="${transactions}">
                    <tr class="hover:bg-gray-50">
                        <td class="px-5 py-4 font-semibold text-indigo-600 whitespace-nowrap">
                            <c:out value="${tx.escrowCode}" />
                        </td>
                        <td class="px-5 py-4 min-w-48">
                            <div class="font-semibold text-gray-800">
                                <c:out value="${tx.title}" />
                            </div>
                            <div class="text-xs text-gray-400 mt-1">
                                <c:out value="${tx.subtitle}" />
                            </div>
                        </td>
                        <td class="px-5 py-4">
                            <c:out value="${tx.buyer}" />
                        </td>
                        <td class="px-5 py-4">
                            <c:out value="${tx.seller}" />
                        </td>
                        <td class="px-5 py-4 text-right font-semibold whitespace-nowrap">
                            <c:choose>
                                <c:when test="${not empty tx.amount}">
                                    <fmt:formatNumber value="${tx.amount}" maxFractionDigits="0" /> ₫
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-5 py-4 whitespace-nowrap">
                            <c:choose>
                                <c:when test="${tx.statusCode eq 'released'}">
                                    <span class="rounded-full bg-emerald-50 text-emerald-700 px-3 py-1 text-xs font-bold">
                                        <c:out value="${tx.statusLabel}" />
                                    </span>
                                </c:when>
                                <c:when test="${tx.statusCode eq 'holding'}">
                                    <span class="rounded-full bg-sky-50 text-sky-700 px-3 py-1 text-xs font-bold">
                                        <c:out value="${tx.statusLabel}" />
                                    </span>
                                </c:when>
                                <c:when test="${tx.statusCode eq 'reviewing'}">
                                    <span class="rounded-full bg-amber-50 text-amber-700 px-3 py-1 text-xs font-bold">
                                        <c:out value="${tx.statusLabel}" />
                                    </span>
                                </c:when>
                                <c:when test="${tx.statusCode eq 'dispute'}">
                                    <span class="rounded-full bg-rose-50 text-rose-700 px-3 py-1 text-xs font-bold">
                                        <c:out value="${tx.statusLabel}" />
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500">
                                        <c:out value="${tx.statusLabel}" />
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty transactions}">
                    <tr>
                        <td colspan="6" class="px-5 py-10 text-center text-gray-400">
                            Không tìm thấy giao dịch phù hợp.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <!-- Phân trang -->
        <c:if test="${dashboardData.totalPages > 1}">
            <div class="px-5 py-4 border-t border-gray-100 flex flex-wrap items-center justify-between gap-3">
                <p class="text-sm text-gray-500">
                    Trang <c:out value="${dashboardData.page}" />
                    / <c:out value="${dashboardData.totalPages}" />
                </p>

                <div class="flex flex-wrap gap-2">
                    <c:forEach var="pageNumber" items="${dashboardData.pageNumbers}">
                        <a href="${ctx}/dashboard?from=${dashboardData.from}&amp;to=${dashboardData.to}&amp;status=${dashboardData.statusFilter}&amp;page=${pageNumber}"
                           class="min-w-9 text-center px-3 py-2 rounded-lg border text-sm font-semibold
                           ${pageNumber == dashboardData.page ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'}">
                            <c:out value="${pageNumber}" />
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </section>

</div>

<!-- Dữ liệu thật được render từ backend -->
<script id="revenue-labels" type="application/json">[
    <c:forEach var="point" items="${chartPoints}" varStatus="loop">
        "<c:out value="${point.day}" />"<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]</script>

<script id="revenue-values" type="application/json">[
    <c:forEach var="point" items="${chartPoints}" varStatus="loop">
        <c:out value="${point.value != null ? point.value : 0}" /><c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]</script>

<script id="category-labels" type="application/json">[
    <c:forEach var="category" items="${categoryShares}" varStatus="loop">
        "<c:out value="${category.name}" />"<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]</script>

<script id="category-values" type="application/json">[
    <c:forEach var="category" items="${categoryShares}" varStatus="loop">
        <c:out value="${category.value != null ? category.value : 0}" /><c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]</script>

<script>
    (function () {
        const parseData = function (id) {
            const element = document.getElementById(id);
            if (!element) return [];

            try {
                return JSON.parse(element.textContent || "[]");
            } catch (error) {
                console.error("Không đọc được dữ liệu biểu đồ:", id, error);
                return [];
            }
        };

        const revenueLabels = parseData("revenue-labels");
        const revenueValues = parseData("revenue-values");
        const categoryLabels = parseData("category-labels");
        const categoryValues = parseData("category-values");

        const revenueCanvas = document.getElementById("revenueChart");

        if (revenueCanvas) {
            new Chart(revenueCanvas, {
                type: "bar",
                data: {
                    labels: revenueLabels,
                    datasets: [{
                        label: "Giá trị đơn hoàn tất (VNĐ)",
                        data: revenueValues,
                        backgroundColor: "#4f46e5",
                        borderRadius: 6,
                        maxBarThickness: 36
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return new Intl.NumberFormat("vi-VN", {
                                        style: "currency",
                                        currency: "VND",
                                        maximumFractionDigits: 0
                                    }).format(context.raw || 0);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return new Intl.NumberFormat("vi-VN", {
                                        notation: "compact",
                                        maximumFractionDigits: 1
                                    }).format(value);
                                }
                            }
                        },
                        x: {
                            ticks: {
                                maxRotation: 45,
                                minRotation: 0
                            }
                        }
                    }
                }
            });
        }

        const categoryCanvas = document.getElementById("categoryChart");

        if (categoryCanvas) {
            new Chart(categoryCanvas, {
                type: "doughnut",
                data: {
                    labels: categoryLabels,
                    datasets: [{
                        data: categoryValues,
                        backgroundColor: [
                            "#4f46e5", "#10b981", "#f59e0b", "#ef4444",
                            "#0ea5e9", "#8b5cf6", "#ec4899", "#64748b"
                        ],
                        borderColor: "#ffffff",
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: "62%",
                    plugins: {
                        legend: {
                            position: "bottom"
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const value = context.raw || 0;
                                    return context.label + ": " +
                                        new Intl.NumberFormat("vi-VN", {
                                            style: "currency",
                                            currency: "VND",
                                            maximumFractionDigits: 0
                                        }).format(value);
                                }
                            }
                        }
                    }
                }
            });
        }
    })();
</script>
