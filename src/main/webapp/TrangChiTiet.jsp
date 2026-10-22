<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${product.title}" default="Chi tiết sản phẩm" /> - MANGAZ</title>

    <!-- Tailwind CSS CDN & Font Awesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TrangChiTiet.css">
</head>
<body class="bg-[#fcfcfd] text-[#141b2b] font-sans">

<%@ include file="includes/header.jsp" %>

<!-- Fallback kiểm tra tồn kho -->
<c:set var="currentStock" value="${product.stockQuantity}" />
<div class="max-w-[1184px] mx-auto px-4 py-4">
    <!-- BREADCRUMB -->
    <nav class="flex items-center justify-between py-2 text-xs text-gray-500" aria-label="Breadcrumb">
        <ol class="flex items-center gap-2">
            <li>
                <a class="hover:text-indigo-600 flex items-center gap-1" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-house text-indigo-600"></i> Trang chủ
                </a>
            </li>
            <li>/</li>
            <li>
                <a class="hover:text-indigo-600" href="${pageContext.request.contextPath}/products">Manga</a>
            </li>
            <c:if test="${not empty product.series_name}">
                <li>/</li>
                <li>
                    <a class="hover:text-indigo-600" href="${pageContext.request.contextPath}/products?series=${product.series_name}">
                        <c:out value="${product.series_name}" />
                    </a>
                </li>
            </c:if>
            <li>/</li>
            <li class="font-semibold text-gray-900 truncate max-w-[280px]">
                <c:out value="${product.title}" />
            </li>
        </ol>
        <span class="bg-indigo-50 text-indigo-600 font-bold px-2.5 py-1 rounded-md text-[11px]">
            MÃ TIN: #MG-<c:out value="${product.id}" default="01" />
        </span>
    </nav>

    <!-- KHỐI CHÍNH: 1 ẢNH & THÔNG TIN ĐẶT MUA -->
    <div class="grid grid-cols-1 md:grid-cols-12 gap-8 mt-4">
        <!-- CỘT TRÁI: 1 ẢNH SẢN PHẨM -->
        <section class="md:col-span-7">
            <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm aspect-[4/3] flex items-center justify-center relative p-4 bg-[#f8faff]">
                <c:set var="productImg" value="${not empty product.image_url ? (product.image_url.startsWith('http') ? product.image_url : (product.image_url.startsWith('./') ? pageContext.request.contextPath.concat('/').concat(product.image_url.substring(2)) : pageContext.request.contextPath.concat('/').concat(product.image_url))) : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" />
                <img src="${productImg}" alt="${product.title}" class="max-h-full max-w-full object-contain drop-shadow-md">

                <div class="absolute bottom-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1.5 rounded-lg border border-gray-100 shadow-sm flex items-center gap-2 text-xs font-bold text-gray-800">
                    <i class="fa-solid fa-magnifying-glass-plus text-indigo-600"></i>
                    <span>Ảnh thực tế</span>
                </div>
            </div>
        </section>

        <!-- CỘT PHẢI: CHI TIẾT & FORM MUA HÀNG -->
        <section class="md:col-span-5 flex flex-col gap-4">
            <div>
                <div class="flex items-center gap-2 mb-2">
                    <c:choose>
                        <c:when test="${product.item_condition == 'NEW'}">
                            <span class="bg-emerald-50 text-emerald-700 border border-emerald-200 text-xs font-bold px-2 py-0.5 rounded">MỚI 100% (SEAL)</span>
                        </c:when>
                        <c:when test="${product.item_condition == 'LIKE_NEW'}">
                            <span class="bg-indigo-50 text-indigo-700 border border-indigo-200 text-xs font-bold px-2 py-0.5 rounded">LIKE NEW (SƯU TẦM)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="bg-amber-50 text-amber-700 border border-amber-200 text-xs font-bold px-2 py-0.5 rounded">ĐÃ QUA SỬ DỤNG</span>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${not empty product.edition}">
                        <span class="bg-gray-100 text-gray-700 text-xs font-bold px-2 py-0.5 rounded"><c:out value="${product.edition}" /></span>
                    </c:if>
                </div>

                <h1 class="text-2xl font-black text-gray-900 leading-snug">
                    <c:out value="${product.title}" />
                </h1>

                <div class="flex items-center gap-2 text-xs text-gray-500 mt-2">
                    <span>Tác giả: <strong class="text-gray-800"><c:out value="${not empty product.author ? product.author : 'Chưa cập nhật'}" /></strong></span>
                    <span>•</span>
                    <span>Tập: <strong class="text-gray-800"><c:out value="${not empty product.volume_number ? product.volume_number : '1'}" /></strong></span>
                </div>
            </div>

            <!-- HỒ SƠ NGƯỜI BÁN -->
            <div class="bg-white p-3.5 rounded-xl border border-gray-200 flex flex-col gap-3 shadow-sm">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-lg overflow-hidden bg-indigo-50 flex-shrink-0">
                        <img src="${not empty product.sellerAvatar ? product.sellerAvatar : pageContext.request.contextPath.concat('/Image/manga_01.jpg')}" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <div class="flex items-center gap-1.5">
                            <span class="font-bold text-sm text-gray-900"><c:out value="${not empty product.sellerName ? product.sellerName : 'Chủ Shop'}" /></span>
                            <i class="fa-solid fa-circle-check text-indigo-600 text-xs" title="Người bán uy tín"></i>
                        </div>
                        <p class="text-xs text-gray-400">Thành viên xác thực sàn MangaZ</p>
                    </div>
                </div>
                <div class="flex gap-2">
                    <a href="${pageContext.request.contextPath}/shop?id=${product.seller_id}" class="flex-1 py-2 text-center bg-gray-50 hover:bg-gray-100 text-gray-800 font-bold text-xs rounded-lg transition border border-gray-200">
                        <i class="fa-solid fa-store mr-1"></i> Xem Tủ Sách
                    </a>
                    <a href="${pageContext.request.contextPath}/chat?receiverId=${product.seller_id}&productId=${product.id}" class="flex-1 py-2 text-center bg-gray-50 hover:bg-gray-100 text-gray-800 font-bold text-xs rounded-lg transition border border-gray-200">
                        <i class="fa-solid fa-comment-dots mr-1"></i> Nhắn tin riêng
                    </a>
                </div>
            </div>

            <!-- KHỐI GIÁ & FORM MUA HÀNG (CHỈ THÊM GIỎ + WISHLIST) -->
            <div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm flex flex-col gap-4">
                <div>
                    <span class="text-[10px] font-bold text-gray-400 uppercase tracking-wider">GIÁ NIÊM YẾT CÔNG KHAI</span>
                    <div class="text-3xl font-black text-gray-900 mt-1 flex items-baseline gap-1">
                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" />
                        <span class="text-lg font-bold text-indigo-600">đ</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-xs mt-1">
                        <i class="fa-solid fa-box-archive text-gray-400 text-xs"></i>
                        <span class="text-gray-500">Tồn kho:</span>
                        <strong class="${currentStock > 0 ? 'text-emerald-600' : 'text-rose-600'} font-bold">
                            ${currentStock > 0 ? currentStock : 0} cuốn
                        </strong>
                    </div>
                </div>

                <!-- FORM ĐẶT HÀNG -->
                <form action="${pageContext.request.contextPath}/cart" method="post" class="flex flex-col gap-3 m-0">
                    <input type="hidden" name="productId" value="${product.id}">

                    <c:if test="${currentStock > 0}">
                        <div class="flex items-center gap-3">
                            <span class="text-xs font-bold text-gray-700 uppercase">Số lượng:</span>
                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden bg-white">
                                <button type="button" onclick="adjustQty(-1)" class="w-8 h-8 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition">-</button>
                                <input type="number" id="quantity" name="quantity" value="1" min="1" max="${currentStock}"
                                       class="w-12 h-8 text-center font-bold text-sm outline-none border-x border-gray-200">
                                <button type="button" onclick="adjustQty(1)" class="w-8 h-8 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition">+</button>
                            </div>
                        </div>

                        <!-- 2 NÚT DUY NHẤT: THÊM VÀO GIỎ & WISHLIST CẠNH NHAU -->
                        <div class="flex items-center gap-2.5 mt-1">
                            <button type="submit" name="action" value="add"
                                    class="flex-1 h-12 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl flex items-center justify-center gap-2 shadow-sm transition">
                                <i class="fa-solid fa-cart-plus text-base"></i>
                                <span class="text-sm">Thêm vào giỏ hàng</span>
                            </button>

                            <button type="submit" formaction="${pageContext.request.contextPath}/wishlist"
                                    class="h-12 w-12 flex-shrink-0 flex items-center justify-center rounded-xl border transition ${isFavorited ? 'bg-rose-50 border-rose-200 text-rose-600' : 'bg-gray-50 hover:bg-rose-50 border-gray-200 hover:border-rose-200 text-gray-500 hover:text-rose-500'}"
                                    title="${isFavorited ? 'Bỏ lưu khỏi kệ sách' : 'Lưu vào kệ sách'}">
                                <i class="${isFavorited ? 'fa-solid text-rose-500' : 'fa-regular'} fa-heart text-lg"></i>
                            </button>
                        </div>
                    </c:if>

                    <c:if test="${currentStock <= 0}">
                        <button class="w-full h-12 bg-gray-200 text-gray-500 font-bold rounded-xl cursor-not-allowed" type="button" disabled>
                            Ấn phẩm tạm hết hàng
                        </button>
                    </c:if>
                </form>

                <div class="text-[11px] text-gray-500 bg-gray-50 p-2.5 rounded-lg flex items-center gap-2 border border-gray-100">
                    <i class="fa-solid fa-shield-check text-indigo-600 text-sm"></i>
                    <span>100% Bảo hiểm Ký Quỹ Escrow - Đổi trả nếu sai mô tả</span>
                </div>
            </div>
        </section>
    </div>

    <!-- HỆ THỐNG TAB NỘI DUNG -->
    <div class="mt-10">
        <!-- 3 Nút Tab -->
        <div class="flex items-center gap-2 overflow-x-auto pb-1">
            <button id="btn-tab-specs" type="button" onclick="switchTab('tab-specs')"
                    class="tab-btn px-6 py-3 rounded-lg font-bold text-sm flex items-center gap-2 bg-[#4a4bf1] text-white shadow-sm transition">
                <i class="fa-solid fa-table-list"></i> Bảng Thông Số & Tình Trạng
            </button>
            <button id="btn-tab-desc" type="button" onclick="switchTab('tab-desc')"
                    class="tab-btn px-6 py-3 rounded-lg font-bold text-sm flex items-center gap-2 bg-[#f0f3fd] text-gray-600 hover:bg-gray-200 transition">
                <i class="fa-solid fa-pen-nib"></i> Ghi Chú Người Bán & Lưu Trữ
            </button>
            <button id="btn-tab-comments" type="button" onclick="switchTab('tab-comments')"
                    class="tab-btn px-6 py-3 rounded-lg font-bold text-sm flex items-center gap-2 bg-[#f0f3fd] text-gray-600 hover:bg-gray-200 transition">
                <i class="fa-solid fa-comments"></i> Hỏi Đáp & Công Khai
            </button>
        </div>

        <!-- TAB 1: BẢNG THÔNG SỐ (2 CỘT NỀN NHẠT ĐÚNG HÌNH MẪU) -->
        <div id="tab-specs" class="tab-panel mt-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Tác giả & Minh hoạ</span>
                    <span class="text-sm font-bold text-gray-900"><c:out value="${not empty product.author ? product.author : 'Chưa cập nhật'}" /></span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Thuộc bộ truyện (Series)</span>
                    <span class="text-sm font-bold text-gray-900"><c:out value="${not empty product.series_name ? product.series_name : 'Truyện đơn tập'}" /></span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Tập số thực tế</span>
                    <span class="text-sm font-bold text-gray-900">Tập <c:out value="${not empty product.volume_number ? product.volume_number : '1'}" /></span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Phiên bản phát hành</span>
                    <span class="text-sm font-bold text-gray-900"><c:out value="${not empty product.edition ? product.edition : 'Bản in gốc'}" /></span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Tình trạng ngoại quan</span>
                    <span class="text-sm font-bold text-[#4a4bf1]">
                        <c:choose>
                            <c:when test="${product.item_condition == 'NEW'}">Mới 100% (Nguyên Seal)</c:when>
                            <c:when test="${product.item_condition == 'LIKE_NEW'}">Like New 95% (Sưu tầm)</c:when>
                            <c:otherwise>Đã qua sử dụng (Còn tốt)</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Ngôn ngữ ấn bản</span>
                    <span class="text-sm font-bold text-gray-900"><c:out value="${not empty product.language ? product.language : 'Tiếng Việt'}" /></span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Số lượng sẵn có</span>
                    <span class="text-sm font-bold text-gray-900">${currentStock} cuốn</span>
                </div>
                <div class="bg-[#f4f7fe] rounded-lg px-5 py-3.5 flex items-center justify-between border border-[#edf2fd]">
                    <span class="text-sm text-gray-500 font-medium">Mã định danh hệ thống</span>
                    <span class="text-sm font-bold text-gray-900">#MG-00<c:out value="${product.id}" default="01" /></span>
                </div>
            </div>
        </div>

        <!-- TAB 2: GHI CHÚ MÔ TẢ -->
        <div id="tab-desc" class="tab-panel mt-4 hidden">
            <div class="bg-[#f4f7fe] rounded-xl p-6 border border-[#edf2fd]">
                <h3 class="text-sm font-bold text-gray-900 mb-2">Tóm tắt & Chi tiết ấn phẩm từ người bán:</h3>
                <p class="text-sm text-gray-700 leading-relaxed whitespace-pre-line">
                    <c:out value="${product.description}" default="Người bán chưa cung cấp thêm ghi chú mô tả cho ấn phẩm này." />
                </p>
            </div>
        </div>

        <!-- TAB 3: HỎI ĐÁP BÌNH LUẬN -->
        <div id="tab-comments" class="tab-panel mt-4 hidden">
            <div class="bg-white rounded-xl p-6 border border-gray-200">
                <form action="${pageContext.request.contextPath}/comment" method="post" class="mb-6">
                    <input type="hidden" name="productId" value="${product.id}">
                    <textarea name="content" rows="3" required placeholder="Đặt câu hỏi công khai cho người bán về tình trạng cuốn sách này..."
                              class="w-full border border-gray-300 rounded-lg p-3 text-sm focus:outline-indigo-600"></textarea>
                    <div class="flex justify-end mt-2">
                        <button type="submit" class="bg-indigo-600 text-white font-bold px-4 py-2 rounded-lg text-xs hover:bg-indigo-700 transition">
                            Gửi câu hỏi
                        </button>
                    </div>
                </form>

                <c:choose>
                    <c:when test="${not empty comments}">
                        <div class="space-y-3">
                            <c:forEach var="c" items="${comments}">
                                <div class="p-3 bg-gray-50 rounded-lg border border-gray-100">
                                    <div class="flex items-center justify-between mb-1">
                                        <span class="font-bold text-xs text-gray-900"><c:out value="${c.userName}" default="Collector" /></span>
                                        <span class="text-[11px] text-gray-400"><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                                    </div>
                                    <p class="text-xs text-gray-700"><c:out value="${c.content}" /></p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-xs text-gray-400 italic text-center py-4">Chưa có câu hỏi nào. Hãy là người đầu tiên thảo luận về cuốn manga này!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>

<!-- SCRIPT CHUYỂN TAB VÀ ĐIỀU CHỈNH SỐ LƯỢNG -->
<script>
    function adjustQty(amount) {
        const input = document.getElementById('quantity');
        if (!input) return;
        let val = parseInt(input.value) || 1;
        const max = parseInt(input.getAttribute('max')) || 99;
        val += amount;
        if (val < 1) val = 1;
        if (val > max) val = max;
        input.value = val;
    }

    function switchTab(tabId) {
        document.querySelectorAll('.tab-panel').forEach(panel => {
            panel.classList.add('hidden');
        });
        const target = document.getElementById(tabId);
        if (target) target.classList.remove('hidden');

        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.className = 'tab-btn px-6 py-3 rounded-lg font-bold text-sm flex items-center gap-2 bg-[#f0f3fd] text-gray-600 hover:bg-gray-200 transition';
        });
        const activeBtn = document.getElementById('btn-' + tabId);
        if (activeBtn) {
            activeBtn.className = 'tab-btn px-6 py-3 rounded-lg font-bold text-sm flex items-center gap-2 bg-[#4a4bf1] text-white shadow-sm transition';
        }
    }
</script>

</body>
</html>