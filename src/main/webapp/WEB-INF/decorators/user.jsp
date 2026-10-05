<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><sitemesh:write property="title" /> | BookStore</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f6f4;
            color: #203047;
            font-family: system-ui, Arial, sans-serif;
            line-height: 1.5;
        }

        a {
            color: #195c86;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        header {
            background: #183247;
            color: white;
        }

        .header-inner {
            width: min(1180px, calc(100% - 40px));
            min-height: 76px;
            margin: auto;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px 28px;
        }

        .logo {
            color: white;
            font-size: 24px;
            font-weight: 800;
            white-space: nowrap;
        }

        .logo span {
            color: #e9ae67;
        }

        nav {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 6px;
        }

        nav a {
            color: #ecf2f6;
            padding: 9px 12px;
            border-radius: 8px;
        }

        nav a:hover {
            color: white;
            background: #ffffff20;
            text-decoration: none;
        }

        .account {
            margin-left: auto;
        }

        .account-name {
            color: #d5e3e9;
            padding: 9px 6px;
        }

        .register-link {
            background: #e9ae67;
            color: #193147;
            font-weight: 700;
        }

        .register-link:hover {
            color: #193147;
            background: #f2c18a;
        }

        main {
            width: min(1180px, calc(100% - 40px));
            min-height: calc(100vh - 150px);
            margin: auto;
            padding: 42px 0 70px;
        }

        h1, h2 {
            color: #183247;
            line-height: 1.25;
        }

        h1 {
            margin: 0 0 22px;
            font-size: clamp(30px, 4vw, 42px);
        }

        h2 {
            font-size: 23px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            margin-top: 22px;
        }

        .card, form.panel {
            background: white;
            border: 1px solid #e5e9ea;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 9px 26px rgba(25, 49, 71, 0.07);
        }

        .grid .card {
            display: flex;
            flex-direction: column;
            min-height: 350px;
        }

        .grid .card h2 {
            margin-top: 6px;
        }

        .grid .card h2 a {
            color: #183247;
        }

        .grid .card h2 a:hover {
            color: #a15b25;
        }

        .grid .card p {
            margin: 7px 0;
            color: #526376;
        }

        .cover {
            max-width: 100%;
            height: 190px;
            object-fit: cover;
            border-radius: 10px;
        }

        label {
            display: block;
            margin: 15px 0 7px;
            font-weight: 600;
        }

        input, select, textarea {
            max-width: 100%;
            min-height: 43px;
            padding: 10px 12px;
            border: 1px solid #c9d3da;
            border-radius: 8px;
            background: white;
            color: #203047;
            font: inherit;
        }

        input:not([type="hidden"]), textarea {
            width: 100%;
        }

        input:focus, select:focus, textarea:focus {
            outline: 2px solid #dfad78;
            outline-offset: 1px;
        }

        textarea {
            min-height: 110px;
            resize: vertical;
        }

        button, .btn {
            display: inline-block;
            margin-top: 12px;
            padding: 10px 18px;
            border: 0;
            border-radius: 8px;
            background: #195c86;
            color: white;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
        }

        button:hover, .btn:hover {
            background: #12496c;
            color: white;
            text-decoration: none;
        }

        .pagination {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 9px;
            margin-top: 28px;
        }

        .pagination a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 40px;
            min-height: 40px;
            padding: 7px 12px;
            background: white;
            border: 1px solid #d9e2e7;
            border-radius: 8px;
        }

        .alert {
            color: #a33732;
        }

        footer {
            background: #183247;
            color: #dce7ee;
            padding: 22px max(20px, calc((100% - 1180px) / 2));
        }

        @media (max-width: 900px) {
            .grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .account {
                margin-left: 0;
            }
        }

        @media (max-width: 600px) {
            .header-inner {
                padding: 15px 0;
            }

            main {
                padding-top: 30px;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .card, form.panel {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-inner">
            <a class="logo" href="${pageContext.request.contextPath}/home">
                Book<span>Store</span>
            </a>

            <nav>
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a>

                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
                    <a href="${pageContext.request.contextPath}/orders">Lịch sử đặt hàng</a>
                </c:if>

                <c:if test="${sessionScope.user.admin}">
                    <a href="${pageContext.request.contextPath}/admin/books">
                        Quản lý sách
                    </a>
                </c:if>
            </nav>

            <nav class="account">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="account-name">
                            Xin chào, <c:out value="${sessionScope.user.fullname}" />
                        </span>
                        <a href="${pageContext.request.contextPath}/logout">
                            Đăng xuất
                        </a>
                    </c:when>

                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login">
                            Đăng nhập
                        </a>
                        <a class="register-link"
                           href="${pageContext.request.contextPath}/register">
                            Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <main>
        <sitemesh:write property="body" />
    </main>

    <footer>
        Nguyễn Minh Tiến · MSSV 24133063 · Mã đề 02
    </footer>
</body>
</html>