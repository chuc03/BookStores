<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .orders-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
  .orders-header { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); border-radius: 16px; padding: 40px; margin-bottom: 32px; color: white; box-shadow: 0 8px 24px rgba(220,53,69,0.15); }
  .orders-header h1 { margin: 0 0 8px 0; font-size: 2rem; font-weight: 700; color: white; }
  .orders-header p { margin: 0; opacity: 0.95; font-size: 1rem; }
  
  .orders-content { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
  
  .empty-orders { text-align: center; padding: 60px 20px; }
  .empty-orders-icon { font-size: 5rem; margin-bottom: 20px; opacity: 0.3; }
  .empty-orders-text { font-size: 1.25rem; color: #64748b; margin-bottom: 24px; }
  .empty-orders-btn { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; border: none; padding: 12px 32px; border-radius: 8px; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; }
  .empty-orders-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); color: white; }
  
  .order-card { background: #f8fafc; border-radius: 12px; padding: 24px; margin-bottom: 16px; transition: all 0.3s; border: 2px solid transparent; }
  .order-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.08); border-color: #e2e8f0; }
  
  .order-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; padding-bottom: 16px; border-bottom: 2px solid #e2e8f0; }
  .order-id { font-size: 1.25rem; font-weight: 700; color: #1e293b; }
  .order-id a { color: #dc3545; text-decoration: none; }
  .order-id a:hover { text-decoration: underline; }
  .order-date { color: #64748b; font-size: 0.9rem; }
  
  .order-card-body { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 16px; }
  @media (max-width: 768px) { .order-card-body { grid-template-columns: 1fr; gap: 12px; } }
  
  .order-info-item { }
  .order-info-label { color: #64748b; font-size: 0.85rem; margin-bottom: 4px; }
  .order-info-value { font-weight: 600; color: #1e293b; font-size: 1rem; }
  
  .order-total { color: #dc3545; font-size: 1.25rem; font-weight: 700; }
  
  .order-card-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 2px solid #e2e8f0; }
  
  .order-status-badge { padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; display: inline-block; }
  .status-new { background: #dbeafe; color: #1e40af; }
  .status-unpaid { background: #fef3c7; color: #92400e; }
  .status-paid { background: #d1fae5; color: #065f46; }
  .status-shipped { background: #ddd6fe; color: #5b21b6; }
  .status-cancelled { background: #fee2e2; color: #991b1b; }
  
  .order-actions { display: flex; gap: 8px; }
  .btn-view { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; border: none; padding: 8px 20px; border-radius: 8px; font-weight: 600; text-decoration: none; transition: all 0.3s; }
  .btn-view:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(220,53,69,0.3); color: white; }
  .btn-cancel { background: white; border: 2px solid #e74c3c; color: #e74c3c; padding: 8px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .btn-cancel:hover { background: #e74c3c; color: white; }
  .btn-cancel:disabled { opacity: 0.5; cursor: not-allowed; }
  
  .orders-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 32px; }
  @media (max-width: 768px) { .orders-stats { grid-template-columns: repeat(2, 1fr); } }
  .stat-card { background: linear-gradient(135deg, #f8fafc, #e2e8f0); border-radius: 12px; padding: 20px; text-align: center; }
  .stat-value { font-size: 2rem; font-weight: 700; color: #dc3545; margin-bottom: 4px; }
  .stat-label { color: #64748b; font-size: 0.9rem; }
  
  .orders-filter-bar { background: white; border-radius: 16px; padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
  
  .filter-tabs { display: flex; gap: 8px; flex-wrap: wrap; }
  .filter-tab { background: #f8fafc; border: 2px solid #e2e8f0; padding: 10px 20px; border-radius: 8px; font-weight: 600; color: #64748b; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-block; }
  .filter-tab:hover { border-color: #dc3545; color: #dc3545; }
  .filter-tab.active { background: linear-gradient(135deg, #dc3545, #ff6b35); border-color: #dc3545; color: white; }
  .filter-tab.active:hover { color: white; }
  
  .orders-list-wrapper { }
</style>

<div class="orders-container">
  <!-- Header -->
  <div class="orders-header">
    <h1>📦 Đơn hàng của tôi</h1>
    <p>Theo dõi và quản lý tất cả đơn hàng của bạn</p>
  </div>
  
    <!-- Main Content -->
    <div class="orders-content">
  
  <!-- Filter Bar -->
  <div class="orders-filter-bar">
    <div class="filter-tabs">
      <a href="?status=all" class="filter-tab ${empty param.status || param.status == 'all' ? 'active' : ''}">📋 Tất cả</a>
      <a href="?status=NEW" class="filter-tab ${param.status == 'NEW' ? 'active' : ''}">🆕 Mới</a>
      <a href="?status=UNPAID" class="filter-tab ${param.status == 'UNPAID' ? 'active' : ''}">⏳ Chưa thanh toán</a>
      <a href="?status=PAID" class="filter-tab ${param.status == 'PAID' ? 'active' : ''}">✅ Đã thanh toán</a>
      <a href="?status=SHIPPED" class="filter-tab ${param.status == 'SHIPPED' ? 'active' : ''}">🚚 Đã giao</a>
      <a href="?status=CANCELLED" class="filter-tab ${param.status == 'CANCELLED' ? 'active' : ''}">❌ Đã hủy</a>
    </div>
  </div>

  <!-- Stats -->
  <c:if test="${not empty orders || totalOrders > 0}">
    <div class="orders-stats">
      <div class="stat-card">
        <div class="stat-value">${totalOrders}</div>
        <div class="stat-label">Tổng đơn hàng</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">${pendingCount}</div>
        <div class="stat-label">Đang chờ</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">${shippedCount}</div>
        <div class="stat-label">Đã giao</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">${cancelledCount}</div>
        <div class="stat-label">Đã hủy</div>
      </div>
    </div>
  </c:if>

    <!-- Empty State -->
    <c:if test="${empty orders}">
      <div class="empty-orders">
        <div class="empty-orders-icon">📭</div>
        <div class="empty-orders-text">Bạn chưa có đơn hàng nào</div>
        <a href="${pageContext.request.contextPath}/books" class="empty-orders-btn">
          🛍️ Bắt đầu mua sắm
        </a>
      </div>
    </c:if>

    <!-- Orders List -->
    <div class="orders-list-wrapper">
    <c:if test="${not empty orders}">
      <c:forEach var="o" items="${orders}">
        <div class="order-card">
          <div class="order-card-header">
            <div>
              <div class="order-id">
                <a href="${pageContext.request.contextPath}/order?id=${o.orderId}">
                  Đơn hàng #${o.orderId}
                </a>
              </div>
              <div class="order-date">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: -2px; margin-right: 4px;">
                  <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/>
                  <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0z"/>
                </svg>
                <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
              </div>
            </div>
            <c:choose>
              <c:when test="${o.orderStatus == 'NEW'}">
                <span class="order-status-badge status-new">🆕 Mới</span>
              </c:when>
              <c:when test="${o.orderStatus == 'UNPAID'}">
                <span class="order-status-badge status-unpaid">⏳ Chưa thanh toán</span>
              </c:when>
              <c:when test="${o.orderStatus == 'PAID'}">
                <span class="order-status-badge status-paid">✅ Đã thanh toán</span>
              </c:when>
              <c:when test="${o.orderStatus == 'SHIPPED'}">
                <span class="order-status-badge status-shipped">🚚 Đã giao</span>
              </c:when>
              <c:when test="${o.orderStatus == 'CANCELLED'}">
                <span class="order-status-badge status-cancelled">❌ Đã hủy</span>
              </c:when>
              <c:otherwise>
                <span class="order-status-badge">${o.orderStatus}</span>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="order-card-body">
            <div class="order-info-item">
              <div class="order-info-label">💰 Tổng tiền</div>
              <div class="order-info-value order-total">
                <fmt:formatNumber value="${o.totalAmount}" pattern="#,###" /> đ
              </div>
            </div>
          </div>

          <div class="order-card-footer">
            <div class="order-actions">
              <a href="${pageContext.request.contextPath}/order?id=${o.orderId}" class="btn-view">
                👁️ Xem chi tiết
              </a>
              <c:if test="${o.orderStatus == 'NEW' || o.orderStatus == 'UNPAID'}">
                <button class="btn-cancel" data-id="${o.orderId}">
                  🗑️ Hủy đơn
                </button>
              </c:if>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:if>
    </div><!-- end orders-list-wrapper -->
  
  </div><!-- end orders-content -->
</div><!-- end orders-container -->

<script>
(function(){
  // Cancel order functionality
  function postCancel(id){
    return fetch(window.location.origin + '${pageContext.request.contextPath}/order/cancel', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'id=' + encodeURIComponent(id)
    }).then(r => r.json());
  }
  
  document.querySelectorAll('.btn-cancel').forEach(function(btn){
    btn.addEventListener('click', function(){
      var id = this.getAttribute('data-id');
      if (!confirm('Bạn có chắc muốn hủy đơn hàng #' + id + '?\n\nSau khi hủy, số lượng sách sẽ được hoàn lại vào kho.')) return;
      var btnEl = this;
      btnEl.disabled = true;
      btnEl.textContent = '⏳ Đang hủy...';
      postCancel(id).then(function(json){
        if (json && json.success) {
          window.location.reload();
        } else {
          alert('Không thể hủy đơn hàng. Vui lòng thử lại.');
          btnEl.disabled = false;
          btnEl.textContent = '🗑️ Hủy đơn';
        }
      }).catch(function(){
        alert('Lỗi kết nối. Vui lòng thử lại.');
        btnEl.disabled = false;
        btnEl.textContent = '🗑️ Hủy đơn';
      });
    });
  });
})();
</script>
