package com.tmdt.Dao;
import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import java.sql.SQLException;

public abstract class BaseDao {
    private Jdbi jdbi;
    protected Jdbi get() {
        if (jdbi == null) {
            MakeConnectest();
        }
        return jdbi;
    }
    private  void MakeConnectest(){
        MysqlDataSource src = new MysqlDataSource();
        String url = "jdbc:mysql://" + DBProperties.host() + ":" + DBProperties.port() + "/"  + DBProperties.dbname() + "?" + DBProperties.option();
        src.setURL(url);
        src.setUser(DBProperties.username());
        src.setPassword(DBProperties.password());

        System.out.println("URL = " + url);
        System.out.println("USER = " + DBProperties.username());
        System.out.println("PASS = " + DBProperties.password());
        try{
            src.setUseCompression(true);
            src.setAutoReconnect(true);

        }
        catch (SQLException e){
            throw new RuntimeException(e);
        }
        jdbi = Jdbi.create(src);

    }



}
