<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="admin-title">Quản lý sách</h3>

<div class="admin-card">
    <form class="admin-form row g-3" method="post" enctype="multipart/form-data">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
        <div class="col-md-6">
            <label class="form-label">Tên sách</label>
            <input class="form-control" name="title" required>
        </div>

        <div class="col-md-6">
            <label class="form-label">Tác giả</label>
            <input class="form-control" name="author" required>
        </div>

        <div class="col-md-6">
            <label class="form-label">Danh mục</label>
            <select class="form-select" name="categoryId" required>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}">${cat.name}</option>
                </c:forEach>
            </select>
        </div>


        <div class="col-md-4">
            <label class="form-label">Giá</label>
            <input class="form-control" type="number" name="price" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Số lượng</label>
            <input class="form-control" type="number" name="stock" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Ảnh bìa</label>
            <input class="form-control" type="file" name="cover">
        </div>
        <label>Mô tả</label>
        <textarea name="description" class="form-control">${book.description}</textarea>


        <div class="col-12">
            <button class="btn btn-success">Thêm sách</button>
        </div>
    </form>

    <c:if test="${not empty books}">
        <hr/>

        <div class="d-flex mb-3 gap-2">
            <input id="booksSearch" class="form-control" placeholder="Tìm sách theo tiêu đề/tác giả...">
            <select id="booksPerPage" class="form-select" style="width:120px;">
                <option value="5">5 / trang</option>
                <option value="10" selected>10 / trang</option>
                <option value="25">25 / trang</option>
            </select>
        </div>

        <div class="table-responsive">
            <table id="booksTable" class="table admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Tác giả</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${books}">
                        <tr>
                            <td>${b.id}</td>
                            <td>${b.title}</td>
                            <td>${b.author}</td>
                            <td>${b.finalPrice}</td>
                            <td>${b.stock}</td>
                            <td class="table-actions">
                                <a class="btn btn-sm btn-outline-primary me-1"
                                   href="${pageContext.request.contextPath}/admin/book/edit?id=${b.id}">
                                    Sửa
                                </a>
                                <button data-id="${b.id}" class="btn btn-sm btn-danger btn-delete">Xóa</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <nav>
            <ul class="pagination justify-content-center">
                <c:if test="${totalPages > 1}">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/admin/books?page=${currentPage-1}&pageSize=${pageSize}">
                            Trước
                        </a>
                    </li>

                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/books?page=${p}&pageSize=${pageSize}">
                                ${p}
                            </a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/admin/books?page=${currentPage+1}&pageSize=${pageSize}">
                            Sau
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>
</div>

<script>
    (function () {
        const delButtons = document.querySelectorAll('.btn-delete');
        if (!delButtons)
            return;

        delButtons.forEach(b => b.addEventListener('click', () => {
                const id = b.getAttribute('data-id');
                if (!confirm('Xác nhận xóa sách #' + id + '?'))
                    return;

                b.disabled = true;
                b.textContent = 'Đang...';

                fetchWithCsrf('${pageContext.request.contextPath}/admin/book/delete', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({id: id})
                })
                        .then(r => r.json())
                        .then(res => {
                            if (res && res.success) {
                                const row = b.closest('tr');
                                if (row)
                                    row.remove();
                            } else {
                                b.disabled = false;
                                b.textContent = 'Xóa';
                                alert('Không thể xóa.');
                            }
                        })
                        .catch(e => {
                            b.disabled = false;
                            b.textContent = 'Xóa';
                            alert('Lỗi: ' + e);
                        });
            }));
    })();
</script>
