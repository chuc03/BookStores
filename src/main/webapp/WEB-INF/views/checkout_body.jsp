<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .checkout-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
  .checkout-header { background: linear-gradient(135deg, #dc3545 0%, #ff6b35 100%); border-radius: 16px; padding: 40px; margin-bottom: 32px; color: white; box-shadow: 0 8px 24px rgba(220,53,69,0.15); }
  .checkout-header h1 { margin: 0 0 8px 0; font-size: 2rem; font-weight: 700; color: white; }
  .checkout-header p { margin: 0; opacity: 0.95; font-size: 1rem; }
  
  .checkout-grid { display: grid; grid-template-columns: 1fr 400px; gap: 24px; }
  @media (max-width: 968px) { .checkout-grid { grid-template-columns: 1fr; } }
  
  .checkout-form { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
  .form-section { margin-bottom: 32px; }
  .form-section:last-child { margin-bottom: 0; }
  .form-section-title { font-size: 1.25rem; font-weight: 700; color: #1e293b; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #e2e8f0; }
  
  .form-group { margin-bottom: 20px; }
  .form-label { display: flex; align-items: center; gap: 8px; font-weight: 600; color: #1e293b; margin-bottom: 8px; font-size: 0.9rem; }
  .form-input { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 0.95rem; transition: all 0.3s; }
  .form-input:focus { outline: none; border-color: #dc3545; box-shadow: 0 0 0 3px rgba(220,53,69,0.1); }
  .form-textarea { min-height: 80px; resize: vertical; }
  .form-select { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 0.95rem; transition: all 0.3s; background: white; }
  .form-select:focus { outline: none; border-color: #dc3545; box-shadow: 0 0 0 3px rgba(220,53,69,0.1); }
  
  .payment-options { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  .payment-option { position: relative; }
  .payment-option input { position: absolute; opacity: 0; }
  .payment-option label { display: flex; flex-direction: column; align-items: center; gap: 8px; padding: 16px; border: 2px solid #e2e8f0; border-radius: 8px; cursor: pointer; transition: all 0.3s; background: white; }
  .payment-option input:checked + label { border-color: #dc3545; background: #fef2f2; }
  .payment-option-icon { font-size: 2rem; }
  .payment-option-text { font-weight: 600; color: #1e293b; }
  
  .order-summary { background: white; border-radius: 16px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); height: fit-content; position: sticky; top: 20px; }
  .summary-title { font-size: 1.25rem; font-weight: 700; color: #1e293b; margin-bottom: 20px; }
  
  .summary-item { display: flex; gap: 16px; padding: 16px 0; border-bottom: 1px solid #e2e8f0; }
  .summary-item:last-child { border-bottom: none; }
  .summary-item-image { width: 60px; height: 90px; border-radius: 8px; object-fit: cover; background: #e2e8f0; }
  .summary-item-details { flex: 1; }
  .summary-item-title { font-weight: 600; color: #1e293b; font-size: 0.9rem; margin-bottom: 4px; }
  .summary-item-qty { color: #64748b; font-size: 0.85rem; }
  .summary-item-price { font-weight: 700; color: #dc3545; }
  
  .summary-totals { margin-top: 20px; padding-top: 20px; border-top: 2px solid #e2e8f0; }
  .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; }
  .summary-label { color: #64748b; font-size: 0.95rem; }
  .summary-value { font-weight: 600; color: #1e293b; }
  .summary-total { border-top: 2px solid #cbd5e1; padding-top: 16px; margin-top: 16px; }
  .summary-total .summary-label { font-size: 1.1rem; font-weight: 700; color: #1e293b; }
  .summary-total .summary-value { font-size: 1.5rem; font-weight: 700; color: #dc3545; }
  
  .submit-btn { background: linear-gradient(135deg, #dc3545, #ff6b35); color: white; border: none; padding: 16px 32px; border-radius: 8px; font-weight: 700; font-size: 1.1rem; width: 100%; cursor: pointer; transition: all 0.3s; margin-top: 24px; }
  .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); }
  
  .alert-error { background: #fee2e2; color: #991b1b; padding: 16px 20px; border-radius: 12px; margin-bottom: 24px; border-left: 4px solid #dc2626; font-weight: 600; }
  
  .back-link { display: inline-flex; align-items: center; gap: 8px; color: #64748b; text-decoration: none; font-weight: 600; margin-bottom: 20px; }
  .back-link:hover { color: #dc3545; }
</style>

<c:set var="cart" value="${sessionScope.cart}" />
<c:set var="items" value="${cart.items}" />

<div class="checkout-container">
  <!-- Header -->
  <div class="checkout-header">
    <h1>💳 Thanh toán đơn hàng</h1>
    <p>Vui lòng kiểm tra thông tin và hoàn tất đơn hàng</p>
  </div>

  <a href="${pageContext.request.contextPath}/cart" class="back-link">
    ← Quay lại giỏ hàng
  </a>

  <div class="checkout-grid">
    <!-- Form -->
    <div class="checkout-form">
      <c:if test="${not empty error}">
        <div class="alert-error">
          ⚠️ ${error}
        </div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/checkout">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
        
        <!-- Customer Info -->
        <div class="form-section">
          <h2 class="form-section-title">📋 Thông tin người nhận</h2>
          
          <div class="form-group">
            <label class="form-label">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
              </svg>
              Họ và tên
            </label>
            <input class="form-input" name="name" value="${sessionScope.me.fullName}" placeholder="Nhập họ tên đầy đủ" required>
          </div>

          <div class="form-group">
            <label class="form-label">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
              </svg>
              Số điện thoại
            </label>
            <input class="form-input" name="phone" value="${sessionScope.me.phone}" pattern="[0-9]{10,11}" placeholder="Nhập 10-11 chữ số" title="Nhập 10-11 chữ số" required>
          </div>

          <div class="form-group">
            <label class="form-label">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5 5 5Z"/>
              </svg>
              Địa chỉ giao hàng
            </label>
            <input class="form-input" name="address" placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố" required>
          </div>

          <div class="form-group">
            <label class="form-label">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M2.5 3A1.5 1.5 0 0 0 1 4.5v.793c.026.009.051.02.076.032L7.674 8.51c.206.1.446.1.652 0l6.598-3.185A.755.755 0 0 1 15 5.293V4.5A1.5 1.5 0 0 0 13.5 3h-11Z"/>
                <path d="M15 6.954 8.978 9.86a2.25 2.25 0 0 1-1.956 0L1 6.954V11.5A1.5 1.5 0 0 0 2.5 13h11a1.5 1.5 0 0 0 1.5-1.5V6.954Z"/>
              </svg>
              Ghi chú (không bắt buộc)
            </label>
            <textarea class="form-input form-textarea" name="note" placeholder="Ghi chú cho người giao hàng..."></textarea>
          </div>
        </div>

        <!-- Payment Method -->
        <div class="form-section">
          <h2 class="form-section-title">💰 Phương thức thanh toán</h2>
          
          <div class="payment-options">
            <div class="payment-option">
              <input type="radio" name="paymentMethod" value="COD" id="payment-cod" checked required>
              <label for="payment-cod">
                <div class="payment-option-icon">🚚</div>
                <div class="payment-option-text">COD</div>
                <div style="font-size: 0.8rem; color: #64748b;">Thanh toán khi nhận hàng</div>
              </label>
            </div>
            
            <div class="payment-option">
              <input type="radio" name="paymentMethod" value="VNPAY" id="payment-vnpay" required>
              <label for="payment-vnpay">
                <div class="payment-option-icon">💳</div>
                <div class="payment-option-text">VNPay</div>
                <div style="font-size: 0.8rem; color: #64748b;">Thanh toán qua VNPay</div>
              </label>
            </div>
          </div>
        </div>

        <button class="submit-btn" type="submit">
          ✓ Xác nhận đặt hàng
        </button>
      </form>
    </div>

    <!-- Order Summary -->
    <div class="order-summary">
      <h3 class="summary-title">📦 Đơn hàng của bạn</h3>
      
      <c:forEach var="it" items="${items}">
        <div class="summary-item">
          <img src="${it.book.coverUrl}" alt="${it.book.title}" class="summary-item-image"
               onerror="this.src='${pageContext.request.contextPath}/assets/images/no-cover.jpg'">
          <div class="summary-item-details">
            <div class="summary-item-title">${it.book.title}</div>
            <div class="summary-item-qty">Số lượng: ${it.quantity}</div>
          </div>
          <div class="summary-item-price">
            <fmt:formatNumber value="${it.lineTotal}" pattern="#,###" /> đ
          </div>
        </div>
      </c:forEach>
      
      <div class="summary-totals">
        <div class="summary-row">
          <span class="summary-label">Tạm tính:</span>
          <span class="summary-value">
            <fmt:formatNumber value="${cart.total}" pattern="#,###" /> đ
          </span>
        </div>
        
        <div class="summary-row">
          <span class="summary-label">Phí vận chuyển:</span>
          <span class="summary-value">Miễn phí</span>
        </div>
        
        <div class="summary-row summary-total">
          <span class="summary-label">Tổng cộng:</span>
          <span class="summary-value">
            <fmt:formatNumber value="${cart.total}" pattern="#,###" /> đ
          </span>
        </div>
      </div>
    </div>
  </div>
</div>
