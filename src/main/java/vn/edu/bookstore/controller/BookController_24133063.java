package vn.edu.bookstore.controller;

import vn.edu.bookstore.service.BookService_24133063;
import vn.edu.bookstore.model.Book_24133063;
import vn.edu.bookstore.model.User_24133063;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/book")
public class BookController_24133063 extends Web_24133063 {

    private final BookService_24133063 svc = new BookService_24133063();

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        try {
            int id = number(q.getParameter("id"), 0);
            Book_24133063 b = svc.find(id);

            if (b == null) {
                r.sendError(404);
                return;
            }

            q.setAttribute("book", b);
            q.setAttribute("reviews", svc.reviews(id));
            view(q, r, "book");
        } catch (Exception e) {
            error(q, r, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");

        try {
            User_24133063 u =
                    (User_24133063) q.getSession().getAttribute("user");

            if (u == null) {
                r.sendRedirect(q.getContextPath() + "/login");
                return;
            }

            int id = number(q.getParameter("id"), 0);
            int stars = number(q.getParameter("stars"), 0);
            String text = q.getParameter("text");

            if (svc.find(id) == null) {
                r.sendError(404);
                return;
            }

            if (stars < 1 || stars > 5
                    || text == null || text.isBlank()
                    || text.length() > 1000) {
                r.sendError(400);
                return;
            }

            svc.review(u.id, id, stars, text.trim());
            r.sendRedirect(q.getContextPath() + "/book?id=" + id);
        } catch (Exception e) {
            error(q, r, e);
        }
    }
}