-- Migration: create OrderStatusHistory table to record status changes
CREATE TABLE OrderStatusHistory (
  id BIGINT IDENTITY(1,1) PRIMARY KEY,
  order_id BIGINT NOT NULL,
  old_status NVARCHAR(50),
  new_status NVARCHAR(50) NOT NULL,
  changed_by INT NULL,
  changed_at DATETIME2 DEFAULT SYSUTCDATETIME(),
  CONSTRAINT FK_OrderStatusHistory_Order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE INDEX IDX_OrderStatusHistory_OrderId ON OrderStatusHistory(order_id);
