package com.tmdt.controller;

import com.tmdt.db.JDBIConnector;
import com.tmdt.untils.VnpayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "PayAuctionController", urlPatterns = {"/pay-auction"})
public class PayAuctionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Lấy thông tin đơn hàng
            Map<String, Object> order = JDBIConnector.get().withHandle(h ->
                    h.createQuery("SELECT order_code, total_amount, payment_status FROM orders WHERE id = :id")
                            .bind("id", orderId).mapToMap().one()
            );

            if (order == null || !"PENDING".equals(order.get("payment_status"))) {
                request.getSession().setAttribute("errorMessage", "Đơn hàng không hợp lệ hoặc đã được thanh toán.");
                response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
                return;
            }

            String orderCode = order.get("order_code").toString();
            double amountDouble = ((Number) order.get("total_amount")).doubleValue();
            long amount = (long) (amountDouble * 100); // VNPay nhân 100

            // Tạo URL thanh toán VNPay (Giống hệt VNPayPaymentController nhưng lấy tiền từ DB)
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String vnp_OrderInfo = "Thanh toan don hang dau gia " + orderCode;
            String orderType = "other";
            String vnp_TxnRef = orderCode;
            String vnp_IpAddr = request.getRemoteAddr();
            String vnp_TmnCode = VnpayConfig.vnp_TmnCode;

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", orderType);
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VnpayConfig.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString())).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = VnpayConfig.hmacSHA512(VnpayConfig.vnp_HashSecret, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = VnpayConfig.vnp_PayUrl + "?" + queryUrl;

            response.sendRedirect(paymentUrl);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }
}