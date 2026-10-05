package vn.edu.bookstore.dao;

import vn.edu.bookstore.config.DB_24133063;
import vn.edu.bookstore.model.OrderItem_24133063;
import vn.edu.bookstore.model.Order_24133063;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderDAOImpl_24133063 implements OrderDAO_24133063 {

    private static class Snapshot {
        String title;
        BigDecimal price;
        int stock;
    }

    @Override
    public int create(int userId, String recipientName, String phone,
                      String address, Map<Integer, Integer> cart)
            throws SQLException {
        if (cart == null || cart.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng đang trống");
        }

        try (Connection c = DB_24133063.open()) {
            c.setAutoCommit(false);
            try {
                Map<Integer, Snapshot> snapshots = new LinkedHashMap<>();
                BigDecimal total = BigDecimal.ZERO;

                String lockSql = "SELECT title, price, quantity FROM books "
                        + "WITH (UPDLOCK, ROWLOCK) WHERE bookid=?";
                try (PreparedStatement s = c.prepareStatement(lockSql)) {
                    for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
                        int bookId = e.getKey();
                        int qty = e.getValue();
                        if (qty < 1) {
                            throw new IllegalArgumentException("Số lượng không hợp lệ");
                        }

                        s.setInt(1, bookId);
                        try (ResultSet r = s.executeQuery()) {
                            if (!r.next()) {
                                throw new IllegalArgumentException(
                                        "Có sách trong giỏ không còn tồn tại");
                            }
                            Snapshot v = new Snapshot();
                            v.title = r.getString("title");
                            v.price = r.getBigDecimal("price");
                            v.stock = r.getInt("quantity");
                            if (qty > v.stock) {
                                throw new IllegalArgumentException(
                                        "Sách '" + v.title + "' chỉ còn "
                                                + v.stock + " cuốn");
                            }
                            snapshots.put(bookId, v);
                            total = total.add(
                                    v.price.multiply(BigDecimal.valueOf(qty)));
                        }
                    }
                }

                int orderId;
                String orderSql = "INSERT INTO orders(user_id,total_amount,"
                        + "payment_method,status,recipient_name,phone,address) "
                        + "VALUES(?,?,'COD','NEW',?,?,?)";
                try (PreparedStatement s = c.prepareStatement(
                        orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    s.setInt(1, userId);
                    s.setBigDecimal(2, total);
                    s.setString(3, recipientName);
                    s.setString(4, phone);
                    s.setString(5, address);
                    s.executeUpdate();
                    try (ResultSet keys = s.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Không tạo được mã đơn hàng");
                        }
                        orderId = keys.getInt(1);
                    }
                }

                String itemSql = "INSERT INTO order_items(order_id,bookid,book_title,"
                        + "quantity,unit_price) VALUES(?,?,?,?,?)";
                String stockSql = "UPDATE books SET quantity=quantity-? "
                        + "WHERE bookid=? AND quantity>=?";
                try (PreparedStatement item = c.prepareStatement(itemSql);
                     PreparedStatement stock = c.prepareStatement(stockSql)) {
                    for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
                        int bookId = e.getKey();
                        int qty = e.getValue();
                        Snapshot v = snapshots.get(bookId);

                        item.setInt(1, orderId);
                        item.setInt(2, bookId);
                        item.setString(3, v.title);
                        item.setInt(4, qty);
                        item.setBigDecimal(5, v.price);
                        item.executeUpdate();

                        stock.setInt(1, qty);
                        stock.setInt(2, bookId);
                        stock.setInt(3, qty);
                        if (stock.executeUpdate() != 1) {
                            throw new SQLException(
                                    "Tồn kho vừa thay đổi, vui lòng thử lại");
                        }
                    }
                }

                c.commit();
                return orderId;
            } catch (Exception ex) {
                c.rollback();
                if (ex instanceof SQLException) throw (SQLException) ex;
                if (ex instanceof IllegalArgumentException)
                    throw (IllegalArgumentException) ex;
                throw new SQLException(ex);
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    @Override
    public List<Order_24133063> listByUser(int userId, String status)
            throws SQLException {
        List<Order_24133063> out = new ArrayList<>();
        String sql = "SELECT order_id,user_id,order_date,total_amount,"
                + "payment_method,status,recipient_name,phone,address "
                + "FROM orders WHERE user_id=?"
                + (status == null ? "" : " AND status=?")
                + " ORDER BY order_date DESC, order_id DESC";

        try (Connection c = DB_24133063.open();
             PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, userId);
            if (status != null) s.setString(2, status);

            try (ResultSet r = s.executeQuery()) {
                while (r.next()) {
                    Order_24133063 o = new Order_24133063();
                    o.id = r.getInt("order_id");
                    o.userId = r.getInt("user_id");
                    o.orderDate = r.getTimestamp("order_date");
                    o.totalAmount = r.getBigDecimal("total_amount");
                    o.paymentMethod = r.getString("payment_method");
                    o.status = r.getString("status");
                    o.recipientName = r.getString("recipient_name");
                    o.phone = r.getString("phone");
                    o.address = r.getString("address");
                    out.add(o);
                }
            }

            String itemSql = "SELECT oi.bookid,oi.book_title,oi.quantity,oi.unit_price "
                    + "FROM order_items oi WHERE oi.order_id=? "
                    + "ORDER BY oi.order_item_id";
            try (PreparedStatement item = c.prepareStatement(itemSql)) {
                for (Order_24133063 o : out) {
                    item.setInt(1, o.id);
                    try (ResultSet r = item.executeQuery()) {
                        while (r.next()) {
                            OrderItem_24133063 x = new OrderItem_24133063();
                            x.bookId = r.getInt(1);
                            x.title = r.getString(2);
                            x.quantity = r.getInt(3);
                            x.unitPrice = r.getBigDecimal(4);
                            o.items.add(x);
                        }
                    }
                }
            }
        }
        return out;
    }
}
