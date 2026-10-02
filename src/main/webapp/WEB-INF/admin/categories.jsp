<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="admin-title">Danh mục</h3>

<div class="admin-card">

    <!-- Form thêm / sửa danh mục -->
    <form class="admin-form mb-3" method="post" action="${pageContext.request.contextPath}/admin/categories">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
        <label class="form-label">Tên danh mục</label>
        <div class="d-flex gap-2">
            <input type="hidden" name="id" value="${editCategory.categoryId}" />
            <input class="form-control" name="name" required value="${editCategory.name}">
            <button class="btn btn-primary btn-admin">
                <c:choose>
                    <c:when test="${not empty editCategory}">Cập nhật</c:when>
                    <c:otherwise>Thêm</c:otherwise>
                </c:choose>
            </button>
        </div>
    </form>

    <!-- Bộ lọc -->
    <div class="d-flex mb-3 gap-2">
        <form class="d-flex" method="get" action="${pageContext.request.contextPath}/admin/categories">
            <input name="q" class="form-control me-2" placeholder="Tìm danh mục..." value="${param.q}" />
            <select name="pageSize" class="form-select me-2" style="width:120px;">
                <option value="5"  ${pageSize == 5  ? 'selected' : ''}>5 / trang</option>
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 / trang</option>
                <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 / trang</option>
            </select>
            <button class="btn btn-outline-primary" type="submit">Áp dụng</button>
        </form>
    </div>

    <!-- Bảng danh mục -->
    <table class="table admin-table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Số lượng</th> <!-- đã sửa -->
            <th>Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="c" items="${categories}">
            <tr>
                <td>${c.categoryId}</td>
                <td>${c.name}</td>
                <td>${c.bookCount}</td> <!-- giữ nguyên dữ liệu -->
                <td>
                    <a class="btn btn-sm btn-outline-primary me-1"
                       href="${pageContext.request.contextPath}/admin/categories?editId=${c.categoryId}">
                       Sửa
                    </a>
                    <button data-id="${c.categoryId}" class="btn btn-sm btn-danger btn-delete">Xóa</button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>


    <!-- Phân trang -->
    <nav>
        <ul class="pagination justify-content-center">
            <c:if test="${totalPages > 1}">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/categories?page=${currentPage-1}&pageSize=${pageSize}">
                       Trước
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/admin/categories?page=${p}&pageSize=${pageSize}">
                           ${p}
                        </a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/categories?page=${currentPage+1}&pageSize=${pageSize}">
                       Sau
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>

</div>

<script>
// AJAX delete handler for categories
(function(){
    const delButtons = document.querySelectorAll('.btn-delete');
    if(!delButtons) return;
    delButtons.forEach(b => b.addEventListener('click', () => {
        const id = b.getAttribute('data-id');
        if(!confirm('Xác nhận xóa danh mục #' + id + '?')) return;
        b.disabled = true; b.textContent = 'Đang...';
        fetchWithCsrf('${pageContext.request.contextPath}/admin/category/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ id: id })
        }).then(r => r.json()).then(res => {
            if(res && res.success){
                const row = b.closest('tr'); if(row) row.remove();
            } else {
                b.disabled = false; b.textContent = 'Xóa';
                alert('Không thể xóa.');
            }
        }).catch(e => {
            b.disabled = false; b.textContent = 'Xóa';
            alert('Lỗi: ' + e);
        });
    }));
})();
</script>
