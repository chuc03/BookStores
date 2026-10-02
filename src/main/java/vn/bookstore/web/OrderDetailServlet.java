package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.model.Order;

@WebServlet("/order")
public class OrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Order order = orderDAO.findById(Long.parseLong(id));

            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // SECURITY: Check if user owns this order (unless admin)
            vn.bookstore.model.User me = (vn.bookstore.model.User) req.getSession().getAttribute("me");
            boolean isAdmin = (me != null && "ADMIN".equals(me.getRoleCode()));

            if (!isAdmin) {
                // Regular user: must own the order
                Integer orderUserId = order.getUserId();
                if (me == null || orderUserId == null || orderUserId.intValue() != me.getId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem đơn hàng này");
                    return;
                }
            }

            req.setAttribute("order", order);
            req.setAttribute("pageTitle", "Chi tiết đơn hàng");
            req.setAttribute("body", "/WEB-INF/views/order_detail_body.jsp");

            req.getRequestDispatcher("/WEB-INF/views/order_detail.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
