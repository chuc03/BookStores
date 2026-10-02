package vn.bookstore.util;

/**
 * VNPay Configuration
 * 
 * NOTE: Đây là cấu hình DEMO. Trong production cần:
 * - Lưu trong environment variables hoặc config file
 * - Sử dụng TMN Code và Hash Secret thực tế từ VNPay
 */
public class VNPayConfig {

    // VNPay Test Environment
    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_RETURN_URL = "http://localhost:8080/bookstore/vnpay-return";

    // Thông tin merchant (DEMO - cần thay bằng thông tin thật)
    public static final String VNP_TMN_CODE = "DEMO12345"; // Mã website tại VNPay
    public static final String VNP_HASH_SECRET = "SECRETKEY123456789"; // Chuỗi bí mật

    // Version
    public static final String VNP_VERSION = "2.1.0";
    public static final String VNP_COMMAND = "pay";
    public static final String VNP_ORDER_TYPE = "other";
    public static final String VNP_CURRENCY_CODE = "VND";
    public static final String VNP_LOCALE = "vn";

    /**
     * Lấy return URL đầy đủ dựa trên context
     * 
     * @param contextPath context path của ứng dụng
     * @return full return URL
     */
    public static String getReturnUrl(String contextPath) {
        // Trong production, nên dùng domain thật
        // Ví dụ: https://yourdomain.com + contextPath + /vnpay-return
        return "http://localhost:8080" + contextPath + "/vnpay-return";
    }
}
