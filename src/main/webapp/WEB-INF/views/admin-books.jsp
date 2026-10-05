<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Quản lý sách</title>

<style>
    .admin-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 16px;
        margin-bottom: 25px;
    }

    .admin-heading h1 {
        margin-bottom: 5px;
    }

    .admin-heading p {
        margin: 0;
        color: #627487;
    }

    .table-wrapper {
        overflow-x: auto;
        border-radius: 14px;
    }

    .book-title {
        font-weight: 700;
        color: #203047;
    }

    .actions {
        display: flex;
        align-items: center;
        gap: 9px;
        white-space: nowrap;
    }

    .actions form {
        margin: 0;
    }

    .edit-link {
        display: inline-block;
        padding: 7px 12px;
        border: 1px solid #c9d9e3;
        border-radius: 8px;
        background: #eff6fa;
        font-size: 14px;
        font-weight: 700;
    }

    .edit-link:hover {
        background: #dcecf5;
        text-decoration: none;
    }

    .empty-books {
        padding: 30px;
        background: white;
        border-radius: 12px;
        color: #627487;
        text-align: center;
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
</style>

<div class="admin-heading">
    <div>
        <h1>Quản lý sách</h1>
        <p>Thêm, cập nhật và theo dõi sách trong cửa hàng.</p>
    </div>

    <a class="btn"
       href="${pageContext.request.contextPath}/admin/book/edit">
        + Thêm sách
    </a>
</div>

<c:choose>
    <c:when test="${empty books}">
        <div class="empty-books">
            Chưa có sách trong danh sách.
        </div>
    </c:when>

    <c:otherwise>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>ISBN</th>
                        <th>Số lượng</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach items="${books}" var="b">
                        <tr>
                            <td>#${b.id}</td>

                            <td class="book-title">
                                <c:out value="${b.title}" />
                            </td>

                            <td>
                                <c:out value="${b.isbn}" />
                            </td>

                            <td>${b.quantity}</td>

                            <td>
                                <div class="actions">
                                    <a class="edit-link"
                                       href="${pageContext.request.contextPath}/admin/book/edit?id=${b.id}">
                                        Sửa
                                    </a>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/admin/book/delete"
                                          onsubmit="return confirm('Bạn có chắc muốn xóa sách này?');">
                                        <input type="hidden"
                                               name="id"
                                               value="${b.id}">

                                        <button type="submit">
                                            Xóa
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<c:if test="${pages > 1}">
    <div class="pagination">
        <c:if test="${page > 1}">
            <a href="?page=${page - 1}">← Trước</a>
        </c:if>

        <c:forEach begin="1" end="${pages}" var="i">
            <c:choose>
                <c:when test="${i == page}">
                    <span class="current">${i}</span>
                </c:when>

                <c:otherwise>
                    <a href="?page=${i}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${page < pages}">
            <a href="?page=${page + 1}">Sau →</a>
        </c:if>
    </div>
</c:if>