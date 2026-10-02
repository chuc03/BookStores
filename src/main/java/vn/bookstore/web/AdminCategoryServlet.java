/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package vn.bookstore.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


/**
 *
 * @author Admin
 */
@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            vn.bookstore.dao.CategoryDAO dao = new vn.bookstore.dao.CategoryDAO();
            int page = 1; int pageSize = 10;
            try {
                String p = req.getParameter("page");
                String ps = req.getParameter("pageSize");
                if (p != null) page = Math.max(1, Integer.parseInt(p));
                if (ps != null) pageSize = Math.max(1, Integer.parseInt(ps));
            } catch (NumberFormatException ex) { ex.printStackTrace(); }
            String q = req.getParameter("q");
            String editIdStr = req.getParameter("editId");
            if (editIdStr != null) {
                try {
                    int editId = Integer.parseInt(editIdStr);
                    vn.bookstore.dao.CategoryDAO cdao = new vn.bookstore.dao.CategoryDAO();
                    vn.bookstore.model.Category editCategory = cdao.findById(editId);
                    req.setAttribute("editCategory", editCategory);
                } catch (NumberFormatException ex) { ex.printStackTrace(); }
            }
            int totalItems = dao.count(q);
            int totalPages = Math.max(1, (int)Math.ceil((double) totalItems / pageSize));
            if (page > totalPages) page = totalPages;
            int offset = (page - 1) * pageSize;
            java.util.List<vn.bookstore.model.Category> categories = dao.findPage(q, offset, pageSize);
            req.setAttribute("categories", categories);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalItems", totalItems);
            req.setAttribute("pageTitle", "Admin - Danh mục");
            req.setAttribute("body", "/WEB-INF/admin/categories.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        vn.bookstore.util.FlashMessage.FlashMessages flash = new vn.bookstore.util.FlashMessage.FlashMessages();
        try {
            String idStr = req.getParameter("id");
            String name = req.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                flash.addError("Tên danh mục không được để trống.");
                req.getSession().setAttribute("flashMessages", flash.getMessages());
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }
            vn.bookstore.dao.CategoryDAO dao = new vn.bookstore.dao.CategoryDAO();
            if (idStr == null || idStr.isEmpty()) {
                int id = dao.create(name.trim());
                if (id > 0) flash.addSuccess("Thêm danh mục thành công.");
                else flash.addError("Không thể thêm danh mục.");
            } else {
                try {
                    int id = Integer.parseInt(idStr);
                    boolean ok = dao.update(id, name.trim());
                    if (ok) flash.addSuccess("Cập nhật danh mục thành công.");
                    else flash.addError("Không thể cập nhật danh mục.");
                } catch (NumberFormatException ex) { flash.addError("ID danh mục không hợp lệ."); }
            }
        } catch (Exception e) {
            flash.addError("Lỗi hệ thống: " + e.getMessage());
        }
        req.getSession().setAttribute("flashMessages", flash.getMessages());
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }
}
