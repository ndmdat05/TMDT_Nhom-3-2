package com.tmdt.Dao;

import com.tmdt.Model.User;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    private static List<User> userList = new ArrayList<>();

    static {
        userList.add(new User(1, "nguyenvana", "nva@gmail.com", "SELLER", "ACTIVE"));
        userList.add(new User(2, "tranvanb", "tvb@gmail.com", "BUYER", "ACTIVE"));
        userList.add(new User(3, "lethic", "ltc@gmail.com", "BUYER", "LOCKED"));
    }

    public List<User> getAllUsers() {
        return userList;
    }

    // Hàm cập nhật trạng thái Lock/Active thật
    public boolean toggleUserStatus(int userId) {
        for (User u : userList) {
            if (u.getId() == userId) {
                if ("ACTIVE".equalsIgnoreCase(u.getStatus())) {
                    u.setStatus("LOCKED");
                } else {
                    u.setStatus("ACTIVE");
                }
                return true;
            }
        }
        return false;
    }
}