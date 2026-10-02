package vn.bookstore.util;

/**
 * Password validation utility enforcing strong password policy.
 * Requirements:
 * - Minimum 6 characters
 * - At least one uppercase letter (A-Z)
 * - At least one lowercase letter (a-z)
 * - At least one digit (0-9)
 */
public class PasswordValidator {

    private static final int MIN_LENGTH = 6;
    private static final String SPECIAL_CHARS = "!@#$%^&*()_+-={}[]|:;<>?,./";

    /**
     * Validates password against the policy.
     * 
     * @param password Password to validate
     * @return PasswordValidationResult containing validation result and error
     *         messages
     */
    public static PasswordValidationResult validate(String password) {
        PasswordValidationResult result = new PasswordValidationResult();

        if (password == null || password.isEmpty()) {
            result.addError("Mật khẩu không được trống");
            return result;
        }

        if (password.length() < MIN_LENGTH) {
            result.addError("Mật khẩu phải có ít nhất " + MIN_LENGTH + " ký tự");
        }

        if (!password.matches(".*[A-Z].*")) {
            result.addError("Mật khẩu phải chứa ít nhất một chữ hoa (A-Z)");
        }

        if (!password.matches(".*[a-z].*")) {
            result.addError("Mật khẩu phải chứa ít nhất một chữ thường (a-z)");
        }

        if (!password.matches(".*\\d.*")) {
            result.addError("Mật khẩu phải chứa ít nhất một chữ số (0-9)");
        }

        return result;
    }

    private static boolean hasSpecialChar(String password) {
        for (char c : password.toCharArray()) {
            if (SPECIAL_CHARS.indexOf(c) >= 0) {
                return true;
            }
        }
        return false;
    }

    /**
     * Inner class for password validation result.
     */
    public static class PasswordValidationResult {
        private StringBuilder errors = new StringBuilder();
        private boolean valid = true;

        public void addError(String error) {
            this.valid = false;
            if (errors.length() > 0) {
                errors.append("\n");
            }
            errors.append(error);
        }

        public boolean isValid() {
            return valid;
        }

        public String getErrors() {
            return errors.toString();
        }

        public String[] getErrorList() {
            return errors.toString().split("\n");
        }
    }
}
