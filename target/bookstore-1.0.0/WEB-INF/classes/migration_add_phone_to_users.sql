-- Migration: add phone column to Users table
ALTER TABLE Users ADD COLUMN phone VARCHAR(50) NULL;
CREATE INDEX idx_users_phone ON Users(phone);
