<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="space-y-6">

    <!-- TIÊU ĐỀ TRANG TỔNG QUAN -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-black text-gray-900 tracking-tight">Tổng Quan Hoạt Động Sàn MangaVault</h1>
            <p class="text-xs text-gray-500 mt-1">Theo dõi dòng tiền ký quỹ Escrow, bài đăng manga chờ duyệt và chỉ số tăng trưởng.</p>
        </div>
        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/admin/content-review"
               class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-4 py-2.5 rounded-xl shadow-sm transition flex items-center gap-2">
                <i class="fa-solid fa-list-check"></i> Duyệt Bài Đăng (${stats.pendingAppraisals})
            </a>
        </div>
    </div>

    <!-- 4 THẺ CHỈ SỐ DOANH THU & GIAO DỊCH (KPI CARDS) -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">

        <!-- CARD 1: TỔNG GMV KÝ QUỸ -->
        <div class="bg-white p-5 rounded-2xl border border-gray-200 shadow-2xs flex flex-col justify-between">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">TỔNG GMV KÝ QUỸ</span>
                <div class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center">
                    <i class="fa-solid fa-shield-halved text-sm"></i>
                </div>
            </div>
            <div class="mt-3">
                <div class="text-2xl font-black text-gray-900">
                    <fmt:formatNumber value="${stats.totalEscrowValue}" pattern="#,###"/> <span class="text-xs font-bold text-indigo-600">đ</span>
                </div>
                <div class="mt-2 text-[11px] font-semibold text-gray-500 flex items-center gap-1">
                    <c:choose>
                        <c:when test="${stats.escrowChangePercent != null && stats.escrowChangePercent >= 0}">
                            <span class="text-emerald-600 font-bold">↑ +${stats.escrowChangePercent}%</span> so với kỳ trước
                        </c:when>
                        <c:when test="${stats.escrowChangePercent != null}">
                            <span class="text-rose-600 font-bold">↓ ${stats.escrowChangePercent}%</span> so với kỳ trước
                        </c:when>
                        <c:otherwise><span class="text-gray-400">Chưa đủ dữ liệu so sánh</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- CARD 2: BÀI ĐĂNG CHỜ GIÁM ĐỊNH -->
        <div class="bg-white p-5 rounded-2xl border border-gray-200 shadow-2xs flex flex-col justify-between">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">MANGA CHỜ DUYỆT</span>
                <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center">
                    <i class="fa-solid fa-book text-sm"></i>
                </div>
            </div>
            <div class="mt-3">
                <div class="text-3xl font-black text-gray-900">${stats.pendingAppraisals} <span class="text-xs font-semibold text-gray-400">truyện</span></div>
                <div class="mt-2 text-[11px] font-bold text-amber-600">
                    ${stats.pendingAppraisals > 0 ? 'Cần duyệt để lên Trang Chủ' : 'Đã duyệt hết bài đăng'}
                </div>
            </div>
        </div>

        <!-- CARD 3: THÀNH VIÊN HOẠT ĐỘNG -->
        <div class="bg-white p-5 rounded-2xl border border-gray-200 shadow-2xs flex flex-col justify-between">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">THÀNH VIÊN SÀN</span>
                <div class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center">
                    <i class="fa-solid fa-users text-sm"></i>
                </div>
            </div>
            <div class="mt-3">
                <div class="text-3xl font-black text-gray-900">${stats.activeCollectors} <span class="text-xs font-semibold text-gray-400">tài khoản</span></div>
                <div class="mt-2 text-[11px] text-gray-500 font-medium">
                    <i class="fa-solid fa-user-plus text-blue-500 mr-1"></i> +${stats.newCollectorsToday} đăng ký mới hôm nay
                </div>
            </div>
        </div>

        <!-- CARD 4: TRANH CHẤP / BÁO CÁO -->
        <div class="bg-white p-5 rounded-2xl border border-gray-200 shadow-2xs flex flex-col justify-between">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">BÁO CÁO KHIẾU NẠI</span>
                <div class="w-8 h-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center">
                    <i class="fa-solid fa-triangle-exclamation text-sm"></i>
                </div>
            </div>
            <div class="mt-3">
                <div class="text-3xl font-black text-gray-900">${stats.disputeCount} <span class="text-xs font-semibold text-gray-400">khiếu nại</span></div>
                <div class="mt-2 text-[11px] font-bold text-rose-600">
                    Tỷ lệ thành công: ${stats.successRatePercent}%
                </div>
            </div>
        </div>

    </div>

    <!-- KHỐI BIỂU ĐỒ DOANH THU KÝ QUỶ & BỘ LỌC NGUYÊN BẢN (KHÓA CHIỀU CAO TRÁNH KÉO DÀI VÔ TẬN) -->
    <div class="bg-white p-6 rounded-2xl border border-gray-200 shadow-2xs">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
            <div>
                <h2 class="text-base font-extrabold text-gray-900">Biểu Đồ Giá Trị Giao Dịch GMV</h2>
                <p class="text-xs text-gray-400 mt-0.5">Biểu đồ tổng doanh thu đơn hàng thành công qua hệ thống Ký quỹ Escrow</p>
            </div>

            <!-- NÚT CHỌN THỜI GIAN: NGÀY / TUẦN / THÁNG / NĂM -->
            <div class="flex items-center bg-gray-100 p-1 rounded-xl text-xs font-bold text-gray-600">
                <a href="?timeFrame=day" class="px-3.5 py-1.5 rounded-lg transition ${selectedTimeFrame == 'day' || empty selectedTimeFrame ? 'bg-indigo-600 text-white shadow-xs' : 'hover:text-gray-900'}">Ngày</a>
                <a href="?timeFrame=week" class="px-3.5 py-1.5 rounded-lg transition ${selectedTimeFrame == 'week' ? 'bg-indigo-600 text-white shadow-xs' : 'hover:text-gray-900'}">Tuần</a>
                <a href="?timeFrame=month" class="px-3.5 py-1.5 rounded-lg transition ${selectedTimeFrame == 'month' ? 'bg-indigo-600 text-white shadow-xs' : 'hover:text-gray-900'}">Tháng</a>
                <a href="?timeFrame=year" class="px-3.5 py-1.5 rounded-lg transition ${selectedTimeFrame == 'year' ? 'bg-indigo-600 text-white shadow-xs' : 'hover:text-gray-900'}">Năm</a>
            </div>
        </div>

        <!-- CONTAINER CHART: ĐÃ KHÓA CHIỀU CAO h-[320px] ĐỂ TRÁNH KÉO DÀI VÔ TẬN -->
        <div class="relative w-full h-[320px]">
            <canvas id="escrowChart"></canvas>
        </div>
    </div>

</div>

<!-- SCRIPT RENDER CHART.JS AN TOÀN -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const ctx = document.getElementById('escrowChart');
        if (!ctx) return;

        // Render dữ liệu từ Java Backend
        const labels = [
            <c:forEach var="pt" items="${chartPoints}" varStatus="loop">
            "${pt.day}"${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        const dataValues = [
            <c:forEach var="pt" items="${chartPoints}" varStatus="loop">
            ${pt.value}${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels.length > 0 ? labels : ["Chưa có dữ liệu"],
                datasets: [{
                    label: 'Giá trị GMV (VNĐ)',
                    data: dataValues.length > 0 ? dataValues : [0],
                    backgroundColor: '#4f46e5',
                    hoverBackgroundColor: '#4338ca',
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, // BẮT BUỘC: Giữ chart vừa khít khung h-[320px], không bị giãn vĩnh viễn
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: '#f3f4f6' },
                        ticks: {
                            font: { size: 11 },
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + ' đ';
                            }
                        }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { font: { size: 11 } }
                    }
                }
            }
        });
    });
</script>