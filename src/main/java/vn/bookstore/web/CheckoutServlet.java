package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.model.Cart;
import vn.bookstore.model.User;

@WebServlet(urlPatterns = { "/checkout" })
public class CheckoutServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    private Cart cart(final HttpServletRequest req) {
        final HttpSession s = req.getSession();
        return (Cart) s.getAttribute("cart");
    }

    @Override
    protected void doGet(final HttpServletRequest req, final HttpServletResponse resp)
            throws ServletException, IOException {
        final Cart cart = cart(req);
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(final HttpServletRequest req, final HttpServletResponse resp)
            throws ServletException, IOException {
        final Cart cart = cart(req);
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String note = req.getParameter("note");
        String paymentMethod = req.getParameter("paymentMethod"); // COD | VNPAY

        // VALIDATION: Check required fields
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập họ tên");
            req.setAttribute("pageTitle", "Thanh toán");
            req.setAttribute("body", "/WEB-INF/views/checkout_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }
        if (phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập số điện thoại");
            req.setAttribute("pageTitle", "Thanh toán");
            req.setAttribute("body", "/WEB-INF/views/checkout_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }
        // Validate phone format (10-11 digits)
        if (!phone.trim().matches("^[0-9]{10,11}$")) {
            req.setAttribute("error", "Số điện thoại không hợp lệ (10-11 chữ số)");
            req.setAttribute("pageTitle", "Thanh toán");
            req.setAttribute("body", "/WEB-INF/views/checkout_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }
        if (address == null || address.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập địa chỉ giao hàng");
            req.setAttribute("pageTitle", "Thanh toán");
            req.setAttribute("body", "/WEB-INF/views/checkout_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }
        if (paymentMethod == null || (!"COD".equals(paymentMethod) && !"VNPAY".equals(paymentMethod))) {
            req.setAttribute("error", "Vui lòng chọn phương thức thanh toán");
            req.setAttribute("pageTitle", "Thanh toán");
            req.setAttribute("body", "/WEB-INF/views/checkout_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        try {
            User me = (User) req.getSession().getAttribute("me");
            Integer userId = (me == null) ? null : me.getId();

            long orderId = orderDAO.createOrder(userId, name, phone, address, note, paymentMethod, cart);

            // Xử lý theo phương thức thanh toán
            if ("VNPAY".equals(paymentMethod)) {
                // Lưu thông tin vào session để VNPayServlet sử dụng
                HttpSession session = req.getSession();
                session.setAttribute("vnpay_order_info", "Thanh toan don hang #" + orderId);
                session.setAttribute("vnpay_amount", (long) cart.getTotal());
                session.setAttribute("vnpay_order_id", String.valueOf(orderId));

                // Lưu dữ liệu checkout để restore nếu thanh toán thất bại
                session.setAttribute("checkoutData", new CheckoutData(name, phone, address, note));

                // Redirect tới VNPayServlet để tạo payment URL
                resp.sendRedirect(req.getContextPath() + "/vnpay-payment");
            } else {
                // COD - Redirect trực tiếp tới success
                req.getSession().removeAttribute("cart");
                resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Inner class để lưu checkout data
     */
    public static class CheckoutData {
        public String name, phone, address, note;

        public CheckoutData(String name, String phone, String address, String note) {
            this.name = name;
            this.phone = phone;
            this.address = address;
            this.note = note;
        }
    }
}
