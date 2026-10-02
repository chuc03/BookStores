package vn.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import vn.bookstore.model.Cart;
import vn.bookstore.model.CartItem;
import vn.bookstore.model.Order;
import vn.bookstore.model.OrderItem;
import vn.bookstore.model.SalesStat;
import vn.bookstore.util.DB;

public class OrderDAO {

    // ================== TẠO ĐƠN HÀNG ==================
    public long createOrder(Integer userId, String name, String phone, String address, String note,
            String paymentMethod, Cart cart) throws SQLException {

        String insertOrder = """
                    INSERT INTO Orders(user_id, customer_name, customer_phone, shipping_address, note,
                                       payment_method, payment_status, order_status, total_amount)
                    VALUES (?, ?, ?, ?, ?, ?, 'UNPAID', 'NEW', ?)
                """;

        String insertItem = """
                    INSERT INTO OrderItems(order_id, book_id, unit_price, quantity)
                    VALUES (?, ?, ?, ?)
                """;

        String lockAndCheckStock = """
                    SELECT stock, price, discount_percent
                    FROM Books WITH (UPDLOCK, ROWLOCK)
                    WHERE book_id = ? AND status = 1
                """;

        String updateStock = "UPDATE Books SET stock = stock - ? WHERE book_id = ?";

        try (Connection c = DB.getConnection()) {
            c.setAutoCommit(false);

            try {
                long orderId;
                try (PreparedStatement ps = c.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                    if (userId == null)
                        ps.setNull(1, Types.INTEGER);
                    else
                        ps.setInt(1, userId);

                    ps.setString(2, name);
                    ps.setString(3, phone);
                    ps.setString(4, address);
                    ps.setString(5, note);
                    ps.setString(6, paymentMethod);
                    ps.setDouble(7, cart.getTotal());

                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next())
                            throw new SQLException("Cannot get order_id");
                        orderId = keys.getLong(1);
                    }
                }

                for (CartItem it : cart.getItems()) {
                    int bookId = it.getBook().getId();
                    int qty = it.getQuantity();

                    double unitPrice;
                    int stock;

                    try (PreparedStatement ps = c.prepareStatement(lockAndCheckStock)) {
                        ps.setInt(1, bookId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next())
                                throw new SQLException("Book not found: " + bookId);
                            stock = rs.getInt("stock");
                            double price = rs.getDouble("price");
                            int discount = rs.getInt("discount_percent");
                            unitPrice = price * (100.0 - discount) / 100.0;
                        }
                    }

                    if (stock < qty)
                        throw new SQLException("Not enough stock for book_id=" + bookId);

                    try (PreparedStatement ps = c.prepareStatement(insertItem)) {
                        ps.setLong(1, orderId);
                        ps.setInt(2, bookId);
                        ps.setDouble(3, unitPrice);
                        ps.setInt(4, qty);
                        ps.executeUpdate();
                    }

                    try (PreparedStatement ps = c.prepareStatement(updateStock)) {
                        ps.setInt(1, qty);
                        ps.setInt(2, bookId);
                        ps.executeUpdate();
                    }
                }

