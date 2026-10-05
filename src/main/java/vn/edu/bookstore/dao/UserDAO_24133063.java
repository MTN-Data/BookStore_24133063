package vn.edu.bookstore.dao;
import vn.edu.bookstore.model.User_24133063;import java.sql.*;
public interface UserDAO_24133063 {User_24133063 byEmail(String email)throws SQLException;void create(String email,String name,String phone,String hash,String otpHash)throws SQLException;boolean activate(String email,String otp)throws SQLException;void login(int id)throws SQLException;}