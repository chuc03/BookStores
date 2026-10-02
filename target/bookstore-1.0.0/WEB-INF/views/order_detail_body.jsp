<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .order-detail-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
  .order-detail-header { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); border-radius: 16px; padding: 40px; margin-bottom: 32px; color: white; box-shadow: 0 8px 24px rgba(220,53,69,0.15); }
  .order-detail-header h1 { margin: 0 0 8px 0; font-size: 2rem; font-weight: 700; color: white; }
  .order-detail-header p { margin: 0; opacity: 0.95; font-size: 1rem; }
  
  .back-link { display: inline-flex; align-items: center; gap: 8px; color: #64748b; text-decoration: none; font-weight: 600; margin-bottom: 20px; }
  .back-link:hover { color: #dc3545; }
  
  .order-detail-grid { display: grid; grid-template-columns: 1fr 400px; gap: 24px; }
  @media (max-width: 968px) { .order-detail-grid { grid-template-columns: 1fr; } }
  
  .order-main { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
  .order-sidebar { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); height: fit-content; position: sticky; top: 20px; }
  
  .section-title { font-size: 1.25rem; font-weight: 700; color: #1e293b; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #e2e8f0; }
  
  .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 32px; }
  @media (max-width: 768px) { .info-grid { grid-template-columns: 1fr; } }
  .info-item { }
  .info-label { color: #64748b; font-size: 0.85rem; margin-bottom: 4px; font-weight: 600; }
  .info-value { color: #1e293b; font-size: 1rem; font-weight: 600; }
  
  .order-status-large { display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; border-radius: 12px; font-weight: 700; font-size: 1.1rem; }
  .status-new { background: #dbeafe; color: #1e40af; }
  .status-unpaid { background: #fef3c7; color: #92400e; }
  .status-paid { background: #d1fae5; color: #065f46; }
  .status-shipped { background: #ddd6fe; color: #5b21b6; }
  .status-cancelled { background: #fee2e2; color: #991b1b; }
  
  .order-item { display: flex; gap: 16px; padding: 20px; background: #f8fafc; border-radius: 12px; margin-bottom: 12px; }
  .order-item-image { width: 80px; height: 120px; border-radius: 8px; object-fit: cover; background: #e2e8f0; }
  .order-item-details { flex: 1; }
  .order-item-title { font-weight: 700; color: #1e293b; font-size: 1.1rem; margin-bottom: 8px; }
  .order-item-qty { color: #64748b; font-size: 0.9rem; margin-bottom: 4px; }
  .order-item-price { color: #dc3545; font-weight: 700; font-size: 1rem; }
  .order-item-subtotal { text-align: right; }
  .order-item-subtotal-value { font-weight: 700; color: #1e293b; font-size: 1.25rem; }
  
  .order-summary { }
  .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; }
  .summary-label { color: #64748b; font-size: 0.95rem; }
  .summary-value { font-weight: 600; color: #1e293b; }
  .summary-total { border-top: 2px solid #cbd5e1; padding-top: 16px; margin-top: 16px; }
  .summary-total .summary-label { font-size: 1.1rem; font-weight: 700; color: #1e293b; }
  .summary-total .summary-value { font-size: 1.75rem; font-weight: 700; color: #dc3545; }
  
  .order-actions { display: flex; flex-direction: column; gap: 12px; margin-top: 24px; }
  .btn-action { padding: 14px 24px; border-radius: 8px; font-weight: 700; font-size: 1rem; cursor: pointer; transition: all 0.3s; text-decoration: none; text-align: center; border: none; }
  .btn-cancel-order { background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; }
  .btn-cancel-order:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(231,76,60,0.3); color: white; }
  .btn-cancel-order:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
  .btn-back { background: white; color: #64748b; border: 2px solid #e2e8f0; }
  .btn-back:hover { background: #f8fafc; color: #1e293b; }
  
  .timeline { margin-top: 24px; }
  .timeline-item { display: flex; gap: 16px; margin-bottom: 16px; position: relative; }
  .timeline-item:not(:last-child)::before { content: ''; position: absolute; left: 11px; top: 32px; width: 2px; height: calc(100% + 4px); background: #e2e8f0; }
  .timeline-icon { width: 24px; height: 24px; border-radius: 50%; background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; flex-shrink: 0; position: relative; z-index: 1; }
  .timeline-content { flex: 1; }
  .timeline-title { font-weight: 700; color: #1e293b; margin-bottom: 4px; }
  .timeline-time { color: #64748b; font-size: 0.85rem; }
</style>

<c:set var="items" value="${order.items}" />

<div class="order-detail-container">
  <!-- Header -->
  <div class="order-detail-header">
    <h1>📋 Chi tiết đơn hàng #${order.orderId}</h1>
    <p>Thông tin chi tiết về đơn hàng của bạn</p>
  </div>

  <a href="${pageContext.request.contextPath}/orders" class="back-link">
    ← Quay lại danh sách đơn hàng
  </a>

  <div class="order-detail-grid">
    <!-- Main Content -->
    <div class="order-main">
      <!-- Order Info -->
      <h2 class="section-title">📦 Thông tin đơn hàng</h2>
      
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: -2px; margin-right: 4px;">
              <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
            </svg>
            Người nhận
          </div>
          <div class="info-value">${order.customerName}</div>
        </div>

        <div class="info-item">
          <div class="info-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: -2px; margin-right: 4px;">
              <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
            </svg>
            Số điện thoại
          </div>
          <div class="info-value">${order.customerPhone}</div>
        </div>

        <div class="info-item" style="grid-column: 1 / -1;">
          <div class="info-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: -2px; margin-right: 4px;">
              <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5 5 5Z"/>
            </svg>
            Địa chỉ giao hàng
          </div>
          <div class="info-value">${order.shippingAddress}</div>
        </div>

        <div class="info-item">
          <div class="info-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: -2px; margin-right: 4px;">
              <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4zm2.5 1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h2a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-2zm0 3a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zm0 2a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1h-1zm3 0a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1h-1zm3 0a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1h-1zm3 0a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1h-1z"/>
            </svg>
            Thanh toán
          </div>
          <div class="info-value">
            <c:choose>
              <c:when test="${order.paymentMethod == 'COD'}">🚚 COD - Thanh toán khi nhận hàng</c:when>
              <c:when test="${order.paymentMethod == 'BANK'}">🏦 Chuyển khoản ngân hàng</c:when>
              <c:otherwise>${order.paymentMethod}</c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="info-item">
          <div class="info-label">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: -2px; margin-right: 4px;">
              <path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/>
              <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0z"/>
            </svg>
            Ngày đặt
          </div>
          <div class="info-value">
            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
          </div>
        </div>
      </div>

      <c:if test="${not empty order.note}">
        <div class="info-item" style="margin-bottom: 32px;">
          <div class="info-label">📝 Ghi chú</div>
          <div class="info-value" style="color: #64748b; font-weight: 400; font-style: italic;">${order.note}</div>
        </div>
      </c:if>

      <!-- Order Items -->
      <h2 class="section-title">📚 Danh sách sản phẩm</h2>
      
      <c:if test="${empty items}">
        <div style="text-align: center; padding: 40px; color: #64748b;">
          Không có sản phẩm trong đơn hàng.
        </div>
      </c:if>

      <c:if test="${not empty items}">
        <c:forEach var="item" items="${items}">
          <div class="order-item">
            <div class="order-item-details">
              <div class="order-item-title">${item.bookTitle}</div>
              <div class="order-item-qty">Số lượng: ${item.quantity}</div>
              <div class="order-item-price">
                Đơn giá: <fmt:formatNumber value="${item.unitPrice}" pattern="#,###" /> đ
              </div>
            </div>
            <div class="order-item-subtotal">
              <div style="color: #64748b; font-size: 0.85rem; margin-bottom: 4px;">Thành tiền</div>
              <div class="order-item-subtotal-value">
                <fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,###" /> đ
              </div>
            </div>
          </div>
        </c:forEach>
      </c:if>
    </div>

    <!-- Sidebar -->
    <div class="order-sidebar">
      <h3 class="section-title">💼 Tổng quan đơn hàng</h3>
      
      <div style="margin-bottom: 24px;">
        <div style="color: #64748b; font-size: 0.85rem; margin-bottom: 8px; font-weight: 600;">Trạng thái hiện tại</div>
        <c:choose>
          <c:when test="${order.orderStatus == 'NEW'}">
            <div class="order-status-large status-new">🆕 Đơn hàng mới</div>
          </c:when>
          <c:when test="${order.orderStatus == 'UNPAID'}">
            <div class="order-status-large status-unpaid">⏳ Chưa thanh toán</div>
          </c:when>
          <c:when test="${order.orderStatus == 'PAID'}">
            <div class="order-status-large status-paid">✅ Đã thanh toán</div>
          </c:when>
          <c:when test="${order.orderStatus == 'SHIPPED'}">
            <div class="order-status-large status-shipped">🚚 Đã giao hàng</div>
          </c:when>
          <c:when test="${order.orderStatus == 'CANCELLED'}">
            <div class="order-status-large status-cancelled">❌ Đã hủy</div>
          </c:when>
          <c:otherwise>
            <div class="order-status-large">${order.orderStatus}</div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="order-summary">
        <div class="summary-row">
          <span class="summary-label">Số sản phẩm:</span>
          <span class="summary-value">
            <c:set var="totalQty" value="0" />
            <c:forEach var="item" items="${items}">
              <c:set var="totalQty" value="${totalQty + item.quantity}" />
            </c:forEach>
            ${totalQty} cuốn
          </span>
        </div>

        <div class="summary-row">
          <span class="summary-label">Tạm tính:</span>
          <span class="summary-value">
            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /> đ
          </span>
        </div>

        <div class="summary-row">
          <span class="summary-label">Phí vận chuyển:</span>
          <span class="summary-value">Miễn phí</span>
        </div>

        <div class="summary-row summary-total">
          <span class="summary-label">Tổng cộng:</span>
          <span class="summary-value">
            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /> đ
          </span>
        </div>
      </div>

      <div class="order-actions">
        <c:if test="${order.orderStatus == 'NEW' || order.orderStatus == 'UNPAID'}">
          <button id="btnCancelOrder" data-id="${order.orderId}" class="btn-action btn-cancel-order">
            🗑️ Hủy đơn hàng
          </button>
        </c:if>
        <a class="btn-action btn-back" href="${pageContext.request.contextPath}/orders">
          ← Quay lại danh sách
        </a>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var btn = document.getElementById('btnCancelOrder');
  if (!btn) return;
  btn.addEventListener('click', function(){
    var id = this.getAttribute('data-id');
    if (!confirm('Bạn có chắc chắn muốn hủy đơn hàng #' + id + '?\n\nSau khi hủy, số lượng sách sẽ được hoàn lại kho.')) return;
    this.disabled = true;
    this.textContent = '⏳ Đang xử lý...';
    fetch(window.location.origin + '${pageContext.request.contextPath}/order/cancel', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'id=' + encodeURIComponent(id)
    }).then(function(r){ return r.json(); }).then(function(json){
      if (json && json.success) {
        window.location.reload();
      } else {
        alert('Không thể hủy đơn hàng. ' + (json.error || 'Vui lòng thử lại.'));
        btn.disabled = false;
        btn.textContent = '🗑️ Hủy đơn hàng';
      }
    }).catch(function(){ 
      alert('Lỗi kết nối. Vui lòng thử lại.'); 
      btn.disabled = false; 
      btn.textContent = '🗑️ Hủy đơn hàng';
    });
  });
})();
</script>
