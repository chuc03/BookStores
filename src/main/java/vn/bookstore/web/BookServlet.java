package vn.bookstore.web;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.BookDAO;
import vn.bookstore.dao.ReviewDAO;
import vn.bookstore.dao.WishlistDAO;
import vn.bookstore.model.Book;
import vn.bookstore.model.BookReview;
import vn.bookstore.model.User;

@WebServlet("/book")
public class BookServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(final HttpServletRequest req, final HttpServletResponse resp)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");

        if (idRaw == null || idRaw.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu id sách");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Id không hợp lệ");
            return;
        }

        try {
            Book book = bookDAO.findById(id);
            if (book == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Load reviews
            List<BookReview> reviews = reviewDAO.findByBookId(id);
            req.setAttribute("reviews", reviews);

            // Check if current user has reviewed this book
            HttpSession session = req.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("me");
                if (user != null) {
                    req.setAttribute("user", user); // Pass user to JSP
                    BookReview userReview = reviewDAO.findByUserAndBook(user.getId(), id);
                    req.setAttribute("userReview", userReview);

                    // Check if book is in wishlist
                    boolean isInWishlist = wishlistDAO.isInWishlist(user.getId(), id);
                    req.setAttribute("isInWishlist", isInWishlist);
                }
            }

            req.setAttribute("book", book);
            req.getRequestDispatcher("/WEB-INF/views/book.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
