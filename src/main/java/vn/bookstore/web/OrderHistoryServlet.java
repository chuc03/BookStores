/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.model.User;

/**
 *
 * @author Admin
 */
@WebServlet("/orders")
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User me = (User) req.getSession().getAttribute("me");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            vn.bookstore.dao.OrderDAO dao = new vn.bookstore.dao.OrderDAO();
            java.util.List<vn.bookstore.model.Order> allOrders = dao.findByUserId(me.getId());

            // Calculate stats from all orders
            int totalOrders = allOrders.size();
            int pendingCount = 0;
            int shippedCount = 0;
            int cancelledCount = 0;

            for (vn.bookstore.model.Order order : allOrders) {
                String status = order.getOrderStatus();
                if ("NEW".equals(status) || "UNPAID".equals(status)) {
                    pendingCount++;
                } else if ("SHIPPED".equals(status)) {
                    shippedCount++;
                } else if ("CANCELLED".equals(status)) {
                    cancelledCount++;
                }
            }

            // Filter by status if provided
            String statusFilter = req.getParameter("status");
            java.util.List<vn.bookstore.model.Order> orders = allOrders;

            if (statusFilter != null && !"all".equalsIgnoreCase(statusFilter)) {
                orders = new java.util.ArrayList<>();
                for (vn.bookstore.model.Order order : allOrders) {
                    if (statusFilter.equalsIgnoreCase(order.getOrderStatus())) {
                        orders.add(order);
                    }
                }
            }

            req.setAttribute("orders", orders);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("pendingCount", pendingCount);
            req.setAttribute("shippedCount", shippedCount);
            req.setAttribute("cancelledCount", cancelledCount);
            req.setAttribute("pageTitle", "Đơn hàng của tôi");
            req.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
