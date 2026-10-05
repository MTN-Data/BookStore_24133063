package vn.edu.bookstore.controller;

import vn.edu.bookstore.model.CartItem_24133063;
import vn.edu.bookstore.model.User_24133063;
import vn.edu.bookstore.service.CartService_24133063;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartController_24133063 extends Web_24133063 {
    private final CartService_24133063 svc = new CartService_24133063();

    @SuppressWarnings("unchecked")
    private Map<Integer, Integer> cart(HttpSession session) {
        Object value = session.getAttribute("cart");
        if (value instanceof Map) {
            return (Map<Integer, Integer>) value;
        }
        Map<Integer, Integer> cart = new LinkedHashMap<>();
        session.setAttribute("cart", cart);
        return cart;
    }

    private User_24133063 requireUser(HttpServletRequest q, HttpServletResponse r)
            throws IOException {
        User_24133063 u = (User_24133063) q.getSession().getAttribute("user");
        if (u == null) {
            r.sendRedirect(q.getContextPath() + "/login");
            return null;
        }
        return u;
    }

    private void flash(HttpSession session, String message) {
        session.setAttribute("cartFlash", message);
    }

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        if (requireUser(q, r) == null) return;

        try {
            HttpSession session = q.getSession();
            Object flash = session.getAttribute("cartFlash");
            if (flash != null) {
                q.setAttribute("message", flash.toString());
                session.removeAttribute("cartFlash");
            }

            List<CartItem_24133063> items = svc.items(cart(session));
            q.setAttribute("items", items);
            q.setAttribute("total", svc.total(items));
            view(q, r, "cart");
        } catch (Exception e) {
            error(q, r, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        if (requireUser(q, r) == null) return;

        HttpSession session = q.getSession();
        Map<Integer, Integer> cart = cart(session);
        String path = q.getServletPath();

        try {
            int id = number(q.getParameter("id"), 0);
            if (id <= 0) throw new IllegalArgumentException("Mã sách không hợp lệ");

            if (path.endsWith("/add")) {
                int quantity = number(q.getParameter("quantity"), 1);
                svc.add(cart, id, quantity);
                flash(session, "Đã thêm sách vào giỏ hàng");
            } else if (path.endsWith("/update")) {
                int quantity = number(q.getParameter("quantity"), 0);
                svc.update(cart, id, quantity);
                flash(session, quantity <= 0
                        ? "Đã xóa sản phẩm khỏi giỏ hàng"
                        : "Đã cập nhật số lượng");
            } else if (path.endsWith("/remove")) {
                cart.remove(id);
                flash(session, "Đã xóa sản phẩm khỏi giỏ hàng");
            }
        } catch (Exception e) {
            flash(session, e.getMessage());
        }

        r.sendRedirect(q.getContextPath() + "/cart");
    }
}
