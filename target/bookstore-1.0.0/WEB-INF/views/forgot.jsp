<%@ page contentType="text/html; charset=UTF-8" %>

<style>
.forgot-password-container {
    max-width: 480px;
    margin: 40px auto;
    padding: 0 20px;
}

.forgot-password-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    padding: 50px 45px;
    border: 1px solid #e8e8e8;
}

.forgot-icon {
    width: 90px;
    height: 90px;
    margin: 0 auto 28px;
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 45px;
    box-shadow: 0 8px 25px rgba(99, 102, 241, 0.3);
}

.forgot-title {
    font-size: 30px;
    font-weight: 700;
    color: #1f2937;
    margin-bottom: 14px;
    text-align: center;
}

.forgot-subtitle {
    color: #6b7280;
    text-align: center;
    margin-bottom: 36px;
    line-height: 1.7;
    font-size: 15px;
}

.forgot-form-group {
    margin-bottom: 28px;
}

.forgot-label {
    display: block;
    font-weight: 600;
    color: #374151;
    margin-bottom: 10px;
    font-size: 15px;
}

.forgot-input-wrapper {
    position: relative;
}

.forgot-email-icon {
    position: absolute;
    left: 16px;
    top: 50%;
    transform: translateY(-50%);
    color: #9ca3af;
    font-size: 20px;
    pointer-events: none;
}

.forgot-input {
    width: 100%;
    padding: 15px 18px 15px 50px;
    border: 2px solid #e5e7eb;
    border-radius: 12px;
    font-size: 15px;
    transition: all 0.3s ease;
    background: #f9fafb;
    box-sizing: border-box;
}

.forgot-input:focus {
    outline: none;
    border-color: #6366f1;
    background: white;
    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
}

.forgot-input:focus + .forgot-email-icon {
    color: #6366f1;
}

.forgot-submit-btn {
    width: 100%;
    padding: 17px;
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 12px;
    box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
}

.forgot-submit-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
}

.forgot-submit-btn:active {
    transform: translateY(0);
}

.forgot-back-link {
    text-align: center;
    margin-top: 28px;
    padding-top: 24px;
    border-top: 1px solid #e5e7eb;
}

.forgot-back-link a {
    color: #6366f1;
    text-decoration: none;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s ease;
    font-size: 15px;
}

.forgot-back-link a:hover {
    color: #8b5cf6;
    gap: 10px;
}

.forgot-alert {
    padding: 16px 18px;
    border-radius: 12px;
    margin-bottom: 28px;
    font-size: 14px;
    line-height: 1.6;
    display: flex;
    align-items: flex-start;
    gap: 10px;
}

.forgot-alert:empty {
    display: none;
}

.forgot-alert strong {
    display: flex;
    align-items: center;
    gap: 6px;
}

.forgot-alert-danger {
    background: #fef2f2;
    border: 1px solid #fecaca;
    color: #dc2626;
}

.forgot-alert-success {
    background: #f0fdf4;
    border: 1px solid #bbf7d0;
    color: #16a34a;
}

.forgot-alert-info {
    background: #eff6ff;
    border: 1px solid #bfdbfe;
    color: #2563eb;
}

@media (max-width: 576px) {
    .forgot-password-card {
        padding: 35px 28px;
        border-radius: 16px;
    }
    
    .forgot-title {
        font-size: 26px;
    }
    
    .forgot-icon {
        width: 75px;
        height: 75px;
        font-size: 38px;
    }
    
    .forgot-subtitle {
        font-size: 14px;
    }
}
</style>

<div class="forgot-password-container">
    <div class="forgot-password-card">
        <div class="forgot-icon">🔐</div>
        
        <h1 class="forgot-title">Quên mật khẩu?</h1>
        <p class="forgot-subtitle">
            Đừng lo lắng! Nhập email của bạn và chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu.
        </p>

        <div id="alertContainer"></div>

        <script>
            // Only show alerts if there's actual content
            const error = '${error}';
            const message = '${message}';
            const container = document.getElementById('alertContainer');
            
            if (error && error.trim() && error !== 'null') {
                container.innerHTML = '<div class="forgot-alert forgot-alert-danger"><strong>❌ Lỗi:</strong> <span>' + error + '</span></div>';
            } else if (message && message.trim() && message !== 'null') {
                container.innerHTML = '<div class="forgot-alert forgot-alert-success"><strong>✅ Thành công:</strong> <span>' + message + '</span></div>';
            }
        </script>

        <form method="post" action="${pageContext.request.contextPath}/forgot-password">
            <jsp:include page="/WEB-INF/views/_csrf.jsp" />
            
            <div class="forgot-form-group">
                <label class="forgot-label">Địa chỉ Email</label>
                <div class="forgot-input-wrapper">
                    <input 
                        type="email" 
                        name="email" 
                        class="forgot-input"
                        placeholder="your.email@example.com" 
                        required 
                        autocomplete="email"
                    />
                    <div class="forgot-email-icon">📧</div>
                </div>
            </div>

            <button type="submit" class="forgot-submit-btn">
                Gửi hướng dẫn đặt lại mật khẩu
            </button>
        </form>

        <div class="forgot-back-link">
            <a href="${pageContext.request.contextPath}/login">
                ← Quay lại đăng nhập
            </a>
        </div>
    </div>
</div>
