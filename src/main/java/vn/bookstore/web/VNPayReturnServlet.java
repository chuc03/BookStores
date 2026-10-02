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
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.util.VNPayConfig;
import vn.bookstore.util.VNPayUtil;

/**
 * VNPay Return/Callback Servlet
 * Xử lý response từ VNPay sau khi thanh toán
 */
@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Lấy tất cả parameters từ VNPay
        Map<String, String> fields = new HashMap<>();
        for (Map.Entry<String, String[]> entry : req.getParameterMap().entrySet()) {
            String fieldName = entry.getKey();
            String fieldValue = entry.getValue()[0];
            if (fieldValue != null && fieldValue.length() > 0) {
                fields.put(fieldName, fieldValue);
            }
        }

        // Lấy secure hash từ VNPay
        String vnpSecureHash = req.getParameter("vnp_SecureHash");

        // Kiểm tra vnpSecureHash không null
        if (vnpSecureHash == null || vnpSecureHash.isEmpty()) {
            session.setAttribute("flashMessages", java.util.List.of(
                    new vn.bookstore.util.FlashMessage(
                            vn.bookstore.util.FlashMessage.MessageType.ERROR,
                            "Thiếu thông tin xác thực thanh toán.")));
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // Remove hash fields
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // Build hash data
        StringBuilder hashData = new StringBuilder();
        fields.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .forEach(entry -> {
                    try {
                        if (hashData.length() > 0) {
                            hashData.append('&');
                        }
                        hashData.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
                        hashData.append('=');
                        hashData.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                });

        // Verify signature
        String signValue = VNPayUtil.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());

        // Get transaction info
        String vnpTxnRef = req.getParameter("vnp_TxnRef"); // Order ID
        String vnpResponseCode = req.getParameter("vnp_ResponseCode");
        String vnpTransactionNo = req.getParameter("vnp_TransactionNo");
        String vnpAmount = req.getParameter("vnp_Amount");

        if (signValue.equalsIgnoreCase(vnpSecureHash)) {
            // Signature hợp lệ
            if ("00".equals(vnpResponseCode)) {
                // Thanh toán thành công
                try {
                    // Validate và parse orderId
                    if (vnpTxnRef == null || vnpTxnRef.isEmpty()) {
                        throw new IllegalArgumentException("Order ID không hợp lệ");
                    }
                    Long orderId = Long.parseLong(vnpTxnRef);
                    boolean updated = orderDAO.updatePaymentStatus(
                            orderId,
                            "PAID",
                            vnpTransactionNo);

                    if (updated) {
                        // Xóa session checkout
                        session.removeAttribute("vnpay_order_info");
                        session.removeAttribute("vnpay_amount");
                        session.removeAttribute("vnpay_order_id");
                        session.removeAttribute("checkoutData");

                        // Redirect tới trang success
                        resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);
                        return;
                    } else {
                        // Cập nhật thất bại
                        session.setAttribute("flashMessages", java.util.List.of(
                                new vn.bookstore.util.FlashMessage(
                                        vn.bookstore.util.FlashMessage.MessageType.ERROR,
                                        "Không thể cập nhật trạng thái đơn hàng. Vui lòng liên hệ hỗ trợ.")));
                        resp.sendRedirect(req.getContextPath() + "/checkout");
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    session.setAttribute("flashMessages", java.util.List.of(
                            new vn.bookstore.util.FlashMessage(
                                    vn.bookstore.util.FlashMessage.MessageType.ERROR,
                                    "Mã đơn hàng không hợp lệ.")));
                    resp.sendRedirect(req.getContextPath() + "/checkout");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("flashMessages", java.util.List.of(
                            new vn.bookstore.util.FlashMessage(
                                    vn.bookstore.util.FlashMessage.MessageType.ERROR,
                                    "Có lỗi xảy ra khi xử lý thanh toán.")));
                    resp.sendRedirect(req.getContextPath() + "/checkout");
                    return;
                }
            } else {
                // Thanh toán thất bại
                String errorMessage = getErrorMessage(vnpResponseCode);
                session.setAttribute("flashMessages", java.util.List.of(
                        new vn.bookstore.util.FlashMessage(
                                vn.bookstore.util.FlashMessage.MessageType.ERROR,
                                "Thanh toán thất bại: " + errorMessage)));
                resp.sendRedirect(req.getContextPath() + "/checkout");
                return;
            }
        } else {
            // Signature không hợp lệ - có thể bị giả mạo
            session.setAttribute("flashMessages", java.util.List.of(
                    new vn.bookstore.util.FlashMessage(
                            vn.bookstore.util.FlashMessage.MessageType.ERROR,
                            "Xác thực thanh toán không hợp lệ. Vui lòng liên hệ hỗ trợ.")));
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }
    }

    /**
     * Get error message from VNPay response code
     */
    private String getErrorMessage(String responseCode) {
        switch (responseCode) {
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09":
                return "Thẻ/Tài khoản chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
            case "10":
                return "Xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11":
                return "Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.";
            case "12":
                return "Thẻ/Tài khoản bị khóa.";
            case "13":
                return "Mật khẩu OTP không đúng.";
            case "24":
                return "Khách hàng hủy giao dịch.";
            case "51":
                return "Tài khoản không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Tài khoản đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì.";
            case "79":
                return "Nhập sai mật khẩu quá số lần quy định.";
            default:
                return "Giao dịch thất bại. Mã lỗi: " + responseCode;
        }
    }
}
