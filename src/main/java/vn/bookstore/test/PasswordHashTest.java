package vn.bookstore.test;

import vn.bookstore.util.Passwords;

/**
 * Test class to generate password hashes
 * Run this to get correct bcrypt hashes for database
 */
public class PasswordHashTest {

    public static void main(String[] args) {
        // Test passwords
        String[] passwords = { "123456", "admin", "Admin@123" };

        System.out.println("=".repeat(60));
        System.out.println("PASSWORD HASH GENERATOR");
        System.out.println("=".repeat(60));

        for (String pwd : passwords) {
            String hash = Passwords.hash(pwd);
            boolean verified = Passwords.verify(pwd, hash);

            System.out.println("\nPassword: " + pwd);
            System.out.println("Hash: " + hash);
            System.out.println("Length: " + hash.length());
            System.out.println("Verified: " + verified);
            System.out.println("-".repeat(60));
        }

        // Test existing hashes from SQL
        System.out.println("\n" + "=".repeat(60));
        System.out.println("TESTING EXISTING HASHES");
        System.out.println("=".repeat(60));

        String hash123456 = "$2a$12$eImiTXuWVxfM37uY4JANjQ1JbXV3lQwTkUQJx.rFJZSiso29YtOki";
        String hashAdmin = "$2a$10$N9qo8uLOickgx2ZMRZoMye6IVI564JjEe6VMGqN3XGrjJEuBLqFZO";

        System.out.println("\nTesting hash for '123456':");
        System.out.println("Hash: " + hash123456);
        System.out.println("Verify '123456': " + Passwords.verify("123456", hash123456));
        System.out.println("Verify 'admin': " + Passwords.verify("admin", hash123456));

        System.out.println("\nTesting hash for 'admin':");
        System.out.println("Hash: " + hashAdmin);
        System.out.println("Verify 'admin': " + Passwords.verify("admin", hashAdmin));
        System.out.println("Verify '123456': " + Passwords.verify("123456", hashAdmin));

        System.out.println("\n" + "=".repeat(60));
        System.out.println("SQL INSERT STATEMENT:");
        System.out.println("=".repeat(60));
        String newHash = Passwords.hash("123456");
        System.out.println("\nINSERT INTO Users (username, email, password_hash, full_name, role, email_verified)");
        System.out.println("VALUES ('admin', 'admin@bookstore.com', '" + newHash + "', N'Administrator', 'ADMIN', 1);");
    }
}
