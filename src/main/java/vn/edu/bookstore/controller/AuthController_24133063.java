package vn.edu.bookstore.controller;

import vn.edu.bookstore.service.*;
import vn.edu.bookstore.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;

@WebServlet(urlPatterns = {"/register", "/activate", "/login", "/logout"})
public class AuthController_24133063 extends Web_24133063 {

    private final AuthService_24133063 svc = new AuthService_24133063();

    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {

        String path = q.getServletPath();

        if (path.equals("/logout")) {
            q.getSession().invalidate();
            r.sendRedirect(q.getContextPath() + "/login");
            return;
        }

        view(q, r, path.substring(1));
    }

    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {

        String path = q.getServletPath();

        try {
            if (path.equals("/register")) {
                String email = q.getParameter("email").trim().toLowerCase();

                svc.register(
                    email,
                    q.getParameter("fullname").trim(),
                    q.getParameter("phone"),
                    q.getParameter("password")
                );

                q.getSession().setAttribute("pendingEmail", email);
                r.sendRedirect(q.getContextPath() + "/activate");
                return;
            }

            if (path.equals("/activate")) {
                String email = (String) q.getSession()
                        .getAttribute("pendingEmail");

                if (email != null && svc.activate(email, q.getParameter("otp"))) {
                    q.getSession().removeAttribute("pendingEmail");
                    r.sendRedirect(q.getContextPath() + "/login?activated=1");
                    return;
                }

                q.setAttribute("message", "OTP sai hoặc hết hạn");
                view(q, r, "activate");
                return;
            }

            if (path.equals("/login")) {
                User_24133063 u = svc.login(
                    q.getParameter("email").trim().toLowerCase(),
                    q.getParameter("password")
                );

                if (u != null) {
                    q.getSession().invalidate();

                    HttpSession session = q.getSession(true);
                    session.setAttribute("user", u);

                    r.sendRedirect(
                        q.getContextPath() + (u.admin ? "/admin/books" : "/home")
                    );
                    return;
                }

                q.setAttribute(
                    "message",
                    "Thông tin đăng nhập không đúng hoặc tài khoản chưa kích hoạt"
                );

                view(q, r, "login");
            }

        } catch (Exception e) {
            q.setAttribute("message", e.getMessage());

            view(
                q,
                r,
                path.equals("/register") ? "register"
                    : path.equals("/activate") ? "activate"
                    : "login"
            );
        }
    }
}