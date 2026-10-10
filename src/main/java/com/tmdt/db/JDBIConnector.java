package com.tmdt.db;

import com.mysql.cj.jdbc.MysqlDataSource;
import com.tmdt.Dao.DBProperties;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;

import java.sql.SQLException;

public class JDBIConnector {
    private static Jdbi jdbi;

    private static void makeConnect() {
        MysqlDataSource dataSource = new MysqlDataSource();
        String url = "jdbc:mysql://"
                + DBProperties.host() + ":"
                + DBProperties.port() + "/"
                + DBProperties.dbname() + "?"
                + DBProperties.option();
        dataSource.setURL(url);
        dataSource.setUser(DBProperties.username());
        dataSource.setPassword(DBProperties.password());

        try {
            dataSource.setAutoReconnect(true);
            dataSource.setUseCompression(true);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        jdbi = Jdbi.create(dataSource);
        jdbi.installPlugin(new SqlObjectPlugin());
    }

    private JDBIConnector() {}

    public static Jdbi get() {
        if (jdbi == null) makeConnect();
        return jdbi;
    }
}