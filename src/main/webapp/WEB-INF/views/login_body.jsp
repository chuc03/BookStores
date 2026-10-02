<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .auth-container { min-height: 80vh; display: flex; align-items: center; justify-content: center; padding: 40px 20px; }
  .auth-card { background: white; border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,0.08); max-width: 480px; width: 100%; overflow: hidden; }
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
  .auth-divider { display: flex; align-items: center; margin: 24px 0; color: #64748b; font-size: 0.875rem; }
  .auth-divider::before, .auth-divider::after { content: ''; flex: 1; height: 1px; background: #e2e8f0; }
  .auth-divider span { padding: 0 16px; }
  .alert-modern { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; }
  .alert-danger { background: #fee2e2; color: #dc2626; border-left: 4px solid #dc2626; }
  .alert-success { background: #d1fae5; color: #059669; border-left: 4px solid #059669; }
</style>

<div class="auth-container">
  <div class="auth-card">
    <div class="auth-header">
      <h2>🔑 Đăng nhập</h2>
      <p>Chào mừng bạn trở lại với BookStore</p>
    </div>
    
    <div class="auth-body">
      <c:if test="${not empty error}">
        <div class="alert-modern alert-danger">
          <strong>⚠️ Lỗi!</strong> ${error}
        </div>
      </c:if>

      <c:if test="${param.reset == 'ok'}">
        <div class="alert-modern alert-success">
          <strong>✅ Thành công!</strong> Mật khẩu đã được đặt lại. Vui lòng đăng nhập bằng mật khẩu mới.
        </div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/login">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />

        <div class="auth-form-group">
          <label class="auth-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
              <path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/>
            </svg>
            Email
          </label>
          <input class="auth-input" name="email" type="email" placeholder="email@example.com" required>
        </div>

        <div class="auth-form-group">
          <label class="auth-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="margin-right: 6px; vertical-align: -2px;">
              <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
            </svg>
            Mật khẩu
          </label>
          <input class="auth-input" type="password" name="password" placeholder="••••••••" required>
        </div>

        <div style="text-align: right; margin-bottom: 20px;">
          <a href="${pageContext.request.contextPath}/forgot-password" class="auth-link" style="font-size: 0.875rem;">
            Quên mật khẩu?
          </a>
        </div>

        <button class="auth-btn" type="submit">
          Đăng nhập ngay
        </button>
      </form>
    </div>

    <div class="auth-footer">
      <p style="margin: 0; color: #64748b; font-size: 0.9rem;">
        Chưa có tài khoản? 
        <a href="${pageContext.request.contextPath}/register" class="auth-link">Đăng ký ngay</a>
      </p>
    </div>
  </div>
</div>
