// Chỉ xử lý tương tác giao diện. Dữ liệu đơn hàng do Backend (PurchaseHistoryServlet -> Service -> DAO)
// render sẵn trong JSP; việc tìm kiếm/lọc được gửi lên server bằng GET.
(function () {
    const form = document.getElementById("histForm");
    if (!form) return;

    // Đổi bộ lọc trạng thái -> tải lại danh sách từ server.
    const status = document.getElementById("f");
    if (status) status.addEventListener("change", () => form.submit());

    // Nhấn Enter trong ô mã đơn sẽ submit form (hành vi mặc định của form GET).
    // Đặt con trỏ cuối ô tìm kiếm khi trang tải lại với từ khóa.
    const q = document.getElementById("q");
    if (q && q.value) {
        q.focus();
        q.setSelectionRange(q.value.length, q.value.length);
    }
})();
