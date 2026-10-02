<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đặt hàng thành công</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    
    .success-container {
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      max-width: 520px;
      width: 100%;
      padding: 50px 40px;
      text-align: center;
      animation: slideUp 0.5s ease-out;
    }
    
    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    .success-icon {
      width: 90px;
      height: 90px;
      background: linear-gradient(135deg, #10b981, #059669);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 30px;
      animation: scaleIn 0.5s ease-out 0.2s both;
    }
    
    @keyframes scaleIn {
      from {
        transform: scale(0);
      }
      to {
        transform: scale(1);
      }
    }
    
    .success-icon svg {
      width: 50px;
      height: 50px;
      stroke: white;
      stroke-width: 3.5;
      fill: none;
      stroke-linecap: round;
      stroke-linejoin: round;
    }
    
    .success-title {
      font-size: 32px;
      font-weight: 700;
      color: #1e293b;
      margin-bottom: 16px;
    }
    
    .success-message {
      font-size: 15px;
      color: #64748b;
      margin-bottom: 30px;
      line-height: 1.7;
      padding: 0 10px;
    }
    
    .order-info {
      background: #f8fafc;
      border-radius: 12px;
      padding: 24px 20px;
      margin-bottom: 36px;
    }
    
    .order-label {
      font-size: 14px;
      color: #64748b;
      margin-bottom: 8px;
    }
    
    .order-id {
      font-size: 28px;
      font-weight: 700;
      color: #667eea;
      font-family: 'Courier New', monospace;
      letter-spacing: 1px;
    }
    
    .button-group {
      display: flex;
      gap: 16px;
      flex-direction: row;
      justify-content: center;
    }
    
    .btn {
      padding: 15px 32px;
      border-radius: 10px;
      font-size: 15px;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      min-width: 160px;
    }
    
    .btn-primary {
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: white;
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    }
    
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
    }
    
    .btn-secondary {
      background: white;
      color: #667eea;
      border: 2px solid #667eea;
    }
    
    .btn-secondary:hover {
      background: #f8fafc;
      transform: translateY(-2px);
    }
    
    @media (max-width: 480px) {
      .button-group {
        flex-direction: column;
      }
      .btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <div class="success-container">
    <div class="success-icon">
      <svg viewBox="0 0 24 24">
        <polyline points="20 6 9 17 4 12"></polyline>
      </svg>
    </div>
    
    <h1 class="success-title">Đặt hàng thành công!</h1>
    
    <p class="success-message">
      Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ xử lý đơn hàng của bạn trong thời gian sớm nhất.
    </p>
    
    <div class="order-info">
      <div class="order-label">Mã đơn hàng của bạn</div>
      <div class="order-id">#${orderId}</div>
    </div>
    
    <div class="button-group">
      <button onclick="window.location.href='${pageContext.request.contextPath}/order?id=${orderId}'" class="btn btn-primary">
        Xem đơn hàng
      </button>
      <button onclick="window.location.href='${pageContext.request.contextPath}/'" class="btn btn-secondary">
        Về trang chủ
      </button>
    </div>
  </div>
</body>
</html>

