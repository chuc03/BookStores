<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div style="max-width: 500px; margin: 50px auto; text-align: center;">
    <div class="card">
        <div class="card-body">
            <h3 class="card-title mb-4">Xác nhận email</h3>
            
            <c:choose>
                <c:when test="${not empty param.success}">
                    <div class="alert alert-success" role="alert">
                        <h4 class="alert-heading">Email đã được xác nhận!</h4>
                        <p>Tài khoản của bạn đã được kích hoạt thành công. Bạn có thể đăng nhập ngay bây giờ.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Đăng nhập</a>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger" role="alert">
                        <h4 class="alert-heading">Xác nhận không thành công</h4>
                        <p>Token xác nhận không hợp lệ hoặc đã hết hạn. Vui lòng kiểm tra email lại hoặc yêu cầu gửi lại liên kết xác nhận.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Quay lại đăng nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
