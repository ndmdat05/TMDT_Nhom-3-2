package com.tmdt.service;

import com.tmdt.Dao.ProductListDao;
import com.tmdt.Model.Category;
import com.tmdt.Model.Product;

import java.util.List;

public class ProductListService {
    private final ProductListDao productListDao = new ProductListDao();

    public List<String> getAllLanguages() {
        return productListDao.getAllLanguages();
    }

    public List<String> getAllConditions() {
        return productListDao.getAllConditions();
    }

    public List<Product> searchProducts(
            String keyword,
            String sort,
            int page,
            int limit
    ) {
        return productListDao.searchProducts(
                keyword,
                sort,
                page,
                limit
        );
    }

    public int countSearchProducts(String keyword) {
        return productListDao.countSearchProducts(keyword);
    }

    public List<Category> getAllCategories() {
        return productListDao.getAllCategories();
    }
}