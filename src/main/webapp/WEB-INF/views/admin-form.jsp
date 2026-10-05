<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Thông tin sách</title>

<style>
    .form-container {
        max-width: 850px;
        margin: 0 auto;
    }

    .back-link {
        display: inline-block;
        margin-bottom: 22px;
    }

    .form-heading h1 {
        margin-bottom: 6px;
    }

    .form-heading p {
        margin: 0 0 25px;
        color: #627487;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 0 22px;
    }

    .form-field {
        min-width: 0;
    }

    .form-field label {
        margin-top: 0;
    }

    .form-field input,
    .form-field textarea {
        margin-bottom: 20px;
    }

    .form-actions {
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 4px;
    }

    .form-actions button {
        margin: 0;
    }

    .cancel-link {
        display: inline-block;
        padding: 10px 18px;
        border: 1px solid #cad7de;
        border-radius: 8px;
        background: #fff;
        color: #203047;
        font-weight: 700;
    }

    .cancel-link:hover {
        background: #edf2f4;
        text-decoration: none;
    }

    @media (max-width: 600px) {
        .form-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="form-container">
    <a class="back-link"
       href="${pageContext.request.contextPath}/admin/books">
        ← Quay lại danh sách sách
    </a>

    <div class="form-heading">
        <h1>
            <c:choose>
                <c:when test="${book.id > 0}">Sửa thông tin sách</c:when>
                <c:otherwise>Thêm sách mới</c:otherwise>
            </c:choose>
        </h1>
        <p>Điền thông tin sách rồi nhấn Lưu sách.</p>
    </div>

    <form class="panel"
          method="post"
          accept-charset="UTF-8"
          action="${pageContext.request.contextPath}/admin/book/edit">

        <input type="hidden" name="id" value="${book.id}">

        <div class="form-grid">
            <div class="form-field">
                <label for="isbn">ISBN</label>
                <input id="isbn"
                       name="isbn"
                       maxlength="20"
                       placeholder="Ví dụ: 9786040000017"
                       value="<c:out value='${book.isbn}' />">
            </div>

            <div class="form-field">
                <label for="title">Tiêu đề *</label>
                <input id="title"
                       name="title"
                       maxlength="200"
                       required
                       value="<c:out value='${book.title}' />">
            </div>

            <div class="form-field">
                <label for="publisher">Nhà xuất bản</label>
                <input id="publisher"
                       name="publisher"
                       maxlength="100"
                       value="<c:out value='${book.publisher}' />">
            </div>

            <div class="form-field">
                <label for="price">Giá (đồng) *</label>
                <input id="price"
                       name="price"
                       type="number"
                       min="0"
                       step="0.01"
                       required
                       value="${book.price}">
            </div>

            <div class="form-field">
                <label for="publishDate">Ngày phát hành</label>
                <input id="publishDate"
                       name="publishDate"
                       type="date"
                       value="${book.publishDate}">
            </div>

            <div class="form-field">
                <label for="quantity">Số lượng *</label>
                <input id="quantity"
                       name="quantity"
                       type="number"
                       min="0"
                       required
                       value="${book.quantity}">
            </div>
        </div>

        <div class="form-field">
            <label for="coverImage">URL ảnh bìa</label>
            <input id="coverImage"
                   name="coverImage"
                   maxlength="500"
                   placeholder="https://..."
                   value="<c:out value='${book.coverImage}' />">
        </div>

        <div class="form-field">
            <label for="description">Mô tả</label>
            <textarea id="description"
                      name="description"
                      rows="5"
                      placeholder="Giới thiệu ngắn về cuốn sách..."><c:out value="${book.description}" /></textarea>
        </div>

        <div class="form-actions">
            <button type="submit">Lưu sách</button>

            <a class="cancel-link"
               href="${pageContext.request.contextPath}/admin/books">
                Hủy
            </a>
        </div>
    </form>
</div>