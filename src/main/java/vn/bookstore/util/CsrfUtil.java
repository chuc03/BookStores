package vn.bookstore.util;

import java.security.SecureRandom;
import java.util.Base64;

import jakarta.servlet.http.HttpSession;

public class CsrfUtil {
    private static final SecureRandom random = new SecureRandom();

    public static String generateToken() {
        byte[] b = new byte[24];
        random.nextBytes(b);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(b);
    }

    public static String getOrCreateToken(HttpSession session) {
        Object t = session.getAttribute("csrfToken");
        if (t instanceof String) return (String) t;
        String token = generateToken();
        session.setAttribute("csrfToken", token);
        return token;
    }
}
