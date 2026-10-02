package vn.bookstore.test;

import java.sql.Connection;
import vn.bookstore.util.DB;

public class TestConnection {
    public static void main(String[] args) {
        try {
            Connection conn = DB.getConnection();
            System.out.println("✅ Database connection successful!");
            System.out.println("Database: " + conn.getCatalog());
            conn.close();
        } catch (Exception e) {
            System.err.println("❌ Database connection failed!");
            e.printStackTrace();
        }
    }
}
