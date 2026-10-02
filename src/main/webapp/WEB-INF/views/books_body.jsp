<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">
                <c:choose>
                    <c:when test="${not empty param.q}">
                        Kết quả tìm kiếm: "${param.q}"
                    </c:when>
                    <c:when test="${not empty param.category}">
                        Danh mục: ${param.category}
                    </c:when>
                    <c:otherwise>
                        Tất cả sách
                    </c:otherwise>
                </c:choose>
            </h2>
        </div>

        <c:if test="${empty books}">
            <div class="alert alert-warning">
                ⚠️ Không tìm thấy sách phù hợp. Vui lòng thử lại với từ khóa khác.
            </div>
        </c:if>

        <div class="grid grid--4 mb-5">
            <c:forEach var="b" items="${books}">
                <div class="card" style="position: relative;">
                    <!-- Wishlist Button -->
                    <c:if test="${sessionScope.me != null}">
                        <form action="${pageContext.request.contextPath}/wishlist" method="post" class="wishlist-btn-card">
                            <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="bookId" value="${b.id}">
                            <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/books${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}">
                            <button type="submit" class="wishlist-icon-btn" title="Thêm vào yêu thích">
                                <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
                                </svg>
                            </button>
                        </form>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/book?id=${b.id}">
                        <c:choose>
                            <c:when test="${not empty b.coverUrl}">
                                <img src="${b.coverUrl}" class="card-img-top" alt="${b.title}">
                            </c:when>
                            <c:otherwise>
                                <div class="card-img-top" style="background: var(--bg-gray); display: flex; align-items: center; justify-content: center; color: var(--text-muted);">
                                    <span style="font-size: 3rem;">📕</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <div class="card-body">
                        <h6 class="card-title">
                            <a href="${pageContext.request.contextPath}/book?id=${b.id}">${b.title}</a>
                        </h6>
                        <p class="card-text">${b.author}</p>
                    </div>
                    <div class="card-footer">
                        <div class="card-price">
                            <fmt:formatNumber value="${b.finalPrice}" type="number" pattern="#,###"/>₫
                        </div>
                        <a class="btn btn-sm btn-primary"
                           href="${pageContext.request.contextPath}/book?id=${b.id}">
                            Xem
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Phân trang">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/books?q=${param.q}&category=${param.category}&page=${currentPage-1}">
                            ← Trước
                        </a>
                    </li>
                    
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/books?q=${param.q}&category=${param.category}&page=${i}">
                                    ${i}
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${i == 2 && currentPage > 4}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                        <c:if test="${i == totalPages - 1 && currentPage < totalPages - 3}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/books?q=${param.q}&category=${param.category}&page=${currentPage+1}">
                            Sau →
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<style>
.pagination {
    display: flex;
    gap: var(--space-2);
}

.page-item .page-link {
    border: 1px solid var(--border);
    color: var(--text);
    padding: var(--space-2) var(--space-4);
    border-radius: var(--radius-sm);
    transition: var(--transition-fast);
}

.page-item .page-link:hover {
    background: var(--bg-gray);
    border-color: var(--brand);
    color: var(--brand);
}

.page-item.active .page-link {
    background: var(--brand);
    color: white;
    border-color: var(--brand);
}

.page-item.disabled .page-link {
    opacity: 0.5;
    pointer-events: none;
}
</style>

