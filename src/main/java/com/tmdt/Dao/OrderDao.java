package com.tmdt.Dao;

import com.tmdt.Model.Order;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private static List<Order> orderList = new ArrayList<>();

    static {
        orderList.add(new Order(501, "Slam Dunk Deluxe Tập 1", "tranvanb", "nguyenvana", 120000, "PENDING", ""));
        orderList.add(new Order(502, "One Piece Tập 1 (Bản in 1997)", "lethic", "nguyenvana", 550000, "CONFIRMED", "GHTK-102938"));
    }

    public List<Order> getAllOrders() {
        return orderList;
    }

    public List<Order> getOrdersBySellerName(String sellerName) {
        List<Order> result = new ArrayList<>();
        for (Order o : orderList) {
            if (o.getSellerName() != null && o.getSellerName().equalsIgnoreCase(sellerName)) {
                result.add(o);
            }
        }
        return result;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        for (Order o : orderList) {
            if (o.getId() == orderId) {
                o.setStatus(newStatus);
                return true;
            }
        }
        return false;
    }

    public int countOrders() {
        return orderList.size();
    }

    public List<Order> getOrdersBySellerId(int sellerId) {
        List<Order> result = new ArrayList<>();
        for (Order o : orderList) {
            result.add(o);
        }
        return result;
    }

    public boolean updateOrderStatus(int orderId, int status) {
        String statusStr;
        switch (status) {
            case 0:
                statusStr = "PENDING";
                break;
            case 1:
                statusStr = "CONFIRMED";
                break;
            case 2:
                statusStr = "COMPLETED";
                break;
            case 3:
                statusStr = "CANCELLED";
                break;
            default:
                statusStr = String.valueOf(status);
                break;
        }
        return updateOrderStatus(orderId, statusStr);
    }
}