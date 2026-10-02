package vn.bookstore.util;

import java.text.Normalizer;
import java.util.regex.Pattern;

public class SlugUtil {

    /**
     * Convert Vietnamese text to URL-friendly slug
     * Example: "Sách Tiếng Việt" -> "sach-tieng-viet"
     */
    public static String toSlug(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "";
        }

        String slug = text.toLowerCase().trim();

        // Replace Vietnamese characters
        slug = slug.replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a");
        slug = slug.replaceAll("[èéẹẻẽêềếệểễ]", "e");
        slug = slug.replaceAll("[ìíịỉĩ]", "i");
        slug = slug.replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o");
        slug = slug.replaceAll("[ùúụủũưừứựửữ]", "u");
        slug = slug.replaceAll("[ỳýỵỷỹ]", "y");
        slug = slug.replaceAll("đ", "d");

        // Remove accents from remaining characters
        slug = Normalizer.normalize(slug, Normalizer.Form.NFD);
        slug = Pattern.compile("\\p{InCombiningDiacriticalMarks}+").matcher(slug).replaceAll("");

        // Replace spaces and special characters with hyphens
        slug = slug.replaceAll("[^a-z0-9]+", "-");

        // Remove leading/trailing hyphens
        slug = slug.replaceAll("^-+|-+$", "");

        // Replace multiple consecutive hyphens with single hyphen
        slug = slug.replaceAll("-+", "-");

        return slug;
    }
}
