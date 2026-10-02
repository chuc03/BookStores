package vn.bookstore.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.util.Passwords;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            var user = dao.findByResetToken(token);
            if (user == null) {
                req.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                req.setAttribute("pageTitle", "Đặt lại mật khẩu");
                req.setAttribute("body", "/WEB-INF/views/reset_invalid.jsp");
                req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("token", token);
            req.setAttribute("pageTitle", "Đặt lại mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/reset_password.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String password = req.getParameter("password");
        String password2 = req.getParameter("password2");

        if (token == null || token.isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Dữ liệu không hợp lệ");
            doGet(req, resp);
            return;
        }
        if (!password.equals(password2)) {
            req.setAttribute("error", "Mật khẩu không khớp");
            req.setAttribute("token", token);
            req.setAttribute("pageTitle", "Đặt lại mật khẩu");
            req.setAttribute("body", "/WEB-INF/views/reset_password.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            var user = dao.findByResetToken(token);
            if (user == null) {
                req.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                doGet(req, resp);
                return;
            }

            String hash = Passwords.hash(password);
            dao.updatePasswordAndClearToken(user.getId(), hash);
            resp.sendRedirect(req.getContextPath() + "/login?reset=ok");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
