<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="stats" value="${dash.stats}"/>
<%-- Fragment: tab Dashboard (bỏ sidebar riêng, dùng sidebar chung của admin-layout) --%>
<%-- Form rỗng: các ô lọc ngày / trạng thái bên dưới gắn vào form này bằng thuộc tính form="dashForm" --%>
<form id="dashForm" method="get" action="${ctx}/admin/manage">
    <input type="hidden" name="tab" value="dashboard">
</form>

<div class="tab-dashboard">
<div class="dash">
    <main>
        <div class="mh">
            <div><h1 style="font-size:19px">Trung tâm Quản trị & Thống kê MangaVault</h1>
                <p class="sub">Giám sát dòng ký quỹ Escrow, tiến độ thẩm định Grab CGC và phân đối giá trị truyện
                    tranh.</p></div>
            <div>
                <div class="rg" id="rg">
                    <button type="button" data-d="7" class="${dash.rangeDays == 7 ? 'on' : ''}">7 ngày</button>
                    <button type="button" data-d="30" class="${dash.rangeDays == 30 ? 'on' : ''}">30 ngày</button>
                    <button type="button" data-d="90" class="${dash.rangeDays == 90 ? 'on' : ''}">Quý này</button>
                </div>
            </div>
        </div>
        <button type="button" class="chk" disabled title="Chưa hỗ trợ">🛡 Báo cáo kiểm toán Escrow</button>

        <%-- KPI: giá trị null = chưa có dữ liệu --%>
        <div class="kpi" id="kpi">
            <div class="card">
                <small>Tổng GMV Ký quỹ</small>
                <b><c:choose>
                    <c:when test="${stats.totalEscrowValue != null}"><fmt:formatNumber value="${stats.totalEscrowValue}" pattern="#,##0"/> ₫</c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose></b>
                <span><c:choose>
                    <c:when test="${stats.escrowChangePercent != null}">
                        ${stats.escrowChangePercent >= 0 ? '▲ +' : '▼ '}<fmt:formatNumber value="${stats.escrowChangePercent}" maxFractionDigits="1"/>% so với kỳ trước
                    </c:when>
                    <c:otherwise>Chưa có dữ liệu</c:otherwise>
                </c:choose></span>
            </div>
            <div class="card">
                <small>Đơn đấu giá thành công</small>
                <b><c:choose>
                    <c:when test="${stats.successfulOrders != null}"><fmt:formatNumber value="${stats.successfulOrders}" pattern="#,##0"/> phiên</c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose></b>
                <span><c:choose>
                    <c:when test="${stats.successRatePercent != null}">Tỷ lệ chốt <fmt:formatNumber value="${stats.successRatePercent}" maxFractionDigits="1"/>%</c:when>
                    <c:otherwise>Chưa có dữ liệu</c:otherwise>
                </c:choose></span>
            </div>
            <div class="card">
                <small>Truyện hiếm chờ thẩm định</small>
                <b><c:choose>
                    <c:when test="${stats.pendingAppraisals != null}"><fmt:formatNumber value="${stats.pendingAppraisals}" pattern="#,##0"/> hồ sơ</c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose></b>
                <span><c:if test="${stats.pendingAppraisals == null}">Chưa có dữ liệu</c:if></span>
            </div>
            <div class="card">
                <small>Collector hoạt động</small>
                <b><c:choose>
                    <c:when test="${stats.activeCollectors != null}"><fmt:formatNumber value="${stats.activeCollectors}" pattern="#,##0"/> người</c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose></b>
                <span><c:choose>
                    <c:when test="${stats.newCollectorsToday != null}">▲ +<fmt:formatNumber value="${stats.newCollectorsToday}" pattern="#,##0"/> mới hôm nay</c:when>
                    <c:when test="${stats.activeCollectors == null}">Chưa có dữ liệu</c:when>
                </c:choose></span>
            </div>
        </div>

        <div class="ch">
            <section class="card"><h3>Thống kê giá trị ký quỹ (biểu đồ cột)</h3>
                <p class="sub">Chọn khoảng thời gian cần xem: từ ngày — đến ngày.</p>
                <div class="flt">Từ ngày <input type="date" id="from" name="from" form="dashForm" value="${dash.from}">
                    Đến ngày <input type="date" id="to" name="to" form="dashForm" value="${dash.to}">
                    <button type="submit" id="ap" form="dashForm">Áp dụng</button>
                    <span id="msg" class="err"><c:out value="${dash.errorMessage}"/></span></div>
                <c:choose>
                    <c:when test="${empty dash.escrowByDay}">
                        <div class="empty">Chưa có dữ liệu ký quỹ trong khoảng thời gian này.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="cv"><canvas id="bar"></canvas></div>
                    </c:otherwise>
                </c:choose>
            </section>
            <section class="card"><h3>Tỷ trọng danh mục truyện (biểu đồ tròn)</h3>
                <p class="sub">Phân bổ giá trị theo từng Master Catalog.</p>
                <c:choose>
                    <c:when test="${empty dash.categoryShares}">
                        <div class="empty">Chưa có dữ liệu danh mục.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="pie">
                            <div class="cv"><canvas id="pie"></canvas></div>
                            <div class="lg" id="lg"></div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>

        <c:if test="${stats.disputeCount != null && stats.disputeCount > 0}">
            <div class="alert">
                <div><b>⚠ Cảnh báo Rủi ro Trung gian: ${stats.disputeCount} trường hợp mâu thuẫn cần xác thực thủ công</b>
                    <p>Hệ thống ghi nhận các giao dịch đang tranh chấp cần can thiệp.</p></div>
                <div>
                    <a class="p" href="${ctx}/admin/manage?tab=dashboard&status=dispute">Xem giao dịch tranh chấp</a>
                </div>
            </div>
        </c:if>

        <section class="card tx">
            <div class="hh">
                <div><h3>Giao dịch Đấu giá & Ký quỹ Gần nhất</h3>
                    <p class="sub">Danh sách theo dõi các phiên đấu giá và ký quỹ</p></div>
                <div class="ctl">
                    <select id="txStatus" name="status" form="dashForm" title="Bộ lọc trạng thái">
                        <option value="">⇅ Tất cả trạng thái</option>
                        <option value="released" ${dash.statusFilter == 'released' ? 'selected' : ''}>Đã giao & Giải ngân</option>
                        <option value="holding" ${dash.statusFilter == 'holding' ? 'selected' : ''}>Đang giữ ký quỹ</option>
                        <option value="reviewing" ${dash.statusFilter == 'reviewing' ? 'selected' : ''}>Đang kiểm duyệt phát hành</option>
                        <option value="dispute" ${dash.statusFilter == 'dispute' ? 'selected' : ''}>Tranh chấp</option>
                    </select>
                </div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>Mã ký quỹ</th>
                    <th>Tên bộ truyện quý</th>
                    <th>Người mua</th>
                    <th>Người gán</th>
                    <th>Số tiền</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody id="tx">
                <c:forEach var="t" items="${dash.transactions}">
                    <tr>
                        <td><b><c:out value="${t.escrowCode}"/></b></td>
                        <td class="tt"><c:out value="${t.title}"/>
                            <small><c:out value="${t.subtitle}"/></small></td>
                        <td><c:out value="${t.buyer}"/></td>
                        <td><c:out value="${t.seller}"/></td>
                        <td><b><c:choose>
                            <c:when test="${t.amount != null}"><fmt:formatNumber value="${t.amount}" pattern="#,##0"/> ₫</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose></b></td>
                        <td><span class="badge ${t.badgeClass}"><c:out value="${t.statusLabel}"/></span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty dash.transactions}">
                    <tr><td colspan="6" class="empty">Chưa có giao dịch.</td></tr>
                </c:if>
                </tbody>
            </table>
            <div class="pg"><span>Hiển thị <fmt:formatNumber value="${dash.transactions.size()}" pattern="#,##0"/> trên <fmt:formatNumber value="${dash.totalTransactions}" pattern="#,##0"/> giao dịch gần nhất</span>
                <c:if test="${dash.totalTransactions > 0}">
                    <c:url var="pgBase" value="/admin/manage">
                        <c:param name="tab" value="dashboard"/>
                        <c:param name="from" value="${dash.from}"/>
                        <c:param name="to" value="${dash.to}"/>
                        <c:if test="${not empty dash.statusFilter}"><c:param name="status" value="${dash.statusFilter}"/></c:if>
                    </c:url>
                    <div>
                        <c:if test="${dash.page > 1}"><a class="pgb" href="${pgBase}&page=${dash.page - 1}">‹</a></c:if>
                        <c:forEach var="p" items="${dash.pageNumbers}">
                            <a class="pgb ${p == dash.page ? 'on' : ''}" href="${pgBase}&page=${p}">${p}</a>
                        </c:forEach>
                        <c:if test="${dash.page < dash.totalPages}"><a class="pgb" href="${pgBase}&page=${dash.page + 1}">›</a></c:if>
                    </div>
                </c:if>
            </div>
        </section>
    </main>
</div>
</div>
<%-- Dữ liệu biểu đồ do DashboardServlet tạo từ Service/DAO (rỗng nếu chưa có) --%>
<script type="application/json" id="dash-data">${chartJson}</script>
