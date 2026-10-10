package com.tmdt.service;

import com.tmdt.Dao.UserDao;
import com.tmdt.Model.User;

public class UserService {
        UserDao userDao = new UserDao();
    public boolean addUser(User user){
        return  userDao.addUser(user);
    }
    public boolean existsByUsername(String username) {
        return  userDao.existsByUsername(username);
    }
    public boolean existsByEmail(String email) {
        return  userDao.existsByEmail(email);
    }
    public User login(String username, String password) {
        return  userDao.login(username, password);
    }
    public boolean activateUser(int userId) {
        return  userDao.activateUser(userId);
    }
    public Integer findUserIdByToken(String token) {
        return  userDao.findUserIdByToken(token);
    }
    public boolean updateResetToken(String email, String token) {
        return  userDao.updateResetToken(email, token);
    }
    public boolean updatePassword(String email, String hashPassword) {
        return  userDao.updatePassword(email, hashPassword);
    }
    public String findEmailByToken(String token) {
        return  userDao.findEmailByToken(token);
    }
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }
}
