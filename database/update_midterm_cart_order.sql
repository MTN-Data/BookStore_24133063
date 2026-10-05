USE BookStore_24133063;
GO

IF OBJECT_ID(N'dbo.orders', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.orders (
        order_id INT IDENTITY PRIMARY KEY,
        user_id INT NOT NULL REFERENCES dbo.users(id),
        order_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        total_amount DECIMAL(14,2) NOT NULL CHECK (total_amount >= 0),
        payment_method VARCHAR(20) NOT NULL DEFAULT 'COD',
        status VARCHAR(30) NOT NULL DEFAULT 'NEW',
        recipient_name NVARCHAR(100) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        address NVARCHAR(500) NOT NULL,
        CONSTRAINT CK_orders_payment CHECK (payment_method IN ('COD')),
        CONSTRAINT CK_orders_status CHECK (status IN (
            'NEW', 'CONFIRMED', 'PREPARING', 'SHIPPING',
            'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED', 'RETURNED'
        ))
    );
END;
GO

IF OBJECT_ID(N'dbo.order_items', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.order_items (
        order_item_id INT IDENTITY PRIMARY KEY,
        order_id INT NOT NULL REFERENCES dbo.orders(order_id),
        bookid INT NULL REFERENCES dbo.books(bookid) ON DELETE SET NULL,
        book_title NVARCHAR(200) NOT NULL,
        quantity INT NOT NULL CHECK (quantity > 0),
        unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price >= 0)
    );
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_orders_user_status_date'
      AND object_id = OBJECT_ID('dbo.orders')
)
BEGIN
    CREATE INDEX IX_orders_user_status_date
    ON dbo.orders(user_id, status, order_date DESC);
END;
GO
