package vn.edu.bookstore.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DB_24133063 {

    private DB_24133063() {
    }

    public static Connection open() throws SQLException {
        String host = System.getenv().getOrDefault("DB_HOST", "localhost");
        String port = System.getenv().getOrDefault("DB_PORT", "1433");
        String name = System.getenv().getOrDefault("DB_NAME", "BookStore_24133063");
        String user = System.getenv().getOrDefault("DB_USER", "sa");
        String pass = System.getenv("DB_PASSWORD");

        if (pass == null) {
            throw new SQLException("Set DB_PASSWORD in Tomcat environment");
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Tomcat chưa nạp thư viện mssql-jdbc", e);
        }

        String url = "jdbc:sqlserver://" + host + ":" + port
                + ";databaseName=" + name
                + ";encrypt=true;trustServerCertificate=true";

        return DriverManager.getConnection(url, user, pass);
    }
}