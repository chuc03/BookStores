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
 * Update Profile Servlet
 * Cập nhật thông tin tài khoản
 */
@WebServlet("/account/update-profile")
public class UpdateProfileServlet extends HttpServlet {

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

        // Load fresh user data
        try {
            User freshUser = userDAO.findById(user.getId());
            if (freshUser != null) {
                req.setAttribute("userData", freshUser);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        req.setAttribute("pageTitle", "Cập nhật thông tin");
        req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
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

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập họ tên");
            req.setAttribute("pageTitle", "Cập nhật thông tin");
            req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email");
            req.setAttribute("pageTitle", "Cập nhật thông tin");
            req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        // Email format validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            req.setAttribute("error", "Email không hợp lệ");
            req.setAttribute("pageTitle", "Cập nhật thông tin");
            req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        try {
            // Check if email is already used by another user
            User existingUser = userDAO.findByEmail(email.trim().toLowerCase());
            if (existingUser != null && existingUser.getId() != user.getId()) {
                req.setAttribute("error", "Email này đã được sử dụng bởi tài khoản khác");
                req.setAttribute("pageTitle", "Cập nhật thông tin");
                req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
                req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
                return;
            }

            boolean success = userDAO.updateUser(user.getId(), email, fullName, phone);

            if (success) {
                // Update session with new data
                user.setEmail(email.trim().toLowerCase());
                user.setFullName(fullName.trim());
                user.setPhone(phone != null ? phone.trim() : null);
                session.setAttribute("user", user);

                resp.sendRedirect(req.getContextPath() + "/account?success=profile_updated");
            } else {
                req.setAttribute("error", "Cập nhật thông tin thất bại");
                req.setAttribute("pageTitle", "Cập nhật thông tin");
                req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
                req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.setAttribute("pageTitle", "Cập nhật thông tin");
            req.setAttribute("body", "/WEB-INF/views/update_profile_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        }
    }
}