                c.commit();
                return orderId;
            } catch (Exception ex) {
                c.rollback();
                throw ex instanceof SQLException ? (SQLException) ex : new SQLException(ex);
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    // ================== XEM CHI TIẾT ĐƠN HÀNG ==================
    public Order findById(long orderId) throws SQLException {
        Order order = null;

        String sql = "SELECT * FROM Orders WHERE order_id = ?";

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setOrderId(rs.getLong("order_id"));
                    try {
                        order.setUserId(rs.getInt("user_id"));
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    order.setCustomerName(rs.getString("customer_name"));
                    order.setCustomerPhone(rs.getString("customer_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setNote(rs.getString("note"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        }

        if (order != null) {
            order.setItems(findItems(orderId));
        }

        return order;
    }

    private List<OrderItem> findItems(long orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();

        String sql = """
                    SELECT oi.*, b.title, b.author, b.cover_url
                    FROM OrderItems oi
                    JOIN Books b ON oi.book_id = b.book_id
                    WHERE oi.order_id = ?
                """;

        try (Connection c = DB.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setBookTitle(rs.getString("title"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));

                    // Create Book object for cover image
                    vn.bookstore.model.Book book = new vn.bookstore.model.Book();
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setCoverUrl(rs.getString("cover_url"));
                    item.setBook(book);

                    items.add(item);
                }
            }
        }

        return items;
    }

    // ================== CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG ==================
    public boolean updateOrderStatus(long orderId, String status) throws SQLException {
        String sql = "UPDATE Orders SET order_status = ? WHERE order_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    // record status change in history
    public boolean recordStatusChange(long orderId, String oldStatus, String newStatus, Integer changedBy)
            throws SQLException {
        String sql = "INSERT INTO OrderStatusHistory(order_id, old_status, new_status, changed_by) VALUES(?,?,?,?)";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            if (oldStatus == null)
                ps.setNull(2, Types.NVARCHAR);
            else
                ps.setString(2, oldStatus);
            ps.setString(3, newStatus);
            if (changedBy == null)
                ps.setNull(4, Types.INTEGER);
            else
                ps.setInt(4, changedBy);
            return ps.executeUpdate() > 0;
        }
    }

    // get last status history entry where new_status = ?
    public java.sql.Timestamp getLastStatusChangeTime(long orderId, String newStatus) throws SQLException {
        String sql = "SELECT TOP 1 changed_at FROM OrderStatusHistory WHERE order_id = ? AND new_status = ? ORDER BY changed_at DESC";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setString(2, newStatus);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getTimestamp(1);
            }
        }
        return null;
    }

    // get last status change record (old->new)
    public vn.bookstore.model.OrderStatusChange getLastStatusChange(long orderId) throws SQLException {
        String sql = "SELECT TOP 1 old_status, new_status, changed_by, changed_at FROM OrderStatusHistory WHERE order_id = ? ORDER BY changed_at DESC";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    vn.bookstore.model.OrderStatusChange ch = new vn.bookstore.model.OrderStatusChange();
                    ch.setOldStatus(rs.getString("old_status"));
                    ch.setNewStatus(rs.getString("new_status"));
                    ch.setChangedBy(rs.getInt("changed_by"));
                    ch.setChangedAt(rs.getTimestamp("changed_at"));
                    return ch;
                }
            }
        }
        return null;
    }

    // ================== THỐNG KÊ DOANH SỐ ==================
    public List<SalesStat> getSalesByDays(int days) throws SQLException {
        List<SalesStat> stats = new ArrayList<>();

        String sql = """
                    SELECT CONVERT(date, created_at) AS dt, COUNT(*) AS orders, SUM(total_amount) AS total
                    FROM Orders
                    WHERE created_at >= DATEADD(day, -?, GETDATE())
                    GROUP BY CONVERT(date, created_at)
                    ORDER BY dt DESC
                """;

        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesStat s = new SalesStat();
                    s.setDate(rs.getDate("dt"));
                    s.setOrderCount(rs.getInt("orders"));
                    s.setTotalAmount(rs.getDouble("total"));
                    stats.add(s);
                }
            }
        }

        return stats;
    }

    // ================== PAGINATION SUPPORT FOR ORDERS (ADMIN) ==================
    public int countOrders() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM Orders";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("cnt");
            }
        }
        return 0;
    }

    public List<Order> findPage(int offset, int limit) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT order_id, customer_name, payment_method, order_status, total_amount, created_at FROM Orders ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setCustomerName(rs.getString("customer_name"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(o);
                }
            }
        }
        return list;
    }

    // ================== FIND ORDERS BY USER ==================
    public List<Order> findByUserId(int userId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT order_id, total_amount, order_status, created_at FROM Orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(o);
                }
            }
        }
        return list;
    }

    // ================== RESTORE STOCK WHEN ORDER CANCELLED ==================
    public boolean restoreStockForCancelledOrder(long orderId) throws SQLException {
        String sql = "UPDATE Books SET stock = stock + oi.quantity FROM Books b INNER JOIN OrderItems oi ON b.book_id = oi.book_id WHERE oi.order_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.executeUpdate();
            return true;
        }
    }

    // ================== UPDATE PAYMENT STATUS (VNPay) ==================
    public boolean updatePaymentStatus(long orderId, String paymentStatus, String vnpayTransactionId)
            throws SQLException {
        String sql = "UPDATE Orders SET payment_status = ?, vnpayTransactionId = ? WHERE order_id = ?";
        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setString(2, vnpayTransactionId);
            ps.setLong(3, orderId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    // ================== ADMIN ORDERS MANAGEMENT ==================
    public List<Order> findAll(int offset, int limit) throws SQLException {
        return findPage(offset, limit);
    }

    public int countAll() throws SQLException {
        return countOrders();
    }

    public List<Order> searchOrders(String query, int offset, int limit) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = """
                    SELECT order_id, customer_name, customer_phone, payment_method, order_status, total_amount, created_at
                    FROM Orders
                    WHERE CAST(order_id AS NVARCHAR) LIKE ?
                       OR customer_name LIKE ?
                       OR customer_phone LIKE ?
                    ORDER BY created_at DESC
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        String searchPattern = "%" + query + "%";

        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, offset);
            ps.setInt(5, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setCustomerName(rs.getString("customer_name"));
                    o.setCustomerPhone(rs.getString("customer_phone"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(o);
                }
            }
        }
        return list;
    }

    public int countSearchOrders(String query) throws SQLException {
        String sql = """
                    SELECT COUNT(*) AS cnt
                    FROM Orders
                    WHERE CAST(order_id AS NVARCHAR) LIKE ?
                       OR customer_name LIKE ?
                       OR customer_phone LIKE ?
                """;

        String searchPattern = "%" + query + "%";

        try (Connection c = DB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("cnt");
            }
        }
        return 0;
    }
}
