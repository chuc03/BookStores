package vn.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import vn.bookstore.model.BookReview;
import vn.bookstore.util.DB;

public class ReviewDAO {

    public List<BookReview> findByBookId(int bookId) throws SQLException {
        String sql = """
                SELECT r.review_id, r.book_id, r.user_id, r.rating, r.review_title,
                       r.review_text, r.created_at, r.updated_at,
                       u.full_name as user_name, u.email as user_email
                FROM BookReviews r
                JOIN Users u ON r.user_id = u.user_id
                WHERE r.book_id = ?
                ORDER BY r.created_at DESC
                """;

        List<BookReview> reviews = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookReview review = new BookReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setBookId(rs.getInt("book_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setReviewTitle(rs.getString("review_title"));
                    review.setReviewText(rs.getString("review_text"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));
                    review.setUserName(rs.getString("user_name"));
                    review.setUserEmail(rs.getString("user_email"));
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public BookReview findByUserAndBook(int userId, int bookId) throws SQLException {
        String sql = """
                SELECT r.review_id, r.book_id, r.user_id, r.rating, r.review_title,
                       r.review_text, r.created_at, r.updated_at,
                       u.full_name as user_name, u.email as user_email
                FROM BookReviews r
                JOIN Users u ON r.user_id = u.user_id
                WHERE r.user_id = ? AND r.book_id = ?
                """;

        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookReview review = new BookReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setBookId(rs.getInt("book_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setReviewTitle(rs.getString("review_title"));
                    review.setReviewText(rs.getString("review_text"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));
                    review.setUserName(rs.getString("user_name"));
                    review.setUserEmail(rs.getString("user_email"));
                    return review;
                }
            }
        }
        return null;
    }

    public boolean create(int userId, int bookId, int rating, String reviewTitle, String reviewText)
            throws SQLException {
        String sql = """
                INSERT INTO BookReviews (user_id, book_id, rating, review_title, review_text)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, rating);
            ps.setString(4, reviewTitle);
            ps.setString(5, reviewText);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean update(int reviewId, int rating, String reviewTitle, String reviewText)
            throws SQLException {
        String sql = """
                UPDATE BookReviews
                SET rating = ?, review_title = ?, review_text = ?, updated_at = GETDATE()
                WHERE review_id = ?
                """;

        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, reviewTitle);
            ps.setString(3, reviewText);
            ps.setInt(4, reviewId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(int reviewId) throws SQLException {
        String sql = "DELETE FROM BookReviews WHERE review_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteByUserAndBook(int userId, int bookId) throws SQLException {
        String sql = "DELETE FROM BookReviews WHERE user_id = ? AND book_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() == 1;
        }
    }

    public int getAverageRating(int bookId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) as avg_rating FROM BookReviews WHERE book_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return (int) Math.round(rs.getDouble("avg_rating"));
                }
            }
        }
        return 0;
    }

    public int getReviewCount(int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM BookReviews WHERE book_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }
        return 0;
    }
}
