package vn.bookstore.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.model.Order;
import vn.bookstore.model.User;

/**
 * Admin Orders Management Servlet
 */
@WebServlet("/admin/orders")
public class AdminOrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("me");
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String searchQuery = req.getParameter("q");
        String pageSizeStr = req.getParameter("pageSize");
        String pageStr = req.getParameter("page");

        int pageSize = 10;
        if (pageSizeStr != null) {
            try {
                pageSize = Integer.parseInt(pageSizeStr);
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }

        int currentPage = 1;
        if (pageStr != null) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1)
                    currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        try {
            List<Order> orders;
            int totalOrders;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                orders = orderDAO.searchOrders(searchQuery, (currentPage - 1) * pageSize, pageSize);
                totalOrders = orderDAO.countSearchOrders(searchQuery);
            } else {
                orders = orderDAO.findAll((currentPage - 1) * pageSize, pageSize);
                totalOrders = orderDAO.countAll();
            }

            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

            req.setAttribute("orders", orders);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("pageTitle", "Quản lý đơn hàng");
            req.setAttribute("body", "/WEB-INF/admin/orders_body.jsp");

            req.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải danh sách đơn hàng: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(req, resp);
        }
    }
}
