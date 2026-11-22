<!-- KHỐI GIÁ & FORM MUA HÀNG / ĐẤU GIÁ -->
<div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm flex flex-col gap-4">
    <c:choose>
        <%-- 1. NẾU LÀ SẢN PHẨM ĐẤU GIÁ (Check biến auction) --%>
        <c:when test="${not empty auction}">
            <div class="bg-orange-50 border border-orange-200 rounded-xl p-4">
                <div class="flex justify-between items-center mb-3">
                    <h3 class="text-base font-bold text-orange-800"><i class="fa-solid fa-gavel"></i> Phiên Đấu Giá</h3>
                    <span class="px-2 py-1 rounded text-xs font-bold ${auction.status == 'ONGOING' ? 'bg-green-100 text-green-700' : 'bg-gray-200 text-gray-700'}">${auction.status}</span>
                </div>

                <div class="grid grid-cols-2 gap-2 mb-3 text-sm">
                    <div>
                        <p class="text-gray-500 text-xs">Giá khởi điểm (Cọc 10%):</p>
                        <p class="font-bold"><fmt:formatNumber value="${auction.startingPrice}" pattern="#,##0"/> đ</p>
                    </div>
                    <div>
                        <p class="text-gray-500 text-xs">Bước giá:</p>
                        <p class="font-bold"><fmt:formatNumber value="${auction.bidStep}" pattern="#,##0"/> đ</p>
                    </div>
                </div>

                <div class="bg-white p-3 rounded-lg border border-orange-100 text-center mb-3">
                    <p class="text-gray-500 text-xs">Giá cao nhất hiện tại:</p>
                    <p class="text-2xl font-black text-red-600">
                        <fmt:formatNumber value="${auction.currentHighestPrice > 0 ? auction.currentHighestPrice : auction.startingPrice}" pattern="#,##0"/> đ
                    </p>
                    <p class="text-xs font-semibold text-orange-600 mt-1">
                        Kết thúc sau: <span id="auction-timer" data-end="${auction.endTime}">Đang tính...</span>
                    </p>
                </div>

                <c:if test="${auction.status == 'ONGOING'}">
                    <form action="${pageContext.request.contextPath}/place-bid" method="POST" class="flex flex-col gap-2">
                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" name="auctionId" value="${auction.id}">
                        <input type="number" name="bidAmount" required
                               min="${auction.currentHighestPrice > 0 ? auction.currentHighestPrice + auction.bidStep : auction.startingPrice}"
                               step="${auction.bidStep}"
                               placeholder="Nhập giá bạn muốn đặt (VNĐ)..."
                               class="border border-gray-300 rounded-lg px-3 py-2 text-sm outline-none focus:border-orange-500">
                        <button type="submit" class="bg-orange-600 text-white px-4 py-2 rounded-lg font-bold hover:bg-orange-700 transition w-full text-sm">
                            Đặt giá ngay
                        </button>
                    </form>
                </c:if>
            </div>

            <c:if test="${not empty bids}">
                <div class="mt-2 border-t pt-3">
                    <h4 class="font-bold text-gray-800 text-sm mb-2">Lịch sử đặt giá (${fn:length(bids)})</h4>
                    <ul class="space-y-2 max-h-32 overflow-y-auto pr-1">
                        <c:forEach var="b" items="${bids}">
                            <li class="flex justify-between items-center bg-gray-50 p-2 rounded text-xs border border-gray-100">
                                <span class="font-semibold text-gray-700">${b.userName}</span>
                                <span class="text-green-600 font-bold"><fmt:formatNumber value="${b.bidAmount}" pattern="#,##0"/> đ</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    var timerEl = document.getElementById("auction-timer");
                    if(!timerEl) return;
                    var endStr = timerEl.getAttribute("data-end");
                    if(!endStr) return;
                    var endTime = new Date(endStr.replace(" ", "T")).getTime();
                    var x = setInterval(function() {
                        var distance = endTime - new Date().getTime();
                        if (distance < 0) {
                            clearInterval(x);
                            timerEl.innerHTML = "ĐÃ KẾT THÚC";
                            timerEl.classList.add("text-red-600");
                            return;
                        }
                        var d = Math.floor(distance / (1000 * 60 * 60 * 24));
                        var h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        var m = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                        var s = Math.floor((distance % (1000 * 60)) / 1000);
                        timerEl.innerHTML = (d > 0 ? d + " ngày " : "") + h + "h " + m + "m " + s + "s";
                    }, 1000);
                });
            </script>
        </c:when>

        <%-- 2. NẾU LÀ SẢN PHẨM MUA BÌNH THƯỜNG (CODE CŨ CỦA BẠN) --%>
        <c:otherwise>
            <div>
                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-wider">GIÁ NIÊM YẾT CÔNG KHAI</span>
                <div class="text-3xl font-black text-gray-900 mt-1 flex items-baseline gap-1">
                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" />
                    <span class="text-lg font-bold text-indigo-600">đ</span>
                </div>
                <div class="flex items-center gap-1.5 text-xs mt-1">
                    <i class="fa-solid fa-box-archive text-gray-400 text-xs"></i>
                    <span class="text-gray-500">Tồn kho:</span>
                    <strong class="${currentStock > 0 ? 'text-emerald-600' : 'text-rose-600'} font-bold">${currentStock > 0 ? currentStock : 0} cuốn</strong>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/cart" method="post" class="flex flex-col gap-3 m-0">
                <input type="hidden" name="productId" value="${product.id}">
                <c:choose>
                    <c:when test="${currentStock > 0}">
                        <div class="flex items-center gap-3">
                            <span class="text-xs font-bold text-gray-700 uppercase">Số lượng:</span>
                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden bg-white">
                                <button type="button" onclick="adjustQty(-1)" class="w-8 h-8 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition">-</button>
                                <input type="number" id="quantity" name="quantity" value="1" min="1" max="${currentStock}" class="w-12 h-8 text-center font-bold text-sm outline-none border-x border-gray-200">
                                <button type="button" onclick="adjustQty(1)" class="w-8 h-8 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 font-bold transition">+</button>
                            </div>
                        </div>
                        <div class="flex items-center gap-2.5 mt-1">
                            <button type="submit" name="action" value="add" class="flex-1 h-12 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl flex items-center justify-center gap-2 shadow-sm transition">
                                <i class="fa-solid fa-cart-plus text-base"></i><span class="text-sm">Thêm vào giỏ hàng</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/wishlist?action=add&productId=${product.id}" class="h-12 w-12 flex-shrink-0 flex items-center justify-center rounded-xl border transition ${not empty sessionScope.wishlist[product.id] ? 'bg-rose-50 border-rose-200 text-rose-600' : 'bg-gray-50 hover:bg-rose-50 border-gray-200 hover:border-rose-200 text-gray-500 hover:text-rose-500'}">
                                <i class="${not empty sessionScope.wishlist[product.id] ? 'fa-solid text-rose-500' : 'fa-regular'} fa-heart text-lg"></i>
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex items-center gap-2.5 mt-1">
                            <button class="flex-1 h-12 bg-gray-200 text-gray-500 font-bold rounded-xl cursor-not-allowed" type="button" disabled>Ấn phẩm tạm hết hàng</button>
                            <a href="${pageContext.request.contextPath}/wishlist?action=add&productId=${product.id}" class="h-12 w-12 flex-shrink-0 flex items-center justify-center rounded-xl border transition ${not empty sessionScope.wishlist[product.id] ? 'bg-rose-50 border-rose-200 text-rose-600' : 'bg-gray-50 hover:bg-rose-50 border-gray-200 hover:border-rose-200 text-gray-500 hover:text-rose-500'}">
                                <i class="${not empty sessionScope.wishlist[product.id] ? 'fa-solid text-rose-500' : 'fa-regular'} fa-heart text-lg"></i>
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </form>
        </c:otherwise>
    </c:choose>

    <div class="text-[11px] text-gray-500 bg-gray-50 p-2.5 rounded-lg flex items-center gap-2 border border-gray-100 mt-2">
        <i class="fa-solid fa-shield-check text-indigo-600 text-sm"></i>
        <span>100% Bảo hiểm Ký Quỹ Escrow - Đổi trả nếu sai mô tả</span>
    </div>
</div>