<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="tracking" value="${history.tracking}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Lịch sử & Theo dõi đơn hàng - MangaZ</title>
    <link rel="stylesheet" href="${ctx}/css/History.css">
</head>
<body data-page="home">
<main class="wrap od">
    <h1>Lịch sử & Theo dõi đơn hàng</h1>
    <p class="sub">Xem lại các đơn hàng trước đây và cập nhật hành trình giao hàng mới nhất.</p>

    <c:if test="${not empty errorMessage}">
        <p class="err"><c:out value="${errorMessage}"/></p>
    </c:if>

    <%-- Chỉ hiện khi người dùng có đơn đang vận chuyển (dữ liệu từ DAO) --%>
    <c:if test="${tracking != null}">
        <section class="card trk">
            <div class="top">
                <div>
                    <div class="live">ĐANG GIAO VẬN</div>
                    <h3>Đơn hàng <c:out value="${tracking.orderCode}"/></h3></div>
                <c:if test="${not empty tracking.estimatedDeliveryText}">
                    <div class="eta">Dự kiến giao hàng<b>${tracking.estimatedDeliveryText}</b></div>
                </c:if>
            </div>
            <div class="stp" id="stp">
                <c:forEach var="s" items="${tracking.steps}" varStatus="vs">
                    <div class="st ${vs.index < tracking.currentStep ? 'done' : (vs.index == tracking.currentStep ? 'cur' : '')}">
                        <i></i>
                        <b><c:out value="${s.label}"/></b>
                        <c:out value="${s.timeText}"/>
                    </div>
                </c:forEach>
            </div>
            <c:if test="${not empty tracking.shippingAddress}">
                <div class="addr">📍 <c:out value="${tracking.shippingAddress}"/></div>
            </c:if>
        </section>
    </c:if>

    <section class="card hist">
        <div class="hh">
            <div><h3>Lịch sử đơn hàng</h3><small id="cnt">${history.orders.size()} đơn hàng được tìm thấy</small></div>
            <form class="ctl" id="histForm" method="get" action="${ctx}/order-history">
                <input id="q" name="q" placeholder="Nhập mã đơn…" value="<c:out value='${history.keyword}'/>">
                <select id="f" name="status">
                    <option value="">Tất cả đơn hàng</option>
                    <option value="ship" ${history.statusFilter == 'ship' ? 'selected' : ''}>Đang vận chuyển</option>
                    <option value="done" ${history.statusFilter == 'done' ? 'selected' : ''}>Hoàn tất</option>
                    <option value="cancel" ${history.statusFilter == 'cancel' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </form>
        </div>
        <table>
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Ngày đặt</th>
                <th class="">Tổng tiền</th>
                <th>Trạng thái</th>
                <th class="r">Thao tác</th>
            </tr>
            </thead>
            <tbody id="tb">
            <c:forEach var="o" items="${history.orders}">
                <tr>
                    <td><b><c:out value="${o.orderCode}"/></b></td>
                    <td style="color:var(--mute)">${o.orderDateText}</td>
                    <td><b><c:choose>
                        <c:when test="${o.totalAmount != null}"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> ₫</c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose></b></td>
                    <td><span class="badge ${o.badgeClass}"><c:out value="${o.statusLabel}"/></span></td>
                    <td class="r"><button type="button" class="view">Xem chi tiết →</button></td>
                </tr>
            </c:forEach>
            <c:if test="${empty history.orders}">
                <tr>
                    <td colspan="5" class="empty">
                        <c:choose>
                            <c:when test="${not empty history.keyword || not empty history.statusFilter}">Không có đơn hàng phù hợp.</c:when>
                            <c:otherwise>Chưa có đơn hàng nào.</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </section>
</main>
<script src="${ctx}/js/history.js"></script>
</body>
</html>
