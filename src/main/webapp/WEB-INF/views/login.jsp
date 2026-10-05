<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Đăng nhập</title>

<style>
    .auth-page {
        max-width: 500px;
        margin: 15px auto;
    }

    .auth-page h1 {
        margin-bottom: 8px;
    }

    .auth-description {
        margin: 0 0 25px;
        color: #627487;
    }

    .auth-page .panel {
        padding: 32px;
    }

    .auth-page .panel button {
        width: 100%;
        margin-top: 22px;
    }

    .auth-page .panel p {
        margin: 22px 0 0;
        text-align: center;
    }

    .message-success {
        padding: 14px 18px;
        border-radius: 9px;
        background: #e8f5ed;
        color: #287047;
        margin-bottom: 18px;
    }

    .message-error {
        padding: 14px 18px;
        border-radius: 9px;
        background: #fff0ed;
        color: #a33732;
        margin-bottom: 18px;
    }
</style>

<div class="auth-page">
    <h1>Đăng nhập</h1>

    <p class="auth-description">
        Đăng nhập để đánh giá những cuốn sách bạn yêu thích.
    </p>

    <c:if test="${param.activated == '1'}">
        <div class="message-success">
            Kích hoạt tài khoản thành công. Bạn có thể đăng nhập.
        </div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="message-error">
            <c:out value="${message}" />
        </div>
    </c:if>

    <form class="panel" method="post" accept-charset="UTF-8">
        <label for="email">Email</label>
        <input id="email"
               name="email"
               type="email"
               autocomplete="email"
               required>

        <label for="password">Mật khẩu</label>
        <input id="password"
               name="password"
               type="password"
               autocomplete="current-password"
               required>

        <button type="submit">Đăng nhập</button>

        <p>
            Chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/register">
                Đăng ký ngay
            </a>
        </p>
    </form>
</div>