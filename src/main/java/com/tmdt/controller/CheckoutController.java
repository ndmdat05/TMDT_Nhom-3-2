package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Model.Cart;
import com.tmdt.Model.CartItem;
import com.tmdt.Model.Product;
import com.tmdt.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getTotalQuantity() == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        User user = getLoggedInUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // ============ 1. VALIDATE USER ============
        User user = getLoggedInUser(session);
        if (user == null || user.getId() <= 0) {
            // Session mất giữa chừng -> KHÔNG cho đặt, bắt login lại
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int buyerId = user.getId();

        // ============ 2. VALIDATE CART ============
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getTotalQuantity() == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // ============ 3. CHECK SINGLE SELLER ============
        // Sản phẩm trong giỏ phải cùng 1 seller (hoặc báo lỗi rõ ràng)
        Set<Integer> sellerIds = new LinkedHashSet<>();
        List<CartItem> items = cart.getItems();
        for (CartItem item : items) {
            Product p = item.getProduct();
            if (p == null || p.getSellerId() <= 0) {
                request.setAttribute("errorMessage",
                        "Sản phẩm '" + (p != null ? p.getTitle() : "?") + "' không có người bán hợp lệ.");
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                return;
            }
            sellerIds.add(p.getSellerId());
        }

        if (sellerIds.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        if (sellerIds.size() > 1) {
            request.setAttribute("errorMessage",
                    "Giỏ hàng đang có sản phẩm từ nhiều người bán. "
                            + "Vui lòng tách đơn hoặc chỉ mua từ một shop trong một lần đặt hàng.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }
        int sellerId = sellerIds.iterator().next();

        // ============ 4. FORM DATA ============
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");
        String paymentMethod  = request.getParameter("paymentMethod");
        String receiverName   = request.getParameter("receiverName");
        String receiverPhone  = request.getParameter("receiverPhone");
        String shippingAddr   = request.getParameter("shippingAddress");

        String finalReceiver = notBlank(receiverName)  ? receiverName.trim()  : safeTrim(fullName);
        String finalPhone    = notBlank(receiverPhone) ? receiverPhone.trim() : safeTrim(phone);
        String finalAddress  = notBlank(shippingAddr)  ? shippingAddr.trim()  : safeTrim(address);

        if (finalReceiver.isEmpty() || finalPhone.isEmpty() || finalAddress.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin giao hàng.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        // ============ 5. SESSION STATE (dùng cho VNPay) ============
        int seed = (int) (100000 + Math.random() * 900000);
        String orderCode = "MGV" + seed;

        session.setAttribute("order_name", finalReceiver);
        session.setAttribute("order_email", email);
        session.setAttribute("order_phone", finalPhone);
        session.setAttribute("order_address", finalAddress);
        session.setAttribute("order_payment_method", paymentMethod);
        session.setAttribute("order_code", orderCode);

        // ✅ QUAN TRỌNG: lưu buyerId + sellerId vào session để VNPayReturn
        //    không phụ thuộc vào session user (có thể mất) và không cần đọc lại cart
        session.setAttribute("checkout_buyer_id", buyerId);
        session.setAttribute("checkout_seller_id", sellerId);

        System.out.println("[CHECKOUT] buyerId=" + buyerId
                + ", sellerId=" + sellerId
                + ", payment=" + paymentMethod
                + ", total=" + cart.getTotalMoney());

        // ============ 6. PAYMENT ROUTING ============
        if ("ONLINE".equalsIgnoreCase(paymentMethod)) {
            response.sendRedirect(request.getContextPath() + "/vnpay-payment");
            return;
        }

        // COD
        OrderDao orderDao = new OrderDao();
        int newOrderId = orderDao.createOrder(
                buyerId,
                sellerId,
                finalReceiver,
                finalPhone,
                finalAddress,
                cart.getTotalMoney(),
                "COD",
                "PENDING",
                orderCode,
                cart
        );

        if (newOrderId <= 0) {
            request.setAttribute("errorMessage",
                    "Không thể tạo đơn hàng. Vui lòng kiểm tra lại sản phẩm hoặc thử lại sau.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        session.removeAttribute("cart");
        session.removeAttribute("checkout_buyer_id");
        session.removeAttribute("checkout_seller_id");
        response.sendRedirect(request.getContextPath() + "/order-success.jsp");
    }

    private User getLoggedInUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        if (!(u instanceof User)) u = session.getAttribute("account");
        return (u instanceof User) ? (User) u : null;
    }

    private boolean notBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }

    private String safeTrim(String s) {
        return s == null ? "" : s.trim();
    }
}