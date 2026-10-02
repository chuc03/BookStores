/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package vn.bookstore.web;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.BookDAO;
import vn.bookstore.dao.CategoryDAO;
import vn.bookstore.dao.OrderDAO;
import vn.bookstore.model.BestSellingBook;
import vn.bookstore.model.Order;
import vn.bookstore.model.SalesStat;

/**
 *
 * @author Admin
 */
@WebServlet("/admin")
public class AdminHomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            OrderDAO orderDAO = new OrderDAO();
            BookDAO bookDAO = new BookDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            // Lấy thống kê 7 ngày gần nhất
            List<SalesStat> stats = orderDAO.getSalesByDays(7);

            // Tạo map để tra cứu nhanh theo ngày
            Map<String, SalesStat> statsMap = new HashMap<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (SalesStat stat : stats) {
                statsMap.put(sdf.format(stat.getDate()), stat);
            }

            // Chuẩn bị dữ liệu cho 7 ngày (từ T2 đến CN)
            Calendar cal = Calendar.getInstance();
            List<Map<String, Object>> chartData = new ArrayList<>();

            for (int i = 6; i >= 0; i--) {
                cal.add(Calendar.DAY_OF_YEAR, -i);
                String dateKey = sdf.format(cal.getTime());

                Map<String, Object> dayData = new HashMap<>();
                int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
                String[] dayNames = { "CN", "T2", "T3", "T4", "T5", "T6", "T7" };
                dayData.put("dayName", dayNames[dayOfWeek - 1]);

                SalesStat stat = statsMap.get(dateKey);
                if (stat != null) {
                    dayData.put("revenue", stat.getTotalAmount());
                    dayData.put("orders", stat.getOrderCount());
                } else {
                    dayData.put("revenue", 0.0);
                    dayData.put("orders", 0);
                }
                dayData.put("isToday", i == 0);

                chartData.add(dayData);
                cal = Calendar.getInstance(); // Reset calendar
            }

            // Thống kê tổng quan
            double todayRevenue = 0;
            int todayOrders = 0;
            double monthRevenue = 0;

            // Doanh thu hôm nay
            if (!stats.isEmpty() && stats.get(0) != null) {
                todayRevenue = stats.get(0).getTotalAmount();
                todayOrders = stats.get(0).getOrderCount();
            }

            // Doanh thu tháng này
            List<SalesStat> monthStats = orderDAO.getSalesByDays(30);
            for (SalesStat stat : monthStats) {
                monthRevenue += stat.getTotalAmount();
            }

            // Giá trị trung bình đơn hàng
            double avgOrderValue = todayOrders > 0 ? todayRevenue / todayOrders : 0;

            // Đếm sách và danh mục
            int totalBooks = bookDAO.countBooks();
            int totalCategories = categoryDAO.countAll();

            // Lấy chi tiết đơn hàng 5 ngày gần đây
            List<Order> recentOrders = orderDAO.findPage(0, 5);

            // Lấy top 4 sách bán chạy nhất
            List<BestSellingBook> bestSellingBooks = bookDAO.getBestSellingBooks(4);

            // Format number
            DecimalFormat df = new DecimalFormat("#,###");

            req.setAttribute("todayRevenue", df.format(todayRevenue / 1000000.0) + "M");
            req.setAttribute("monthRevenue", df.format(monthRevenue / 1000000000.0) + "B");
            req.setAttribute("todayOrders", todayOrders);
            req.setAttribute("avgOrderValue", df.format(avgOrderValue / 1000) + "K");
            req.setAttribute("totalBooks", totalBooks);
            req.setAttribute("totalCategories", totalCategories);
            req.setAttribute("chartData", chartData);
            req.setAttribute("recentOrders", recentOrders);
            req.setAttribute("bestSellingBooks", bestSellingBooks);

            req.setAttribute("body", "/WEB-INF/admin/index.jsp");
            req.setAttribute("currentPath", "/admin");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
