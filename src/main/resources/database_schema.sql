-- ============================================
-- BookStore Database Schema
-- SQL Server 2019+
-- Created: 2026-01-06
-- ============================================

-- Database creation (run separately if needed)
-- CREATE DATABASE BookStoreDB;
-- GO

USE BookStoreDB;
GO

-- ============================================
-- Drop existing tables (if recreating)
-- ============================================
IF OBJECT_ID('OrderStatusHistory', 'U') IS NOT NULL DROP TABLE OrderStatusHistory;
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Books', 'U') IS NOT NULL DROP TABLE Books;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- ============================================
-- Table: Users
-- ============================================
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(255) NOT NULL UNIQUE,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(255),
    phone NVARCHAR(50),
    role NVARCHAR(50) NOT NULL DEFAULT 'USER',
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Password reset fields
    reset_token NVARCHAR(255) NULL,
    reset_expires DATETIME2 NULL,
    
    -- Email verification fields
    email_verified TINYINT DEFAULT 0,
    email_verify_token NVARCHAR(255) NULL,
    email_verify_expires DATETIME2 NULL,
    
    CONSTRAINT CHK_Users_Role CHECK (role IN ('USER', 'ADMIN'))
);

CREATE INDEX idx_users_username ON Users(username);
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_phone ON Users(phone);
CREATE INDEX idx_users_reset_token ON Users(reset_token);
CREATE INDEX idx_email_verify_token ON Users(email_verify_token);
GO

-- ============================================
-- Table: Categories
-- ============================================
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL UNIQUE,
    slug NVARCHAR(255) NOT NULL UNIQUE,
    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE INDEX idx_categories_name ON Categories(name);
CREATE INDEX idx_categories_slug ON Categories(slug);
GO

-- ============================================
-- Table: Books
-- ============================================
CREATE TABLE Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(500) NOT NULL,
    author NVARCHAR(255),
    cover_url NVARCHAR(500),
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_percent INT DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    category_id INT,
    description NVARCHAR(MAX),
    status TINYINT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT FK_Books_Category FOREIGN KEY (category_id) 
        REFERENCES Categories(category_id) ON DELETE SET NULL,
    CONSTRAINT CHK_Books_Price CHECK (price >= 0),
    CONSTRAINT CHK_Books_Discount CHECK (discount_percent >= 0 AND discount_percent <= 100),
    CONSTRAINT CHK_Books_Stock CHECK (stock >= 0),
    CONSTRAINT CHK_Books_Status CHECK (status IN (0, 1))
);

CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_author ON Books(author);
CREATE INDEX idx_books_category ON Books(category_id);
CREATE INDEX idx_books_status ON Books(status);
CREATE INDEX idx_books_created_at ON Books(created_at DESC);
GO

