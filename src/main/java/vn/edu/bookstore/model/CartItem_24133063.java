package vn.edu.bookstore.model;

import java.math.BigDecimal;

public class CartItem_24133063 {
    private final Book_24133063 book;
    private final int quantity;

    public CartItem_24133063(Book_24133063 book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }

    public Book_24133063 getBook() {
        return book;
    }

    public int getQuantity() {
        return quantity;
    }

    public BigDecimal getSubtotal() {
        return book.price.multiply(BigDecimal.valueOf(quantity));
    }
}
