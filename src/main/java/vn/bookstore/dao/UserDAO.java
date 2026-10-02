package vn.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import vn.bookstore.model.User;
import vn.bookstore.util.DB;
import vn.bookstore.util.Passwords;

public class UserDAO {

    public User login(String email, String password) throws SQLException {
        String sql = """
                    SELECT user_id, email, full_name, phone, role, password_hash
                    FROM Users
                    WHERE email = ?
                """;
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;
                String hash = rs.getString("password_hash");
                if (!Passwords.verify(password, hash))
                    return null;

                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRoleCode(rs.getString("role"));
                return u;
            }
        }
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT user_id, email, full_name, phone, role FROM Users WHERE email = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRoleCode(rs.getString("role"));
                return u;
            }
        }
    }

    public User findById(int id) throws SQLException {
        String sql = "SELECT user_id, email, full_name, phone, role FROM Users WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRoleCode(rs.getString("role"));
                return u;
            }
        }
    }

    public boolean createPasswordResetToken(int userId, String token, Timestamp expires) throws SQLException {
        String sql = "UPDATE Users SET reset_token = ?, reset_expires = ? WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expires);
            ps.setInt(3, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            // If columns are missing, try to create them and retry once
            if (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("invalid column name")) {
                try (Connection c = DB.getConnection()) {
                    ensureResetColumnsExist(c);
                }
                try (Connection c2 = DB.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql)) {
                    ps2.setString(1, token);
                    ps2.setTimestamp(2, expires);
                    ps2.setInt(3, userId);
                    return ps2.executeUpdate() == 1;
                }
            }
            throw ex;
        }
    }

    public User findByResetToken(String token) throws SQLException {
        String sql = "SELECT user_id, email, full_name, phone, reset_expires FROM Users WHERE reset_token = ? AND status = 1";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;
                Timestamp expires = rs.getTimestamp("reset_expires");
                if (expires == null || expires.before(new Timestamp(System.currentTimeMillis())))
                    return null;
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                return u;
            }
        } catch (SQLException ex) {
            if (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("invalid column name")) {
                try (Connection c = DB.getConnection()) {
                    ensureResetColumnsExist(c);
                }
                try (Connection c2 = DB.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql)) {
                    ps2.setString(1, token);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        if (!rs2.next())
                            return null;
                        Timestamp expires = rs2.getTimestamp("reset_expires");
                        if (expires == null || expires.before(new Timestamp(System.currentTimeMillis())))
                            return null;
                        User u = new User();
                        u.setId(rs2.getInt("user_id"));
                        u.setEmail(rs2.getString("email"));
                        u.setFullName(rs2.getString("full_name"));
                        u.setPhone(rs2.getString("phone"));
                        return u;
                    }
                }
            }
            throw ex;
        }
    }

    public boolean updatePasswordAndClearToken(int userId, String passwordHash) throws SQLException {
        String sql = "UPDATE Users SET password_hash = ?, reset_token = NULL, reset_expires = NULL WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            if (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("invalid column name")) {
                try (Connection c = DB.getConnection()) {
                    ensureResetColumnsExist(c);
                }
                try (Connection c2 = DB.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql)) {
                    ps2.setString(1, passwordHash);
                    ps2.setInt(2, userId);
                    return ps2.executeUpdate() == 1;
                }
            }
            throw ex;
        }
    }

    // Ensure reset_token and reset_expires columns exist on Users table. Safe to
    // call multiple times.
    private void ensureResetColumnsExist(Connection c) throws SQLException {
        if (!columnExists(c, "Users", "reset_token")) {
            try (PreparedStatement ps = c.prepareStatement("ALTER TABLE Users ADD reset_token NVARCHAR(255) NULL")) {
                ps.executeUpdate();
            }
        }
        if (!columnExists(c, "Users", "reset_expires")) {
            try (PreparedStatement ps = c.prepareStatement("ALTER TABLE Users ADD reset_expires DATETIME2 NULL")) {
                ps.executeUpdate();
            }
        }
        // create index if not exists - best effort
        if (!indexExists(c, "idx_users_reset_token")) {
            try (PreparedStatement ps = c
                    .prepareStatement("CREATE INDEX idx_users_reset_token ON Users(reset_token)")) {
                ps.executeUpdate();
            } catch (SQLException ignore) {
                /* ignore if cannot create (permissions) */ }
        }
    }

    // Ensure email verification columns exist on Users table. Safe to call multiple
    // times.
    private void ensureEmailVerificationColumnsExist(Connection c) throws SQLException {
        if (!columnExists(c, "Users", "email_verified")) {
            try (PreparedStatement ps = c.prepareStatement("ALTER TABLE Users ADD email_verified BIT DEFAULT 0")) {
                ps.executeUpdate();
            }
        }
        if (!columnExists(c, "Users", "email_verify_token")) {
            try (PreparedStatement ps = c
                    .prepareStatement("ALTER TABLE Users ADD email_verify_token NVARCHAR(255) NULL")) {
                ps.executeUpdate();
            }
        }
        if (!columnExists(c, "Users", "email_verify_expires")) {
            try (PreparedStatement ps = c
                    .prepareStatement("ALTER TABLE Users ADD email_verify_expires DATETIME2 NULL")) {
                ps.executeUpdate();
            }
        }
        // create index if not exists - best effort
        if (!indexExists(c, "idx_email_verify_token")) {
            try (PreparedStatement ps = c
                    .prepareStatement("CREATE INDEX idx_email_verify_token ON Users(email_verify_token)")) {
                ps.executeUpdate();
            } catch (SQLException ignore) {
                /* ignore if cannot create (permissions) */ }
        }
    }

    private boolean columnExists(Connection c, String tableName, String columnName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ? AND COLUMN_NAME = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private boolean indexExists(Connection c, String indexName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM sys.indexes WHERE name = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, indexName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean registerUser(String email, String rawPassword, String fullName, String phone) throws SQLException {
        // Generate username from email (part before @)
        String username = email.substring(0, email.indexOf('@')).toLowerCase();

        String sql = """
                    INSERT INTO Users(username, email, password_hash, full_name, phone, role)
                    VALUES (?, ?, ?, ?, ?, 'USER')
                """;
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, Passwords.hash(rawPassword));
            ps.setString(4, fullName.trim());
            ps.setString(5, phone == null ? null : phone.trim());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateUser(int userId, String email, String fullName, String phone) throws SQLException {
        String sql = "UPDATE Users SET email = ?, full_name = ?, phone = ? WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            ps.setString(2, fullName.trim());
            ps.setString(3, phone == null ? null : phone.trim());
            ps.setInt(4, userId);
            return ps.executeUpdate() == 1;
        }
    }

    public String createEmailVerificationToken(String email) throws SQLException {
        // Generate token
        String token = java.util.UUID.randomUUID().toString();
        Timestamp expires = new Timestamp(System.currentTimeMillis() + 24 * 60 * 60 * 1000); // 24 hours

        String sql = "UPDATE Users SET email_verify_token = ?, email_verify_expires = ? WHERE email = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expires);
            ps.setString(3, email.trim().toLowerCase());
            ps.executeUpdate();
            return token;
        } catch (SQLException ex) {
            // If columns are missing, try to create them and retry once
            if (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("invalid column name")) {
                try (Connection c = DB.getConnection()) {
                    ensureEmailVerificationColumnsExist(c);
                }
                try (Connection c2 = DB.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql)) {
                    ps2.setString(1, token);
                    ps2.setTimestamp(2, expires);
                    ps2.setString(3, email.trim().toLowerCase());
                    ps2.executeUpdate();
                    return token;
                }
            }
            throw ex;
        }
    }

    public User findByEmailVerificationToken(String token) throws SQLException {
        String sql = "SELECT user_id, email, full_name, phone, email_verify_expires FROM Users WHERE email_verify_token = ? AND status = 1";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;
                Timestamp expires = rs.getTimestamp("email_verify_expires");
                if (expires == null || expires.before(new Timestamp(System.currentTimeMillis())))
                    return null;
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                return u;
            }
        } catch (SQLException ex) {
            if (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("invalid column name")) {
                try (Connection c = DB.getConnection()) {
                    ensureEmailVerificationColumnsExist(c);
                }
                try (Connection c2 = DB.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql)) {
                    ps2.setString(1, token);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        if (!rs2.next())
                            return null;
                        Timestamp expires = rs2.getTimestamp("email_verify_expires");
                        if (expires == null || expires.before(new Timestamp(System.currentTimeMillis())))
                            return null;
                        User u = new User();
                        u.setId(rs2.getInt("user_id"));
                        u.setEmail(rs2.getString("email"));
                        u.setFullName(rs2.getString("full_name"));
                        return u;
                    }
                }
            }
            throw ex;
        }
    }

    public boolean markEmailAsVerified(int userId) throws SQLException {
        String sql = "UPDATE Users SET email_verified = 1, email_verify_token = NULL, email_verify_expires = NULL WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            if (ex.getMessage() != null && ex.getMessage().toLowerCase().contains("invalid column name")) {
                try (Connection c = DB.getConnection()) {
                    ensureEmailVerificationColumnsExist(c);
                }
                try (Connection c2 = DB.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql)) {
                    ps2.setInt(1, userId);
                    return ps2.executeUpdate() == 1;
                }
            }
            throw ex;
        }
    }

    // Admin user management methods
    public java.util.List<User> findAll() throws SQLException {
        String sql = "SELECT user_id, username, email, full_name, phone, role, created_at FROM Users ORDER BY created_at DESC";
        java.util.List<User> users = new java.util.ArrayList<>();
        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRoleCode(rs.getString("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(u);
            }
        }
        return users;
    }

    public java.util.List<User> search(String keyword) throws SQLException {
        String sql = "SELECT user_id, username, email, full_name, phone, role, created_at FROM Users WHERE email LIKE ? OR full_name LIKE ? OR username LIKE ? ORDER BY created_at DESC";
        java.util.List<User> users = new java.util.ArrayList<>();
        String pattern = "%" + keyword + "%";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPhone(rs.getString("phone"));
                    u.setRoleCode(rs.getString("role"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    users.add(u);
                }
            }
        }
        return users;
    }

    public boolean toggleStatus(int userId) throws SQLException {
        // Since we don't have status column, we can't toggle it
        // This method is not functional without status column
        return false;
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE user_id = ? AND role != 'ADMIN'";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) throws SQLException {
        // Verify old password first
        String verifySql = "SELECT password_hash FROM Users WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(verifySql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return false;
                String currentHash = rs.getString("password_hash");
                if (!Passwords.verify(oldPassword, currentHash)) {
                    return false; // Old password incorrect
                }
            }
        }

        // Update with new password
        String updateSql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(updateSql)) {
            ps.setString(1, Passwords.hash(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        }
    }
}
