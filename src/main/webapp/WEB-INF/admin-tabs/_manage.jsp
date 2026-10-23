<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- Fragment: tab users / products / orders (nội dung cũ của manage.jsp, bỏ header + sidebar) --%>
<h1 class="text-2xl font-bold text-gray-900 mb-6">
    <c:if test="${activeTab == 'users'}">Danh sách Người dùng</c:if>
    <c:if test="${activeTab == 'products'}">Danh sách Sản phẩm Toàn sàn</c:if>
    <c:if test="${activeTab == 'orders'}">Danh sách Đơn hàng Toàn sàn</c:if>
</h1>

<%-- Thông báo thao tác --%>
<c:if test="${not empty sessionScope.message}">
    <div class="mb-4 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-lg text-sm font-semibold flex justify-between items-center">
        <span>✓ ${sessionScope.message}</span>
        <c:remove var="message" scope="session" />
    </div>
</c:if>

<div class="border border-gray-200 rounded-xl overflow-hidden">
    <table class="w-full text-left text-sm">
        <thead class="bg-gray-50 text-gray-600 font-semibold border-b border-gray-200 text-xs uppercase">
        <tr>
            <th class="px-6 py-4">ID</th>
            <th class="px-6 py-4">
                <c:choose>
                    <c:when test="${activeTab == 'users'}">Tên / Email</c:when>
                    <c:when test="${activeTab == 'products'}">Tên truyện / Người đăng</c:when>
                    <c:otherwise>Sản phẩm / Người Mua & Bán</c:otherwise>
                </c:choose>
            </th>
            <th class="px-6 py-4">
                <c:choose>
                    <c:when test="${activeTab == 'users'}">Vai trò</c:when>
                    <c:otherwise>Giá trị</c:otherwise>
                </c:choose>
            </th>
            <th class="px-6 py-4">Trạng thái</th>
            <th class="px-6 py-4 text-center">Thao tác</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">

        <%-- TAB: USERS --%>
        <c:if test="${activeTab == 'users'}">
            <c:forEach var="u" items="${userList}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-900">#USR-${u.id}</td>
                    <td class="px-6 py-4">
                        <p class="font-bold text-gray-900">${u.username}</p>
                        <p class="text-xs text-gray-500">${u.email}</p>
                    </td>
                    <td class="px-6 py-4 font-medium">${u.role}</td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 ${u.status == 'ACTIVE' ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-red-50 text-red-700 border-red-200'} border rounded text-xs font-bold">
                                ${u.status}
                        </span>
                    </td>
                    <td class="px-6 py-4 text-center space-x-4">
                        <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline">
                            <input type="hidden" name="action" value="toggleUserStatus">
                            <input type="hidden" name="tab" value="users">
                            <input type="hidden" name="userId" value="${u.id}">
                            <button type="submit" class="text-indigo-500 hover:text-indigo-800 transition-colors" title="${u.status == 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}">
                                <i class="fas ${u.status == 'ACTIVE' ? 'fa-lock' : 'fa-unlock'} text-lg"></i>
                            </button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa người dùng này?');">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="tab" value="users">
                            <input type="hidden" name="userId" value="${u.id}">
                            <button type="submit" class="text-red-500 hover:text-red-800 transition-colors" title="Xóa tài khoản">
                                <i class="fas fa-trash-alt text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

        <%-- TAB: PRODUCTS --%>
        <c:if test="${activeTab == 'products'}">
            <c:forEach var="p" items="${productList}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-900">#PRD-${p.id}</td>
                    <td class="px-6 py-4">
                        <p class="font-bold text-gray-900">${p.title}</p>
                        <p class="text-xs text-gray-500">Seller: ${p.sellerName}</p>
                    </td>
                    <td class="px-6 py-4 font-bold text-indigo-700">
                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ"/>
                    </td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 bg-blue-50 text-blue-700 border border-blue-200 rounded text-xs font-bold">${p.status}</span>
                    </td>
                    <td class="px-6 py-4 text-center">
                        <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này khỏi sàn?');">
                            <input type="hidden" name="action" value="deleteProduct">
                            <input type="hidden" name="tab" value="products">
                            <input type="hidden" name="productId" value="${p.id}">
                            <button type="submit" class="text-red-500 hover:text-red-800 transition-colors" title="Xóa sản phẩm">
                                <i class="fas fa-trash-alt text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

        <%-- TAB: ORDERS --%>
        <c:if test="${activeTab == 'orders'}">
            <c:forEach var="o" items="${orderList}">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-900">#ORD-${o.id}</td>
                    <td class="px-6 py-4">
                        <p class="font-bold text-gray-900">${o.productTitle}</p>
                        <p class="text-xs text-gray-500">Mua: ${o.buyerName} | Bán: ${o.sellerName}</p>
                    </td>
                    <td class="px-6 py-4 font-bold text-indigo-700">
                        <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/>
                    </td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 ${o.status == 'COMPLETED' ? 'bg-green-50 text-green-700 border-green-200' : (o.status == 'CANCELLED' ? 'bg-red-50 text-red-700 border-red-200' : 'bg-orange-50 text-orange-700 border-orange-200')} border rounded text-xs font-bold">
                                ${o.status}
                        </span>
                    </td>
                    <td class="px-6 py-4 text-center">
                        <form action="${pageContext.request.contextPath}/admin/manage" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                            <input type="hidden" name="action" value="cancelOrder">
                            <input type="hidden" name="tab" value="orders">
                            <input type="hidden" name="orderId" value="${o.id}">
                            <button type="submit" class="text-red-500 hover:text-red-800 transition-colors ${o.status == 'CANCELLED' || o.status == 'COMPLETED' ? 'opacity-50 cursor-not-allowed' : ''}"
                                    title="Hủy đơn hàng"
                                ${o.status == 'CANCELLED' || o.status == 'COMPLETED' ? 'disabled' : ''}>
                                <i class="fas fa-times-circle text-xl"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

        </tbody>
    </table>
</div>
