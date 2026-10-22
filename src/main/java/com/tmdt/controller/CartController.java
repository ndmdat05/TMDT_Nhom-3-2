package com.tmdt.controller;

import com.tmdt.Dao.ProductDao;
import com.tmdt.Model.Cart;
import com.tmdt.Model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String productIdRaw = request.getParameter("productId");

        if (productIdRaw != null && !productIdRaw.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdRaw.trim());
                if ("add".equalsIgnoreCase(action)) {
                    int quantity = 1;
                    String qtyRaw = request.getParameter("quantity");
                    if (qtyRaw != null && !qtyRaw.trim().isEmpty()) {
                        quantity = Integer.parseInt(qtyRaw.trim());
                    }
                    if (quantity < 1) quantity = 1;
                    Product product = productDao.getProductById(productId);
                    if (product != null) {
                        cart.addProduct(product, quantity);
                    }
                } else if ("delete".equalsIgnoreCase(action)) {
                    cart.removeProduct(productId);
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}