package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Model.Cart;
import com.tmdt.Model.Order;
import com.tmdt.Model.User;
import com.tmdt.untils.VnpayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ============ 1. VERIFY SIGNATURE ============
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) fields.put(fieldName, fieldValue);
        }
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fn = itr.next();
            String fv = fields.get(fn);
            if (fv != null && !fv.isEmpty()) {
                hashData.append(fn).append('=')
                        .append(URLEncoder.encode(fv, StandardCharsets.US_ASCII));
                if (itr.hasNext()) hashData.append('&');
            }
        }
        String signValue = VnpayConfig.hmacSHA512(VnpayConfig.vnp_HashSecret, hashData.toString());
        boolean validSignature = signValue.equalsIgnoreCase(vnp_SecureHash);

        String responseCode = request.getParameter("vnp_ResponseCode");
        String orderCode    = request.getParameter("vnp_TxnRef");
        HttpSession session = request.getSession();

        if (!validSignature || !"00".equals(responseCode)) {
            request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
            return;
        }

        OrderDao orderDao = new OrderDao();

        // ============ 2. KIỂM TRA ĐƠN ĐÃ TỒN TẠI TRONG DB CHƯA (VÍ DỤ: ĐƠN ĐẤU GIÁ AUC...) ============
        Order existingOrder = orderDao.getOrderByCode(orderCode);
        if (existingOrder != null) {
            // Cập nhật trạng thái thanh toán thành PAID cho đơn hàng đã tồn tại
            boolean updated = orderDao.updatePaymentStatusByCode(orderCode, "PAID", "CONFIRMED");
            if (updated) {
                // Dọn dẹp session nếu có
                session.removeAttribute("order_code");
                request.getRequestDispatcher("/order-success.jsp").forward(request, response);
                return;
            } else {
                request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
                return;
            }
        }

        // ============ 3. LẤY ID TỪ SESSION (ĐỐI VỚI ĐƠN MUA THƯỜNG TẠO MỚI) ============
        Cart cart = (Cart) session.getAttribute("cart");
        String receiverName = (String) session.getAttribute("order_name");
        String receiverPhone = (String) session.getAttribute("order_phone");
        String address = (String) session.getAttribute("order_address");

        Integer buyerId  = (Integer) session.getAttribute("checkout_buyer_id");
        Integer sellerId = (Integer) session.getAttribute("checkout_seller_id");

        if (buyerId == null || buyerId <= 0) {
            User user = getLoggedInUser(session);
            if (user != null) buyerId = user.getId();
        }

        if (buyerId == null || buyerId <= 0
                || sellerId == null || sellerId <= 0
                || cart == null || cart.getTotalQuantity() == 0
                || receiverName == null || receiverPhone == null || address == null) {
            System.err.println("[VNPayReturn] Missing data: buyerId=" + buyerId
                    + ", sellerId=" + sellerId
                    + ", cartEmpty=" + (cart == null || cart.getTotalQuantity() == 0));
            request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
            return;
        }

        // ============ 4. TẠO ĐƠN THƯỜNG MỚI ============
        int newId = orderDao.createOrder(
                buyerId,
                sellerId,
                receiverName,
                receiverPhone,
                address,
                cart.getTotalMoney(),
                "ONLINE",
                "PAID",
                orderCode,
                cart
        );

        if (newId <= 0) {
            request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
            return;
        }

        // ============ 5. CLEANUP ============
        session.removeAttribute("cart");
        session.removeAttribute("order_name");
        session.removeAttribute("order_phone");
        session.removeAttribute("order_address");
        session.removeAttribute("order_email");
        session.removeAttribute("order_payment_method");
        session.removeAttribute("order_code");
        session.removeAttribute("checkout_buyer_id");
        session.removeAttribute("checkout_seller_id");

        request.getRequestDispatcher("/order-success.jsp").forward(request, response);
    }

    private User getLoggedInUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        if (!(u instanceof User)) u = session.getAttribute("account");
        return (u instanceof User) ? (User) u : null;
    }
}