<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .cart-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
  .cart-header { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); border-radius: 16px; padding: 40px; margin-bottom: 32px; color: white; box-shadow: 0 8px 24px rgba(220,53,69,0.15); }
  .cart-header h1 { margin: 0 0 8px 0; font-size: 2rem; font-weight: 700; color: white; }
  .cart-header p { margin: 0; opacity: 0.95; font-size: 1rem; }
  
  .cart-content { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
  
  .empty-cart { text-align: center; padding: 60px 20px; }
  .empty-cart-icon { font-size: 5rem; margin-bottom: 20px; opacity: 0.3; }
  .empty-cart-text { font-size: 1.25rem; color: #64748b; margin-bottom: 24px; }
  .empty-cart-btn { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; border: none; padding: 12px 32px; border-radius: 8px; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.3s; }
  .empty-cart-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); color: white; }
  
  .cart-item { background: #f8fafc; border-radius: 12px; padding: 20px; margin-bottom: 16px; display: flex; align-items: center; gap: 20px; transition: all 0.3s; }
  .cart-item:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
  .cart-item-image { width: 80px; height: 120px; border-radius: 8px; object-fit: cover; background: #e2e8f0; }
  .cart-item-details { flex: 1; }
  .cart-item-title { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
  .cart-item-author { color: #64748b; font-size: 0.9rem; margin-bottom: 8px; }
  .cart-item-price { color: #dc3545; font-weight: 700; font-size: 1.1rem; }
  .cart-item-discount { text-decoration: line-through; color: #94a3b8; font-size: 0.9rem; margin-left: 8px; }
  
  .cart-item-qty { display: flex; align-items: center; gap: 8px; }
  .qty-input { width: 80px; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 8px; text-align: center; font-weight: 600; }
  .qty-input:focus { outline: none; border-color: #dc3545; }
  .qty-btn { background: white; border: 2px solid #dc3545; color: #dc3545; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
  .qty-btn:hover { background: #dc3545; color: white; }
  
  .remove-btn { background: white; border: 2px solid #e74c3c; color: #e74c3c; padding: 8px 16px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.3s; border-style: solid; }
  .remove-btn:hover { background: #e74c3c; color: white; }
  
  .cart-summary { background: linear-gradient(135deg, #f8fafc, #e2e8f0); border-radius: 12px; padding: 24px; margin-top: 24px; }
  .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; }
  .summary-label { color: #64748b; font-size: 0.95rem; }
  .summary-value { font-weight: 600; color: #1e293b; }
  .summary-total { border-top: 2px solid #cbd5e1; padding-top: 16px; margin-top: 16px; }
  .summary-total .summary-label { font-size: 1.1rem; font-weight: 700; color: #1e293b; }
  .summary-total .summary-value { font-size: 1.5rem; font-weight: 700; color: #dc3545; }
  
  .checkout-btn { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; border: none; padding: 16px 48px; border-radius: 8px; font-weight: 700; font-size: 1.1rem; width: 100%; margin-top: 20px; cursor: pointer; transition: all 0.3s; text-decoration: none; display: block; text-align: center; }
  .checkout-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); color: white; }
  
  .continue-shopping { text-align: center; margin-top: 16px; }
  .continue-shopping a { color: #64748b; text-decoration: none; font-weight: 600; }
  .continue-shopping a:hover { color: #dc3545; }
  
  .alert-modern { padding: 16px 20px; border-radius: 12px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-weight: 600; }
  .alert-warning { background: #fef3c7; color: #92400e; border-left: 4px solid #f59e0b; }
  .alert-warning .btn-close { background: transparent; border: none; font-size: 1.2rem; cursor: pointer; }
  
  @media (max-width: 768px) {
    .cart-item { flex-direction: column; text-align: center; }
    .cart-item-image { width: 100%; height: 200px; }
    .cart-item-qty { justify-content: center; }
  }
</style>

<c:set var="cart" value="${sessionScope.cart}" />
<c:set var="items" value="${cart.items}" />

<div class="cart-container">
  <!-- Header -->
  <div class="cart-header">
    <h1>🛒 Giỏ hàng của bạn</h1>
    <p>Kiểm tra và cập nhật giỏ hàng trước khi thanh toán</p>
  </div>

  <div class="cart-content">
    <!-- Alert -->
    <c:if test="${not empty sessionScope.cartError}">
      <div class="alert-modern alert-warning">
        <span>⚠️ ${sessionScope.cartError}</span>
        <button type="button" class="btn-close" onclick="this.parentElement.remove()">×</button>
      </div>
      <c:remove var="cartError" scope="session" />
    </c:if>

    <!-- Empty Cart -->
    <c:if test="${empty cart || empty items}">
      <div class="empty-cart">
        <div class="empty-cart-icon">🛍️</div>
        <div class="empty-cart-text">Giỏ hàng của bạn đang trống</div>
        <a href="${pageContext.request.contextPath}/books" class="empty-cart-btn">
          📚 Khám phá sách ngay
        </a>
      </div>
    </c:if>

    <!-- Cart Items -->
    <c:if test="${not empty cart && not empty items}">
      <c:forEach var="it" items="${items}">
        <div class="cart-item">
          <img src="${it.book.coverUrl}" alt="${it.book.title}" class="cart-item-image" 
               onerror="this.src='${pageContext.request.contextPath}/assets/images/no-cover.jpg'">
          
          <div class="cart-item-details">
            <div class="cart-item-title">${it.book.title}</div>
            <div class="cart-item-author">📖 ${it.book.author}</div>
            <div class="cart-item-price">
              <fmt:formatNumber value="${it.book.price * (100 - it.book.discountPercent) / 100}" pattern="#,###" /> đ
              <c:if test="${it.book.discountPercent > 0}">
                <span class="cart-item-discount">
                  <fmt:formatNumber value="${it.book.price}" pattern="#,###" /> đ
                </span>
              </c:if>
            </div>
          </div>
          
          <div class="cart-item-qty">
            <form method="post" action="${pageContext.request.contextPath}/cart/update" style="display: flex; align-items: center; gap: 8px;">
              <jsp:include page="/WEB-INF/views/_csrf.jsp" />
              <input type="hidden" name="id" value="${it.book.id}"/>
              <input class="qty-input" type="number" min="1" name="qty" value="${it.quantity}"/>
              <button class="qty-btn" type="submit">✓</button>
            </form>
          </div>
          
          <div>
            <form method="post" action="${pageContext.request.contextPath}/cart/remove" style="display: inline;">
              <jsp:include page="/WEB-INF/views/_csrf.jsp" />
              <input type="hidden" name="id" value="${it.book.id}"/>
              <button class="remove-btn" type="submit">🗑️ Xóa</button>
            </form>
          </div>
        </div>
      </c:forEach>

      <!-- Summary -->
      <div class="cart-summary">
        <div class="summary-row">
          <span class="summary-label">Số lượng sản phẩm:</span>
          <span class="summary-value">
            <c:set var="totalQty" value="0" />
            <c:forEach var="it" items="${items}">
              <c:set var="totalQty" value="${totalQty + it.quantity}" />
            </c:forEach>
            ${totalQty} cuốn
          </span>
        </div>
        
        <div class="summary-row summary-total">
          <span class="summary-label">Tổng cộng:</span>
          <span class="summary-value">
            <fmt:formatNumber value="${cart.total}" pattern="#,###" /> đ
          </span>
        </div>
        
        <a href="${pageContext.request.contextPath}/checkout" class="checkout-btn">
          💳 Tiến hành thanh toán
        </a>
        
        <div class="continue-shopping">
          <a href="${pageContext.request.contextPath}/books">← Tiếp tục mua sắm</a>
        </div>
      </div>
    </c:if>
  </div>
</div>
