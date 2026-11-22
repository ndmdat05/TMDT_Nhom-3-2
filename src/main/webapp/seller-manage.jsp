<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kênh Người Bán - MangaZ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .modal-scroll { max-height: calc(100vh - 200px); overflow-y: auto; }
    </style>
</head>
<body class="bg-[#fcfcfd] text-[#141b2b] font-sans">

<jsp:include page="includes/header.jsp" />

<!-- FLASH MESSAGES -->
<div class="max-w-[1400px] mx-auto mt-4 px-6">
    <c:if test="${not empty sessionScope.sellerFlash_success}">
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-800 px-4 py-3 rounded-lg relative mb-4">
            <i class="fas fa-circle-check mr-2"></i> <c:out value="${sessionScope.sellerFlash_success}"/>
            <button type="button" class="absolute top-3 right-3 text-emerald-600 hover:text-emerald-800" onclick="this.parentElement.remove()">&times;</button>
        </div>
        <c:remove var="sellerFlash_success" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.sellerFlash_error}">
        <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg relative mb-4">
            <i class="fas fa-circle-exclamation mr-2"></i> <c:out value="${sessionScope.sellerFlash_error}"/>
            <button type="button" class="absolute top-3 right-3 text-red-600 hover:text-red-800" onclick="this.parentElement.remove()">&times;</button>
        </div>
        <c:remove var="sellerFlash_error" scope="session"/>
    </c:if>
</div>

