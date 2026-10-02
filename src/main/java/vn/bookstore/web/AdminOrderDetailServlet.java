package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.model.Order;
import vn.bookstore.model.User;

@WebServlet("/admin/order")
public class AdminOrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User me = (User) req.getSession().getAttribute("me");
        if (me == null || !me.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        try {
            long orderId = Long.parseLong(idStr);
            Order order = orderDAO.findById(orderId);

            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng");
                return;
            }

            req.setAttribute("order", order);
            req.setAttribute("items", order.getItems());
            req.setAttribute("pageTitle", "Chi tiết đơn hàng #" + orderId);
            req.setAttribute("body", "/WEB-INF/admin/order_detail_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}