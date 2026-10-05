package vn.edu.bookstore.dao;

import vn.edu.bookstore.model.Order_24133063;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface OrderDAO_24133063 {
    int create(int userId, String recipientName, String phone,
               String address, Map<Integer, Integer> cart) throws SQLException;

    List<Order_24133063> listByUser(int userId, String status)
            throws SQLException;
}
