package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/category/delete")
public class AdminCategoryDeleteServlet extends HttpServlet {

    private final vn.bookstore.dao.CategoryDAO dao = new vn.bookstore.dao.CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        resp.setContentType("application/json;charset=UTF-8");
        if (idStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false}");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = dao.delete(id);
            if (ok) resp.getWriter().write("{\"success\":true}");
            else { resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); resp.getWriter().write("{\"success\":false}"); }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
