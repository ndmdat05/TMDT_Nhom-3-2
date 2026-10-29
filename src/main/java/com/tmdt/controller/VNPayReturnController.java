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

        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        String signValue = VnpayConfig.hmacSHA512(VnpayConfig.vnp_HashSecret, hashData.toString());
        boolean checkSignature = signValue.equalsIgnoreCase(vnp_SecureHash);

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String orderCode = request.getParameter("vnp_TxnRef");
        HttpSession session = request.getSession();

        if (checkSignature && "00".equals(vnp_ResponseCode)) {
            // ==========================================
            // 1. THANH TOÁN THÀNH CÔNG -> LƯU VÀO DATABASE
            // ==========================================
            Cart cart = (Cart) session.getAttribute("cart");
            User user = (User) session.getAttribute("user");
            String receiverName = (String) session.getAttribute("order_name");
            String receiverPhone = (String) session.getAttribute("order_phone");
            String address = (String) session.getAttribute("order_address");

            if (cart != null) {
                OrderDao orderDao = new OrderDao();
                orderDao.createOrder(
                        user != null ? user.getId() : 1,
                        2, // seller_id mặc định
                        receiverName,
                        receiverPhone,
                        address,
                        cart.getTotalMoney(),
                        "ONLINE",
                        "PAID",
                        orderCode,
                        cart // <--- THÊM BIẾN CART VÀO ĐÂY
                );

                // Xóa giỏ hàng và dữ liệu đặt hàng trong session
                session.removeAttribute("cart");
                session.removeAttribute("order_name");
                session.removeAttribute("order_phone");
                session.removeAttribute("order_address");
                session.removeAttribute("order_email");
                session.removeAttribute("order_payment_method");
                session.removeAttribute("order_code");
            }

            request.getRequestDispatcher("/order-success.jsp").forward(request, response);

        } else {
            request.getRequestDispatcher("/order-failed.jsp").forward(request, response);
        }
    }}