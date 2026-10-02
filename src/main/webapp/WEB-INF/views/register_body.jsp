<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .auth-container { min-height: 80vh; display: flex; align-items: center; justify-content: center; padding: 40px 20px; }
  .auth-card { background: white; border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,0.08); max-width: 520px; width: 100%; overflow: hidden; }
  .auth-header { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); padding: 40px 32px; text-align: center; color: white; }
  .auth-header h2 { font-size: 1.75rem; font-weight: 700; margin: 0 0 8px 0; color: white; }
  .auth-header p { margin: 0; opacity: 0.95; font-size: 0.95rem; color: white; }
  .auth-body { padding: 32px; }
  .auth-form-group { margin-bottom: 20px; }
  .auth-label { display: block; font-weight: 600; color: #1e293b; margin-bottom: 8px; font-size: 0.9rem; }
  .auth-input { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 0.95rem; transition: all 0.3s; box-sizing: border-box; }
  .auth-input:focus { outline: none; border-color: #dc3545; box-shadow: 0 0 0 3px rgba(220,53,69,0.1); }
  .auth-btn { width: 100%; padding: 14px; background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); color: white; border: none; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .auth-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); }
  .auth-footer { text-align: center; padding: 20px 32px 32px; border-top: 1px solid #e2e8f0; margin-top: 24px; }
  .auth-link { color: #dc3545; text-decoration: none; font-weight: 500; transition: all 0.2s; }
  .auth-link:hover { color: #c72333; text-decoration: underline; }
  .alert-modern { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; }
  .alert-danger { background: #fee2e2; color: #dc2626; border-left: 4px solid #dc2626; }
  .alert-success { background: #d1fae5; color: #059669; border-left: 4px solid #059669; }
  .password-hint { background: #f8fafc; border-left: 3px solid #64748b; padding: 12px; border-radius: 6px; margin-top: 8px; font-size: 0.85rem; color: #475569; }
  .password-hint ul { margin: 8px 0 0; padding-left: 20px; }
  .password-hint li { margin: 4px 0; }
  .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
  @media (max-width: 576px) { .form-row { grid-template-columns: 1fr; } }
</style>

<div class="auth-container">
  <div class="auth-card">
    <div class="auth-header">
      <h2>🎉 Tạo tài khoản</h2>
      <p>Tham gia cùng chúng tôi để khám phá thế giới sách</p>
    </div>
    
    <div class="auth-body">
      <c:if test="${not empty error}">
        <div class="alert-modern alert-danger">
          <strong>⚠️ Lỗi!</strong> ${error}
        </div>
      </c:if>

      <c:if test="${not empty sessionScope.flashMessages}">
        <c:forEach var="msg" items="${sessionScope.flashMessages}">
          <div class="alert-modern ${msg.bootstrapAlertClass}">
            ${msg.message}
          </div>
        </c:forEach>
        <%
          session.removeAttribute("flashMessages");
        %>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/register">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />

        <div class="auth-form-group">
          <label class="auth-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
              <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
            </svg>
            Họ và tên
          </label>
          <input class="auth-input" name="fullName" placeholder="Nguyễn Văn A" required value="${param.fullName}">
        </div>

        <div class="form-row">
          <div class="auth-form-group">
            <label class="auth-label">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
                <path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/>
              </svg>
              Email
            </label>
            <input class="auth-input" type="email" name="email" placeholder="email@example.com" required value="${param.email}">
          </div>

          <div class="auth-form-group">
            <label class="auth-label">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
                <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
              </svg>
              Số điện thoại
            </label>
            <input class="auth-input" name="phone" placeholder="0123456789" value="${param.phone}">
          </div>
        </div>

        <div class="auth-form-group">
          <label class="auth-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
              <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
            </svg>
            Mật khẩu
          </label>
          <input class="auth-input" type="password" name="password" placeholder="••••••••" required>
          <div class="password-hint">
            <strong>🔒 Yêu cầu mật khẩu:</strong>
            <ul>
              <li>Tối thiểu 6 ký tự</li>
              <li>Chứa ít nhất 1 chữ hoa (A-Z)</li>
              <li>Chứa ít nhất 1 chữ thường (a-z)</li>
              <li>Chứa ít nhất 1 chữ số (0-9)</li>
            </ul>
          </div>
        </div>

        <div class="auth-form-group">
          <label class="auth-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
              <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
            </svg>
            Nhập lại mật khẩu
          </label>
          <input class="auth-input" type="password" name="confirm" placeholder="••••••••" required>
        </div>

        <button class="auth-btn" type="submit">
          🚀 Đăng ký ngay
        </button>
      </form>
    </div>

    <div class="auth-footer">
      <p style="margin: 0; color: #64748b; font-size: 0.9rem;">
        Đã có tài khoản? 
        <a href="${pageContext.request.contextPath}/login" class="auth-link">Đăng nhập</a>
      </p>
    </div>
  </div>
</div>

