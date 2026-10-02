package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.UserDAO;
import vn.bookstore.model.User;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Object me = req.getSession().getAttribute("me");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.setAttribute("user", me);
        req.setAttribute("pageTitle", "Tài khoản");
        req.setAttribute("body", "/WEB-INF/views/account_body.jsp");
        req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Object o = req.getSession().getAttribute("me");
        if (o == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        User me = (User) o;
        String email = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        // VALIDATION
        if (email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/account?error=email_required");
            return;
        }
        // Validate email format
        if (!email.trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            resp.sendRedirect(req.getContextPath() + "/account?error=invalid_email");
            return;
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/account?error=name_required");
            return;
        }
        // Validate phone format if provided
        if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^[0-9]{10,11}$")) {
            resp.sendRedirect(req.getContextPath() + "/account?error=invalid_phone");
            return;
        }

        try {
            boolean ok = userDAO.updateUser(me.getId(), email, fullName, phone);
            if (ok) {
                // refresh session user
                me.setEmail(email);
                me.setFullName(fullName);
                me.setPhone(phone);
                req.getSession().setAttribute("me", me);
            }
            resp.sendRedirect(req.getContextPath() + "/account?success=true");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
