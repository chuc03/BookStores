<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .update-profile-container {
        max-width: 600px;
        margin: 40px auto;
        padding: 30px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .update-profile-container h2 {
        margin-bottom: 20px;
        color: #333;
        text-align: center;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: #555;
    }
    .form-group input {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
        box-sizing: border-box;
    }
    .form-group input:focus {
        outline: none;
        border-color: #007bff;
    }
    .alert {
        padding: 12px;
        margin-bottom: 20px;
        border-radius: 4px;
    }
    .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    .btn-primary {
        width: 100%;
        padding: 12px;
        background: #dc3545;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.3s;
    }
    .btn-primary:hover {
        background: #c82333;
    }
    .back-link {
        display: block;
        text-align: center;
        margin-top: 20px;
        color: #007bff;
        text-decoration: none;
    }
    .back-link:hover {
        text-decoration: underline;
    }
    .form-hint {
        font-size: 13px;
        color: #6c757d;
        margin-top: 5px;
    }
</style>

<div class="update-profile-container">
    <h2>👤 Cập nhật thông tin</h2>

    <c:if test="${error != null}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/account/update-profile" method="post">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
        <div class="form-group">
            <label for="fullName">Họ và tên <span style="color: red;">*</span></label>
            <input type="text" id="fullName" name="fullName" 
                   value="${userData != null ? userData.fullName : (sessionScope.me != null ? sessionScope.me.fullName : '')}" required>
        </div>

        <div class="form-group">
            <label for="email">Email <span style="color: red;">*</span></label>
            <input type="email" id="email" name="email" 
                   value="${userData != null ? userData.email : (sessionScope.me != null ? sessionScope.me.email : '')}" required>
            <div class="form-hint">Email sẽ được dùng để đăng nhập</div>
        </div>

        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <input type="tel" id="phone" name="phone" 
                   value="${userData != null ? userData.phone : (sessionScope.me != null ? sessionScope.me.phone : '')}">
        </div>

        <button type="submit" class="btn-primary">Cập nhật thông tin</button>
    </form>

    <a href="${pageContext.request.contextPath}/account" class="back-link">← Quay lại trang tài khoản</a>
</div>
