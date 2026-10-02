<%@ page contentType="text/html; charset=UTF-8" %>
<h3 class="mb-3">Đặt lại mật khẩu</h3>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/reset-password">
  <jsp:include page="/WEB-INF/views/_csrf.jsp" />
  <input type="hidden" name="token" value="${token}" />
  <jsp:include page="/WEB-INF/views/_csrf.jsp" />
  <div class="mb-3">
    <label class="form-label">Mật khẩu mới</label>
    <input type="password" name="password" class="form-control" required />
  </div>
  <div class="mb-3">
    <label class="form-label">Nhập lại mật khẩu</label>
    <input type="password" name="password2" class="form-control" required />
  </div>
  <button class="btn btn-primary">Đặt lại mật khẩu</button>
</form>
