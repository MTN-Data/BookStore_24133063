package vn.edu.bookstore.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import vn.edu.bookstore.model.Book_24133063;
import vn.edu.bookstore.service.BookService_24133063;

@WebServlet(urlPatterns = {
    "/admin/books",
    "/admin/book/edit",
    "/admin/book/delete"
})
public class AdminBookController_24133063 extends Web_24133063 {

    private final BookService_24133063 svc = new BookService_24133063();

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        try {
            if (q.getServletPath().endsWith("edit")) {
                int id = number(q.getParameter("id"), 0);

                Book_24133063 b = id > 0
                        ? svc.find(id)
                        : new Book_24133063();

                if (b == null) {
                    r.sendError(404);
                    return;
                }

                q.setAttribute("book", b);
                view(q, r, "admin-form");
                return;
            }

            int page = Math.max(1, number(q.getParameter("page"), 1));
            int pages = Math.max(1, (svc.count(null) + 2) / 3);
            page = Math.min(page, pages);

            q.setAttribute("books", svc.page(null, page));
            q.setAttribute("page", page);
            q.setAttribute("pages", pages);

            view(q, r, "admin-books");
        } catch (Exception e) {
            error(q, r, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {

        q.setCharacterEncoding("UTF-8");

        try {
            int id = number(q.getParameter("id"), 0);

            if (q.getServletPath().endsWith("delete")) {
                if (id <= 0) {
                    r.sendError(400);
                    return;
                }

                svc.delete(id);
            } else {
                Book_24133063 b = new Book_24133063();

                b.id = id;
                b.isbn = q.getParameter("isbn");
                b.title = q.getParameter("title");
                b.publisher = q.getParameter("publisher");
                b.description = q.getParameter("description");
                b.coverImage = q.getParameter("coverImage");
                b.price = new BigDecimal(q.getParameter("price"));
                b.quantity = Integer.parseInt(q.getParameter("quantity"));

                String date = q.getParameter("publishDate");
                b.publishDate = date == null || date.isBlank()
                        ? null
                        : Date.valueOf(date);

                if (b.title == null
                        || b.title.isBlank()
                        || b.quantity < 0
                        || b.price.signum() < 0) {
                    throw new IllegalArgumentException(
                            "Dữ liệu sách không hợp lệ");
                }

                svc.save(b);
            }

            r.sendRedirect(q.getContextPath() + "/admin/books");
        } catch (Exception e) {
            error(q, r, e);
        }
    }
}