<div class="max-w-[1400px] mx-auto my-6 px-6">
    <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
        <h2 class="text-2xl font-black text-gray-900"><i class="fas fa-store text-red-600 mr-2"></i>Kênh Người Bán</h2>
        <button onclick="document.getElementById('addProductModal').classList.remove('hidden')" class="bg-red-600 hover:bg-red-700 text-white font-bold py-2.5 px-5 rounded-lg transition shadow-sm">
            <i class="fas fa-plus mr-1"></i> Đăng bán truyện mới
        </button>
    </div>

    <div class="flex border-b border-gray-200 mb-6 overflow-x-auto">
        <a href="seller-manage?action=products" class="px-5 py-3 font-bold text-sm whitespace-nowrap ${activeTab == 'products' ? 'text-indigo-600 border-b-2 border-indigo-600' : 'text-gray-500 hover:text-indigo-600'}">Sản phẩm của tôi</a>
        <a href="seller-manage?action=orders" class="px-5 py-3 font-bold text-sm whitespace-nowrap ${activeTab == 'orders' ? 'text-indigo-600 border-b-2 border-indigo-600' : 'text-gray-500 hover:text-indigo-600'}">Đơn hàng cần xử lý</a>
        <a href="seller-manage?action=cancelled" class="px-5 py-3 font-bold text-sm whitespace-nowrap ${activeTab == 'cancelled' ? 'text-red-600 border-b-2 border-red-600' : 'text-gray-500 hover:text-red-600'}">Đơn hủy</a>
        <a href="seller-manage?action=refunds" class="px-5 py-3 font-bold text-sm whitespace-nowrap ${activeTab == 'refunds' ? 'text-amber-600 border-b-2 border-amber-600' : 'text-gray-500 hover:text-amber-600'}">Đơn hoàn trả</a>
    </div>

    <div class="bg-white p-6 border border-gray-200 rounded-xl shadow-sm overflow-x-auto">
        <c:choose>
            <c:when test="${activeTab == 'products'}">
                <table class="w-full text-left text-sm">
                    <thead class="bg-gray-50 text-gray-600 text-xs uppercase">
                    <tr>
                        <th class="px-4 py-3 rounded-tl-lg whitespace-nowrap">Hình ảnh</th>
                        <th class="px-4 py-3 min-w-[250px]">Tên Truyện</th>
                        <th class="px-4 py-3 whitespace-nowrap">Giá bán</th>
                        <th class="px-4 py-3 min-w-[200px]">Trạng thái</th>
                        <th class="px-4 py-3 text-right rounded-tr-lg whitespace-nowrap">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach var="p" items="${sellerProducts}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3">
                                <c:choose>
                                    <c:when test="${not empty p.imageUrl}">
                                        <img src="${p.imageUrl}" alt="${p.title}" class="w-[50px] h-[70px] object-cover rounded border border-gray-200" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="w-[50px] h-[70px] bg-orange-200 rounded border border-orange-300 items-center justify-center hidden"><i class="fas fa-book text-gray-800 text-xl"></i></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-[50px] h-[70px] bg-orange-200 rounded border border-orange-300 flex items-center justify-center"><i class="fas fa-book text-gray-800 text-xl"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3 font-bold text-gray-900"><c:out value="${p.title}"/></td>
                            <td class="px-4 py-3 text-red-600 font-bold whitespace-nowrap">
                                <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> đ
                            </td>
                            <td class="px-4 py-3">
                                <c:choose>
                                    <c:when test="${p.status == 'APPROVED'}"><span class="px-2 py-1 rounded bg-emerald-100 text-emerald-700 text-xs font-bold whitespace-nowrap">Đang hiển thị</span></c:when>
                                    <c:when test="${p.status == 'PENDING_APPROVAL'}"><span class="px-2 py-1 rounded bg-amber-100 text-amber-700 text-xs font-bold whitespace-nowrap"><i class="fas fa-clock mr-1"></i>Chờ duyệt</span></c:when>
                                    <c:when test="${p.status == 'REJECTED'}">
                                        <span class="px-2 py-1 rounded bg-red-100 text-red-700 text-xs font-bold whitespace-nowrap"><i class="fas fa-circle-xmark mr-1"></i>Bị từ chối</span>
                                        <c:if test="${not empty p.rejectionReason}">
                                            <div class="text-xs text-red-600 mt-1 p-1 bg-red-50 rounded"><b>Lý do:</b> <c:out value="${p.rejectionReason}"/></div>
                                        </c:if>
                                    </c:when>
                                    <c:when test="${p.status == 'HIDDEN'}"><span class="px-2 py-1 rounded bg-gray-200 text-gray-700 text-xs font-bold whitespace-nowrap"><i class="fas fa-eye-slash mr-1"></i>Đang ẩn</span></c:when>
                                    <c:otherwise><span class="px-2 py-1 rounded bg-gray-800 text-white text-xs font-bold">${p.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3 text-right whitespace-nowrap">
                                <div class="flex items-center justify-end gap-2">
                                    <a href="seller-manage?action=edit&id=${p.id}" class="px-3 py-1.5 border border-indigo-200 text-indigo-600 hover:bg-indigo-50 rounded text-xs font-bold"><i class="fas fa-edit"></i> Sửa</a>
                                    <c:if test="${p.status == 'APPROVED' || p.status == 'HIDDEN'}">
                                        <form action="seller-manage" method="post" class="inline m-0">
                                            <input type="hidden" name="action" value="toggle-status">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="px-3 py-1.5 border ${p.status == 'APPROVED' ? 'border-amber-200 text-amber-600 hover:bg-amber-50' : 'border-emerald-200 text-emerald-600 hover:bg-emerald-50'} rounded text-xs font-bold">
                                                <i class="fas ${p.status == 'APPROVED' ? 'fa-eye-slash' : 'fa-eye'}"></i> ${p.status == 'APPROVED' ? 'Ẩn' : 'Hiện'}
                                            </button>
                                        </form>
                                    </c:if>
                                    <form action="seller-manage" method="post" class="inline m-0" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button type="submit" class="px-3 py-1.5 border border-red-200 text-red-600 hover:bg-red-50 rounded text-xs font-bold"><i class="fas fa-trash"></i> Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sellerProducts}">
                        <tr><td colspan="5" class="text-center text-gray-500 py-10"><i class="fas fa-box-open text-4xl mb-3 text-gray-300"></i><div>Bạn chưa đăng bán sản phẩm nào.</div></td></tr>
                    </c:if>
                    </tbody>
                </table>
            </c:when>

            <c:when test="${activeTab == 'orders' or activeTab == 'cancelled' or activeTab == 'refunds'}">
                <table class="w-full text-left text-sm">
                    <thead class="bg-gray-50 text-gray-600 text-xs uppercase">
                    <tr>
                        <th class="px-4 py-3 rounded-tl-lg whitespace-nowrap">Mã đơn</th>
                        <th class="px-4 py-3 min-w-[150px]">Người Mua</th>
                        <th class="px-4 py-3 min-w-[250px]">Sản phẩm</th>
                        <th class="px-4 py-3 whitespace-nowrap">Tổng tiền</th>
                        <th class="px-4 py-3 whitespace-nowrap">Trạng thái</th>
                        <th class="px-4 py-3 text-right rounded-tr-lg whitespace-nowrap">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach var="o" items="${sellerOrders}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-3 font-bold text-gray-900 whitespace-nowrap">#ORD-${not empty o.orderCode ? o.orderCode : o.id}</td>
                            <td class="px-4 py-3 text-gray-700">${not empty o.receiverName ? o.receiverName : o.buyerName}</td>
                            <td class="px-4 py-3 text-gray-700">${o.productTitle}</td>
                            <td class="px-4 py-3 text-red-600 font-bold whitespace-nowrap">
                                <fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> đ
                            </td>
                            <td class="px-4 py-3 whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${o.status == 'PENDING'}"><span class="px-2 py-1 rounded bg-amber-100 text-amber-700 text-xs font-bold">PENDING</span></c:when>
                                    <c:when test="${o.status == 'CONFIRMED'}"><span class="px-2 py-1 rounded bg-blue-100 text-blue-700 text-xs font-bold">CONFIRMED</span></c:when>
                                    <c:when test="${o.status == 'SHIPPING'}"><span class="px-2 py-1 rounded bg-indigo-100 text-indigo-700 text-xs font-bold">SHIPPING</span></c:when>
                                    <c:when test="${o.status == 'COMPLETED'}"><span class="px-2 py-1 rounded bg-emerald-100 text-emerald-700 text-xs font-bold">COMPLETED</span></c:when>
                                    <c:when test="${o.status == 'CANCELLED'}"><span class="px-2 py-1 rounded bg-red-100 text-red-700 text-xs font-bold">CANCELLED</span></c:when>
                                    <c:otherwise><span class="px-2 py-1 rounded bg-gray-200 text-gray-700 text-xs font-bold">${o.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3 text-right whitespace-nowrap">
                                <a href="seller-order-detail?id=${o.id}" class="px-3 py-1.5 border border-red-200 text-red-600 hover:bg-red-50 rounded text-xs font-bold"><i class="fas fa-eye mr-1"></i> Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sellerOrders}">
                        <tr><td colspan="6" class="text-center text-gray-500 py-10"><i class="fas fa-box-open text-4xl mb-3 text-gray-300"></i><div>Chưa có đơn hàng nào.</div></td></tr>
                    </c:if>
                    </tbody>
                </table>
            </c:when>
        </c:choose>
    </div>
