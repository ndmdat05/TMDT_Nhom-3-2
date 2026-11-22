
package com.tmdt.Dao;

import com.tmdt.Model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

public class UserDao extends BaseDao {

    public List<User> getAllUsers() {
        String sql = "SELECT id, full_name, username, email, role, " +
                "created_at, status, is_verified, auth_provider, " +
                "phone_number, address, avatar_url " +
                "FROM users " +
                "WHERE status IS NULL OR status <> 'DELETED' " +
                "ORDER BY created_at DESC, id DESC";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(User.class)
                        .list()
        );
    }

    public User findById(int id) {
        String sql = "SELECT id, full_name, username, email, role, " +
                "created_at, status, verify_token, is_verified, " +
                "hash_password, auth_provider, phone_number, address, " +
                "avatar_url " +
                "FROM users WHERE id = :id";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users " +
                "WHERE status IS NULL OR status <> 'DELETED'";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = :username";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("username", username)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = :email";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("email", email)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean addUser(User user) {
        String sql = "INSERT INTO users " +
                "(full_name, username, email, hash_password, role, " +
                "is_verified, verify_token, auth_provider, status) " +
                "VALUES (:full_name, :username, :email, :hash_password, " +
                ":role, :is_verified, :verify_token, :auth_provider, :status)";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("full_name", user.getFull_name())
                        .bind("username", user.getUsername())
                        .bind("email", user.getEmail())
                        .bind("hash_password", user.getHash_password())
                        .bind("role", user.getRole())
                        .bind("is_verified", user.isIs_verified())
                        .bind("verify_token", user.getVerify_token())
                        .bind("auth_provider", user.getAuth_provider())
                        .bind("status", user.getStatus())
                        .execute() > 0
        );
    }

    public boolean updateAdminUser(User user) {
        String sql = "UPDATE users SET " +
                "full_name = :full_name, " +
                "username = :username, " +
                "email = :email, " +
                "role = :role " +
                "WHERE id = :id AND (status IS NULL OR status <> 'DELETED')";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("full_name", user.getFull_name())
                        .bind("username", user.getUsername())
                        .bind("email", user.getEmail())
                        .bind("role", user.getRole())
                        .bind("id", user.getId())
                        .execute() > 0
        );
    }

    public boolean updateUserStatus(int userId, String status) {
        if (!"ACTIVE".equals(status) && !"LOCKED".equals(status)) {
            throw new IllegalArgumentException("Trạng thái tài khoản không hợp lệ.");
        }

        String sql = "UPDATE users SET status = :status " +
                "WHERE id = :id AND (status IS NULL OR status <> 'DELETED')";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    public boolean toggleUserStatus(int userId) {
        String sql = "UPDATE users SET status = " +
                "CASE " +
                "WHEN status = 'ACTIVE' THEN 'LOCKED' " +
                "WHEN status = 'LOCKED' THEN 'ACTIVE' " +
                "END " +
                "WHERE id = :id " +
                "AND role <> 'ADMIN' " +
                "AND status IN ('ACTIVE', 'LOCKED')";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    public boolean deleteUser(int userId) {
        String sql = "UPDATE users SET status = 'DELETED' " +
                "WHERE id = :id " +
                "AND role <> 'ADMIN' " +
                "AND status IN ('ACTIVE', 'LOCKED')";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", userId)
                        .execute() > 0
        );
    }


    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET " +
                "full_name = :full_name, " +
                "phone_number = :phone_number, " +
                "address = :address, " +
                "avatar_url = :avatar_url " +
                "WHERE id = :id";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("full_name", user.getFull_name())
                        .bind("phone_number", user.getPhone_number())
                        .bind("address", user.getAddress())
                        .bind("avatar_url", user.getAvatar_url())
                        .bind("id", user.getId())
                        .execute() > 0
        );
    }

    public boolean activateUser(int userId) {
        String sql = "UPDATE users SET is_verified = 1, verify_token = NULL " +
                "WHERE id = :id";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    public Integer findUserIdByToken(String token) {
        String sql = "SELECT id FROM users WHERE verify_token = :token";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("token", token)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public boolean updateResetToken(String email, String token) {
        String sql = "UPDATE users SET verify_token = :token WHERE email = :email";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("token", token)
                        .bind("email", email)
                        .execute() > 0
        );
    }

    public boolean updatePassword(String email, String hashPassword) {
        String sql = "UPDATE users SET hash_password = :hashPassword, " +
                "verify_token = NULL WHERE email = :email";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("hashPassword", hashPassword)
                        .bind("email", email)
                        .execute() > 0
        );
    }

    public String findEmailByToken(String token) {
        String sql = "SELECT email FROM users WHERE verify_token = :token";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("token", token)
                        .mapTo(String.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users " +
                "WHERE email = :email " +
                "AND (status IS NULL OR status <> 'DELETED')";

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users " +
                "WHERE (username = :username OR email = :username) " +
                "AND status = 'ACTIVE'";

        User user = get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("username", username)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );

        if (user == null ||
                user.getHash_password() == null ||
                user.getHash_password().isEmpty()) {
            return null;
        }

        if (!BCrypt.checkpw(password, user.getHash_password())) {
            return null;
        }

        return user;
    }
    public boolean addAdminUser(User user) {
        String sql = "INSERT INTO users " +
                "(full_name, username, email, hash_password, role, " +
                "is_verified, auth_provider, status, avatar_url) " +
                "VALUES (:full_name, :username, :email, :hash_password, " +
                ":role, :is_verified, :auth_provider, :status, :avatar_url)";

        return get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("full_name", user.getFull_name())
                        .bind("username", user.getUsername())
                        .bind("email", user.getEmail())
                        .bind("hash_password", user.getHash_password())
                        .bind("role", user.getRole())
                        .bind("is_verified", user.isIs_verified())
                        .bind("auth_provider", user.getAuth_provider())
                        .bind("status", user.getStatus())
                        .bind("avatar_url", user.getAvatar_url())
                        .execute() > 0
        );
    }

    public boolean updateAdminUserDetails(
            User user, boolean updatePassword) {

        String sql;

        if (updatePassword) {
            sql = "UPDATE users SET " +
                    "full_name = :full_name, " +
                    "email = :email, " +
                    "role = :role, " +
                    "avatar_url = :avatar_url, " +
                    "hash_password = :hash_password " +
                    "WHERE id = :id AND status <> 'DELETED'";
        } else {
            sql = "UPDATE users SET " +
                    "full_name = :full_name, " +
                    "email = :email, " +
                    "role = :role, " +
                    "avatar_url = :avatar_url " +
                    "WHERE id = :id AND status <> 'DELETED'";
        }

        return get().withHandle(handle -> {
            var update = handle.createUpdate(sql)
                    .bind("full_name", user.getFull_name())
                    .bind("email", user.getEmail())
                    .bind("role", user.getRole())
                    .bind("avatar_url", user.getAvatar_url())
                    .bind("id", user.getId());

            if (updatePassword) {
                update.bind("hash_password", user.getHash_password());
            }

            return update.execute() > 0;
        });
    }
}
