<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="admin-title">Sửa sách</h3>

<div class="admin-card">
    <form class="admin-form row g-3" method="post" enctype="multipart/form-data">
        <jsp:include page="/WEB-INF/views/_csrf.jsp" />

        <input type="hidden" name="id" value="${book.id}" />

        <div class="col-md-6">
            <label class="form-label">Tên sách</label>
            <input class="form-control" name="title" required value="${book.title}">
        </div>

        <div class="col-md-6">
            <label class="form-label">Tác giả</label>
            <input class="form-control" name="author" required value="${book.author}">
        </div>

        <div class="col-md-6">
            <label class="form-label">Danh mục</label>
            <select name="categoryId" class="form-select" required>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" ${cat.categoryId == book.categoryId ? 'selected' : ''}>${cat.name}</option>
                </c:forEach>
            </select>
        </div>



        <div class="col-md-4">
            <label class="form-label">Giá</label>
            <input class="form-control" type="number" name="price" required value="${book.price}">
        </div>

        <div class="col-md-4">
            <label class="form-label">Số lượng</label>
            <input class="form-control" type="number" name="stock" required value="${book.stock}">
        </div>

        <div class="col-md-4">
            <label class="form-label">Ảnh bìa (không bắt buộc)</label>
            <input class="form-control" type="file" name="cover">
        </div>
        <label>Mô tả</label>
        <textarea name="description" class="form-control">${book.description}</textarea>


        <div class="col-12">
            <button class="btn btn-primary">Cập nhật</button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/books">Hủy</a>
        </div>
    </form>
</div>
