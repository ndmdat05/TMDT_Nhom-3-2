package com.tmdt.Dao;

import com.tmdt.Model.Order;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    private static List<Order> orderList = new ArrayList<>();

    static {
        orderList.add(new Order(501, "Slam Dunk Deluxe Tập 1", "tranvanb", "nguyenvana", 120000, "PENDING", ""));

// Hoặc nếu đơn đã có mã vận đơn:
        orderList.add(new Order(502, "One Piece Tập 1 (Bản in 1997)", "lethic", "nguyenvana", 550000, "CONFIRMED", "GHTK-102938"));
    }

    public List<Order> getAllOrders() {
        return orderList;
    }

    public List<Order> getOrdersBySellerName(String sellerName) {
        List<Order> result = new ArrayList<>();
        for (Order o : orderList) {
            if (o.getSellerName().equalsIgnoreCase(sellerName)) {
                result.add(o);
            }
        }
        return result;
    }

    // Cập nhật trạng thái đơn hàng (Xác nhận, Hủy...)
    public boolean updateOrderStatus(int orderId, String newStatus) {
        for (Order o : orderList) {
            if (o.getId() == orderId) {
                o.setStatus(newStatus);
                return true;
            }
        }
        return false;
    }
}