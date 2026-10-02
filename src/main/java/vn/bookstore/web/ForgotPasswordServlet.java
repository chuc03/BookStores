package vn.bookstore.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.model.User;
import vn.bookstore.util.EmailUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet(urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("pageTitle", "Quên mật khẩu");
        req.setAttribute("body", "/WEB-INF/views/forgot.jsp");
        req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email");
            doGet(req, resp);
            return;
        }

        try {
            UserDAO userDao = new UserDAO();
            User u = userDao.findByEmail(email);
            if (u == null) {
                // don't reveal whether email exists
                req.setAttribute("message", "Nếu email tồn tại, bạn sẽ nhận được hướng dẫn qua email.");
                doGet(req, resp);
                return;
            }

            String token = UUID.randomUUID().toString();
            Timestamp expires = new Timestamp(System.currentTimeMillis() + 60L * 60L * 1000L); // 1 hour
            userDao.createPasswordResetToken(u.getId(), token, expires);

            String baseUrl = req.getServletContext().getInitParameter("site.baseUrl");
            if (baseUrl == null || baseUrl.isEmpty()) baseUrl = req.getRequestURL().toString().replace(req.getRequestURI(), "") + req.getContextPath();
            String resetLink = baseUrl + "/reset-password?token=" + token;

            String html = "<p>Xin chào " + u.getFullName() + ",</p>"
                    + "<p>Bạn (hoặc ai đó) đã yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Nhấp vào liên kết bên dưới để tạo mật khẩu mới (liên kết có hiệu lực 1 giờ):</p>"
                    + "<p><a href=\"" + resetLink + "\">Đặt lại mật khẩu</a></p>"
                    + "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, hãy bỏ qua email này.</p>";

            try {
                EmailUtil.sendHtmlEmail(getServletContext(), u.getEmail(), "Đặt lại mật khẩu BookStore", html);
            } catch (Exception ex) {
                // log error and continue (do not reveal details to user)
                getServletContext().log("Failed to send reset email to " + u.getEmail(), ex);
            }

            req.setAttribute("message", "Nếu email tồn tại, bạn sẽ nhận được hướng dẫn qua email.");
            doGet(req, resp);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
