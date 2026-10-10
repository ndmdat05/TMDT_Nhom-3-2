package com.tmdt.Model;

import java.time.LocalDateTime;

public class User {
    private int id;
    private String full_name;
    private String username;
    private String email;
    private String role; // "ADMIN", "SELLER", "BUYER"
    private LocalDateTime created_at;
    private String status; // "ACTIVE", "LOCKED"
    String verify_token;
    boolean is_verified;
    String hash_password;
    private String auth_provider;

    public User() {}

    public User(String full_name, String username, String email,String hash_password, String role,boolean is_verified ,String verify_token,String auth_provider,String status) {
        this.id = id;
        this.full_name = full_name;
        this.username = username;
        this.email = email;
        this.role = role;
        this.verify_token = verify_token;
        this.is_verified = is_verified;
        this.hash_password = hash_password;
        this.status = status;
        this.auth_provider = auth_provider;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public String getVerify_token() {
        return verify_token;
    }

    public void setVerify_token(String verify_token) {
        this.verify_token = verify_token;
    }

    public boolean isIs_verified() {
        return is_verified;
    }

    public void setIs_verified(boolean is_verified) {
        this.is_verified = is_verified;
    }

    public String getHash_password() {
        return hash_password;
    }

    public void setHash_password(String hash_password) {
        this.hash_password = hash_password;
    }

    public String getAuth_provider() {
        return auth_provider;
    }

    public void setAuth_provider(String auth_provider) {
        this.auth_provider = auth_provider;
    }
}