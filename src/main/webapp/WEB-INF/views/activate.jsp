<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>Kích hoạt tài khoản</title>

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

    .message-error {
        padding: 14px 18px;
        border-radius: 9px;
        background: #fff0ed;
        color: #a33732;
        margin-bottom: 18px;
    }
</style>

<div class="auth-page">
    <h1>Kích hoạt tài khoản</h1>

    <p class="auth-description">
        Nhập mã OTP gồm 6 chữ số đã gửi tới email.
        Mã có hiệu lực trong 10 phút.
    </p>

    <c:if test="${not empty message}">
        <div class="message-error">
            <c:out value="${message}" />
        </div>
    </c:if>

    <form class="panel" method="post">
        <label for="otp">Mã OTP</label>
        <input id="otp"
               name="otp"
               maxlength="6"
               inputmode="numeric"
               autocomplete="one-time-code"
               pattern="[0-9]{6}"
               placeholder="Nhập 6 chữ số"
               required>

        <button type="submit">Kích hoạt tài khoản</button>
    </form>
</div>