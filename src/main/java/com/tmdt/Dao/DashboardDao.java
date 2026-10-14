package com.tmdt.Dao;

import com.tmdt.Model.DashboardCategoryShare;
import com.tmdt.Model.DashboardChartPoint;
import com.tmdt.Model.DashboardStats;
import com.tmdt.Model.DashboardTransaction;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho Dashboard (Admin). Viết theo mẫu UserDao: extends BaseDao + JDBI ({@code get().withHandle(...)}).
 *
 * ============================ KHUNG CẦN HOÀN THIỆN ============================
 * Hiện CHƯA có database cho Dashboard nên các hằng SQL_* bên dưới để TRỐNG.
 * Khi SQL trống, method trả về kết quả rỗng (KHÔNG có dữ liệu giả) và giao diện hiển thị trạng thái trống.
 *
 * Khi có database, bạn chỉ cần:
 *   1. Điền câu SQL vào các hằng SQL_*  (tên bảng, tên cột, JOIN, điều kiện...).
 *   2. Đặt ALIAS cột trong SELECT đúng bằng tên thuộc tính của DTO (xem "Cột trả về") -
 *      JDBI mapToBean sẽ tự ánh xạ, không cần sửa code Java bên dưới.
 *   3. Với trạng thái giao dịch: SQL phải trả cột statusCode thuộc {released, holding, reviewing, dispute}
 *      và statusLabel (chữ hiển thị) - có thể dùng CASE WHEN để quy đổi từ giá trị trong DB.
 * ==============================================================================
 */
public class DashboardDao extends BaseDao {

    // ---------------------------------------------------------------------
    // TODO(DB) 1/5 - Thẻ KPI. Tham số: :from, :to (DATE).
    // Cột trả về (1 dòng) -> DashboardStats:
    //   totalEscrowValue, escrowChangePercent, successfulOrders, successRatePercent,
    //   pendingAppraisals, activeCollectors, newCollectorsToday, disputeCount
    // Cột nào chưa tính được thì có thể bỏ khỏi SELECT (giá trị sẽ là null -> UI hiện "Chưa có dữ liệu").
    // ---------------------------------------------------------------------
    private static final String SQL_STATS = "";

    // ---------------------------------------------------------------------
    // TODO(DB) 2/5 - Biểu đồ cột: giá trị ký quỹ theo NGÀY. Tham số: :from, :to.
    // Cột trả về (nhiều dòng) -> DashboardChartPoint: day (DATE), value (số tiền).
    // Nên ORDER BY day ASC. Ngày không có giao dịch có thể bỏ qua.
    // ---------------------------------------------------------------------
    private static final String SQL_ESCROW_BY_DAY = "";

    // ---------------------------------------------------------------------
    // TODO(DB) 3/5 - Biểu đồ tròn: giá trị theo DANH MỤC. Tham số: :from, :to.
    // Cột trả về (nhiều dòng) -> DashboardCategoryShare: name, value.
    // (percent KHÔNG cần trả về, DashboardService tự tính.)
    // ---------------------------------------------------------------------
    private static final String SQL_CATEGORY_SHARE = "";

    // ---------------------------------------------------------------------
    // TODO(DB) 4/5 - Bảng giao dịch gần nhất (phân trang + lọc trạng thái).
    // Tham số: :status (rỗng = tất cả; nếu khác rỗng hãy lọc theo statusCode đã quy đổi),
    //          :limit, :offset.
    // Cột trả về -> DashboardTransaction: escrowCode, title, subtitle, buyer, seller,
    //          amount, statusCode, statusLabel.  ORDER BY thời điểm giao dịch DESC.
    // ---------------------------------------------------------------------
    private static final String SQL_RECENT_TRANSACTIONS = "";

    // ---------------------------------------------------------------------
    // TODO(DB) 5/5 - Đếm tổng số giao dịch (cùng điều kiện lọc với SQL_RECENT_TRANSACTIONS).
    // Tham số: :status. Trả về 1 số nguyên.
    // ---------------------------------------------------------------------
    private static final String SQL_COUNT_TRANSACTIONS = "";

    private static boolean notConfigured(String sql) {
        return sql == null || sql.isBlank();
    }

    /** Số liệu KPI trong khoảng [from, to]. Chưa cấu hình SQL -> DashboardStats rỗng (toàn null). */
    public DashboardStats getStats(LocalDate from, LocalDate to) {
        if (notConfigured(SQL_STATS)) {
            return new DashboardStats();
        }
        return get().withHandle(h -> h.createQuery(SQL_STATS)
                .bind("from", from)
                .bind("to", to)
                .mapToBean(DashboardStats.class)
                .findOne()
                .orElse(new DashboardStats()));
    }

    /** Giá trị ký quỹ theo ngày trong khoảng [from, to]. */
    public List<DashboardChartPoint> getEscrowValueByDay(LocalDate from, LocalDate to) {
        if (notConfigured(SQL_ESCROW_BY_DAY)) {
            return new ArrayList<>();
        }
        return get().withHandle(h -> h.createQuery(SQL_ESCROW_BY_DAY)
                .bind("from", from)
                .bind("to", to)
                .mapToBean(DashboardChartPoint.class)
                .list());
    }

    /** Giá trị theo danh mục trong khoảng [from, to]. */
    public List<DashboardCategoryShare> getCategoryShares(LocalDate from, LocalDate to) {
        if (notConfigured(SQL_CATEGORY_SHARE)) {
            return new ArrayList<>();
        }
        return get().withHandle(h -> h.createQuery(SQL_CATEGORY_SHARE)
                .bind("from", from)
                .bind("to", to)
                .mapToBean(DashboardCategoryShare.class)
                .list());
    }

    /** Giao dịch gần nhất, có phân trang. status rỗng = tất cả. */
    public List<DashboardTransaction> getRecentTransactions(String status, int limit, int offset) {
        if (notConfigured(SQL_RECENT_TRANSACTIONS)) {
            return new ArrayList<>();
        }
        return get().withHandle(h -> h.createQuery(SQL_RECENT_TRANSACTIONS)
                .bind("status", status)
                .bind("limit", limit)
                .bind("offset", offset)
                .mapToBean(DashboardTransaction.class)
                .list());
    }

    /** Tổng số giao dịch theo bộ lọc trạng thái (để tính số trang). */
    public long countTransactions(String status) {
        if (notConfigured(SQL_COUNT_TRANSACTIONS)) {
            return 0L;
        }
        return get().withHandle(h -> h.createQuery(SQL_COUNT_TRANSACTIONS)
                .bind("status", status)
                .mapTo(Long.class)
                .findOne()
                .orElse(0L));
    }
}
