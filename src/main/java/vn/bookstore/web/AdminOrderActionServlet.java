package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.model.User;

@WebServlet("/admin/order/action")
public class AdminOrderActionServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User me = (User) req.getSession().getAttribute("me");
        if (me == null || !me.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        if (action == null || idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        try {
            long id = Long.parseLong(idStr);
            boolean ok = false;
            if ("ship".equalsIgnoreCase(action)) {
                ok = orderDAO.updateOrderStatus(id, "SHIPPED");
            } else if ("cancel".equalsIgnoreCase(action)) {
                ok = orderDAO.updateOrderStatus(id, "CANCELLED");
            } else if ("complete".equalsIgnoreCase(action)) {
                ok = orderDAO.updateOrderStatus(id, "DELIVERED");
            }
            resp.setContentType("application/json;charset=UTF-8");
            if (ok) {
                resp.getWriter().write("{\"success\":true}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json;charset=UTF-8");
            String msg = e.getMessage();
            if (msg != null) {
                msg = msg.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
            } else {
                msg = "Unknown error";
            }
            resp.getWriter().write("{\"success\":false,\"message\":\"" + msg + "\"}");
        }
    }
}
