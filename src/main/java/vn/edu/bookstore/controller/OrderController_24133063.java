package vn.edu.bookstore.controller;

import vn.edu.bookstore.model.User_24133063;
import vn.edu.bookstore.service.OrderService_24133063;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/orders")
public class OrderController_24133063 extends Web_24133063 {
    private final OrderService_24133063 svc = new OrderService_24133063();

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        User_24133063 u = (User_24133063) q.getSession().getAttribute("user");
        if (u == null) {
            r.sendRedirect(q.getContextPath() + "/login");
            return;
        }

        try {
            String status = svc.normalizeStatus(q.getParameter("status"));
            q.setAttribute("orders", svc.history(u.id, status));
            q.setAttribute("statuses", svc.statuses());
            q.setAttribute("selectedStatus", status == null ? "" : status);

            int placed = number(q.getParameter("placed"), 0);
            if (placed > 0) {
                q.setAttribute("message",
                        "Đặt hàng COD thành công. Mã đơn hàng #" + placed);
            }
            view(q, r, "orders");
        } catch (Exception e) {
            error(q, r, e);
        }
    }
}
