package vn.bookstore.web;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bookstore.dao.ReviewDAO;
import vn.bookstore.model.BookReview;
import vn.bookstore.model.User;

/**
 * Book Review Servlet
 * Xử lý thêm/sửa/xóa đánh giá sách
 */
@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

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

        if (bookIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr);

            if ("delete".equals(action)) {
                // Delete review
                boolean success = reviewDAO.deleteByUserAndBook(user.getId(), bookId);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&success=review_deleted");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&error=delete_failed");
                }
                return;
            }

            // Create or Update review
            String ratingStr = req.getParameter("rating");
            String reviewTitle = req.getParameter("reviewTitle");
            String reviewText = req.getParameter("reviewText");

            // Validation
            if (ratingStr == null || reviewTitle == null || reviewText == null) {
                resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&error=missing_fields");
                return;
            }

            int rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&error=invalid_rating");
                return;
            }

            if (reviewTitle.trim().isEmpty() || reviewText.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&error=empty_fields");
                return;
            }

            // Check if user already reviewed this book
            BookReview existingReview = reviewDAO.findByUserAndBook(user.getId(), bookId);

            boolean success;
            if (existingReview != null) {
                // Update existing review
                success = reviewDAO.update(existingReview.getReviewId(), rating, reviewTitle.trim(), reviewText.trim());
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&success=review_updated");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&error=update_failed");
                }
            } else {
                // Create new review
                success = reviewDAO.create(user.getId(), bookId, rating, reviewTitle.trim(), reviewText.trim());
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&success=review_added");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/book?id=" + bookId + "&error=create_failed");
                }
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/?error=invalid_input");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/?error=database_error");
        }
    }
}
