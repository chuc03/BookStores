package vn.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import vn.bookstore.model.Category;
import vn.bookstore.util.DB;

public class CategoryDAO {

    public int count(String q) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Categories WHERE (? IS NULL OR name LIKE ? )";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (q == null || q.isBlank()) {
                ps.setNull(1, Types.NVARCHAR);
                ps.setNull(2, Types.NVARCHAR);
            } else {
                ps.setString(1, q.trim());
                ps.setString(2, "%" + q.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Categories";
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    public List<Category> findPage(String q, int offset, int limit) throws SQLException {
        String sql = "SELECT category_id, name FROM Categories WHERE (? IS NULL OR name LIKE ?) ORDER BY name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<Category> list = new ArrayList<>();
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (q == null || q.isBlank()) {
                ps.setNull(1, Types.NVARCHAR);
                ps.setNull(2, Types.NVARCHAR);
            } else {
                ps.setString(1, q.trim());
                ps.setString(2, "%" + q.trim() + "%");
            }
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setName(rs.getString("name"));
                    list.add(cat);
                }
            }
        }
        return list;
    }

    public Category findById(int id) throws SQLException {
        String sql = "SELECT category_id, name FROM Categories WHERE category_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setName(rs.getString("name"));
                    return cat;
                }
            }
        }
        return null;
    }

    public Category findBySlug(String slug) throws SQLException {
        String sql = "SELECT category_id, name, slug FROM Categories WHERE slug = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setName(rs.getString("name"));
                    cat.setSlug(rs.getString("slug"));
                    return cat;
                }
            }
        }
        return null;
    }

    public int create(String name) throws SQLException {
        String slug = vn.bookstore.util.SlugUtil.toSlug(name);
        String sql = "INSERT INTO Categories(name, slug) VALUES(?, ?)";
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, slug);
            int cnt = ps.executeUpdate();
            if (cnt > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    public boolean update(int id, String name) throws SQLException {
        String slug = vn.bookstore.util.SlugUtil.toSlug(name);
        String sql = "UPDATE Categories SET name = ?, slug = ? WHERE category_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, slug);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Categories WHERE category_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Category> findPageWithBookCount(String q, int offset, int limit) throws SQLException {
        String sql = """
                    SELECT c.category_id, c.name,
                           COUNT(b.id) AS bookCount
                    FROM categories c
                    LEFT JOIN books b ON b.category_id = c.category_id
                    WHERE (? IS NULL OR c.name LIKE ?)
                    GROUP BY c.category_id, c.name
                    ORDER BY c.category_id
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        List<Category> list = new ArrayList<>();

        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, q);
            ps.setString(2, q == null ? null : "%" + q + "%");
            ps.setInt(3, offset);
            ps.setInt(4, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setBookCount(rs.getInt("bookCount"));
                list.add(c);
            }
        }
        return list;
    }

    public List<Category> findAll() throws SQLException {
        String sql = "SELECT category_id, name, slug FROM categories ORDER BY name ASC";

        List<Category> list = new ArrayList<>();

        try (Connection con = DB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                list.add(c);
            }
        }

        return list;
    }

    public List<Category> findAllWithBookCount() throws SQLException {
        String sql = """
                    SELECT c.category_id, c.name,
                           COUNT(b.book_id) AS bookCount
                    FROM categories c
                    LEFT JOIN books b ON b.category_id = c.category_id
                    GROUP BY c.category_id, c.name
                    ORDER BY c.category_id DESC
                """;

        List<Category> list = new ArrayList<>();

        try (Connection con = DB.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setBookCount(rs.getInt("bookCount"));
                list.add(c);
            }
        }

        return list;
    }

}
