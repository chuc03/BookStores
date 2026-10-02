-- Migration: Cập nhật CHECK constraint để hỗ trợ VNPay
-- Thêm 'VNPAY' vào danh sách payment_method được phép

USE BookStoreDB;
GO

-- Drop constraint cũ
IF EXISTS (
    SELECT * FROM sys.check_constraints 
    WHERE name = 'CHK_Orders_PaymentMethod'
)
BEGIN
    ALTER TABLE Orders
    DROP CONSTRAINT CHK_Orders_PaymentMethod;
    
    PRINT 'Dropped old CHK_Orders_PaymentMethod constraint';
END
GO

-- Thêm constraint mới với VNPAY
ALTER TABLE Orders
ADD CONSTRAINT CHK_Orders_PaymentMethod 
CHECK (payment_method IN ('COD', 'BANKING', 'CARD', 'VNPAY'));
GO

PRINT 'Updated CHK_Orders_PaymentMethod constraint - Added VNPAY';
GO

-- Cập nhật dữ liệu nếu có (optional)
-- UPDATE Orders SET payment_method = 'VNPAY' WHERE payment_method = 'BANKING';
