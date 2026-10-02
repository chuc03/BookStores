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
import vn.bookstore.model.SalesStat;

@WebServlet(urlPatterns = { "/admin/stats" })
public class AdminStatsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDao = new OrderDAO();
        try {
            // show last 30 days by default
            List<SalesStat> stats = orderDao.getSalesByDays(30);
            request.setAttribute("stats", stats);
            request.setAttribute("pageTitle", "Thống kê doanh số");
            request.setAttribute("body", "/WEB-INF/admin/stats_body.jsp");
            request.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
