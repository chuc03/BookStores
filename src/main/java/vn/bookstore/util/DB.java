package vn.bookstore.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DB {
    private DB() {}

    // Sửa theo máy bạn
    private static final String URL =
            "jdbc:sqlserver://localhost:1433;databaseName=BookStoreDB;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }

}
