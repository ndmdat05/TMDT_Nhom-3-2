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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String publisher = request.getParameter("publisher");
        String seller = request.getParameter("seller");
        String condition = request.getParameter("condition");
        String language = request.getParameter("language");
        String categoryId = request.getParameter("categoryId");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
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

        Double minPrice = null;
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            minPrice = Double.parseDouble(minPriceStr);
        }

        Double maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            maxPrice = Double.parseDouble(maxPriceStr);
        }
        Integer categoryIdn = null;
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            categoryIdn = Integer.parseInt(categoryId);
        }

        List<Product> productList = productService.filterProducts(publisher, seller, condition, language, categoryIdn, minPrice, maxPrice, sort, page, limit);
        int totalProducts = productService.countFilterProducts(publisher, seller, condition, language, categoryIdn, minPrice, maxPrice);
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