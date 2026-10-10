package com.tmdt.Dao;

import com.tmdt.Model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.ArrayList;
import java.util.List;

public class UserDao extends BaseDao {
    private static List<User> userList = new ArrayList<>();

    static {
        userList.add(new User("Nguyen Van A","nguyenvana", "nva@gmail.com","", "SELLER",false,"","", "ACTIVE"));
        userList.add(new User("Nguyen Van A","tranvanb", "tvb@gmail.com","", "BUYER", false,"","","ACTIVE"));
        userList.add(new User("Nguyen Van A","lethic", "ltc@gmail.com","", "BUYER",false,"","", "LOCKED"));
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

    public boolean addUser(User user){
        String sql = "INSERT INTO users (full_name, username, email, hash_password, role, is_verified, verify_token,auth_provider,status) VALUES (:full_name, :username, :email, :hash_password, :role, :is_verified, :verify_token,:auth_provider,:status)";
        return get().withHandle(h -> {
            return h.createUpdate(sql).bindBean(user).execute() > 0;
        });
    }
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = :username";
        return get().withHandle(h -> {
            return h.createQuery(sql)
                    .bind("username", username)
                    .mapTo(Integer.class)
                    .one() > 0;
        });
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = :email";
        return get().withHandle(h -> {
            return   h.createQuery(sql)
                    .bind("email", email)
                    .mapTo(Integer.class)
                    .one() > 0;
        });
    }
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE (username = :username OR email = :username)";
        User user = get().withHandle(h->{
            return h.createQuery(sql).bind("username", username).mapToBean(User.class).findOne().orElse(null);
        });
        if(user == null){
            return null;
        }
        boolean isPasswordMatch = BCrypt.checkpw(password, user.getHash_password());
        if(isPasswordMatch){
            return user;
        }
        else{
            return null;
        }
    }

    public Integer findUserIdByToken(String token) {
        String sql = "SELECT id FROM users WHERE verify_token = :token";
        return get().withHandle(handle -> {
            return handle.createQuery(sql).bind("token", token).mapTo(Integer.class).findOne().orElse(null);
        });
    }

    public boolean activateUser(int userId) {
        String sql = "UPDATE users SET is_verified = 1, verify_token = NULL WHERE id = :id";
        return get().withHandle(handle -> {
            return handle.createUpdate(sql).bind("id", userId).execute() > 0;
        });
    }

    public boolean updateResetToken(String email, String token) {
        String sql = "UPDATE users SET verify_token = :token WHERE email = :email";
        return get().withHandle(h -> {
            return h.createUpdate(sql).bind("token", token).bind("email", email).execute() > 0;
        } );
    }

    public boolean updatePassword(String email, String hashPassword) {
        String sql = "UPDATE users SET hash_password = :hashPassword, verify_token = NULL WHERE email = :email";

        return get().withHandle(h -> {
            return h.createUpdate(sql).bind("hashPassword", hashPassword).bind("email", email).execute() > 0;
        });
    }

    public String findEmailByToken(String token) {
        String sql = "SELECT email FROM users WHERE verify_token = :token";
        return get().withHandle(h -> {
            return  h.createQuery(sql).bind("token", token).mapTo(String.class).findOne().orElse(null);
        });
    }
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = :email";
        return get().withHandle(h -> {
            return h.createQuery(sql).bind("email", email).mapToBean(User.class).findOne().orElse(null);
        });
    }
}