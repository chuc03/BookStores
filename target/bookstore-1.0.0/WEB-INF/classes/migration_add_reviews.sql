-- Migration: Add Reviews and Ratings
-- Description: Tạo bảng BookReviews để lưu đánh giá sách

-- Kiểm tra và tạo bảng BookReviews
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BookReviews')
BEGIN
    CREATE TABLE BookReviews (
        review_id INT IDENTITY(1,1) PRIMARY KEY,
        book_id INT NOT NULL,
        user_id INT NOT NULL,
        rating TINYINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
        review_title NVARCHAR(200),
        review_text NVARCHAR(MAX),
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE(),
        
        CONSTRAINT FK_BookReviews_Book FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
        CONSTRAINT FK_BookReviews_User FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        CONSTRAINT UQ_BookReviews_UserBook UNIQUE(book_id, user_id) -- Mỗi user chỉ review 1 lần cho 1 sách
    );

    -- Index để tối ưu query
    CREATE INDEX idx_bookreview_book ON BookReviews(book_id);
    CREATE INDEX idx_bookreview_user ON BookReviews(user_id);
    CREATE INDEX idx_bookreview_rating ON BookReviews(rating);
    CREATE INDEX idx_bookreview_created ON BookReviews(created_at DESC);

    PRINT 'Bảng BookReviews đã được tạo thành công';
END
ELSE
BEGIN
    PRINT 'Bảng BookReviews đã tồn tại';
END
GO

-- Thêm cột average_rating và review_count vào bảng Books để tối ưu performance
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'average_rating')
BEGIN
    ALTER TABLE Books ADD average_rating DECIMAL(3,2) DEFAULT 0;
    PRINT 'Đã thêm cột average_rating vào bảng Books';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'review_count')
BEGIN
    ALTER TABLE Books ADD review_count INT DEFAULT 0;
    PRINT 'Đã thêm cột review_count vào bảng Books';
END
GO

-- Tạo trigger để tự động cập nhật average_rating và review_count khi có review mới
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_UpdateBookRating')
    DROP TRIGGER trg_UpdateBookRating;
GO

CREATE TRIGGER trg_UpdateBookRating
ON BookReviews
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật cho books bị ảnh hưởng bởi INSERT/UPDATE
    UPDATE b
    SET 
        average_rating = ISNULL((SELECT AVG(CAST(rating AS DECIMAL(3,2))) FROM BookReviews WHERE book_id = b.book_id), 0),
        review_count = ISNULL((SELECT COUNT(*) FROM BookReviews WHERE book_id = b.book_id), 0)
    FROM Books b
    WHERE b.book_id IN (SELECT DISTINCT book_id FROM inserted)
       OR b.book_id IN (SELECT DISTINCT book_id FROM deleted);
END
GO

PRINT 'Migration hoàn tất: Hệ thống reviews và ratings đã sẵn sàng!';
