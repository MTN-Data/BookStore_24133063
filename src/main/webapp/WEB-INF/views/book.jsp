<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" scope="page" />

<title>Chi tiết sách</title>

<style>
    .back-link {
        display: inline-block;
        margin-bottom: 22px;
    }

    .book-detail {
        display: grid;
        grid-template-columns: 260px minmax(0, 1fr);
        gap: 32px;
        align-items: start;
    }

    .detail-cover {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 350px;
        border-radius: 12px;
        overflow: hidden;
        background: linear-gradient(135deg, #dceae8, #f6e4cd);
        color: #315c62;
        font-size: 28px;
        font-weight: 800;
    }

    .detail-cover img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .detail-label {
        margin: 0 0 7px;
        color: #a16630;
        font-size: 13px;
        font-weight: 800;
        letter-spacing: 2px;
        text-transform: uppercase;
    }

    .detail-info h1 {
        margin-bottom: 12px;
    }

    .detail-price {
        color: #a15b25;
        font-size: 25px;
        font-weight: 800;
    }

    .detail-list {
        display: grid;
        grid-template-columns: 145px minmax(0, 1fr);
        gap: 13px 18px;
        margin: 25px 0;
    }

    .detail-list dt {
        color: #627487;
    }

    .detail-list dd {
        margin: 0;
        font-weight: 600;
        overflow-wrap: anywhere;
    }

    .description {
        padding-top: 20px;
        border-top: 1px solid #e9edef;
        white-space: pre-wrap;
    }

    .section-title {
        margin: 37px 0 18px;
    }

    .review-card {
        margin-bottom: 13px;
    }

    .review-card p {
        margin-bottom: 0;
        white-space: pre-wrap;
    }

    .review-stars {
        color: #a15b25;
        font-weight: 800;
    }

    .review-form {
        max-width: 760px;
        margin-top: 24px;
    }

    .review-form h2 {
        margin-top: 0;
    }

    .review-form select {
        min-width: 130px;
    }

    .login-notice,
    .empty-reviews {
        padding: 18px 22px;
        border-radius: 12px;
        background: #eaf2ef;
        color: #385d57;
    }

    @media (max-width: 700px) {
        .book-detail {
            grid-template-columns: 1fr;
        }

        .detail-cover {
            height: 240px;
        }

        .detail-list {
            grid-template-columns: 120px minmax(0, 1fr);
        }
    }
</style>

<a class="back-link"
   href="${pageContext.request.contextPath}/home">
    ← Quay lại danh sách sách
</a>

<article class="card book-detail">
    <div class="detail-cover">
        <c:choose>
            <c:when test="${not empty book.coverImage}">
                <img src="<c:out value='${book.coverImage}' />"
                     alt="Bìa sách">
            </c:when>

            <c:otherwise>
                BookStore
            </c:otherwise>
        </c:choose>
    </div>

    <div class="detail-info">
        <p class="detail-label">Chi tiết sách</p>

        <h1>
            <c:out value="${book.title}" />
        </h1>

        <div class="detail-price">
            <fmt:formatNumber value="${book.price}"
                              pattern="#,##0" /> ₫
        </div>

        <dl class="detail-list">
            <dt>Tác giả</dt>
            <dd><c:out value="${book.authors}" /></dd>

            <dt>Nhà xuất bản</dt>
            <dd><c:out value="${book.publisher}" /></dd>

            <dt>Ngày phát hành</dt>
            <dd>${book.publishDate}</dd>

            <dt>ISBN</dt>
            <dd><c:out value="${book.isbn}" /></dd>

            <dt>Số lượng</dt>
            <dd>${book.quantity}</dd>

            <dt>Đánh giá</dt>
            <dd>${book.reviews}</dd>
        </dl>

        <c:if test="${not empty book.description}">
            <div class="description">
                <c:out value="${book.description}" />
            </div>
        </c:if>

        <c:choose>
            <c:when test="${book.quantity <= 0}">
                <p class="alert"><strong>Sách hiện đã hết hàng.</strong></p>
            </c:when>
            <c:when test="${empty sessionScope.user}">
                <p class="login-notice">
                    <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    để thêm sách vào giỏ hàng.
                </p>
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/cart/add">
                    <input type="hidden" name="id" value="${book.id}">
                    <label for="buyQuantity">Số lượng mua</label>
                    <input id="buyQuantity" type="number" name="quantity"
                           min="1" max="${book.quantity}" value="1" required>
                    <button type="submit">Thêm vào giỏ hàng</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</article>

<h2 class="section-title">
    Đánh giá của độc giả (${book.reviews})
</h2>

<c:choose>
    <c:when test="${empty reviews}">
        <div class="empty-reviews">
            Chưa có đánh giá nào cho cuốn sách này.
        </div>
    </c:when>

    <c:otherwise>
        <c:forEach items="${reviews}" var="v">
            <div class="card review-card">
                <strong>
                    <c:out value="${v.fullname}" />
                </strong>

                <span class="review-stars">
                    · ★ ${v.stars}/5
                </span>

                <p>
                    <c:out value="${v.text}" />
                </p>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${empty sessionScope.user}">
        <p class="login-notice">
            <a href="${pageContext.request.contextPath}/login">
                Đăng nhập
            </a>
            để viết đánh giá.
        </p>
    </c:when>

    <c:otherwise>
        <form class="panel review-form"
              method="post"
              accept-charset="UTF-8"
              action="${pageContext.request.contextPath}/book">

            <h2>Viết đánh giá</h2>

            <input type="hidden"
                   name="id"
                   value="${book.id}">

            <label for="stars">Số sao</label>
            <select id="stars" name="stars" required>
                <option value="5">5 sao</option>
                <option value="4">4 sao</option>
                <option value="3">3 sao</option>
                <option value="2">2 sao</option>
                <option value="1">1 sao</option>
            </select>

            <label for="text">Nội dung đánh giá</label>
            <textarea id="text"
                      name="text"
                      maxlength="1000"
                      placeholder="Chia sẻ cảm nhận của bạn về cuốn sách..."
                      required></textarea>

            <button type="submit">Gửi đánh giá</button>
        </form>
    </c:otherwise>
</c:choose>