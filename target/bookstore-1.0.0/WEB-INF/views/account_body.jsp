<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .account-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
  .account-header { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); border-radius: 16px; padding: 40px; margin-bottom: 32px; color: white; box-shadow: 0 8px 24px rgba(220,53,69,0.15); }
  .account-header h1 { margin: 0 0 12px 0; font-size: 2rem; font-weight: 700; color: white; }
  .account-header p { margin: 0; opacity: 0.95; font-size: 1rem; color: white; }
  .account-grid { display: grid; grid-template-columns: 300px 1fr; gap: 24px; }
  @media (max-width: 768px) { .account-grid { grid-template-columns: 1fr; } }
  
  /* Sidebar */
  .account-sidebar { background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); height: fit-content; }
  .account-avatar { width: 120px; height: 120px; border-radius: 50%; background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; display: flex; align-items: center; justify-content: center; font-size: 3rem; font-weight: 700; margin: 0 auto 20px; border: 4px solid white; box-shadow: 0 4px 12px rgba(220,53,69,0.2); }
  .account-user-name { text-align: center; font-size: 1.25rem; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
  .account-user-email { text-align: center; color: #64748b; font-size: 0.9rem; margin-bottom: 24px; }
  .account-nav { list-style: none; padding: 0; margin: 0; }
  .account-nav-item { margin-bottom: 8px; }
  .account-nav-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 8px; color: #475569; text-decoration: none; transition: all 0.2s; }
  .account-nav-link:hover { background: #f8fafc; color: #dc3545; }
  .account-nav-link.active { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; }
  .account-nav-link svg { width: 20px; height: 20px; }
  
  /* Content */
  .account-content { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
  .account-section { margin-bottom: 32px; }
  .account-section:last-child { margin-bottom: 0; }
  .account-section-title { font-size: 1.25rem; font-weight: 700; color: #1e293b; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #e2e8f0; }
  .account-form-group { margin-bottom: 20px; }
  .account-label { display: block; font-weight: 600; color: #1e293b; margin-bottom: 8px; font-size: 0.9rem; }
  .account-input { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 0.95rem; transition: all 0.3s; box-sizing: border-box; }
  .account-input:focus { outline: none; border-color: #dc3545; box-shadow: 0 0 0 3px rgba(220,53,69,0.1); }
  .account-input:disabled { background: #f8fafc; cursor: not-allowed; }
  .account-btn { padding: 12px 24px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-block; border: none; }
  .account-btn-primary { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; }
  .account-btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); color: white; }
  .account-btn-outline { background: white; color: #dc3545; border: 2px solid #dc3545; }
  .account-btn-outline:hover { background: #dc3545; color: white; }
  .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
  @media (max-width: 576px) { .form-row { grid-template-columns: 1fr; } }
  
  /* Stats */
  .account-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 32px; }
  @media (max-width: 768px) { .account-stats { grid-template-columns: 1fr; } }
  .stat-card { background: linear-gradient(135deg, #f8fafc, #e2e8f0); border-radius: 12px; padding: 20px; text-align: center; }
  .stat-value { font-size: 2rem; font-weight: 700; color: #dc3545; margin-bottom: 4px; }
  .stat-label { color: #64748b; font-size: 0.9rem; }
  
  /* Alert */
  .alert-modern { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; }
  .alert-success { background: #d1fae5; color: #059669; border-left: 4px solid #059669; }
</style>

<div class="account-container">
  <!-- Header -->
  <div class="account-header">
    <h1>👤 Tài khoản của tôi</h1>
    <p>Quản lý thông tin cá nhân và xem lịch sử đơn hàng</p>
  </div>

  <div class="account-grid">
    <!-- Sidebar -->
    <div class="account-sidebar">
      <div class="account-avatar">
        ${sessionScope.me.fullName.substring(0,1).toUpperCase()}
      </div>
      <div class="account-user-name">${sessionScope.me.fullName}</div>
      <div class="account-user-email">${sessionScope.me.email}</div>
      
      <ul class="account-nav">
        <li class="account-nav-item">
          <a href="${pageContext.request.contextPath}/account" class="account-nav-link active">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
            </svg>
            Thông tin cá nhân
          </a>
        </li>
        <li class="account-nav-item">
          <a href="${pageContext.request.contextPath}/orders" class="account-nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
              <path d="M5 1a2 2 0 0 0-2 2v2H2a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-1V3a2 2 0 0 0-2-2H5zM4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2H4V3zm1 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1V8z"/>
            </svg>
            Đơn hàng của tôi
          </a>
        </li>
        <li class="account-nav-item">
          <a href="${pageContext.request.contextPath}/cart" class="account-nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
              <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l1.313 7h8.17l1.313-7H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
            </svg>
            Giỏ hàng
          </a>
        </li>
        <li class="account-nav-item">
          <a href="${pageContext.request.contextPath}/wishlist" class="account-nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
              <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
            </svg>
            Danh sách yêu thích
          </a>
        </li>
        <li class="account-nav-item">
          <a href="${pageContext.request.contextPath}/account/change-password" class="account-nav-link">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
            </svg>
            Đổi mật khẩu
          </a>
        </li>
        <li class="account-nav-item">
          <a href="${pageContext.request.contextPath}/logout" class="account-nav-link" style="color: #dc3545;">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
              <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
              <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
            </svg>
            Đăng xuất
          </a>
        </li>
      </ul>
    </div>

    <!-- Content -->
    <div class="account-content">
      <c:if test="${param.success == 'password_changed'}">
        <div class="alert-modern alert-success">
          <strong>✅ Thành công!</strong> Mật khẩu đã được thay đổi.
        </div>
      </c:if>
      <c:if test="${param.success == 'profile_updated'}">
        <div class="alert-modern alert-success">
          <strong>✅ Thành công!</strong> Thông tin tài khoản đã được cập nhật.
        </div>
      </c:if>
      <c:if test="${param.success == 'true'}">
        <div class="alert-modern alert-success">
          <strong>✅ Thành công!</strong> Thông tin tài khoản đã được cập nhật.
        </div>
      </c:if>

      <!-- Personal Info -->
      <div class="account-section">
        <h2 class="account-section-title">📝 Thông tin cá nhân</h2>
        
        <div class="form-row">
          <div class="account-form-group">
            <label class="account-label">Họ và tên</label>
            <input class="account-input" value="${user.fullName}" disabled>
          </div>

          <div class="account-form-group">
            <label class="account-label">Email</label>
            <input class="account-input" value="${user.email}" disabled>
          </div>
        </div>

        <div class="account-form-group">
          <label class="account-label">Số điện thoại</label>
          <input class="account-input" value="${user.phone != null ? user.phone : 'Chưa cập nhật'}" disabled>
        </div>

        <div style="display: flex; gap: 12px; margin-top: 24px;">
          <a href="${pageContext.request.contextPath}/account/update-profile" class="account-btn account-btn-primary">
            ✏️ Chỉnh sửa thông tin
          </a>
          <a href="${pageContext.request.contextPath}/account/change-password" class="account-btn account-btn-outline">
            🔒 Đổi mật khẩu
          </a>
          <a href="${pageContext.request.contextPath}/orders" class="account-btn account-btn-outline">
            📦 Xem đơn hàng
          </a>
        </div>
      </div>
    </div>
  </div>
</div>
