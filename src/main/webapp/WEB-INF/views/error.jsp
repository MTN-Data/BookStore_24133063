<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Đã xảy ra lỗi</title>

<style>
    .error-page {
        max-width: 650px;
        margin: 45px auto;
    }

    .error-page .card {
        padding: 35px;
    }

    .error-page h1 {
        margin-bottom: 12px;
    }

    .error-message {
        padding: 14px 18px;
        margin: 18px 0 25px;
        border-radius: 9px;
        background: #fff0ed;
        color: #a33732;
        overflow-wrap: anywhere;
    }
</style>

<div class="error-page">
    <div class="card">
        <h1>Không thể xử lý yêu cầu</h1>

        <c:if test="${not empty error}">
            <div class="error-message">
                <c:out value="${error}" />
            </div>
        </c:if>

        <a class="btn" href="${pageContext.request.contextPath}/home">
            Quay lại trang chủ
        </a>
    </div>
</div>