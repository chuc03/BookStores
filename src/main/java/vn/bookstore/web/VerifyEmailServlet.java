package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.model.User;
import vn.bookstore.util.FlashMessage;

@WebServlet("/verify-email")
public class VerifyEmailServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        HttpSession session = req.getSession();
        FlashMessage.FlashMessages flashMessages = new FlashMessage.FlashMessages();

        if (token == null || token.isBlank()) {
            flashMessages.addError("Token xác nhận không hợp lệ.");
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Find user by verification token
            User user = userDAO.findByEmailVerificationToken(token);

            if (user == null) {
                flashMessages.addError("Token xác nhận không tìm thấy hoặc đã hết hạn.");
                session.setAttribute("flashMessages", flashMessages.getMessages());
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            // Mark email as verified
            boolean ok = userDAO.markEmailAsVerified(user.getId());

            if (ok) {
                flashMessages.addSuccess("Email đã được xác nhận thành công! Bạn có thể đăng nhập.");
                session.setAttribute("flashMessages", flashMessages.getMessages());
                resp.sendRedirect(req.getContextPath() + "/login");
            } else {
                flashMessages.addError("Không thể xác nhận email. Vui lòng thử lại.");
                session.setAttribute("flashMessages", flashMessages.getMessages());
                resp.sendRedirect(req.getContextPath() + "/login");
            }

        } catch (Exception e) {
            e.printStackTrace();
            flashMessages.addError("Lỗi hệ thống. Vui lòng thử lại sau.");
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
