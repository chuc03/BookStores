package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.BookDAO;
import vn.bookstore.model.User;

@WebServlet("/admin/book/delete")
public class AdminBookDeleteServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User me = (User) req.getSession().getAttribute("me");
        if (me == null || !"ADMIN".equals(me.getRoleCode())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            boolean ok = bookDAO.softDelete(id);
            resp.setContentType("application/json;charset=UTF-8");
            if (ok) resp.getWriter().write("{\"success\":true}");
            else { resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); resp.getWriter().write("{\"success\":false}"); }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
