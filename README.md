# BookStore_24133063 — đề 02

Nguyễn Minh Tiến · MSSV 24133063. Maven WAR, Java 17, Tomcat 9, SQL Server, Servlet/JDBC/JSP, SiteMesh 3.


## Phần giữa kỳ làm tiếp cho vai trò User

### 1. Giỏ hàng
- Thêm sách từ trang danh sách hoặc chi tiết.
- Xóa sản phẩm khỏi giỏ.
- Sửa số lượng.
- Số lượng luôn được kiểm tra trong giới hạn tồn kho.
- Giỏ hàng lưu trong HttpSession.

### 2. Thanh toán COD
- Trang checkout nhập tên người nhận, số điện thoại, địa chỉ.
- Phương thức thanh toán cố định COD.
- Khi đặt hàng, hệ thống kiểm tra tồn kho lại trong transaction, tạo đơn + chi tiết đơn và trừ tồn kho.

### 3. Lịch sử đặt hàng
- Xem các đơn của user đang đăng nhập.
- Lọc theo 8 trạng thái: NEW, CONFIRMED, PREPARING, SHIPPING, OUT_FOR_DELIVERY, DELIVERED, CANCELLED, RETURNED.
- File `database/test_order_status.sql` có các lệnh UPDATE mẫu để đổi trạng thái trong database và quan sát giao diện.

