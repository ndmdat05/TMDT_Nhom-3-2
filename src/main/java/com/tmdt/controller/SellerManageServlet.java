package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Dao.ProductDao;
import com.tmdt.db.JDBIConnector;
import com.tmdt.Model.Category;
import com.tmdt.Model.Order;
import com.tmdt.Model.Product;
import com.tmdt.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "SellerManageServlet", urlPatterns = {"/seller-manage"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class SellerManageServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        User acc = getLoggedInUser(request);
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) action = "products";

        if ("edit".equals(action) || "add".equals(action)) {
            if ("edit".equals(action)) {
                try {
                    int productId = Integer.parseInt(request.getParameter("id"));
                    Product product = productDao.getProductForSeller(productId, acc.getId());
                    if (product == null) {
                        response.sendRedirect(request.getContextPath() + "/seller-manage?action=products");
                        return;
                    }
                    request.setAttribute("product", product);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/seller-manage?action=products");
                    return;
                }
            }
            request.setAttribute("categoryList", loadCategories());
            request.setAttribute("brandList", loadBrands());
            request.getRequestDispatcher("/seller-edit-product.jsp").forward(request, response);
            return;
        }

        int sellerId = acc.getId();
        List<Product> sellerProducts = productDao.getProductsBySellerId(sellerId);
        List<Order> allOrders = orderDao.getOrdersBySellerId(sellerId);
        if (allOrders == null) allOrders = new ArrayList<>();

        List<Order> sellerOrders;
        switch (action.toLowerCase()) {
            case "cancelled":
                sellerOrders = allOrders.stream().filter(o -> "CANCELLED".equalsIgnoreCase(o.getStatus())).collect(Collectors.toList());
                break;
            case "refunds":
                sellerOrders = allOrders.stream().filter(o -> "REFUND".equalsIgnoreCase(o.getStatus()) || "RETURNED".equalsIgnoreCase(o.getStatus()) || "REFUNDED".equalsIgnoreCase(o.getPaymentStatus())).collect(Collectors.toList());
                break;
            case "orders":
                sellerOrders = allOrders.stream().filter(o -> o.getStatus() != null && !"CANCELLED".equalsIgnoreCase(o.getStatus()) && !"REFUND".equalsIgnoreCase(o.getStatus()) && !"RETURNED".equalsIgnoreCase(o.getStatus())).collect(Collectors.toList());
                break;
            default:
                sellerOrders = allOrders;
        }

        if ("products".equals(action)) {
            request.setAttribute("categoryList", loadCategories());
            request.setAttribute("brandList", loadBrands());
        }

        request.setAttribute("sellerProducts", sellerProducts);
        request.setAttribute("sellerOrders", sellerOrders);
        request.setAttribute("activeTab", action);

        request.getRequestDispatcher("/seller-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User acc = getLoggedInUser(request);
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int sellerId = acc.getId();
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAdd(request, sellerId, acc);
        } else if ("update".equals(action)) {
            handleUpdate(request, sellerId);
        } else if ("delete".equals(action)) {
            handleDelete(request, sellerId);
        } else if ("toggle-status".equals(action)) {
            handleToggle(request, sellerId);
        }
        response.sendRedirect(request.getContextPath() + "/seller-manage?action=products");
    }

    private String handleFileUpload(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                String ext = "";
                if (fileName != null && fileName.contains(".")) {
                    ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
                }
                if (!ext.matches("\\.(jpg|jpeg|png|webp|gif)")) return null;

                String newFileName = "manga_" + System.currentTimeMillis() + ext;
                String uploadDir = request.getServletContext().getRealPath("/Image/uploads/");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, Paths.get(uploadDir, newFileName), StandardCopyOption.REPLACE_EXISTING);
                }
                return "Image/uploads/" + newFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return new File(fileName).getName();
            }
        }
        return null;
    }

    // -------- ADD --------
    private void handleAdd(HttpServletRequest request, int sellerId, User seller) {
        try {
            boolean isAuction = request.getParameter("isAuction") != null;
            Product p = parseProductFromForm(request);

            if (p == null) {
                flash(request, "error", "Vui lòng kiểm tra lại: tên, giá bán phải hợp lệ.");
                return;
            }

            if (isAuction) {
                try {
                    double sp = Double.parseDouble(request.getParameter("startingPrice"));
                    p.setPrice(sp);
                } catch (Exception e) {
                    flash(request, "error", "Giá khởi điểm không hợp lệ.");
                    return;
                }
            }

            String uploadedImage = handleFileUpload(request);
            if (uploadedImage != null) p.setImageUrl(uploadedImage);

            p.setAuction(isAuction);
            p.setSellerId(sellerId);
            p.setSellerName(seller.getUsername());
            p.setStatus("PENDING_APPROVAL");

            int newId = productDao.addProduct(p);

            if (newId > 0) {
                if (isAuction) {
                    try {
                        double startingPrice = Double.parseDouble(request.getParameter("startingPrice"));
                        double bidStep = Double.parseDouble(request.getParameter("bidStep"));
                        String endTimeStr = request.getParameter("endTime");

                        java.sql.Timestamp endTime = Timestamp.valueOf(endTimeStr.replace("T", " ") + ":00");
                        java.sql.Timestamp startTime = new Timestamp(System.currentTimeMillis());

                        JDBIConnector.get().useHandle(h ->
                                h.createUpdate("INSERT INTO auctions (product_id, seller_id, starting_price, bid_step, start_time, end_time, status) " +
                                                "VALUES (:pid, :sid, :start, :step, :stime, :etime, 'UPCOMING')")
                                        .bind("pid", newId).bind("sid", sellerId)
                                        .bind("start", startingPrice).bind("step", bidStep)
                                        .bind("stime", startTime).bind("etime", endTime)
                                        .execute()
                        );
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        flash(request, "error", "Lỗi lưu thông tin đấu giá. Vui lòng thử lại.");
                        return;
                    }
                }
                flash(request, "success", "Đã đăng bán! Bài đăng đang chờ Admin kiểm duyệt.");
            } else {
                flash(request, "error", "Không thể tạo sản phẩm. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            flash(request, "error", "Lỗi xử lý dữ liệu: " + e.getMessage());
        }
    }

    private void handleUpdate(HttpServletRequest request, int sellerId) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = parseProductFromForm(request);
            if (p == null) {
                flash(request, "error", "Vui lòng kiểm tra lại: tên, giá bán.");
                return;
            }
            p.setId(id);

            String uploadedImage = handleFileUpload(request);
            if (uploadedImage != null) p.setImageUrl(uploadedImage);

            boolean ok = productDao.updateProduct(p, sellerId);
            if (ok) {
                flash(request, "success", "Đã cập nhật. Nếu sản phẩm đang hiển thị, sẽ chuyển về trạng thái chờ duyệt lại.");
            } else {
                flash(request, "error", "Không thể cập nhật. Sản phẩm không tồn tại hoặc không thuộc về bạn.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            flash(request, "error", "Dữ liệu không hợp lệ.");
        }
    }

    private void handleDelete(HttpServletRequest request, int sellerId) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = productDao.deleteProduct(id, sellerId);
            flash(request, ok ? "success" : "error",
                    ok ? "Đã xóa sản phẩm." : "Không thể xóa sản phẩm (không thuộc về bạn).");
        } catch (Exception e) {
            flash(request, "error", "Mã sản phẩm không hợp lệ.");
        }
    }

    private void handleToggle(HttpServletRequest request, int sellerId) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = productDao.toggleProductStatus(id, sellerId);
            flash(request, ok ? "success" : "error",
                    ok ? "Đã thay đổi trạng thái hiển thị."
                            : "Không thể thay đổi. Sản phẩm chưa được duyệt hoặc không thuộc về bạn.");
        } catch (Exception e) {
            flash(request, "error", "Mã sản phẩm không hợp lệ.");
        }
    }

    // SỬA LẠI HÀM NÀY: Cho phép price bị null nếu là đấu giá
    private Product parseProductFromForm(HttpServletRequest req) {
        String title = req.getParameter("title");
        if (title == null || title.trim().isEmpty()) return null;
        if (title.trim().length() > 255) return null;

        double price = 0; // Mặc định là 0
        try {
            String priceStr = req.getParameter("price");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = Double.parseDouble(priceStr);
                if (price < 0) return null;
            }
        } catch (Exception e) { return null; }

        int stock = 1;
        try {
            String stockStr = req.getParameter("stockQuantity");
            if(stockStr != null && !stockStr.isEmpty()) stock = Integer.parseInt(stockStr);
        } catch (Exception ignored) {}
        if (stock < 0) stock = 0;

        Integer volume = null;
        try {
            String v = req.getParameter("volumeNumber");
            if (v != null && !v.trim().isEmpty()) volume = Integer.parseInt(v.trim());
        } catch (Exception ignored) {}

        Integer categoryId = null;
        try { categoryId = Integer.parseInt(req.getParameter("categoryId")); } catch (Exception ignored) {}
        Integer brandId = null;
        try { brandId = Integer.parseInt(req.getParameter("brandId")); } catch (Exception ignored) {}

        Product p = new Product();
        p.setTitle(title.trim());
        p.setPrice(price);
        p.setStockQuantity(stock);
        p.setDescription(trimToNull(req.getParameter("description")));
        p.setImageUrl(trimToNull(req.getParameter("imageUrl")));
        p.setSeriesName(trimToNull(req.getParameter("seriesName")));
        p.setAuthor(trimToNull(req.getParameter("author")));
        p.setVolumeNumber(volume);
        p.setEdition(trimToNull(req.getParameter("edition")));

        String cond = req.getParameter("itemCondition");
        if (cond == null || !cond.matches("NEW|LIKE_NEW|USED")) cond = "NEW";
        p.setItemCondition(cond);

        String lang = req.getParameter("language");
        if (lang == null || lang.trim().isEmpty()) lang = "Tiếng Việt";
        p.setLanguage(lang.trim());

        if (categoryId != null && categoryId > 0) p.setCategories_id(categoryId);
        if (brandId != null && brandId > 0) p.setBrandId(brandId);
        return p;
    }

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        if (s == null) return null;
        Object u = s.getAttribute("user");
        if (!(u instanceof User)) u = s.getAttribute("account");
        return (u instanceof User) ? (User) u : null;
    }

    private void flash(HttpServletRequest req, String type, String msg) {
        req.getSession().setAttribute("sellerFlash_" + type, msg);
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private List<Category> loadCategories() {
        try {
            return JDBIConnector.get().withHandle(h -> h.createQuery("SELECT id, name FROM categories ORDER BY id ASC").mapToBean(Category.class).list());
        } catch (Exception e) { return new ArrayList<>(); }
    }

    private List<Category> loadBrands() {
        try {
            return JDBIConnector.get().withHandle(h -> h.createQuery("SELECT id, name FROM brands ORDER BY id ASC").mapToBean(Category.class).list());
        } catch (Exception e) { return new ArrayList<>(); }
    }
}