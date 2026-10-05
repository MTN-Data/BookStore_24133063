package vn.edu.bookstore.dao;
import vn.edu.bookstore.model.*;
import java.sql.*;import java.util.*;
public interface BookDAO_24133063 {
 List<Book_24133063> page(Integer author,int page,int size)throws SQLException;
 int count(Integer author)throws SQLException;
 Book_24133063 find(int id)throws SQLException;
 List<Review_24133063> reviews(int id)throws SQLException;
 List<Map<String,Object>> authors()throws SQLException;
 void save(Book_24133063 b)throws SQLException;
 void delete(int id)throws SQLException;
 void addReview(int user,int book,int stars,String text)throws SQLException;
}