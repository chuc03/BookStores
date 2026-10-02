-- Migration: Thêm cột vnpayTransactionId vào bảng Orders
-- Dùng để lưu mã giao dịch từ VNPay

USE BookStoreDB;
GO

-- Thêm cột vnpayTransactionId
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('Orders') 
    AND name = 'vnpayTransactionId'
)
BEGIN
    ALTER TABLE Orders
    ADD vnpayTransactionId NVARCHAR(50) NULL;
    
    PRINT 'Added column vnpayTransactionId to Orders table';
END
ELSE
BEGIN
    PRINT 'Column vnpayTransactionId already exists';
END
GO

-- Cập nhật giá trị mặc định cho paymentMethod nếu NULL
UPDATE Orders
SET paymentMethod = 'COD'
WHERE paymentMethod IS NULL;
GO

-- Cập nhật giá trị mặc định cho paymentStatus nếu NULL
UPDATE Orders
SET paymentStatus = 'UNPAID'
WHERE paymentStatus IS NULL;
GO

PRINT 'Migration completed successfully';
GO
