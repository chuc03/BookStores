-- Migration: add reset token and expiry columns for password reset
ALTER TABLE Users ADD reset_token NVARCHAR(255) NULL;
ALTER TABLE Users ADD reset_expires DATETIME2 NULL;
CREATE INDEX idx_users_reset_token ON Users(reset_token);
