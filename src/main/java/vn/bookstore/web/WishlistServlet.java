package vn.bookstore.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.WishlistDAO;
import vn.bookstore.model.Book;
import vn.bookstore.model.User;

/**
 * Wishlist Servlet
 * Quản lý danh sách yêu thích của user
 */
@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("me");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Book> wishlistBooks = wishlistDAO.getWishlistByUserId(user.getId());
            req.setAttribute("wishlistBooks", wishlistBooks);
            req.setAttribute("pageTitle", "Danh sách yêu thích");
            req.setAttribute("body", "/WEB-INF/views/wishlist_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải wishlist: " + e.getMessage());
            req.setAttribute("pageTitle", "Danh sách yêu thích");
            req.setAttribute("body", "/WEB-INF/views/wishlist_body.jsp");
            req.getRequestDispatcher("/WEB-INF/views/_layout.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("me");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String bookIdStr = req.getParameter("bookId");
        String redirectUrl = req.getParameter("redirect");

        if (bookIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/wishlist?error=missing_book_id");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr);
            boolean success = false;

            switch (action) {
                case "add":
                    success = wishlistDAO.addToWishlist(user.getId(), bookId);
                    if (redirectUrl != null && !redirectUrl.isEmpty()) {
                        resp.sendRedirect(
                                redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "success=added_to_wishlist");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/wishlist?success=added");
                    }
                    break;

                case "remove":
                    success = wishlistDAO.removeFromWishlist(user.getId(), bookId);
                    if (redirectUrl != null && !redirectUrl.isEmpty()) {
                        resp.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?")
                                + "success=removed_from_wishlist");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/wishlist?success=removed");
                    }
                    break;

                case "toggle":
                    boolean inWishlist = wishlistDAO.isInWishlist(user.getId(), bookId);
                    if (inWishlist) {
                        wishlistDAO.removeFromWishlist(user.getId(), bookId);
                    } else {
                        wishlistDAO.addToWishlist(user.getId(), bookId);
                    }
                    if (redirectUrl != null && !redirectUrl.isEmpty()) {
                        resp.sendRedirect(redirectUrl);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/wishlist");
                    }
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/wishlist?error=invalid_action");
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/wishlist?error=invalid_book_id");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/wishlist?error=database_error");
        }
    }
}
