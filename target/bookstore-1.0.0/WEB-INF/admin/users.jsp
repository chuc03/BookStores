<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h3 class="admin-title">Quản lý Users</h3>

<!-- Thông báo -->
<c:if test="${param.success == 'status_updated'}">
    <div class="alert alert-success">Cập nhật trạng thái thành công!</div>
</c:if>
<c:if test="${param.success == 'user_deleted'}">
    <div class="alert alert-success">Xóa user thành công!</div>
</c:if>
<c:if test="${param.error != null}">
    <div class="alert alert-danger">
        <c:choose>
            <c:when test="${param.error == 'cannot_modify_self'}">Không thể thao tác trên tài khoản của chính mình!</c:when>
            <c:when test="${param.error == 'delete_failed'}">Không thể xóa user này (có thể là admin hoặc có dữ liệu liên quan)</c:when>
            <c:when test="${param.error == 'update_failed'}">Cập nhật thất bại!</c:when>
            <c:otherwise>Có lỗi xảy ra: ${param.error}</c:otherwise>
        </c:choose>
    </div>
</c:if>

<div class="admin-card">
    <!-- Thống kê -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h3 class="text-primary">${users.size()}</h3>
                    <p class="text-muted mb-0">Tổng số users</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h3 class="text-success">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach var="u" items="${users}">
                            <c:if test="${u.active}">
                                <c:set var="activeCount" value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </h3>
                    <p class="text-muted mb-0">Users đang hoạt động</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <h3 class="text-warning">
                        <c:set var="adminCount" value="0"/>
                        <c:forEach var="u" items="${users}">
                            <c:if test="${u.admin}">
                                <c:set var="adminCount" value="${adminCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${adminCount}
                    </h3>
                    <p class="text-muted mb-0">Admins</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Tìm kiếm -->
    <form action="${pageContext.request.contextPath}/admin/users" method="get" class="mb-3">
        <div class="input-group">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo email, tên, username..." value="${keyword}">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            <c:if test="${keyword != null}">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">Xóa bộ lọc</a>
            </c:if>
        </div>
    </form>

    <!-- Bảng users -->
    <div class="table-responsive">
        <table class="table admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Họ tên</th>
                    <th>Điện thoại</th>
                    <th>Role</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.username}</td>
                        <td>${u.email}</td>
                        <td>${u.fullName}</td>
                        <td>${u.phone}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.admin}">
                                    <span class="badge bg-warning text-dark">ADMIN</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">USER</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="badge bg-success">Hoạt động</span>
                        </td>
                        <td>
                            <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td class="table-actions">
                            <c:if test="${u.id != sessionScope.me.id && !u.admin}">
                                <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <input type="hidden" name="action" value="delete">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Xóa user này? Thao tác không thể hoàn tác!')">
                                        Xóa
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr>
                        <td colspan="9" style="text-align: center; padding: 40px; color: #6c757d;">
                            Không tìm thấy user nào
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
