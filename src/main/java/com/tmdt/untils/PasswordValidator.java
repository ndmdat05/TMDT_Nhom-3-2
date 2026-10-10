package com.tmdt.untils;

public class PasswordValidator {
    public boolean isValid(String pw){
        if(pw==null) return false;
        String check = "^(?=.*[a-z])(?=.*[A-Z]).{9,}$";
        return pw.matches(check);

    }
}
