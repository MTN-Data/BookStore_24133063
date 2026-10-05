<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Đăng ký</title>

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

    .message-error {
        padding: 14px 18px;
        border-radius: 9px;
        background: #fff0ed;
        color: #a33732;
        margin-bottom: 18px;
    }
</style>

<div class="auth-page">
    <h1>Tạo tài khoản</h1>

    <p class="auth-description">
        Đăng ký để nhận mã xác thực qua email và bắt đầu đánh giá sách.
    </p>

    <c:if test="${not empty message}">
        <div class="message-error">
            <c:out value="${message}" />
        </div>
    </c:if>

    <form class="panel" method="post" accept-charset="UTF-8">
        <label for="fullname">Họ và tên</label>
        <input id="fullname"
               name="fullname"
               maxlength="100"
               autocomplete="name"
               required>

        <label for="email">Email</label>
        <input id="email"
               name="email"
               type="email"
               maxlength="100"
               autocomplete="email"
               required>

        <label for="phone">Số điện thoại</label>
        <input id="phone"
               name="phone"
               type="tel"
               maxlength="20"
               autocomplete="tel">

        <label for="password">Mật khẩu</label>
        <input id="password"
               name="password"
               type="password"
               minlength="8"
               autocomplete="new-password"
               required>

        <button type="submit">Đăng ký và nhận OTP</button>

        <p>
            Đã có tài khoản?
            <a href="${pageContext.request.contextPath}/login">
                Đăng nhập
            </a>
        </p>
    </form>
</div>