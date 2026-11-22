package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Model.Cart;
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

        // ============ 2. LẤY ID TỪ SESSION ============
        Cart cart = (Cart) session.getAttribute("cart");
        String receiverName = (String) session.getAttribute("order_name");
        String receiverPhone = (String) session.getAttribute("order_phone");
        String address = (String) session.getAttribute("order_address");

        Integer buyerId  = (Integer) session.getAttribute("checkout_buyer_id");
        Integer sellerId = (Integer) session.getAttribute("checkout_seller_id");

        // Fallback: nếu vì lý do gì đó session mất, đọc user từ session (không fallback về 1/2)
        if (buyerId == null || buyerId <= 0) {
            User user = getLoggedInUser(session);
            if (user != null) buyerId = user.getId();
        }

        if (buyerId == null || buyerId <= 0
                || sellerId == null || sellerId <= 0
                || cart == null || cart.getTotalQuantity() == 0
                || receiverName == null || receiverPhone == null || address == null) {
            // Không thể xác định buyer/seller/đơn -> báo thất bại, KHÔNG tạo đơn rác
            System.err.println("[VNPayReturn] Missing data: buyerId=" + buyerId
                    + ", sellerId=" + sellerId
                    + ", cartEmpty=" + (cart == null || cart.getTotalQuantity() == 0));
            request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
            return;
        }

        // ============ 3. TẠO ĐƠN ============
        OrderDao orderDao = new OrderDao();
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

        // ============ 4. CLEANUP ============
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