</div>

<!-- MODAL THÊM SẢN PHẨM -->
<div id="addProductModal" class="hidden fixed inset-0 z-[100] bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-3xl overflow-hidden flex flex-col" style="max-height: 90vh;">
        <div class="bg-red-600 text-white px-5 py-4 flex justify-between items-center shrink-0">
            <h5 class="font-bold text-lg m-0"><i class="fas fa-plus-circle mr-2"></i>Đăng Bán Truyện</h5>
            <button type="button" class="text-white hover:text-gray-200 text-xl" onclick="document.getElementById('addProductModal').classList.add('hidden')">&times;</button>
        </div>

        <div class="p-6 overflow-y-auto modal-scroll">
            <form action="seller-manage" method="post" id="addProductForm" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <h6 class="font-bold text-red-600 border-b border-gray-200 pb-2 mb-4 text-sm uppercase tracking-wider"><i class="fas fa-book mr-1"></i> Thông tin cơ bản</h6>
                <div class="mb-4">
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Tên truyện <span class="text-red-500">*</span></label>
                    <input type="text" name="title" required maxlength="255" placeholder="VD: One Piece - Tập 1" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Thể loại</label>
                        <select name="categoryId" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none bg-white">
                            <option value="">-- Chọn thể loại --</option>
                            <c:forEach var="c" items="${categoryList}"><option value="${c.id}"><c:out value="${c.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Nhà xuất bản</label>
                        <select name="brandId" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none bg-white">
                            <option value="">-- Chọn NXB --</option>
                            <c:forEach var="b" items="${brandList}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                </div>

                <h6 class="font-bold text-red-600 border-b border-gray-200 pb-2 mb-4 mt-6 text-sm uppercase tracking-wider"><i class="fas fa-info-circle mr-1"></i> Chi tiết ấn phẩm</h6>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Tên bộ truyện (Series)</label>
                        <input type="text" name="seriesName" maxlength="255" placeholder="VD: One Piece" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Tác giả</label>
                        <input type="text" name="author" maxlength="255" placeholder="VD: Eiichiro Oda" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Tập số</label>
                        <input type="number" name="volumeNumber" min="1" placeholder="VD: 1" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Phiên bản</label>
                        <input type="text" name="edition" maxlength="100" placeholder="VD: Bản in đầu 2003" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Tình trạng <span class="text-red-500">*</span></label>
                        <select name="itemCondition" required class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none bg-white">
                            <option value="NEW">Mới 100% (Nguyên seal)</option>
                            <option value="LIKE_NEW">Like New (Sưu tầm)</option>
                            <option value="USED">Đã qua sử dụng</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Ngôn ngữ</label>
                        <select name="language" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none bg-white">
                            <option value="Tiếng Việt">Tiếng Việt</option>
                            <option value="Tiếng Nhật">Tiếng Nhật</option>
                            <option value="Tiếng Anh">Tiếng Anh</option>
                        </select>
                    </div>
                </div>

                <h6 class="font-bold text-red-600 border-b border-gray-200 pb-2 mb-4 mt-6 text-sm uppercase tracking-wider"><i class="fas fa-tag mr-1"></i> Giá & Tồn kho</h6>

                <div id="normalPriceFields" class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Giá bán (VNĐ) <span class="text-red-500">*</span></label>
                        <!-- Đã bỏ step="1000" để không bị lỗi HTML5 -->
                        <input type="number" id="normalPriceInput" name="price" min="0" placeholder="VD: 450000" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Số lượng trong kho</label>
                        <input type="number" id="stockInput" name="stockQuantity" min="0" value="1" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                </div>

                <!-- KHỐI ĐẤU GIÁ -->
                <div class="mb-4 mt-2 p-4 bg-orange-50 border border-orange-200 rounded-xl">
                    <div class="flex items-center gap-2">
                        <input type="checkbox" id="isAuction" name="isAuction" value="true" onchange="toggleAuctionFields()" class="w-4 h-4 text-orange-600 rounded focus:ring-orange-500 cursor-pointer">
                        <label class="font-bold text-orange-800 cursor-pointer text-sm" for="isAuction">
                            <i class="fas fa-gavel mr-1"></i> Đăng bán dưới hình thức Đấu giá
                        </label>
                    </div>

                    <div id="auctionFields" class="mt-4 hidden grid-cols-1 md:grid-cols-3 gap-3">
                        <div>
                            <label class="block text-xs font-semibold text-gray-700 mb-1">Giá khởi điểm (VNĐ) <span class="text-red-500">*</span></label>
                            <!-- Đã bỏ step="1000" -->
                            <input type="number" id="startingPriceInput" name="startingPrice" min="0" placeholder="VD: 100000" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-orange-500 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-700 mb-1">Bước giá (VNĐ) <span class="text-red-500">*</span></label>
                            <input type="number" id="bidStepInput" name="bidStep" value="10000" min="1000" step="1000" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-orange-500 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-gray-700 mb-1">Thời gian kết thúc <span class="text-red-500">*</span></label>
                            <input type="datetime-local" id="endTimeInput" name="endTime" class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-orange-500 outline-none">
                        </div>
                    </div>
                </div>

                <h6 class="font-bold text-red-600 border-b border-gray-200 pb-2 mb-4 mt-6 text-sm uppercase tracking-wider"><i class="fas fa-image mr-1"></i> Ảnh & Mô tả</h6>
                <div class="mb-4 p-4 bg-gray-50 rounded-xl border border-gray-200">
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Ảnh bìa</label>
                    <div class="mb-3">
                        <label class="block text-xs text-gray-500 mb-1">Tải ảnh lên từ máy</label>
                        <input type="file" name="imageFile" accept="image/*" onchange="previewImage(event)" class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                    </div>
                    <div class="text-center text-xs text-gray-400 mb-2">--- HOẶC ---</div>
                    <div class="mb-3">
                        <label class="block text-xs text-gray-500 mb-1">Dán URL ảnh</label>
                        <input type="text" name="imageUrl" placeholder="https://..." class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none">
                    </div>
                    <div class="mt-2 text-center">
                        <img id="imagePreview" src="" alt="Preview" class="max-h-[150px] mx-auto rounded-lg border border-gray-200 hidden">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Mô tả sản phẩm</label>
                    <textarea name="description" rows="4" maxlength="5000" placeholder="Mô tả tình trạng thực tế..." class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:border-indigo-500 outline-none"></textarea>
                </div>

                <div class="bg-blue-50 text-blue-800 p-3 rounded-lg text-sm border border-blue-200">
                    <i class="fas fa-info-circle mr-1"></i> Bài đăng sẽ ở trạng thái <b>Chờ duyệt</b> cho đến khi Admin phê duyệt.
                </div>
            </form>
        </div>

        <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex justify-end gap-3 shrink-0">
            <button type="button" class="px-5 py-2 rounded-lg bg-white border border-gray-300 text-gray-700 font-bold hover:bg-gray-50 transition" onclick="document.getElementById('addProductModal').classList.add('hidden')">Hủy</button>
            <button type="submit" form="addProductForm" class="px-5 py-2 rounded-lg bg-red-600 text-white font-bold hover:bg-red-700 transition"><i class="fas fa-paper-plane mr-1"></i> Gửi duyệt</button>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script>
    function previewImage(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('imagePreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) { preview.src = e.target.result; preview.classList.remove('hidden'); }
            reader.readAsDataURL(file);
        } else { preview.src = ""; preview.classList.add('hidden'); }
    }

    function toggleAuctionFields() {
        var isAuction = document.getElementById("isAuction").checked;
        var normalFields = document.getElementById("normalPriceFields");
        var auctionFields = document.getElementById("auctionFields");

        var normalPrice = document.getElementById("normalPriceInput");
        var stock = document.getElementById("stockInput");

        var startPrice = document.getElementById("startingPriceInput");
        var bidStep = document.getElementById("bidStepInput");
        var endTime = document.getElementById("endTimeInput");

        if (isAuction) {
            normalFields.style.display = "none";
            normalPrice.required = false;
            stock.required = false;

            auctionFields.style.display = "grid";
            auctionFields.classList.remove("hidden");
            startPrice.required = true;
            bidStep.required = true;
            endTime.required = true;
        } else {
            normalFields.style.display = "grid";
            normalPrice.required = true;
            stock.required = true;

            auctionFields.style.display = "none";
            auctionFields.classList.add("hidden");
            startPrice.required = false;
            bidStep.required = false;
            endTime.required = false;
        }
    }
</script>
</body>
</html>