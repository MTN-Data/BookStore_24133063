package vn.edu.bookstore.dao;

import vn.edu.bookstore.config.DB_24133063;
import vn.edu.bookstore.model.*;
import java.sql.*;
import java.util.*;

public class BookDAOImpl_24133063 implements BookDAO_24133063 {

    private static final String BASE =
            "SELECT b.*, " +
            "COALESCE((SELECT STRING_AGG(a.author_name, ', ') " +
            "FROM book_author ba " +
            "JOIN author a ON a.author_id = ba.author_id " +
            "WHERE ba.bookid = b.bookid), '') authors, " +
            "(SELECT COUNT(*) FROM rating r " +
            "WHERE r.bookid = b.bookid) reviews " +
            "FROM books b";

    private Book_24133063 map(ResultSet r) throws SQLException {

        Book_24133063 b = new Book_24133063();

        b.id = r.getInt("bookid");
        b.isbn = r.getString("isbn");
        b.title = r.getString("title");
        b.publisher = r.getString("publisher");
        b.price = r.getBigDecimal("price");
        b.description = r.getString("description");
        b.publishDate = r.getDate("publish_date");
        b.coverImage = r.getString("cover_image");
        b.quantity = r.getInt("quantity");
        b.authors = r.getString("authors");
        b.reviews = r.getInt("reviews");

        return b;
    }

    public List<Book_24133063> page(Integer author, int page, int size)
            throws SQLException {

        List<Book_24133063> out = new ArrayList<>();

        String sql = BASE
                + (author == null
                    ? ""
                    : " WHERE EXISTS(SELECT 1 FROM book_author ba "
                    + "WHERE ba.bookid=b.bookid AND ba.author_id=?)")
                + " ORDER BY b.bookid OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(sql)
        ) {
            int n = 1;

            if (author != null) {
                s.setInt(n++, author);
            }

            s.setInt(n++, (page - 1) * size);
            s.setInt(n, size);

            try (ResultSet r = s.executeQuery()) {
                while (r.next()) {
                    out.add(map(r));
                }
            }
        }

        return out;
    }

    public int count(Integer author) throws SQLException {

        String sql = "SELECT COUNT(*) FROM books b"
                + (author == null
                    ? ""
                    : " WHERE EXISTS(SELECT 1 FROM book_author ba "
                    + "WHERE ba.bookid=b.bookid AND ba.author_id=?)");

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(sql)
        ) {
            if (author != null) {
                s.setInt(1, author);
            }

            try (ResultSet r = s.executeQuery()) {
                r.next();
                return r.getInt(1);
            }
        }
    }

    public Book_24133063 find(int id) throws SQLException {

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(
                BASE + " WHERE b.bookid=?"
            )
        ) {
            s.setInt(1, id);

            try (ResultSet r = s.executeQuery()) {
                return r.next() ? map(r) : null;
            }
        }
    }

    public List<Review_24133063> reviews(int id)
            throws SQLException {

        List<Review_24133063> out = new ArrayList<>();

        String sql =
                "SELECT u.fullname, r.rating, r.review_text, r.created_at " +
                "FROM rating r " +
                "JOIN users u ON u.id = r.userid " +
                "WHERE r.bookid=? " +
                "ORDER BY r.created_at DESC";

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(sql)
        ) {
            s.setInt(1, id);

            try (ResultSet r = s.executeQuery()) {
                while (r.next()) {

                    Review_24133063 v = new Review_24133063();

                    v.fullname = r.getString(1);
                    v.stars = r.getInt(2);
                    v.text = r.getString(3);
                    v.createdAt = r.getTimestamp(4);

                    out.add(v);
                }
            }
        }

        return out;
    }

    public List<Map<String, Object>> authors()
            throws SQLException {

        List<Map<String, Object>> out = new ArrayList<>();

        String sql =
                "SELECT author_id, author_name " +
                "FROM author ORDER BY author_name";

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(sql);
            ResultSet r = s.executeQuery()
        ) {
            while (r.next()) {

                Map<String, Object> m = new HashMap<>();

                m.put("id", r.getInt(1));
                m.put("name", r.getString(2));

                out.add(m);
            }
        }

        return out;
    }

    public void save(Book_24133063 b) throws SQLException {

        boolean edit = b.id > 0;

        String sql = edit
                ? "UPDATE books SET isbn=?, title=?, publisher=?, "
                + "price=?, description=?, publish_date=?, "
                + "cover_image=?, quantity=? WHERE bookid=?"
                : "INSERT INTO books(isbn, title, publisher, price, "
                + "description, publish_date, cover_image, quantity) "
                + "VALUES(?,?,?,?,?,?,?,?)";

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(sql)
        ) {
            s.setString(1, b.isbn);
            s.setString(2, b.title);
            s.setString(3, b.publisher);
            s.setBigDecimal(4, b.price);
            s.setString(5, b.description);
            s.setDate(6, b.publishDate);
            s.setString(7, b.coverImage);
            s.setInt(8, b.quantity);

            if (edit) {
                s.setInt(9, b.id);
            }

            s.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {

        try (Connection c = DB_24133063.open()) {

            c.setAutoCommit(false);

            try (
                PreparedStatement r = c.prepareStatement(
                    "DELETE FROM rating WHERE bookid=?"
                );
                PreparedStatement a = c.prepareStatement(
                    "DELETE FROM book_author WHERE bookid=?"
                );
                PreparedStatement b = c.prepareStatement(
                    "DELETE FROM books WHERE bookid=?"
                )
            ) {
                r.setInt(1, id);
                r.executeUpdate();

                a.setInt(1, id);
                a.executeUpdate();

                b.setInt(1, id);
                b.executeUpdate();

                c.commit();

            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            }
        }
    }

    public void addReview(int user, int book, int stars, String text)
            throws SQLException {

        String sql =
                "INSERT INTO rating(userid, bookid, rating, review_text) "
                + "VALUES(?,?,?,?)";

        try (
            Connection c = DB_24133063.open();
            PreparedStatement s = c.prepareStatement(sql)
        ) {
            s.setInt(1, user);
            s.setInt(2, book);
            s.setInt(3, stars);
            s.setString(4, text);

            s.executeUpdate();
        }
    }
}