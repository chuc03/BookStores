package vn.bookstore.web.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.model.User;

/**
 * Admin User Management Servlet
 * Quản lý users: xem danh sách, khóa/mở khóa, xóa, tìm kiếm
 */
@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("me");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRoleCode())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String keyword = req.getParameter("keyword");

        try {
            List<User> users;
            if (keyword != null && !keyword.trim().isEmpty()) {
                users = userDAO.search(keyword.trim());
                req.setAttribute("keyword", keyword);
            } else {
                users = userDAO.findAll();
            }
            req.setAttribute("users", users);
            req.setAttribute("pageTitle", "Quản lý Users");
            req.setAttribute("body", "/WEB-INF/admin/users.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải danh sách users: " + e.getMessage());
            req.setAttribute("pageTitle", "Quản lý Users");
            req.setAttribute("body", "/WEB-INF/admin/users.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("me");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRoleCode())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String action = req.getParameter("action");
        String userIdStr = req.getParameter("userId");

        if (action == null || userIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=invalid_request");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // Không cho phép thao tác trên chính mình
            if (userId == currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=cannot_modify_self");
                return;
            }

            boolean success = false;
            String message = "";

            switch (action) {
                case "toggle_status":
                    success = userDAO.toggleStatus(userId);
                    message = success ? "success=status_updated" : "error=update_failed";
                    break;

                case "delete":
                    success = userDAO.deleteUser(userId);
                    message = success ? "success=user_deleted" : "error=delete_failed";
                    break;

                default:
                    message = "error=invalid_action";
            }

            resp.sendRedirect(req.getContextPath() + "/admin/users?" + message);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=invalid_user_id");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=database_error");
        }
    }
}
