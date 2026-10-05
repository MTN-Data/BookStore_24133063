<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" scope="page" />

<title>Thanh toán COD</title>

<style>
    .checkout-layout { display:grid; grid-template-columns:minmax(0,1fr) 360px; gap:26px; align-items:start; }
    .checkout-form h2, .order-summary h2 { margin-top:0; }
    .notice { margin-bottom:18px; padding:13px 16px; border-radius:10px; background:#fff0ed; color:#a33732; }
    .cod-box { padding:14px 16px; border-radius:10px; background:#eaf2ef; color:#385d57; margin-bottom:18px; }
    .order-line { display:flex; justify-content:space-between; gap:16px; padding:10px 0; border-bottom:1px solid #e9edef; }
    .order-line:last-of-type { border-bottom:0; }
    .total { display:flex; justify-content:space-between; gap:16px; margin-top:16px; padding-top:16px; border-top:2px solid #e9edef; font-size:20px; font-weight:800; color:#a15b25; }
    .checkout-form button { width:100%; }
    @media (max-width:800px) { .checkout-layout { grid-template-columns:1fr; } }
</style>

<a href="${pageContext.request.contextPath}/cart">← Quay lại giỏ hàng</a>
<h1>Thanh toán đơn hàng</h1>

<c:if test="${not empty message}">
    <div class="notice"><c:out value="${message}" /></div>
</c:if>

<div class="checkout-layout">
    <form class="panel checkout-form" method="post"
          action="${pageContext.request.contextPath}/checkout">
        <h2>Thông tin nhận hàng</h2>
        <div class="cod-box">
            Phương thức thanh toán: <strong>COD - thanh toán khi nhận hàng</strong>.
        </div>

        <label for="recipientName">Tên người nhận</label>
        <input id="recipientName" name="recipientName" maxlength="100"
               value="<c:out value='${recipientName}' />" required>

        <label for="phone">Số điện thoại</label>
        <input id="phone" name="phone" maxlength="20"
               value="<c:out value='${phone}' />" required>

        <label for="address">Địa chỉ giao hàng</label>
        <textarea id="address" name="address" maxlength="500" required><c:out value="${address}" /></textarea>

        <button type="submit">Xác nhận đặt hàng COD</button>
    </form>

    <aside class="card order-summary">
        <h2>Đơn hàng của bạn</h2>
        <c:forEach items="${items}" var="item">
            <div class="order-line">
                <span><c:out value="${item.book.title}" /> × ${item.quantity}</span>
                <strong><fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> ₫</strong>
            </div>
        </c:forEach>
        <div class="total">
            <span>Tổng cộng</span>
            <span><fmt:formatNumber value="${total}" pattern="#,##0" /> ₫</span>
        </div>
    </aside>
</div>
