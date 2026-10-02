package vn.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import vn.bookstore.model.Book;
import vn.bookstore.util.DB;

public class WishlistDAO {

    public List<Book> getWishlistByUserId(int userId) throws SQLException {
        String sql = """
                SELECT b.book_id, b.title, b.author, b.price, b.discount_percent,
                       b.cover_url, b.stock, b.category_id, b.description,
                       b.average_rating, b.review_count, w.added_at
                FROM Wishlist w
                JOIN Books b ON w.book_id = b.book_id
                WHERE w.user_id = ?
                ORDER BY w.added_at DESC
                """;

        List<Book> books = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book();
                    book.setId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setPrice(rs.getDouble("price"));
                    book.setDiscountPercent(rs.getInt("discount_percent"));
                    book.setCoverUrl(rs.getString("cover_url"));
                    book.setStock(rs.getInt("stock"));
                    book.setCategoryId(rs.getInt("category_id"));
                    book.setDescription(rs.getString("description"));
                    book.setAverageRating(rs.getDouble("average_rating"));
                    book.setReviewCount(rs.getInt("review_count"));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public boolean addToWishlist(int userId, int bookId) throws SQLException {
        String sql = "INSERT INTO Wishlist (user_id, book_id) VALUES (?, ?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            // Nếu đã tồn tại (unique constraint violation), coi như thành công
            if (e.getMessage().contains("UNIQUE") || e.getMessage().contains("duplicate")) {
                return true;
            }
            throw e;
        }
    }

    public boolean removeFromWishlist(int userId, int bookId) throws SQLException {
        String sql = "DELETE FROM Wishlist WHERE user_id = ? AND book_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() >= 0; // Trả về true cả khi không có row nào bị xóa
        }
    }

    public boolean isInWishlist(int userId, int bookId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Wishlist WHERE user_id = ? AND book_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int getWishlistCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Wishlist WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean clearWishlist(int userId) throws SQLException {
        String sql = "DELETE FROM Wishlist WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        }
    }
}
