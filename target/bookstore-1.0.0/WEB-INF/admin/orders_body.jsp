<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h3 class="admin-title">Quản lý đơn hàng</h3>

<div class="admin-card">

    <!-- Bộ lọc -->
    <div class="d-flex mb-3 gap-2">
        <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin/orders">
            <input name="q" class="form-control me-2" placeholder="Tìm theo ID hoặc khách..." value="${param.q}" />
            <select name="pageSize" class="form-select me-2" style="width:120px;">
                <option value="5"  ${pageSize == 5  ? 'selected' : ''}>5 / trang</option>
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 / trang</option>
                <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 / trang</option>
            </select>
            <button class="btn btn-outline-primary" type="submit">Áp dụng</button>
        </form>
    </div>

    <!-- Bảng đơn hàng -->
    <div class="table-responsive">
        <table id="ordersTable" class="table admin-table">
            <thead>
                <tr>
                    <th>Mã</th>
                    <th>Khách</th>
                    <th>Tổng</th>
                    <th>Thanh toán</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td><strong>#${o.orderId}</strong></td>
                        <td>${o.customerName}</td>
                        <td><strong><fmt:formatNumber value="${o.totalAmount}" type="number" pattern="#,###"/>₫</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${o.paymentMethod == 'VNPAY'}">
                                    <span class="badge" style="background: #1e88e5; color: white;">VNPay</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge" style="background: #66bb6a; color: white;">COD</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${o.orderStatus == 'NEW'}">
                                    <span class="badge" style="background: #ffa726; color: white;">Mới</span>
                                </c:when>
                                <c:when test="${o.orderStatus == 'SHIPPED' || o.orderStatus == 'Shipping'}">
                                    <span class="badge" style="background: #42a5f5; color: white;">Đang giao</span>
                                </c:when>
                                <c:when test="${o.orderStatus == 'CANCELLED' || o.orderStatus == 'Cancelled'}">
                                    <span class="badge" style="background: #ef5350; color: white;">Đã hủy</span>
                                </c:when>
                                <c:when test="${o.orderStatus == 'DELIVERED' || o.orderStatus == 'Delivered'}">
                                    <span class="badge" style="background: #66bb6a; color: white;">Hoàn thành</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge" style="background: #bdbdbd; color: white;">${o.orderStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="table-actions">
                            <a class="btn btn-sm btn-outline-primary me-1"
                               href="${pageContext.request.contextPath}/admin/order?id=${o.orderId}">
                                Xem
                            </a>
                            <c:if test="${o.orderStatus == 'NEW'}">
                                <button data-id="${o.orderId}" class="btn btn-sm btn-success btn-ship">Giao</button>
                                <button data-id="${o.orderId}" class="btn btn-sm btn-danger btn-cancel">Hủy</button>
                            </c:if>
                            <c:if test="${o.orderStatus == 'SHIPPED' || o.orderStatus == 'Shipping'}">
                                <button data-id="${o.orderId}" class="btn btn-sm btn-primary btn-complete">Đã giao</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Phân trang -->
    <nav>
        <ul class="pagination justify-content-center">
            <c:if test="${totalPages > 1}">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/orders?page=${currentPage-1}&pageSize=${pageSize}">
                        Trước
                    </a>
                </li>

                <c:forEach begin="1" end="${totalPages}" var="p">
                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/admin/orders?page=${p}&pageSize=${pageSize}">
                            ${p}
                        </a>
                    </li>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/orders?page=${currentPage+1}&pageSize=${pageSize}">
                        Sau
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</div>

<script>
(function(){
    // AJAX action handler
    function postAction(id, action){
        return fetchWithCsrf('${pageContext.request.contextPath}/admin/order/action', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ id: id, action: action })
        }).then(r => r.json());
    }

    // Giao hàng
    document.querySelectorAll('.btn-ship').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            btn.disabled = true;
            btn.textContent = 'Đang...';

            postAction(id, 'ship').then(res => {
                if(res && res.success){
                    location.reload();
                } else {
                    btn.disabled = false;
                    btn.textContent = 'Giao';
                    alert('Không thể cập nhật: ' + (res.message || 'Lỗi không xác định'));
                }
            }).catch(err => {
                btn.disabled = false;
                btn.textContent = 'Giao';
                alert('Lỗi kết nối: ' + err.message);
            });
        });
    });

    // Hủy đơn
    document.querySelectorAll('.btn-cancel').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            if(!confirm('Xác nhận hủy đơn #' + id + '?')) return;

            btn.disabled = true;
            btn.textContent = 'Đang...';

            postAction(id, 'cancel').then(res => {
                if(res && res.success){
                    location.reload();
                } else {
                    btn.disabled = false;
                    btn.textContent = 'Hủy';
                    alert('Không thể hủy: ' + (res.message || 'Lỗi không xác định'));
                }
            }).catch(err => {
                btn.disabled = false;
                btn.textContent = 'Hủy';
                alert('Lỗi kết nối: ' + err.message);
            });
        });
    });

    // Hoàn thành đơn hàng (Đã giao)
    document.querySelectorAll('.btn-complete').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            if(!confirm('Xác nhận đơn hàng #' + id + ' đã giao thành công?')) return;

            btn.disabled = true;
            btn.textContent = 'Đang...';

            postAction(id, 'complete').then(res => {
                if(res && res.success){
                    location.reload();
                } else {
                    btn.disabled = false;
                    btn.textContent = 'Đã giao';
                    alert('Không thể cập nhật: ' + (res.message || 'Lỗi không xác định'));
                }
            }).catch(err => {
                btn.disabled = false;
                btn.textContent = 'Đã giao';
                alert('Lỗi kết nối: ' + err.message);
            });
        });
    });
})();
</script>
