<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" scope="page" />

<title>Lịch sử đặt hàng</title>

<style>
    .history-heading { margin-bottom:22px; }
    .history-heading p { margin:0; color:#627487; }
    .filter-box { display:flex; align-items:end; gap:12px; flex-wrap:wrap; margin-bottom:24px; padding:18px 22px; background:white; border:1px solid #e5e9ea; border-radius:14px; }
    .filter-box label { margin:0 0 7px; }
    .filter-box button { margin:0; }
    .message { margin-bottom:18px; padding:13px 16px; border-radius:10px; background:#eaf2ef; color:#385d57; }
    .order-card { margin-bottom:20px; }
    .order-head { display:flex; justify-content:space-between; gap:18px; flex-wrap:wrap; padding-bottom:16px; border-bottom:1px solid #e9edef; }
    .order-id { font-size:20px; font-weight:800; color:#183247; }
    .order-date { color:#627487; font-size:14px; }
    .status { display:inline-block; padding:7px 11px; border-radius:20px; background:#eaf2ef; color:#385d57; font-weight:800; }
    .order-item { display:grid; grid-template-columns:minmax(0,1fr) 90px 150px; gap:15px; padding:13px 0; border-bottom:1px solid #f0f2f3; }
    .order-item:last-child { border-bottom:0; }
    .order-footer { display:flex; justify-content:space-between; gap:20px; flex-wrap:wrap; padding-top:16px; border-top:1px solid #e9edef; }
    .address { color:#526376; max-width:650px; }
    .total { color:#a15b25; font-size:20px; font-weight:800; white-space:nowrap; }
    .empty { text-align:center; padding:38px 24px; }
    @media (max-width:650px) { .order-item { grid-template-columns:1fr 70px; } .order-price { grid-column:1/-1; } }
</style>

<div class="history-heading">
    <h1>Lịch sử đặt hàng</h1>
    <p>Lọc đơn theo từng trạng thái để theo dõi quá trình xử lý đơn hàng.</p>
</div>

<c:if test="${not empty message}">
    <div class="message"><c:out value="${message}" /></div>
</c:if>

<form class="filter-box" method="get" action="${pageContext.request.contextPath}/orders">
    <div>
        <label for="status">Trạng thái đơn hàng</label>
        <select id="status" name="status">
            <option value="">Tất cả trạng thái</option>
            <c:forEach items="${statuses}" var="s">
                <option value="${s.key}" <c:if test="${selectedStatus == s.key}">selected</c:if>>
                    <c:out value="${s.value}" />
                </option>
            </c:forEach>
        </select>
    </div>
    <button type="submit">Lọc đơn hàng</button>
</form>

<c:choose>
    <c:when test="${empty orders}">
        <div class="card empty">
            Chưa có đơn hàng phù hợp với trạng thái đã chọn.
        </div>
    </c:when>
    <c:otherwise>
        <c:forEach items="${orders}" var="o">
            <article class="card order-card">
                <div class="order-head">
                    <div>
                        <div class="order-id">Đơn hàng #${o.id}</div>
                        <div class="order-date">
                            <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                            · Thanh toán ${o.paymentMethod}
                        </div>
                    </div>
                    <span class="status"><c:out value="${o.statusLabel}" /></span>
                </div>

                <c:forEach items="${o.items}" var="item">
                    <div class="order-item">
                        <div><strong><c:out value="${item.title}" /></strong></div>
                        <div>SL: ${item.quantity}</div>
                        <div class="order-price">
                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0" /> ₫
                        </div>
                    </div>
                </c:forEach>

                <div class="order-footer">
                    <div class="address">
                        Người nhận: <strong><c:out value="${o.recipientName}" /></strong><br>
                        SĐT: <c:out value="${o.phone}" /><br>
                        Địa chỉ: <c:out value="${o.address}" />
                    </div>
                    <div class="total">
                        Tổng: <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0" /> ₫
                    </div>
                </div>
            </article>
        </c:forEach>
    </c:otherwise>
</c:choose>
