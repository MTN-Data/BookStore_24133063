package vn.edu.bookstore.service;

import vn.edu.bookstore.model.Book_24133063;
import vn.edu.bookstore.model.CartItem_24133063;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CartService_24133063 {
    private final BookService_24133063 books = new BookService_24133063();

    public Book_24133063 requireBook(int bookId) throws SQLException {
        Book_24133063 b = books.find(bookId);
        if (b == null) {
            throw new IllegalArgumentException("Sách không tồn tại");
        }
        return b;
    }

    public void add(Map<Integer, Integer> cart, int bookId, int addQuantity)
            throws SQLException {
        Book_24133063 b = requireBook(bookId);
        if (addQuantity < 1) {
            throw new IllegalArgumentException("Số lượng phải từ 1 trở lên");
        }
        if (b.quantity < 1) {
            throw new IllegalArgumentException("Sách đã hết hàng");
        }

        int current = cart.getOrDefault(bookId, 0);
        long next = (long) current + addQuantity;
        if (next > b.quantity) {
            throw new IllegalArgumentException(
                    "Chỉ còn " + b.quantity + " cuốn trong kho");
        }
        cart.put(bookId, (int) next);
    }

    public void update(Map<Integer, Integer> cart, int bookId, int quantity)
            throws SQLException {
        if (!cart.containsKey(bookId)) {
            throw new IllegalArgumentException("Sản phẩm không có trong giỏ hàng");
        }
        if (quantity <= 0) {
            cart.remove(bookId);
            return;
        }

        Book_24133063 b = requireBook(bookId);
        if (quantity > b.quantity) {
            throw new IllegalArgumentException(
                    "Số lượng tối đa hiện có là " + b.quantity);
        }
        cart.put(bookId, quantity);
    }

    public List<CartItem_24133063> items(Map<Integer, Integer> cart)
            throws SQLException {
        List<CartItem_24133063> out = new ArrayList<>();
        for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
            Book_24133063 b = books.find(e.getKey());
            if (b != null && e.getValue() > 0) {
                out.add(new CartItem_24133063(b, e.getValue()));
            }
        }
        return out;
    }

    public BigDecimal total(List<CartItem_24133063> items) {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem_24133063 item : items) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }
}
