package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.model.User;

@WebServlet("/order/cancel")
public class OrderCancelServlet extends HttpServlet {

    private final vn.bookstore.dao.OrderDAO orderDAO = new vn.bookstore.dao.OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        User me = (User) req.getSession().getAttribute("me");
        if (me == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"success\":false}");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false}");
            return;
        }

        try {
            long id = Long.parseLong(idStr);
            vn.bookstore.model.Order order = orderDAO.findById(id);
            if (order == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"success\":false}");
                return;
            }
            Integer ownerId = order.getUserId();
            if (ownerId == null || ownerId.intValue() != me.getId()) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("{\"success\":false}");
                return;
            }

            String status = order.getOrderStatus();
            if (!("NEW".equals(status) || "UNPAID".equals(status))) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"error\":\"Cannot cancel\"}");
                return;
            }

            boolean ok = orderDAO.updateOrderStatus(id, "CANCELLED");
            if (ok) {
                // RESTORE STOCK for cancelled items
                try {
                    orderDAO.restoreStockForCancelledOrder(id);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    // Log but don't fail the cancellation
                }
                // record history: old -> CANCELLED
                try {
                    orderDAO.recordStatusChange(id, status, "CANCELLED", me != null ? me.getId() : null);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                // send confirmation email to the user if registered
                try {
                    if (ownerId != null) {
                        UserDAO udao = new UserDAO();
                        User u = udao.findById(ownerId);
                        if (u != null && u.getEmail() != null && !u.getEmail().isBlank()) {
                            String subject = "Xác nhận hủy đơn hàng #" + id;
                            // build richer HTML email with order items
                            StringBuilder html = new StringBuilder();
                            html.append("<div style=\"font-family:Arial,Helvetica,sans-serif;color:#111\">\n");
                            html.append("<h3>Đơn hàng #" + id + " đã được hủy</h3>\n");
                            html.append("<p>Xin chào " + (u.getFullName() != null ? u.getFullName() : "") + ",</p>\n");
                            html.append(
                                    "<p>Đơn hàng của bạn đã được hủy theo yêu cầu. Chi tiết đơn hàng như sau:</p>\n");
                            html.append("<table style=\"width:100%;border-collapse:collapse;\">\n");
                            html.append(
                                    "<thead><tr style=\"background:#f5f5f5;\"><th style=\"padding:8px;border:1px solid #ddd;text-align:left\">Sách</th><th style=\"padding:8px;border:1px solid #ddd;text-align:right\">Số lượng</th><th style=\"padding:8px;border:1px solid #ddd;text-align:right\">Đơn giá</th></tr></thead>\n");
                            html.append("<tbody>\n");
                            double total = 0.0;
                            vn.bookstore.model.Order full = order; // already populated with items
                            if (full.getItems() != null) {
                                for (vn.bookstore.model.OrderItem it : full.getItems()) {
                                    html.append("<tr>");
                                    html.append("<td style=\"padding:8px;border:1px solid #ddd;\">"
                                            + escapeHtml(it.getBookTitle()) + "</td>");
                                    html.append("<td style=\"padding:8px;border:1px solid #ddd;text-align:right\">"
                                            + it.getQuantity() + "</td>");
                                    html.append("<td style=\"padding:8px;border:1px solid #ddd;text-align:right\">"
                                            + String.format("%,.0f", it.getUnitPrice()) + " đ</td>");
                                    html.append("</tr>\n");
                                    total += it.getUnitPrice() * it.getQuantity();
                                }
                            }
                            html.append("</tbody>\n");
                            html.append(
                                    "<tfoot><tr><td style=\"padding:8px;border:1px solid #ddd;\"></td><td style=\"padding:8px;border:1px solid #ddd;text-align:right\"><strong>Tổng</strong></td><td style=\"padding:8px;border:1px solid #ddd;text-align:right\"><strong>"
                                            + String.format("%,.0f", total) + " đ</strong></td></tr></tfoot>\n");
                            html.append("</table>\n");
                            html.append(
                                    "<p>Nếu bạn cần trợ giúp, hãy trả lời email này hoặc truy cập trang hỗ trợ của chúng tôi.</p>\n");
                            html.append("<p>Trân trọng,<br/>BookStore</p>\n");
                            html.append("</div>");
                            try {
                                vn.bookstore.util.EmailUtil.sendHtmlEmail(req.getServletContext(), u.getEmail(),
                                        subject, html.toString());
                            } catch (Exception e) {
                                throw new ServletException(e);
                            }
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                resp.getWriter().write("{\"success\":true}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"success\":false}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // simple helper to escape HTML in email content
    private static String escapeHtml(String s) {
        if (s == null)
            return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'",
                "&#39;");
    }
}
