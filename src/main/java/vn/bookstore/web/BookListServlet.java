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
import vn.bookstore.dao.BookDAO;
import vn.bookstore.dao.CategoryDAO;
import vn.bookstore.model.Category;

/**
 *
 * @author Admin
 */
@WebServlet("/books")
public class BookListServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("q");
        String categorySlug = req.getParameter("category");

        int page = 1;
        int pageSize = 12;
        String p = req.getParameter("page");
        if (p != null) {
            try {
                page = Math.max(1, Integer.parseInt(p));
            } catch (NumberFormatException ex) {
                ex.printStackTrace();
            }
        }

        try {
            Integer categoryId = null;
            Category category = null;

            // Get category if slug provided
            if (categorySlug != null && !categorySlug.isBlank()) {
                category = categoryDAO.findBySlug(categorySlug.trim());
                if (category != null) {
                    categoryId = category.getCategoryId();
                    req.setAttribute("selectedCategory", category);
                }
            }

            int total = bookDAO.count(keyword, categoryId);
            int totalPages = Math.max(1, (int) Math.ceil(total / (double) pageSize));
            if (page > totalPages)
                page = totalPages;
            int offset = (page - 1) * pageSize;

            req.setAttribute("books", bookDAO.findPage(keyword, categoryId, offset, pageSize));
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalItems", total);

            String pageTitle = "Danh sách sách";
            if (category != null) {
                pageTitle = "Danh mục: " + category.getName();
            }

            req.setAttribute("pageTitle", pageTitle);
            req.setAttribute("body", "/WEB-INF/views/books_body.jsp");

            req.getRequestDispatcher("/WEB-INF/views/books.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace(); // Print stack trace instead of throwing
        }
    }
}
