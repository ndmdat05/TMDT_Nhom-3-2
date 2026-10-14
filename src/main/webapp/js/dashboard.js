// Chỉ xử lý tương tác giao diện + vẽ biểu đồ từ dữ liệu THẬT do Backend cung cấp
// (DashboardServlet -> DashboardService -> DashboardDao) trong <script id="dash-data">.
// Không có dữ liệu mẫu và không sinh số liệu ở phía client.
(function () {
    const $ = id => document.getElementById(id);
    const DAY = 864e5;
    const MAX_DAYS = 90;
    const PALETTE = ["#2f55e8", "#16a36a", "#f08a24", "#9aa3bd", "#e5484d", "#7a5af8", "#0ea5b7", "#c2410c"];

    // ---- Dữ liệu từ Backend ----
    let data = { days: [], values: [], categories: [] };
    try {
        const el = $("dash-data");
        if (el && el.textContent.trim()) data = JSON.parse(el.textContent);
    } catch (e) {
        console.error("Không đọc được dữ liệu Dashboard", e);
    }

    // ---- Tiện ích ngày (theo giờ địa phương, tránh lệch múi giờ của toISOString) ----
    const pad = n => String(n).padStart(2, "0");
    const iso = d => d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate());

    // ---- Bộ lọc thời gian: gửi lên server bằng GET ----
    const form = $("dashForm");

    function submitRange() {
        const f = $("from").value;
        const t = $("to").value;
        const msg = $("msg");
        const from = new Date(f);
        const to = new Date(t);
        if (!f || !t || from > to) {
            msg.textContent = "Khoảng ngày không hợp lệ.";
            return;
        }
        if ((to - from) / DAY + 1 > MAX_DAYS) {
            msg.textContent = "Tối đa " + MAX_DAYS + " ngày.";
            return;
        }
        msg.textContent = "";
        form.submit();
    }

    document.querySelectorAll("#rg button").forEach(b => {
        b.addEventListener("click", () => {
            const d = +b.dataset.d;
            const to = new Date();
            const from = new Date(+to - (d - 1) * DAY);
            $("from").value = iso(from);
            $("to").value = iso(to);
            submitRange();
        });
    });

    const apply = $("ap");
    if (apply) {
        apply.addEventListener("click", e => {
            e.preventDefault();
            submitRange();
        });
    }

    const status = $("txStatus");
    if (status) status.addEventListener("change", () => form.submit());

    // ---- Biểu đồ ----
    if (typeof Chart === "undefined") return;   // CDN không tải được: giữ nguyên phần còn lại của trang

    const barEl = $("bar");
    if (barEl && data.days.length) {
        new Chart(barEl, {
            type: "bar",
            data: {
                labels: data.days.map(s => s.slice(8, 10) + "/" + s.slice(5, 7)),
                datasets: [{
                    label: "Giá trị ký quỹ (triệu ₫)",
                    data: data.values.map(v => v / 1e6),
                    backgroundColor: "#2f55e8",
                    borderRadius: 4,
                    maxBarThickness: 22
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false }, ticks: { font: { size: 9 }, maxTicksLimit: 10 } },
                    y: { ticks: { font: { size: 9 } }, grid: { color: "#eef0f6" } }
                }
            }
        });
    }

    const pieEl = $("pie");
    if (pieEl && data.categories.length) {
        const colors = data.categories.map((c, i) => PALETTE[i % PALETTE.length]);
        new Chart(pieEl, {
            type: "doughnut",
            data: {
                labels: data.categories.map(c => c.name),
                datasets: [{
                    data: data.categories.map(c => c.value),
                    backgroundColor: colors,
                    borderWidth: 2
                }]
            },
            options: { maintainAspectRatio: false, cutout: "0%", plugins: { legend: { display: false } } }
        });

        const lg = $("lg");
        if (lg) {
            lg.innerHTML = "";
            data.categories.forEach((c, i) => {
                const row = document.createElement("div");
                const name = document.createElement("span");
                const dot = document.createElement("i");
                dot.style.background = colors[i];
                name.appendChild(dot);
                name.appendChild(document.createTextNode(" " + c.name));
                const val = document.createElement("b");
                val.textContent = c.percent.toLocaleString("vi-VN", { maximumFractionDigits: 1 }) + "% · " +
                    (c.value / 1e6).toLocaleString("vi-VN", { maximumFractionDigits: 1 }) + "tr";
                row.appendChild(name);
                row.appendChild(val);
                lg.appendChild(row);
            });
        }
    }
})();
