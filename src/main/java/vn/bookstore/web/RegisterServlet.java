package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.util.EmailUtil;
import vn.bookstore.util.FlashMessage;
import vn.bookstore.util.PasswordValidator;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        HttpSession session = req.getSession();
        FlashMessage.FlashMessages flashMessages = new FlashMessage.FlashMessages();

        // ===== VALIDATE =====
        if (fullName == null || fullName.isBlank()
                || email == null || email.isBlank()
                || password == null || password.isBlank()
                || confirm == null || confirm.isBlank()) {

            flashMessages.addError("Vui lòng nhập đầy đủ thông tin.");
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        // Validate strong password
        PasswordValidator.PasswordValidationResult pwdResult = PasswordValidator.validate(password);
        if (!pwdResult.isValid()) {
            for (String error : pwdResult.getErrorList()) {
                flashMessages.addError(error);
            }
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        if (!password.equals(confirm)) {
            flashMessages.addError("Mật khẩu nhập lại không khớp.");
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        try {
            // Check if email already exists
            if (userDAO.findByEmail(email) != null) {
                flashMessages.addError("Email này đã được đăng ký.");
                session.setAttribute("flashMessages", flashMessages.getMessages());
                resp.sendRedirect(req.getContextPath() + "/register");
                return;
            }

            // Register user with email verification
            boolean ok = userDAO.registerUser(email, password, fullName, phone);

            if (!ok) {
                flashMessages.addError("Không thể tạo tài khoản. Vui lòng thử lại.");
                session.setAttribute("flashMessages", flashMessages.getMessages());
                resp.sendRedirect(req.getContextPath() + "/register");
                return;
            }

            // Create email verification token
            String token = userDAO.createEmailVerificationToken(email);

            // Send verification email
            String verifyLink = req.getScheme() + "://" + req.getServerName() 
                + (req.getServerPort() != 80 && req.getServerPort() != 443 ? ":" + req.getServerPort() : "")
                + req.getContextPath() + "/verify-email?token=" + token;

            String emailBody = "<h3>Xác nhận email</h3>"
                + "<p>Xin chào " + fullName + ",</p>"
                + "<p>Vui lòng nhấp <a href=\"" + verifyLink + "\">vào đây</a> để xác nhận email của bạn.</p>"
                + "<p>Liên kết sẽ hết hạn sau 24 giờ.</p>";

            EmailUtil.sendHtmlEmail(req.getServletContext(), email, "Xác nhận email đăng ký", emailBody);

            // Success message with verification instruction
            flashMessages.addSuccess("Đăng ký thành công! Vui lòng kiểm tra email để xác nhận tài khoản.");
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (Exception e) {
            e.printStackTrace();
            flashMessages.addError("Lỗi hệ thống. Vui lòng thử lại sau.");
            session.setAttribute("flashMessages", flashMessages.getMessages());
            resp.sendRedirect(req.getContextPath() + "/register");
        }
    }
}
