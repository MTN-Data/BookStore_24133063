<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" scope="page" />

<title>Danh sách sách</title>

<style>
    .intro {
        margin-bottom: 27px;
    }

    .intro .eyebrow {
        margin: 0 0 7px;
        color: #a16630;
        font-size: 13px;
        font-weight: 800;
        letter-spacing: 2px;
        text-transform: uppercase;
    }

    .intro h1 {
        margin-bottom: 8px;
    }

    .intro .subtitle {
        margin: 0;
        color: #627487;
        font-size: 17px;
    }

    .filter-box {
        display: flex;
        align-items: end;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 26px;
        padding: 20px 24px;
        background: white;
        border: 1px solid #e5e9ea;
        border-radius: 14px;
    }

    .filter-field {
        width: min(310px, 100%);
    }

    .filter-field label {
        margin: 0 0 7px;
    }

    .filter-field select {
        width: 100%;
    }

    .filter-box button {
        margin: 0;
    }

    .book-cover-placeholder {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 155px;
        margin-bottom: 18px;
        border-radius: 10px;
        background: linear-gradient(135deg, #dceae8, #f6e4cd);
        color: #315c62;
        font-size: 25px;
        font-weight: 800;
    }

    .grid .card .cover {
        display: block;
        width: 100%;
        height: 155px;
        margin-bottom: 18px;
    }

    .book-author {
        color: #a16630 !important;
        font-size: 14px;
        font-weight: 700;
    }

    .grid .card h2 {
        margin: 4px 0 12px;
        min-height: 58px;
        line-height: 1.3;
    }

    .book-footer {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        margin-top: auto;
        padding-top: 19px;
        border-top: 1px solid #e9edef;
    }

    .book-price {
        color: #a15b25;
        font-size: 18px;
        font-weight: 800;
    }

    .review-count {
        padding: 6px 10px;
        border-radius: 20px;
        background: #eaf2ef;
        color: #3e655c;
        font-size: 13px;
        font-weight: 700;
        white-space: nowrap;
    }

    .pagination .current {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 40px;
        min-height: 40px;
        padding: 7px 12px;
        border-radius: 8px;
        background: #195c86;
        color: white;
        font-weight: 700;
    }

    .empty-books {
        padding: 35px;
        background: white;
        border-radius: 12px;
        color: #627487;
        text-align: center;
    }

    @media (max-width: 600px) {
        .filter-field {
            width: 100%;
        }

        .filter-box button {
            width: 100%;
        }
    }
</style>

<div class="intro">
    <p class="eyebrow">Tủ sách BookStore</p>
    <h1>Khám phá sách hay</h1>
    <p class="subtitle">
        Chọn tác giả yêu thích và tìm cuốn sách dành cho bạn.
    </p>
</div>

<form class="filter-box"
      method="get"
      action="${pageContext.request.contextPath}/home">

    <div class="filter-field">
        <label for="author">Lọc theo tác giả</label>

        <select id="author" name="author">
            <option value="0">Tất cả tác giả</option>

            <c:forEach items="${authors}" var="a">
                <option value="${a.id}"
                    <c:if test="${author == a.id}">selected</c:if>>
                    <c:out value="${a.name}" />
                </option>
            </c:forEach>
        </select>
    </div>

    <button type="submit">Áp dụng bộ lọc</button>
</form>

<c:choose>
    <c:when test="${empty books}">
        <div class="empty-books">
            Chưa có sách của tác giả này.
        </div>
    </c:when>

    <c:otherwise>
        <div class="grid">
            <c:forEach items="${books}" var="b">
                <article class="card">
                    <c:choose>
                        <c:when test="${not empty b.coverImage}">
                            <img class="cover"
                                 src="<c:out value='${b.coverImage}' />"
                                 alt="Bìa sách">
                        </c:when>

                        <c:otherwise>
                            <div class="book-cover-placeholder">
                                BookStore
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <p class="book-author">
                        <c:out value="${b.authors}" />
                    </p>

                    <h2>
                        <a href="${pageContext.request.contextPath}/book?id=${b.id}">
                            <c:out value="${b.title}" />
                        </a>
                    </h2>

                    <p>
                        Nhà xuất bản:
                        <c:out value="${b.publisher}" />
                    </p>

                    <p>
                        ISBN:
                        <c:out value="${b.isbn}" />
                    </p>

                    <div class="book-footer">
                        <span class="book-price">
                            <fmt:formatNumber value="${b.price}"
                                              pattern="#,##0" /> ₫
                        </span>

                        <span class="review-count">
                            ${b.reviews} đánh giá
                        </span>
                    </div>

                    <c:if test="${not empty sessionScope.user and b.quantity > 0}">
                        <form method="post" action="${pageContext.request.contextPath}/cart/add">
                            <input type="hidden" name="id" value="${b.id}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit">Thêm vào giỏ</button>
                        </form>
                    </c:if>

                    <c:if test="${b.quantity <= 0}">
                        <p><strong>Hết hàng</strong></p>
                    </c:if>
                </article>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<c:if test="${pages > 1}">
    <div class="pagination">
        <c:if test="${page > 1}">
            <a href="?author=${author}&amp;page=${page - 1}">
                ← Trước
            </a>
        </c:if>

        <c:forEach begin="1" end="${pages}" var="i">
            <c:choose>
                <c:when test="${i == page}">
                    <span class="current">${i}</span>
                </c:when>

                <c:otherwise>
                    <a href="?author=${author}&amp;page=${i}">
                        ${i}
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${page < pages}">
            <a href="?author=${author}&amp;page=${page + 1}">
                Sau →
            </a>
        </c:if>
    </div>
</c:if>