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

        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = (User) session.getAttribute("account");
        }
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getTotalQuantity() == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String shippingAddress = request.getParameter("shippingAddress");

        // Mã đơn hàng định dạng chữ và số liền nhau
        int randomNum = (int) (100000 + Math.random() * 900000);
        String orderCode = "MGV" + randomNum;

        // Lưu thông tin tạm vào Session
        session.setAttribute("order_name", fullName);
        session.setAttribute("order_email", email);
        session.setAttribute("order_phone", phone);
        session.setAttribute("order_address", address);
        session.setAttribute("order_payment_method", paymentMethod);
        session.setAttribute("order_code", orderCode);

        if ("ONLINE".equalsIgnoreCase(paymentMethod)) {
            response.sendRedirect(request.getContextPath() + "/vnpay-payment");
        } else {
            // Luồng COD: Ghi ngay vào DB
            User user = (User) session.getAttribute("user");
            if (user == null) {
                user = (User) session.getAttribute("account");
            }

            // Ưu tiên lấy receiverName nếu form checkout có gửi, không thì dùng fullName
            String finalReceiver = (receiverName != null && !receiverName.trim().isEmpty()) ? receiverName : fullName;
            String finalPhone = (receiverPhone != null && !receiverPhone.trim().isEmpty()) ? receiverPhone : phone;
            String finalAddress = (shippingAddress != null && !shippingAddress.trim().isEmpty()) ? shippingAddress : address;

            // 1. Tự động lấy sellerId từ cuốn truyện có trong giỏ hàng
            int sellerId = 1;
            if (cart.getItems() != null) {
                for (CartItem item : cart.getItems()) {
                    Product p = item.getProduct();
                    if (p != null && p.getSellerId() > 0) {
                        sellerId = p.getSellerId();
                        break;
                    }
                }
            }

            OrderDao orderDao = new OrderDao();
            int buyerId = (user != null) ? user.getId() : 1;

            // 2. Truyền đúng sellerId vừa lấy được vào đơn hàng
            int newOrderId = orderDao.createOrder(
                    buyerId,
                    sellerId, // Đã thay thế số 2 cố định bằng ID của người bán thật
                    finalReceiver,
                    finalPhone,
                    finalAddress,
                    cart.getTotalMoney(),
                    "COD",
                    "PENDING",
                    orderCode,
                    cart
            );

            // Xóa giỏ hàng trong session sau khi đã lưu xong vào CSDL
            session.removeAttribute("cart");

            // Chuyển hướng sang trang đặt hàng thành công
            response.sendRedirect(request.getContextPath() + "/order-success.jsp");
        }
    }
}