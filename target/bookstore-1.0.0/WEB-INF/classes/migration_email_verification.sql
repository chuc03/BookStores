-- Database migration for email verification feature
-- Add email verification columns to Users table (SQL Server)

-- Kiểm tra và thêm cột email_verified
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'email_verified')
BEGIN
    ALTER TABLE Users ADD email_verified BIT DEFAULT 0;
    PRINT 'Đã thêm cột email_verified';
END
ELSE
BEGIN
    PRINT 'Cột email_verified đã tồn tại';
END
GO

-- Kiểm tra và thêm cột email_verify_token
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'email_verify_token')
BEGIN
    ALTER TABLE Users ADD email_verify_token NVARCHAR(255) NULL;
    PRINT 'Đã thêm cột email_verify_token';
END
ELSE
BEGIN
    PRINT 'Cột email_verify_token đã tồn tại';
END
GO

-- Kiểm tra và thêm cột email_verify_expires
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'email_verify_expires')
BEGIN
    ALTER TABLE Users ADD email_verify_expires DATETIME2 NULL;
    PRINT 'Đã thêm cột email_verify_expires';
END
ELSE
BEGIN
    PRINT 'Cột email_verify_expires đã tồn tại';
END
GO

-- Tạo index cho faster token lookups
IF NOT EXISTS (SELECT * FROM sys.indexes 
               WHERE name = 'idx_email_verify_token' AND object_id = OBJECT_ID('Users'))
BEGIN
    CREATE INDEX idx_email_verify_token ON Users(email_verify_token);
    PRINT 'Đã tạo index idx_email_verify_token';
END
ELSE
BEGIN
    PRINT 'Index idx_email_verify_token đã tồn tại';
END
GO

PRINT 'Migration email verification hoàn tất!';
