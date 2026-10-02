package vn.bookstore.web;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.model.User;

/**
 * Change Password Servlet
 * Đổi mật khẩu cho user đã đăng nhập
 */
@WebServlet("/account/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("me");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("pageTitle", "Đổi mật khẩu");
        req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
        req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("me");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validation
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại");
            req.setAttribute("pageTitle", "Đổi mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            req.setAttribute("pageTitle", "Đổi mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
            req.setAttribute("pageTitle", "Đổi mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.setAttribute("pageTitle", "Đổi mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        if (oldPassword.equals(newPassword)) {
            req.setAttribute("error", "Mật khẩu mới phải khác mật khẩu hiện tại");
            req.setAttribute("pageTitle", "Đổi mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        try {
            boolean success = userDAO.changePassword(user.getId(), oldPassword, newPassword);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/account?success=password_changed");
            } else {
                req.setAttribute("error", "Mật khẩu hiện tại không đúng");
                req.setAttribute("pageTitle", "Đổi mật khẩu");
                req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
                req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.setAttribute("pageTitle", "Đổi mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/change_password_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        }
    }
}
