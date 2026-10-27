package com.tmdt.controller;

import com.tmdt.Dao.OrderDao;
import com.tmdt.Model.Cart;
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
            // Luồng COD: Ghi ngay vào DB (payment_status phải là 'PENDING' để không lỗi check constraint)
            User user = (User) session.getAttribute("user");
            OrderDao orderDao = new OrderDao();
            orderDao.createOrder(
                    user != null ? user.getId() : 1,
                    2, // seller_id mặc định của Kenji Vault
                    fullName,
                    phone,
                    address,
                    cart.getTotalMoney(),
                    "COD",
                    "PENDING",
                    orderCode
            );

            session.removeAttribute("cart");
            response.sendRedirect(request.getContextPath() + "/order-success.jsp");
        }
    }
}