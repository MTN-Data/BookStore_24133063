package vn.edu.bookstore.model;

import java.math.BigDecimal;

public class OrderItem_24133063 {
    public int bookId;
    public String title;
    public int quantity;
    public BigDecimal unitPrice;

    public int getBookId() { return bookId; }
    public String getTitle() { return title; }
    public int getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public BigDecimal getSubtotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
