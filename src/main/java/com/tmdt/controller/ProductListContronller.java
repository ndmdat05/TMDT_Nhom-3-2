package com.tmdt.controller;

import com.tmdt.Model.Category;
import com.tmdt.Model.Product;
import com.tmdt.service.ProductListService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductListContronller", value = "/product-list")
public class ProductListContronller extends HttpServlet {
    private final ProductListService productService = new ProductListService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        String keyword = request.getParameter("q");
        String sort = request.getParameter("sort");
        String pageStr = request.getParameter("page");

        int page = 1;
        int limit = 9;

        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Product> productList = productService.searchProducts(
                keyword,
                sort,
                page,
                limit
        );

        int totalProducts = productService.countSearchProducts(keyword);
        int totalPages = (int) Math.ceil((double) totalProducts / limit);

        List<String> languageList = productService.getAllLanguages();
        List<String> conditionList = productService.getAllConditions();
        List<Category> categoryList = productService.getAllCategories();

        request.setAttribute("productList", productList);
        request.setAttribute("languageList", languageList);
        request.setAttribute("conditionList", conditionList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/product-list.jsp").forward(request, response);
    }
}