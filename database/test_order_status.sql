USE BookStore_24133063;
GO

-- Xem các đơn đã tạo (lấy order_id cần test)
SELECT order_id, user_id, order_date, total_amount, payment_method, status
FROM orders
ORDER BY order_id DESC;
GO

-- Thay <ORDER_ID> bằng mã đơn muốn kiểm tra rồi chạy TỪNG lệnh một.
-- Sau mỗi lần UPDATE, tải lại trang Lịch sử đặt hàng để quan sát trạng thái.

-- UPDATE orders SET status='NEW'              WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='CONFIRMED'        WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='PREPARING'        WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='SHIPPING'         WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='OUT_FOR_DELIVERY' WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='DELIVERED'        WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='CANCELLED'        WHERE order_id=<ORDER_ID>;
-- UPDATE orders SET status='RETURNED'         WHERE order_id=<ORDER_ID>;
