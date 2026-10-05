package vn.edu.bookstore.service;

import vn.edu.bookstore.dao.*;
import vn.edu.bookstore.model.*;
import java.sql.*;
import java.util.*;

public class BookService_24133063 {

    private final BookDAO_24133063 dao = new BookDAOImpl_24133063();

    public List<Book_24133063> page(Integer author, int page)
            throws SQLException {
        return dao.page(author, page, 3);
    }

    public int count(Integer author) throws SQLException {
        return dao.count(author);
    }

    public Book_24133063 find(int id) throws SQLException {
        return dao.find(id);
    }

    public List<Review_24133063> reviews(int id) throws SQLException {
        return dao.reviews(id);
    }

    public List<Map<String, Object>> authors() throws SQLException {
        return dao.authors();
    }

    public void save(Book_24133063 b) throws SQLException {
        dao.save(b);
    }

    public void delete(int id) throws SQLException {
        dao.delete(id);
    }

    public void review(int user, int book, int stars, String text)
            throws SQLException {
        dao.addReview(user, book, stars, text);
    }
}