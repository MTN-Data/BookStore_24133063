package vn.edu.bookstore.controller;

import vn.edu.bookstore.model.CartItem_24133063;
import vn.edu.bookstore.model.User_24133063;
import vn.edu.bookstore.service.CartService_24133063;
import vn.edu.bookstore.service.OrderService_24133063;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutController_24133063 extends Web_24133063 {
    private final CartService_24133063 cartService = new CartService_24133063();
    private final OrderService_24133063 orderService = new OrderService_24133063();

    @SuppressWarnings("unchecked")
    private Map<Integer, Integer> cart(HttpSession session) {
        Object value = session.getAttribute("cart");
        if (value instanceof Map) return (Map<Integer, Integer>) value;
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

    private boolean prepare(HttpServletRequest q, HttpServletResponse r)
            throws Exception {
        List<CartItem_24133063> items = cartService.items(cart(q.getSession()));
        if (items.isEmpty()) {
            q.getSession().setAttribute("cartFlash", "Giỏ hàng đang trống");
            r.sendRedirect(q.getContextPath() + "/cart");
            return false;
        }
        q.setAttribute("items", items);
        q.setAttribute("total", cartService.total(items));
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        User_24133063 u = requireUser(q, r);
        if (u == null) return;

        try {
            if (!prepare(q, r)) return;
            q.setAttribute("recipientName", u.fullname);
            view(q, r, "checkout");
        } catch (Exception e) {
            error(q, r, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        q.setCharacterEncoding("UTF-8");
        User_24133063 u = requireUser(q, r);
        if (u == null) return;

        String name = q.getParameter("recipientName");
        String phone = q.getParameter("phone");
        String address = q.getParameter("address");

        try {
            Map<Integer, Integer> cart = cart(q.getSession());
            int orderId = orderService.checkout(u.id, name, phone, address, cart);
            cart.clear();
            r.sendRedirect(q.getContextPath() + "/orders?placed=" + orderId);
        } catch (Exception e) {
            q.setAttribute("message", e.getMessage());
            q.setAttribute("recipientName", name);
            q.setAttribute("phone", phone);
            q.setAttribute("address", address);
            try {
                if (!prepare(q, r)) return;
                view(q, r, "checkout");
            } catch (Exception nested) {
                error(q, r, nested);
            }
        }
    }
}
