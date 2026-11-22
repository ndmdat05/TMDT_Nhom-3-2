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
    private String verify_token;
    private boolean is_verified;
    private String hash_password;
    private String auth_provider;
    private String phone_number;
    private String address;
    private String avatar_url;

    public User() {
    }

    public User(String full_name, String username, String email, String hash_password, String role,
                boolean is_verified, String verify_token, String auth_provider, String phone_number,
                String address, String status) {
        this.full_name = full_name;
        this.username = username;
        this.email = email;
        this.hash_password = hash_password;
        this.role = role;
        this.is_verified = is_verified;
        this.verify_token = verify_token;
        this.auth_provider = auth_provider;
        this.phone_number = phone_number;
        this.address = address;
        this.status = status;
    }

    public User(int id, String full_name, String username, String email, String hash_password, String role,
                boolean is_verified, String verify_token, String auth_provider, String phone_number,
                String address, String avatar_url, String status) {
        this.id = id;
        this.full_name = full_name;
        this.username = username;
        this.email = email;
        this.hash_password = hash_password;
        this.role = role;
        this.is_verified = is_verified;
        this.verify_token = verify_token;
        this.auth_provider = auth_provider;
        this.phone_number = phone_number;
        this.address = address;
        this.avatar_url = avatar_url;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public String getFull_name() {
        return full_name;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getRole() {
        return role;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public String getStatus() {
        return status;
    }

    public String getVerify_token() {
        return verify_token;
    }

    public boolean isIs_verified() {
        return is_verified;
    }

    public String getHash_password() {
        return hash_password;
    }

    public String getAuth_provider() {
        return auth_provider;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public String getAddress() {
        return address;
    }

    public String getAvatar_url() {
        return avatar_url;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setVerify_token(String verify_token) {
        this.verify_token = verify_token;
    }

    public void setIs_verified(boolean is_verified) {
        this.is_verified = is_verified;
    }

    public void setHash_password(String hash_password) {
        this.hash_password = hash_password;
    }

    public void setAuth_provider(String auth_provider) {
        this.auth_provider = auth_provider;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setAvatar_url(String avatar_url) {
        this.avatar_url = avatar_url;
    }
}