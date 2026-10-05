package vn.edu.bookstore.service;

import vn.edu.bookstore.dao.OrderDAO_24133063;
import vn.edu.bookstore.dao.OrderDAOImpl_24133063;
import vn.edu.bookstore.model.Order_24133063;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class OrderService_24133063 {
    private final OrderDAO_24133063 dao = new OrderDAOImpl_24133063();

    private static final Set<String> STATUS = new LinkedHashSet<>(Arrays.asList(
            "NEW", "CONFIRMED", "PREPARING", "SHIPPING",
            "OUT_FOR_DELIVERY", "DELIVERED", "CANCELLED", "RETURNED"));

    public int checkout(int userId, String recipientName, String phone,
                        String address, Map<Integer, Integer> cart)
            throws SQLException {
        recipientName = clean(recipientName);
        phone = clean(phone);
        address = clean(address);

        if (recipientName.isEmpty())
            throw new IllegalArgumentException("Vui lòng nhập tên người nhận");
        if (phone.isEmpty() || phone.length() > 20)
            throw new IllegalArgumentException("Số điện thoại không hợp lệ");
        if (address.isEmpty() || address.length() > 500)
            throw new IllegalArgumentException("Địa chỉ giao hàng không hợp lệ");

        return dao.create(userId, recipientName, phone, address,
                new LinkedHashMap<>(cart));
    }

    public List<Order_24133063> history(int userId, String status)
            throws SQLException {
        String value = normalizeStatus(status);
        return dao.listByUser(userId, value);
    }

    public String normalizeStatus(String status) {
        if (status == null || status.isBlank()) return null;
        String value = status.trim().toUpperCase();
        return STATUS.contains(value) ? value : null;
    }

    public Map<String, String> statuses() {
        Map<String, String> out = new LinkedHashMap<>();
        out.put("NEW", "Đơn hàng mới");
        out.put("CONFIRMED", "Đã xác nhận");
        out.put("PREPARING", "Chuẩn bị hàng");
        out.put("SHIPPING", "Vận chuyển");
        out.put("OUT_FOR_DELIVERY", "Giao hàng");
        out.put("DELIVERED", "Đã giao");
        out.put("CANCELLED", "Đơn hàng hủy");
        out.put("RETURNED", "Đơn hàng hoàn");
        return out;
    }

    private String clean(String s) {
        return s == null ? "" : s.trim();
    }
}
