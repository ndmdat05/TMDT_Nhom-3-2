package com.tmdt.service;

import com.tmdt.Dao.ProductListDao;
import com.tmdt.Model.Category;
import com.tmdt.Model.Product;

import java.util.List;

public class ProductListService {
    ProductListDao productListDao = new ProductListDao();

    public List<String> getAllLanguages() {
        return productListDao.getAllLanguages();
    }

    public List<String> getAllConditions() {
        return productListDao.getAllConditions();
    }

    public List<Product> filterProducts(String publisher, String seller, String condition, String language, Integer categoryId, Double minPrice, Double maxPrice, String sort, int page, int limit){
        return productListDao.filterProducts(publisher, seller, condition, language, categoryId, minPrice, maxPrice, sort, page, limit);
    }

    public int countFilterProducts(String publisher, String seller, String condition, String language, Integer categoryId, Double minPrice, Double maxPrice) {
        return productListDao.countFilterProducts(publisher, seller, condition, language, categoryId, minPrice, maxPrice);
    }

    public List<Category> getAllCategories() {
        return productListDao.getAllCategories();
    }
}