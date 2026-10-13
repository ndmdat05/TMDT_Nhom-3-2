package com.tmdt.controller;

import com.tmdt.Dao.ProductDao;
import com.tmdt.Model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<Product> newMangaList = productDao.getTopNewProducts(8);
        List<Product> featuredMangaList = productDao.getFeaturedProducts(8);
        List<Product> allProducts = productDao.getAllProducts();

        request.setAttribute("newMangaList", newMangaList);
        request.setAttribute("featuredMangaList", featuredMangaList);
        request.setAttribute("allProducts", allProducts);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}