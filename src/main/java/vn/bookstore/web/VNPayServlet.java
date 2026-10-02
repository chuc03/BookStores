package vn.bookstore.web;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.util.VNPayConfig;
import vn.bookstore.util.VNPayUtil;

/**
 * VNPay Payment Gateway Servlet
 * Tạo URL thanh toán và redirect user tới VNPay
 */
@WebServlet("/vnpay-payment")
public class VNPayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Không cho phép truy cập trực tiếp bằng GET
        resp.sendRedirect(req.getContextPath() + "/checkout");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Lấy thông tin từ session (đã lưu từ CheckoutServlet)
        String orderInfo = (String) session.getAttribute("vnpay_order_info");
        Long amount = (Long) session.getAttribute("vnpay_amount");
        String orderId = (String) session.getAttribute("vnpay_order_id");

        if (orderInfo == null || amount == null || orderId == null || amount <= 0) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=invalid_payment");
            return;
        }

        try {
            // Build VNPay parameters
            Map<String, String> vnpParams = new HashMap<>();
            vnpParams.put("vnp_Version", VNPayConfig.VNP_VERSION);
            vnpParams.put("vnp_Command", VNPayConfig.VNP_COMMAND);
            vnpParams.put("vnp_TmnCode", VNPayConfig.VNP_TMN_CODE);
            vnpParams.put("vnp_Amount", String.valueOf(amount * 100)); // VNPay yêu cầu nhân 100
            vnpParams.put("vnp_CurrCode", VNPayConfig.VNP_CURRENCY_CODE);
            vnpParams.put("vnp_TxnRef", orderId); // Mã đơn hàng
            vnpParams.put("vnp_OrderInfo", orderInfo);
            vnpParams.put("vnp_OrderType", VNPayConfig.VNP_ORDER_TYPE);
            vnpParams.put("vnp_Locale", VNPayConfig.VNP_LOCALE);
            vnpParams.put("vnp_ReturnUrl", VNPayConfig.getReturnUrl(req.getContextPath()));
            vnpParams.put("vnp_IpAddr", getClientIP(req));
            vnpParams.put("vnp_CreateDate", VNPayUtil.getCurrentDateTime());

            // Build query string
            StringBuilder query = new StringBuilder();
            vnpParams.entrySet().stream()
                    .sorted(Map.Entry.comparingByKey())
                    .forEach(entry -> {
                        try {
                            if (query.length() > 0) {
                                query.append('&');
                            }
                            query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
                            query.append('=');
                            query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
                        } catch (Exception e) {
                            throw new RuntimeException(e);
                        }
                    });

            // Generate secure hash
            String queryString = query.toString();
            String vnpSecureHash = VNPayUtil.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, queryString);
            queryString += "&vnp_SecureHash=" + vnpSecureHash;

            // Build payment URL
            String paymentUrl = VNPayConfig.VNP_PAY_URL + "?" + queryString;

            // Redirect to VNPay
            resp.sendRedirect(paymentUrl);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/checkout?error=payment_failed");
        }
    }

    /**
     * Get client IP address
     */
    private String getClientIP(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}
