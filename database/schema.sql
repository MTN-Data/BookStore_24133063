IF DB_ID(N'BookStore_24133063') IS NULL CREATE DATABASE BookStore_24133063;
GO
USE BookStore_24133063;
GO
CREATE TABLE users(id INT IDENTITY PRIMARY KEY,email VARCHAR(100) NOT NULL UNIQUE,fullname NVARCHAR(100) NOT NULL,phone VARCHAR(20),passwd VARCHAR(60) NOT NULL,signup_date DATETIME2 DEFAULT SYSDATETIME(),last_login DATETIME2,is_admin BIT NOT NULL DEFAULT 0,is_active BIT NOT NULL DEFAULT 0,otp_hash VARCHAR(60),otp_expiry DATETIME2);
CREATE TABLE books(bookid INT IDENTITY PRIMARY KEY,isbn VARCHAR(20),title NVARCHAR(200) NOT NULL,publisher NVARCHAR(100),price DECIMAL(12,2),description NVARCHAR(MAX),publish_date DATE,cover_image NVARCHAR(500),quantity INT NOT NULL DEFAULT 0);
CREATE TABLE author(author_id INT IDENTITY PRIMARY KEY,author_name NVARCHAR(100) NOT NULL,date_of_birth DATE);
CREATE TABLE book_author(bookid INT NOT NULL REFERENCES books(bookid),author_id INT NOT NULL REFERENCES author(author_id),CONSTRAINT PK_book_author PRIMARY KEY(bookid,author_id));
CREATE TABLE rating(rating_id INT IDENTITY PRIMARY KEY,userid INT NOT NULL REFERENCES users(id),bookid INT NOT NULL REFERENCES books(bookid),rating TINYINT NOT NULL CHECK(rating BETWEEN 1 AND 5),review_text NVARCHAR(1000) NOT NULL,created_at DATETIME2 DEFAULT SYSDATETIME());
CREATE TABLE orders(order_id INT IDENTITY PRIMARY KEY,user_id INT NOT NULL REFERENCES users(id),order_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),total_amount DECIMAL(14,2) NOT NULL CHECK(total_amount>=0),payment_method VARCHAR(20) NOT NULL DEFAULT 'COD' CHECK(payment_method='COD'),status VARCHAR(30) NOT NULL DEFAULT 'NEW' CHECK(status IN ('NEW','CONFIRMED','PREPARING','SHIPPING','OUT_FOR_DELIVERY','DELIVERED','CANCELLED','RETURNED')),recipient_name NVARCHAR(100) NOT NULL,phone VARCHAR(20) NOT NULL,address NVARCHAR(500) NOT NULL);
CREATE TABLE order_items(order_item_id INT IDENTITY PRIMARY KEY,order_id INT NOT NULL REFERENCES orders(order_id),bookid INT NULL REFERENCES books(bookid) ON DELETE SET NULL,book_title NVARCHAR(200) NOT NULL,quantity INT NOT NULL CHECK(quantity>0),unit_price DECIMAL(12,2) NOT NULL CHECK(unit_price>=0));
CREATE INDEX IX_orders_user_status_date ON orders(user_id,status,order_date DESC);
GO
INSERT INTO author(author_name) VALUES (N'Nguyễn Nhật Ánh'),(N'Tô Hoài'),(N'Nam Cao');
INSERT INTO books(isbn,title,publisher,price,publish_date,quantity) VALUES
('9786040000011',N'Cho tôi xin một vé đi tuổi thơ',N'NXB Trẻ',85000,'2024-01-10',12),
('9786040000012',N'Mắt biếc',N'NXB Trẻ',95000,'2024-02-10',9),
('9786040000013',N'Tôi thấy hoa vàng trên cỏ xanh',N'NXB Trẻ',110000,'2024-03-10',14),
('9786040000014',N'Cô gái đến từ hôm qua',N'NXB Trẻ',88000,'2024-04-10',8),
('9786040000015',N'Dế Mèn phiêu lưu ký',N'NXB Kim Đồng',65000,'2023-05-10',18),
('9786040000016',N'Chí Phèo',N'NXB Văn Học',72000,'2023-06-10',11);
INSERT INTO book_author(bookid,author_id) VALUES (1,1),(2,1),(3,1),(4,1),(5,2),(6,3);
