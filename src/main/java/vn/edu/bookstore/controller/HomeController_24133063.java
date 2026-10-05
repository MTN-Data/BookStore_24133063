package vn.edu.bookstore.controller;

import vn.edu.bookstore.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;

@WebServlet(urlPatterns = {"/", "/home", "/books"})
public class HomeController_24133063 extends Web_24133063 {

    private final BookService_24133063 svc = new BookService_24133063();

    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {

        try {
            int a = number(q.getParameter("author"), 0);
            int page = Math.max(1, number(q.getParameter("page"), 1));

            Integer author = a > 0 ? a : null;

            int total = svc.count(author);
            int pages = Math.max(1, (total + 2) / 3);

            page = Math.min(page, pages);

            q.setAttribute("authors", svc.authors());
            q.setAttribute("books", svc.page(author, page));
            q.setAttribute("page", page);
            q.setAttribute("pages", pages);
            q.setAttribute("author", a);

            view(q, r, "home");

        } catch (Exception e) {
            error(q, r, e);
        }
    }
}