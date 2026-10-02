<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="mb-3">
    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
        ← Quay lại danh sách
    </a>
</div>

<h3 class="admin-title">Chi tiết đơn hàng #${order.orderId}</h3>

<div class="row">
    <!-- Thông tin đơn hàng -->
    <div class="col-md-6 mb-4">
        <div class="admin-card">
            <h5 class="mb-3"><i class="bi bi-receipt"></i> Thông tin đơn hàng</h5>
            <table class="table table-sm">
                <tr>
                    <td><strong>Mã đơn:</strong></td>
                    <td>#${order.orderId}</td>
                </tr>
                <tr>
                    <td><strong>Ngày đặt:</strong></td>
                    <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                </tr>
                <tr>
                    <td><strong>Trạng thái:</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${order.orderStatus == 'NEW'}">
                                <span class="badge" style="background: #ffa726; color: white;">Mới</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'SHIPPED'}">
                                <span class="badge" style="background: #42a5f5; color: white;">Đang giao</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'CANCELLED'}">
                                <span class="badge" style="background: #ef5350; color: white;">Đã hủy</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'DELIVERED'}">
                                <span class="badge" style="background: #66bb6a; color: white;">Hoàn thành</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${order.orderStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td><strong>Phương thức thanh toán:</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'VNPAY'}">
                                <span class="badge" style="background: #1e88e5; color: white;">VNPay</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge" style="background: #66bb6a; color: white;">COD</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td><strong>Trạng thái thanh toán:</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${order.paymentStatus == 'PAID'}">
                                <span class="badge bg-success">Đã thanh toán</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning text-dark">Chưa thanh toán</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- Thông tin khách hàng -->
    <div class="col-md-6 mb-4">
        <div class="admin-card">
            <h5 class="mb-3"><i class="bi bi-person"></i> Thông tin khách hàng</h5>
            <table class="table table-sm">
                <tr>
                    <td><strong>Họ tên:</strong></td>
                    <td>${order.customerName}</td>
                </tr>
                <tr>
                    <td><strong>Số điện thoại:</strong></td>
                    <td>${order.customerPhone}</td>
                </tr>
                <tr>
                    <td><strong>Địa chỉ giao hàng:</strong></td>
                    <td>${order.shippingAddress}</td>
                </tr>
                <c:if test="${not empty order.note}">
                    <tr>
                        <td><strong>Ghi chú:</strong></td>
                        <td>${order.note}</td>
                    </tr>
                </c:if>
            </table>
        </div>
    </div>
</div>

<!-- Chi tiết sản phẩm -->
<div class="admin-card">
    <h5 class="mb-3"><i class="bi bi-cart"></i> Chi tiết sản phẩm</h5>
    <div class="table-responsive">
        <table class="table admin-table">
            <thead>
                <tr>
                    <th>Sách</th>
                    <th class="text-end">Đơn giá</th>
                    <th class="text-center">Số lượng</th>
                    <th class="text-end">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <c:if test="${not empty item.book.coverUrl}">
                                    <img src="${pageContext.request.contextPath}/${item.book.coverUrl}"
                                         alt="${item.book.title}"
                                         style="width: 50px; height: 70px; object-fit: cover; margin-right: 12px;">
                                </c:if>
                                <div>
                                    <div><strong>${item.book.title}</strong></div>
                                    <small class="text-muted">${item.book.author}</small>
                                </div>
                            </div>
                        </td>
                        <td class="text-end">
                            <fmt:formatNumber value="${item.unitPrice}" type="number" pattern="#,###"/>₫
                        </td>
                        <td class="text-center">
                            <strong>${item.quantity}</strong>
                        </td>
                        <td class="text-end">
                            <strong><fmt:formatNumber value="${item.unitPrice * item.quantity}" type="number" pattern="#,###"/>₫</strong>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3" class="text-end"><strong>Tổng cộng:</strong></td>
                    <td class="text-end">
                        <h5 class="mb-0 text-primary">
                            <fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,###"/>₫
                        </h5>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</div>

<!-- Hành động -->
<div class="admin-card mt-3">
    <h5 class="mb-3">Hành động</h5>
    <div class="d-flex gap-2">
        <c:if test="${order.orderStatus == 'NEW'}">
            <button data-id="${order.orderId}" class="btn btn-success btn-ship">
                <i class="bi bi-truck"></i> Giao hàng
            </button>
            <button data-id="${order.orderId}" class="btn btn-danger btn-cancel">
                <i class="bi bi-x-circle"></i> Hủy đơn
            </button>
        </c:if>
        <c:if test="${order.orderStatus == 'SHIPPED'}">
            <button data-id="${order.orderId}" class="btn btn-primary btn-complete">
                <i class="bi bi-check-circle"></i> Đã giao
            </button>
        </c:if>
        <c:if test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'CANCELLED'}">
            <span class="text-muted">Không có hành động khả dụng</span>
        </c:if>
    </div>
</div>

<script>
(function(){
    function postAction(id, action){
        return fetchWithCsrf('${pageContext.request.contextPath}/admin/order/action', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ id: id, action: action })
        }).then(r => r.json());
    }

    document.querySelectorAll('.btn-ship').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-hourglass"></i> Đang xử lý...';

            postAction(id, 'ship').then(res => {
                if(res && res.success){
                    location.reload();
                } else {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-truck"></i> Giao hàng';
                    alert('Không thể cập nhật: ' + (res.message || 'Lỗi không xác định'));
                }
            }).catch(err => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-truck"></i> Giao hàng';
                alert('Lỗi kết nối: ' + err.message);
            });
        });
    });

    document.querySelectorAll('.btn-cancel').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            if(!confirm('Xác nhận hủy đơn #' + id + '?')) return;

            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-hourglass"></i> Đang xử lý...';

            postAction(id, 'cancel').then(res => {
                if(res && res.success){
                    location.reload();
                } else {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-x-circle"></i> Hủy đơn';
                    alert('Không thể hủy: ' + (res.message || 'Lỗi không xác định'));
                }
            }).catch(err => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-x-circle"></i> Hủy đơn';
                alert('Lỗi kết nối: ' + err.message);
            });
        });
    });

    document.querySelectorAll('.btn-complete').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            if(!confirm('Xác nhận đơn hàng #' + id + ' đã giao thành công?')) return;

            btn.disabled = true;
            btn.innerHTML = '<i class="bi bi-hourglass"></i> Đang xử lý...';

            postAction(id, 'complete').then(res => {
                if(res && res.success){
                    location.reload();
                } else {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-check-circle"></i> Đã giao';
                    alert('Không thể cập nhật: ' + (res.message || 'Lỗi không xác định'));
                }
            }).catch(err => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-check-circle"></i> Đã giao';
                alert('Lỗi kết nối: ' + err.message);
            });
        });
    });
})();
</script>
