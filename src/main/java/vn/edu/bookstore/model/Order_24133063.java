package vn.edu.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order_24133063 {
    public int id;
    public int userId;
    public Timestamp orderDate;
    public BigDecimal totalAmount;
    public String paymentMethod;
    public String status;
    public String recipientName;
    public String phone;
    public String address;
    public List<OrderItem_24133063> items = new ArrayList<>();

    public int getId() { return id; }
    public int getUserId() { return userId; }
    public Timestamp getOrderDate() { return orderDate; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getStatus() { return status; }
    public String getRecipientName() { return recipientName; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public List<OrderItem_24133063> getItems() { return items; }

    public String getStatusLabel() {
        if (status == null) return "";
        switch (status) {
            case "NEW": return "Đơn hàng mới";
            case "CONFIRMED": return "Đã xác nhận";
            case "PREPARING": return "Chuẩn bị hàng";
            case "SHIPPING": return "Vận chuyển";
            case "OUT_FOR_DELIVERY": return "Giao hàng";
            case "DELIVERED": return "Đã giao";
            case "CANCELLED": return "Đơn hàng hủy";
            case "RETURNED": return "Đơn hàng hoàn";
            default: return status;
        }
    }
}
