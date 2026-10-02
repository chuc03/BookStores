-- Migration: Add Wishlist
-- Description: Tạo bảng Wishlist để lưu danh sách yêu thích của users

-- Kiểm tra và tạo bảng Wishlist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Wishlist')
BEGIN
    CREATE TABLE Wishlist (
        wishlist_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        book_id INT NOT NULL,
        added_at DATETIME2 DEFAULT GETDATE(),
        
        CONSTRAINT FK_Wishlist_User FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        CONSTRAINT FK_Wishlist_Book FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
        CONSTRAINT UQ_Wishlist_UserBook UNIQUE(user_id, book_id) -- Mỗi user chỉ thêm 1 lần cho 1 sách
    );

    -- Index để tối ưu query
    CREATE INDEX idx_wishlist_user ON Wishlist(user_id);
    CREATE INDEX idx_wishlist_book ON Wishlist(book_id);
    CREATE INDEX idx_wishlist_added ON Wishlist(added_at DESC);

    PRINT 'Bảng Wishlist đã được tạo thành công';
END
ELSE
BEGIN
    PRINT 'Bảng Wishlist đã tồn tại';
END
GO

PRINT 'Migration hoàn tất: Wishlist feature đã sẵn sàng!';
