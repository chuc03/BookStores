package vn.bookstore.web;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.bookstore.dao.BookDAO;
import vn.bookstore.dao.CategoryDAO;
import vn.bookstore.model.Book;
import vn.bookstore.model.Category;

/**
 * Advanced Search Servlet with Filters
 * Hỗ trợ tìm kiếm nâng cao với filter giá, category, sắp xếp
 */
@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Get search parameters
            String query = req.getParameter("q");
            String categorySlug = req.getParameter("category");
            String minPriceStr = req.getParameter("minPrice");
            String maxPriceStr = req.getParameter("maxPrice");
            String sortBy = req.getParameter("sort"); // newest, price-asc, price-desc, name-asc

            // Pagination
            int page = 1;
            try {
                page = Integer.parseInt(req.getParameter("page"));
                if (page < 1)
                    page = 1;
            } catch (Exception ignored) {
            }

            int limit = 12;
            int offset = (page - 1) * limit;

            // Parse price filter
            Double minPrice = null;
            Double maxPrice = null;
            try {
                if (minPriceStr != null && !minPriceStr.isBlank()) {
                    minPrice = Double.parseDouble(minPriceStr);
                }
                if (maxPriceStr != null && !maxPriceStr.isBlank()) {
                    maxPrice = Double.parseDouble(maxPriceStr);
                }
            } catch (NumberFormatException e) {
                // Ignore invalid price
            }

            // Default sort
            if (sortBy == null || sortBy.isBlank()) {
                sortBy = "newest";
            }

            // Search with filters
            List<Book> books = bookDAO.searchWithFilters(query, categorySlug, minPrice, maxPrice, sortBy, offset,
                    limit);
            int totalBooks = bookDAO.countWithFilters(query, categorySlug, minPrice, maxPrice);
            int totalPages = (int) Math.ceil(totalBooks * 1.0 / limit);

            // Load all categories for filter
            List<Category> categories = categoryDAO.findAll();

            // Set attributes
            req.setAttribute("books", books);
            req.setAttribute("categories", categories);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalBooks", totalBooks);
            req.setAttribute("query", query);
            req.setAttribute("selectedCategory", categorySlug);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);
            req.setAttribute("sortBy", sortBy);

            req.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
