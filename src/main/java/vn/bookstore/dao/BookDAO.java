package vn.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import vn.bookstore.model.BestSellingBook;
import vn.bookstore.model.Book;
import vn.bookstore.util.DB;

public class BookDAO {

    // ================== FIND ALL ==================
    public List<Book> findAll(String q) throws SQLException {
        String sql = """
                    SELECT book_id, title, author, cover_url, price, discount_percent, stock, category_id, description
                    FROM Books
                    WHERE status = 1
                      AND (? IS NULL OR title LIKE ? OR author LIKE ?)
                    ORDER BY created_at DESC
                """;

        List<Book> list = new ArrayList<>();

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            if (q == null || q.isBlank()) {
                ps.setNull(1, Types.NVARCHAR);
                ps.setNull(2, Types.NVARCHAR);
                ps.setNull(3, Types.NVARCHAR);
            } else {
                String like = "%" + q.trim() + "%";
                ps.setString(1, q.trim());
                ps.setString(2, like);
                ps.setString(3, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(map(rs));
            }
        }
        return list;
    }

    // ================== COUNT ==================
    public int count(String q) throws SQLException {
        String sql = """
                    SELECT COUNT(*)
                    FROM Books
                    WHERE status = 1
                      AND (? IS NULL OR title LIKE ? OR author LIKE ?)
                """;

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            if (q == null || q.isBlank()) {
                ps.setNull(1, Types.NVARCHAR);
                ps.setNull(2, Types.NVARCHAR);
                ps.setNull(3, Types.NVARCHAR);
            } else {
                String like = "%" + q.trim() + "%";
                ps.setString(1, q.trim());
                ps.setString(2, like);
                ps.setString(3, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    public int count(String q, Integer categoryId) throws SQLException {
        String sql = """
                    SELECT COUNT(*)
                    FROM Books
                    WHERE status = 1
                      AND (? IS NULL OR category_id = ?)
                      AND (? IS NULL OR title LIKE ? OR author LIKE ?)
                """;

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            if (categoryId == null) {
                ps.setNull(1, Types.INTEGER);
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(1, categoryId);
                ps.setInt(2, categoryId);
            }

            if (q == null || q.isBlank()) {
                ps.setNull(3, Types.NVARCHAR);
                ps.setNull(4, Types.NVARCHAR);
                ps.setNull(5, Types.NVARCHAR);
            } else {
                String like = "%" + q.trim() + "%";
                ps.setString(3, q.trim());
                ps.setString(4, like);
                ps.setString(5, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    public int countBooks() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Books WHERE status = 1";
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    // ================== FIND PAGE ==================
    public List<Book> findPage(String q, int offset, int limit) throws SQLException {
        String sql = """
                    SELECT book_id, title, author, cover_url, price, discount_percent, stock, category_id, description
                    FROM Books
                    WHERE status = 1
                      AND (? IS NULL OR title LIKE ? OR author LIKE ?)
                    ORDER BY created_at DESC
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        List<Book> list = new ArrayList<>();

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            if (q == null || q.isBlank()) {
                ps.setNull(1, Types.NVARCHAR);
                ps.setNull(2, Types.NVARCHAR);
                ps.setNull(3, Types.NVARCHAR);
            } else {
                String like = "%" + q.trim() + "%";
                ps.setString(1, q.trim());
                ps.setString(2, like);
                ps.setString(3, like);
            }

            ps.setInt(4, offset);
            ps.setInt(5, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(map(rs));
            }
        }
        return list;
    }

    public List<Book> findPage(String q, Integer categoryId, int offset, int limit) throws SQLException {
        String sql = """
                    SELECT book_id, title, author, cover_url, price, discount_percent, stock, category_id, description
                    FROM Books
                    WHERE status = 1
                      AND (? IS NULL OR category_id = ?)
                      AND (? IS NULL OR title LIKE ? OR author LIKE ?)
                    ORDER BY created_at DESC
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        List<Book> list = new ArrayList<>();

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            if (categoryId == null) {
                ps.setNull(1, Types.INTEGER);
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(1, categoryId);
                ps.setInt(2, categoryId);
            }

            if (q == null || q.isBlank()) {
                ps.setNull(3, Types.NVARCHAR);
                ps.setNull(4, Types.NVARCHAR);
                ps.setNull(5, Types.NVARCHAR);
            } else {
                String like = "%" + q.trim() + "%";
                ps.setString(3, q.trim());
                ps.setString(4, like);
                ps.setString(5, like);
            }

            ps.setInt(6, offset);
            ps.setInt(7, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(map(rs));
            }
        }
        return list;
    }

    // ================== FIND BY ID ==================
    public Book findById(int id) throws SQLException {
        String sql = """
                    SELECT book_id, title, author, cover_url, price, discount_percent, stock, category_id, description
                    FROM Books
                    WHERE book_id = ? AND status = 1
                """;

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return map(rs);
            }
        }
        return null;
    }

    // ================== CREATE ==================
    public int create(Book b) throws SQLException {
        String sql = """
                    INSERT INTO Books(title, author, cover_url, price, discount_percent, stock, category_id, description, status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)
                """;

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());

            if (b.getCoverUrl() == null)
                ps.setNull(3, Types.NVARCHAR);
            else
                ps.setString(3, b.getCoverUrl());

            ps.setDouble(4, b.getPrice());
            ps.setInt(5, b.getDiscountPercent());
            ps.setInt(6, b.getStock());
            ps.setInt(7, b.getCategoryId());
            ps.setString(8, b.getDescription());

            int cnt = ps.executeUpdate();

            if (cnt > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next())
                        return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    // ================== UPDATE ==================
    public boolean update(Book b) throws SQLException {
        String sql = """
                    UPDATE Books
                    SET title = ?, author = ?, cover_url = ?, price = ?, discount_percent = ?, stock = ?, category_id = ?, description = ?
                    WHERE book_id = ?
                """;

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());

            if (b.getCoverUrl() == null)
                ps.setNull(3, Types.NVARCHAR);
            else
                ps.setString(3, b.getCoverUrl());

            ps.setDouble(4, b.getPrice());
            ps.setInt(5, b.getDiscountPercent());
            ps.setInt(6, b.getStock());
            ps.setInt(7, b.getCategoryId());
            ps.setString(8, b.getDescription());
            ps.setInt(9, b.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ================== MAP RESULTSET ==================
    private Book map(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setCoverUrl(rs.getString("cover_url"));
        b.setPrice(rs.getDouble("price"));
        b.setDiscountPercent(rs.getInt("discount_percent"));
        b.setStock(rs.getInt("stock"));
        b.setCategoryId(rs.getInt("category_id"));
        b.setDescription(rs.getString("description"));
        return b;
    }

    // ================== SOFT DELETE ==================
    public boolean softDelete(int id) throws SQLException {
        String sql = "UPDATE Books SET status = 0 WHERE book_id = ?";
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ================== ADVANCED SEARCH WITH FILTERS ==================
    public List<Book> searchWithFilters(String query, String categorySlug, Double minPrice, Double maxPrice,
            String sortBy, int offset, int limit) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append(
                "SELECT b.book_id, b.title, b.author, b.cover_url, b.price, b.discount_percent, b.stock, b.category_id, b.description ");
        sql.append("FROM Books b ");
        sql.append("LEFT JOIN Categories c ON b.category_id = c.category_id ");
        sql.append("WHERE b.status = 1 ");

        // Search query
        if (query != null && !query.isBlank()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }

        // Category filter
        if (categorySlug != null && !categorySlug.isBlank()) {
            sql.append("AND c.slug = ? ");
        }

        // Price filter
        if (minPrice != null) {
            sql.append("AND (b.price - (b.price * b.discount_percent / 100.0)) >= ? ");
        }
        if (maxPrice != null) {
            sql.append("AND (b.price - (b.price * b.discount_percent / 100.0)) <= ? ");
        }

        // Sorting
        switch (sortBy != null ? sortBy : "newest") {
            case "price-asc":
                sql.append("ORDER BY (b.price - (b.price * b.discount_percent / 100.0)) ASC ");
                break;
            case "price-desc":
                sql.append("ORDER BY (b.price - (b.price * b.discount_percent / 100.0)) DESC ");
                break;
            case "name-asc":
                sql.append("ORDER BY b.title ASC ");
                break;
            default: // newest
                sql.append("ORDER BY b.created_at DESC ");
                break;
        }

        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Book> list = new ArrayList<>();

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set query parameters
            if (query != null && !query.isBlank()) {
                String like = "%" + query.trim() + "%";
                ps.setString(paramIndex++, like);
                ps.setString(paramIndex++, like);
            }

            if (categorySlug != null && !categorySlug.isBlank()) {
                ps.setString(paramIndex++, categorySlug);
            }

            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex++, maxPrice);
            }

            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public int countWithFilters(String query, String categorySlug, Double minPrice, Double maxPrice)
            throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Books b ");
        sql.append("LEFT JOIN Categories c ON b.category_id = c.category_id ");
        sql.append("WHERE b.status = 1 ");

        if (query != null && !query.isBlank()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }

        if (categorySlug != null && !categorySlug.isBlank()) {
            sql.append("AND c.slug = ? ");
        }

        if (minPrice != null) {
            sql.append("AND (b.price - (b.price * b.discount_percent / 100.0)) >= ? ");
        }
        if (maxPrice != null) {
            sql.append("AND (b.price - (b.price * b.discount_percent / 100.0)) <= ? ");
        }

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (query != null && !query.isBlank()) {
                String like = "%" + query.trim() + "%";
                ps.setString(paramIndex++, like);
                ps.setString(paramIndex++, like);
            }

            if (categorySlug != null && !categorySlug.isBlank()) {
                ps.setString(paramIndex++, categorySlug);
            }

            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex, maxPrice);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // ================== GET BEST SELLING BOOKS ==================
    /**
     * Get top best-selling books based on total quantity sold
     * 
     * @param limit Maximum number of books to return
     * @return List of best-selling books with title and total sold
     * @throws SQLException
     */
    public List<BestSellingBook> getBestSellingBooks(int limit) throws SQLException {
        String sql = """
                    SELECT TOP(?)
                        b.book_id,
                        b.title,
                        ISNULL(SUM(oi.quantity), 0) as total_sold
                    FROM Books b
                    LEFT JOIN OrderItems oi ON b.book_id = oi.book_id
                    LEFT JOIN Orders o ON oi.order_id = o.order_id
                    WHERE b.status = 1
                        AND (o.order_status IS NULL OR o.order_status NOT IN ('CANCELLED'))
                    GROUP BY b.book_id, b.title
                    ORDER BY total_sold DESC
                """;

        List<BestSellingBook> list = new ArrayList<>();

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BestSellingBook book = new BestSellingBook();
                    book.setBookId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setTotalSold(rs.getInt("total_sold"));
                    list.add(book);
                }
            }
        }
        return list;
    }
}
