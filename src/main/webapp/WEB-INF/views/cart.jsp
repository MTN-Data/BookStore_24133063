<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN" scope="page" />

<title>Giỏ hàng</title>

<style>
    .cart-heading { display:flex; justify-content:space-between; align-items:end; gap:16px; flex-wrap:wrap; margin-bottom:22px; }
    .cart-heading p { margin:0; color:#627487; }
    .message { margin-bottom:18px; padding:13px 16px; border-radius:10px; background:#eaf2ef; color:#385d57; }
    .cart-layout { display:grid; grid-template-columns:minmax(0,1fr) 310px; gap:24px; align-items:start; }
    .cart-row { display:grid; grid-template-columns:minmax(0,1fr) 120px 145px 90px; gap:16px; align-items:center; padding:18px 0; border-bottom:1px solid #e9edef; }
    .cart-row:last-child { border-bottom:0; }
    .cart-title { font-weight:800; color:#183247; }
    .cart-meta { color:#627487; font-size:14px; }
    .cart-row form { margin:0; }
    .qty-form { display:flex; gap:8px; align-items:center; }
    .qty-form input { width:72px !important; min-height:38px; }
    .qty-form button { margin:0; padding:8px 11px; }
    .remove-button { margin:0; padding:8px 11px; background:#fff0ed; color:#a33732; border:1px solid #e8c8c2; }
    .summary h2 { margin-top:0; }
    .summary-line { display:flex; justify-content:space-between; gap:16px; margin:12px 0; }
    .summary-total { padding-top:14px; border-top:1px solid #e9edef; font-size:20px; font-weight:800; color:#a15b25; }
    .summary .btn { width:100%; text-align:center; margin-top:16px; }
    .empty-cart { text-align:center; padding:42px 24px; }
    @media (max-width:800px) {
        .cart-layout { grid-template-columns:1fr; }
        .cart-row { grid-template-columns:1fr 110px; }
    }
</style>

<div class="cart-heading">
    <div>
        <h1>Giỏ hàng</h1>
        <p>Thêm, xóa và thay đổi số lượng trong giới hạn tồn kho.</p>
    </div>
    <a href="${pageContext.request.contextPath}/home">← Tiếp tục mua sách</a>
</div>

<c:if test="${not empty message}">
    <div class="message"><c:out value="${message}" /></div>
</c:if>

<c:choose>
    <c:when test="${empty items}">
        <div class="card empty-cart">
            <h2>Giỏ hàng đang trống</h2>
            <p>Hãy chọn một cuốn sách để bắt đầu đặt hàng.</p>
            <a class="btn" href="${pageContext.request.contextPath}/home">Xem danh sách sách</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="cart-layout">
            <div class="card">
                <c:forEach items="${items}" var="item">
                    <div class="cart-row">
                        <div>
                            <div class="cart-title"><c:out value="${item.book.title}" /></div>
                            <div class="cart-meta">
                                Còn ${item.book.quantity} cuốn ·
                                <fmt:formatNumber value="${item.book.price}" pattern="#,##0" /> ₫/cuốn
                            </div>
                        </div>

                        <form class="qty-form" method="post"
                              action="${pageContext.request.contextPath}/cart/update">
                            <input type="hidden" name="id" value="${item.book.id}">
                            <input type="number" name="quantity" min="1"
                                   max="${item.book.quantity}" value="${item.quantity}" required>
                            <button type="submit">Sửa</button>
                        </form>

                        <strong>
                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> ₫
                        </strong>

                        <form method="post" action="${pageContext.request.contextPath}/cart/remove">
                            <input type="hidden" name="id" value="${item.book.id}">
                            <button class="remove-button" type="submit">Xóa</button>
                        </form>
                    </div>
                </c:forEach>
            </div>

            <aside class="card summary">
                <h2>Tóm tắt đơn hàng</h2>
                <div class="summary-line">
                    <span>Số sản phẩm</span>
                    <strong>${fn:length(items)}</strong>
                </div>
                <div class="summary-line summary-total">
                    <span>Tổng cộng</span>
                    <span><fmt:formatNumber value="${total}" pattern="#,##0" /> ₫</span>
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/checkout">
                    Thanh toán COD
                </a>
            </aside>
        </div>
    </c:otherwise>
</c:choose>
