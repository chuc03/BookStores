package vn.bookstore.util;

import org.mindrot.jbcrypt.BCrypt;

public final class Passwords {
    private Passwords() {
    }

    public static String hash(String raw) {
        return BCrypt.hashpw(raw, BCrypt.gensalt(12));
    }

    public static boolean verify(String raw, String hash) {
        if (hash == null || hash.length() < 59) {
            return false;
        }
        try {
            return BCrypt.checkpw(raw, hash);
        } catch (Exception e) {
            // Invalid hash format
            return false;
        }
    }
}