-- ============================================
-- Table: Orders
-- ============================================
CREATE TABLE Orders (
    order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL,
    customer_name NVARCHAR(255) NOT NULL,
    customer_phone NVARCHAR(50) NOT NULL,
    shipping_address NVARCHAR(500) NOT NULL,
    note NVARCHAR(MAX),
    payment_method NVARCHAR(50) NOT NULL,
    payment_status NVARCHAR(50) NOT NULL DEFAULT 'UNPAID',
    order_status NVARCHAR(50) NOT NULL DEFAULT 'NEW',
    total_amount DECIMAL(12,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT FK_Orders_User FOREIGN KEY (user_id) 
        REFERENCES Users(user_id) ON DELETE SET NULL,
    CONSTRAINT CHK_Orders_PaymentMethod CHECK (payment_method IN ('COD', 'BANKING', 'CARD', 'VNPAY')),
    CONSTRAINT CHK_Orders_PaymentStatus CHECK (payment_status IN ('UNPAID', 'PAID', 'REFUNDED')),
    CONSTRAINT CHK_Orders_OrderStatus CHECK (order_status IN ('NEW', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
    CONSTRAINT CHK_Orders_TotalAmount CHECK (total_amount >= 0)
);

CREATE INDEX idx_orders_user ON Orders(user_id);
CREATE INDEX idx_orders_status ON Orders(order_status);
CREATE INDEX idx_orders_payment_status ON Orders(payment_status);
CREATE INDEX idx_orders_created_at ON Orders(created_at DESC);
GO

-- ============================================
-- Table: OrderItems
-- ============================================
CREATE TABLE OrderItems (
    order_item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    book_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    
    CONSTRAINT FK_OrderItems_Order FOREIGN KEY (order_id) 
        REFERENCES Orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_Book FOREIGN KEY (book_id) 
        REFERENCES Books(book_id) ON DELETE NO ACTION,
    CONSTRAINT CHK_OrderItems_UnitPrice CHECK (unit_price >= 0),
    CONSTRAINT CHK_OrderItems_Quantity CHECK (quantity > 0)
);

CREATE INDEX idx_orderitems_order ON OrderItems(order_id);
CREATE INDEX idx_orderitems_book ON OrderItems(book_id);
GO

-- ============================================
-- Table: OrderStatusHistory
-- ============================================
CREATE TABLE OrderStatusHistory (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    old_status NVARCHAR(50),
    new_status NVARCHAR(50) NOT NULL,
    changed_by INT NULL,
    changed_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    
    CONSTRAINT FK_OrderStatusHistory_Order FOREIGN KEY (order_id) 
        REFERENCES Orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderStatusHistory_User FOREIGN KEY (changed_by) 
        REFERENCES Users(user_id) ON DELETE SET NULL
);

CREATE INDEX idx_orderstatushistory_order ON OrderStatusHistory(order_id);
CREATE INDEX idx_orderstatushistory_changed_at ON OrderStatusHistory(changed_at DESC);
GO

-- ============================================
-- Initial Data - Admin User
-- ============================================
-- Password: admin123 (hashed with bcrypt)
-- Note: Update password_hash with actual bcrypt hash in production
INSERT INTO Users (username, email, password_hash, full_name, role, email_verified) 
VALUES ('admin', 'admin@bookstore.com', '$2a$10$YourBcryptHashHere', N'Administrator', 'ADMIN', 1);
GO

-- ============================================
-- Initial Data - Sample Categories
-- ============================================
INSERT INTO Categories (name, slug) VALUES
(N'Văn học', 'van-hoc'),
(N'Kinh tế', 'kinh-te'),
(N'Tâm lý - Kỹ năng sống', 'tam-ly-ky-nang-song'),
(N'Thiếu nhi', 'thieu-nhi'),
(N'Sách học ngoại ngữ', 'sach-hoc-ngoai-ngu'),
(N'Khoa học - Công nghệ', 'khoa-hoc-cong-nghe'),
(N'Lịch sử', 'lich-su'),
(N'Triết học', 'triet-hoc');
GO

-- ============================================
-- Stored Procedures (Optional)
-- ============================================

-- Procedure: Get sales statistics by date range
CREATE PROCEDURE sp_GetSalesStatsByDays
    @days INT
AS
BEGIN
    SELECT 
        CONVERT(DATE, created_at) AS sale_date,
        COUNT(*) AS order_count,
        SUM(total_amount) AS total_sales
    FROM Orders
    WHERE created_at >= DATEADD(DAY, -@days, GETDATE())
        AND order_status NOT IN ('CANCELLED')
    GROUP BY CONVERT(DATE, created_at)
    ORDER BY sale_date DESC;
END;
GO

-- Procedure: Get low stock books
CREATE PROCEDURE sp_GetLowStockBooks
    @threshold INT = 10
AS
BEGIN
    SELECT 
        b.book_id,
        b.title,
        b.author,
        b.stock,
        c.name AS category_name
    FROM Books b
    LEFT JOIN Categories c ON b.category_id = c.category_id
    WHERE b.stock <= @threshold AND b.status = 1
    ORDER BY b.stock ASC, b.title;
END;
GO

-- Procedure: Get order statistics
CREATE PROCEDURE sp_GetOrderStatistics
AS
BEGIN
    SELECT 
        COUNT(*) AS total_orders,
        SUM(CASE WHEN order_status = 'NEW' THEN 1 ELSE 0 END) AS new_orders,
        SUM(CASE WHEN order_status = 'CONFIRMED' THEN 1 ELSE 0 END) AS confirmed_orders,
        SUM(CASE WHEN order_status = 'SHIPPED' THEN 1 ELSE 0 END) AS shipped_orders,
        SUM(CASE WHEN order_status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered_orders,
        SUM(CASE WHEN order_status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_orders,
        SUM(CASE WHEN payment_status = 'PAID' THEN 1 ELSE 0 END) AS paid_orders,
        SUM(CASE WHEN payment_status = 'UNPAID' THEN 1 ELSE 0 END) AS unpaid_orders,
        SUM(total_amount) AS total_revenue
    FROM Orders;
END;
GO

-- ============================================
-- Views (Optional)
-- ============================================

-- View: Book inventory with category
CREATE VIEW vw_BookInventory AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.price,
    b.discount_percent,
    b.stock,
    b.status,
    c.name AS category_name,
    c.slug AS category_slug,
    b.created_at
FROM Books b
LEFT JOIN Categories c ON b.category_id = c.category_id;
GO

-- View: Order summary
CREATE VIEW vw_OrderSummary AS
SELECT 
    o.order_id,
    o.customer_name,
    o.customer_phone,
    o.order_status,
    o.payment_status,
    o.total_amount,
    o.created_at,
    u.username,
    u.email,
    COUNT(oi.order_item_id) AS item_count
FROM Orders o
LEFT JOIN Users u ON o.user_id = u.user_id
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id, o.customer_name, o.customer_phone, 
    o.order_status, o.payment_status, o.total_amount, 
    o.created_at, u.username, u.email;
GO

-- ============================================
-- Triggers (Optional)
-- ============================================

-- Trigger: Update Books.updated_at on changes
CREATE TRIGGER trg_Books_UpdateTimestamp
ON Books
AFTER UPDATE
AS
BEGIN
    UPDATE Books
    SET updated_at = GETDATE()
    FROM Books b
    INNER JOIN inserted i ON b.book_id = i.book_id;
END;
GO

-- Trigger: Update Orders.updated_at on changes
CREATE TRIGGER trg_Orders_UpdateTimestamp
ON Orders
AFTER UPDATE
AS
BEGIN
    UPDATE Orders
    SET updated_at = GETDATE()
    FROM Orders o
    INNER JOIN inserted i ON o.order_id = i.order_id;
END;
GO

-- ============================================
-- Database Info
-- ============================================
PRINT '============================================';
PRINT 'BookStore Database Schema Created Successfully';
PRINT 'Database: BookStoreDB';
PRINT 'Tables: Users, Categories, Books, Orders, OrderItems, OrderStatusHistory';
PRINT 'Version: 1.0';
PRINT 'Date: 2026-01-06';
PRINT '============================================';
GO
