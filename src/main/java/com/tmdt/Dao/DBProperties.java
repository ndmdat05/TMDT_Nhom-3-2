package com.tmdt.Dao;

import java.io.IOException;
import java.util.Properties;

public class DBProperties {
    private static Properties prop = new Properties();
    static {
        try{
            prop.load(DBProperties.class.getClassLoader().getResourceAsStream("db.properties"));
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }
    public static String host() {
        return prop.get("db.host").toString();
    }
    public static int port() {
        try{
            return Integer.parseInt(prop.get("db.port").toString());
        }
        catch (NumberFormatException e){
            return 3306;
        }
    }
    public static String username(){
        return prop.get("db.username").toString();
    }
    public static String password(){
        return prop.getProperty("db.password", "");
    }

    public static String dbname(){
        return "mangazdb";
    }
    public static String option(){
        return prop.get("db.option").toString();
    }
    public static void main(String[] args) {
        com.tmdt.db.JDBIConnector.get().useHandle(handle -> {
            System.out.println("Kết nối MySQL thành công!");
        });
    }

}
