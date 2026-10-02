<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="search-page">
    <div class="container">
        <div class="search-header">
            <h1 class="search-title">
                <c:choose>
                    <c:when test="${not empty query}">
                        🔍 Kết quả tìm kiếm cho "<strong>${query}</strong>"
                    </c:when>
                    <c:otherwise>
                        📚 Tìm kiếm sách
                    </c:otherwise>
                </c:choose>
            </h1>
            <p class="search-count">Tìm thấy <strong>${totalBooks}</strong> sản phẩm</p>
        </div>

        <div class="search-layout">
            <!-- Sidebar Filters -->
            <aside class="search-sidebar">
                <div class="filter-card">
                    <h3 class="filter-title">🎯 Bộ lọc</h3>

                    <form method="get" action="${pageContext.request.contextPath}/search" id="filterForm">
                        <input type="hidden" name="q" value="${query}">
                        
                        <!-- Category Filter -->
                        <div class="filter-group">
                            <h4 class="filter-label">Danh mục</h4>
                            <div class="filter-options">
                                <label class="filter-option">
                                    <input type="radio" name="category" value="" ${empty selectedCategory ? 'checked' : ''}>
                                    <span>Tất cả</span>
                                </label>
                                <c:forEach var="cat" items="${categories}">
                                    <label class="filter-option">
                                        <input type="radio" name="category" value="${cat.slug}" 
                                               ${selectedCategory == cat.slug ? 'checked' : ''}>
                                        <span>${cat.name}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Price Filter -->
                        <div class="filter-group">
                            <h4 class="filter-label">Giá</h4>
                            <div class="price-inputs">
                                <div>
                                    <label class="price-label">Từ</label>
                                    <input type="number" name="minPrice" placeholder="0" 
                                           value="${minPrice != null ? minPrice.intValue() : ''}" class="price-input" step="1000">
                                </div>
                                <div>
                                    <label class="price-label">Đến</label>
                                    <input type="number" name="maxPrice" placeholder="0" 
                                           value="${maxPrice != null ? maxPrice.intValue() : ''}" class="price-input" step="1000">
                                </div>
                            </div>
                            <div class="price-suggestions">
                                <button type="button" class="price-tag" onclick="setPrice(0, 50000)">Dưới 50K</button>
                                <button type="button" class="price-tag" onclick="setPrice(50000, 100000)">50K - 100K</button>
                                <button type="button" class="price-tag" onclick="setPrice(100000, 200000)">100K - 200K</button>
                                <button type="button" class="price-tag" onclick="setPrice(200000, '')">Trên 200K</button>
                            </div>
                        </div>

                        <!-- Sort -->
                        <div class="filter-group">
                            <h4 class="filter-label">Sắp xếp</h4>
                            <select name="sort" class="filter-select">
                                <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                <option value="price-asc" ${sortBy == 'price-asc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
                                <option value="price-desc" ${sortBy == 'price-desc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
                                <option value="name-asc" ${sortBy == 'name-asc' ? 'selected' : ''}>Tên: A → Z</option>
                            </select>
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn-filter-apply">Áp dụng</button>
                            <button type="button" class="btn-filter-reset" onclick="resetFilters()">Xóa lọc</button>
                        </div>
                    </form>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="search-content">
                <c:if test="${empty books}">
                    <div class="empty-state">
                        <svg width="120" height="120" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                        </svg>
                        <h3>Không tìm thấy sản phẩm</h3>
                        <p>Hãy thử tìm kiếm với từ khóa khác hoặc điều chỉnh bộ lọc</p>
                    </div>
                </c:if>

                <c:if test="${not empty books}">
                    <div class="books-grid">
                        <c:forEach var="book" items="${books}">
                            <div class="book-card" style="position: relative;">
                                <!-- Wishlist Button -->
                                <c:if test="${sessionScope.me != null}">
                                    <form action="${pageContext.request.contextPath}/wishlist" method="post" class="wishlist-btn-card">
                                        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="bookId" value="${book.id}">
                                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/search${not empty pageContext.request.queryString ? '?' : ''}${pageContext.request.queryString}">
                                        <button type="submit" class="wishlist-icon-btn" title="Thêm vào yêu thích">
                                            <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                                                <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
                                            </svg>
                                        </button>
                                    </form>
                                </c:if>

                                <a href="${pageContext.request.contextPath}/book?id=${book.id}" class="book-image-link">
                                    <c:choose>
                                        <c:when test="${not empty book.coverUrl}">
                                            <img src="${book.coverUrl}" alt="${book.title}" class="book-image">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="book-image-placeholder">📕</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${book.discountPercent > 0}">
                                        <span class="book-discount">-${book.discountPercent}%</span>
                                    </c:if>
                                </a>
                                <div class="book-info">
                                    <h3 class="book-title">
                                        <a href="${pageContext.request.contextPath}/book?id=${book.id}">${book.title}</a>
                                    </h3>
                                    <p class="book-author">${book.author}</p>
                                    <div class="book-footer">
                                        <div class="book-price">
                                            <c:if test="${book.discountPercent > 0}">
                                                <span class="price-original"><fmt:formatNumber value="${book.price}" type="number" pattern="#,###"/>₫</span>
                                            </c:if>
                                            <span class="price-final"><fmt:formatNumber value="${book.finalPrice}" type="number" pattern="#,###"/>₫</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/book?id=${book.id}" class="btn-view">Xem</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="pagination-nav">
                            <ul class="pagination">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?q=${query}&category=${selectedCategory}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sortBy}&page=${currentPage-1}">
                                        ← Trước
                                    </a>
                                </li>
                                
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?q=${query}&category=${selectedCategory}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sortBy}&page=${i}">
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
                                    <a class="page-link" href="?q=${query}&category=${selectedCategory}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sortBy}&page=${currentPage+1}">
                                        Sau →
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:if>
            </main>
        </div>
    </div>
</div>

<style>
.search-page { padding: 32px 0; background: #f8f9fa; min-height: 70vh; }
.search-header { margin-bottom: 32px; }
.search-title { font-size: 1.75rem; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
.search-title strong { color: #dc3545; }
.search-count { color: #64748b; font-size: 0.95rem; }

.search-layout { display: grid; grid-template-columns: 280px 1fr; gap: 32px; }

/* Sidebar */
.search-sidebar { position: sticky; top: 100px; height: fit-content; }
.filter-card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
.filter-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 20px; color: #1e293b; }

.filter-group { margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #e2e8f0; }
.filter-group:last-of-type { border-bottom: none; }
.filter-label { font-size: 0.95rem; font-weight: 600; margin-bottom: 12px; color: #334155; }

.filter-options { display: flex; flex-direction: column; gap: 8px; }
.filter-option { display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 8px; border-radius: 6px; transition: background 0.2s; }
.filter-option:hover { background: #f8f9fa; }
.filter-option input[type="radio"] { margin: 0; }
.filter-option span { font-size: 0.9rem; color: #475569; }

.price-inputs { display: flex; flex-direction: column; gap: 12px; margin-bottom: 12px; }
.price-label { display: block; font-size: 0.85rem; font-weight: 600; color: #64748b; margin-bottom: 6px; }
.price-input { width: 100%; padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 0.9rem; box-sizing: border-box; }
.price-suggestions { display: flex; flex-wrap: wrap; gap: 6px; }
.price-tag { padding: 6px 12px; background: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 0.8rem; cursor: pointer; transition: all 0.2s; }
.price-tag:hover { background: #dc3545; color: white; border-color: #dc3545; }

.filter-select { width: 100%; padding: 10px 12px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 0.9rem; }

.filter-actions { display: flex; gap: 8px; margin-top: 20px; }
.btn-filter-apply { flex: 1; padding: 10px; background: #dc3545; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; }
.btn-filter-apply:hover { background: #c72333; }
.btn-filter-reset { flex: 1; padding: 10px; background: white; color: #475569; border: 1px solid #e2e8f0; border-radius: 6px; font-weight: 600; cursor: pointer; }
.btn-filter-reset:hover { background: #f8f9fa; }

/* Books Grid */
.books-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 24px; }
.book-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: all 0.3s; }
.book-card:hover { transform: translateY(-4px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }

.book-image-link { position: relative; display: block; aspect-ratio: 3/4; overflow: hidden; }
.book-image { width: 100%; height: 100%; object-fit: cover; }
.book-image-placeholder { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: #f8f9fa; font-size: 4rem; }
.book-discount { position: absolute; top: 8px; right: 8px; background: #dc3545; color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; }

.book-info { padding: 16px; }
.book-title { font-size: 0.95rem; font-weight: 600; margin-bottom: 6px; line-height: 1.4; }
.book-title a { color: #1e293b; text-decoration: none; }
.book-title a:hover { color: #dc3545; }
.book-author { font-size: 0.85rem; color: #64748b; margin-bottom: 12px; }

.book-footer { display: flex; align-items: center; justify-content: space-between; }
.book-price { display: flex; flex-direction: column; }
.price-original { font-size: 0.8rem; color: #94a3b8; text-decoration: line-through; }
.price-final { font-size: 1.1rem; font-weight: 700; color: #dc3545; }
.btn-view { padding: 6px 16px; background: #dc3545; color: white; border-radius: 6px; font-size: 0.85rem; font-weight: 600; text-decoration: none; transition: background 0.2s; }
.btn-view:hover { background: #c72333; }

/* Empty State */
.empty-state { text-align: center; padding: 80px 20px; }
.empty-state svg { color: #cbd5e1; margin-bottom: 16px; }
.empty-state h3 { font-size: 1.25rem; color: #475569; margin-bottom: 8px; }
.empty-state p { color: #94a3b8; }

/* Pagination */
.pagination-nav { margin-top: 40px; }
.pagination { display: flex; justify-content: center; gap: 8px; list-style: none; padding: 0; margin: 0; }
.page-link { padding: 8px 14px; background: white; border: 1px solid #e2e8f0; border-radius: 6px; color: #475569; text-decoration: none; font-size: 0.9rem; transition: all 0.2s; }
.page-link:hover { background: #f8f9fa; border-color: #dc3545; color: #dc3545; }
.page-item.active .page-link { background: #dc3545; color: white; border-color: #dc3545; }
.page-item.disabled .page-link { opacity: 0.5; cursor: not-allowed; pointer-events: none; }

@media (max-width: 992px) {
    .search-layout { grid-template-columns: 1fr; }
    .search-sidebar { position: static; }
}
</style>

<script>
function setPrice(min, max) {
    document.querySelector('input[name="minPrice"]').value = min || '';

    document.querySelector('input[name="maxPrice"]').value = max || '';
}

function resetFilters() {
    const form = document.getElementById('filterForm');
    form.reset();
    form.submit();
}

// Auto-submit on filter change
document.querySelectorAll('input[name="category"]').forEach(radio => {
    radio.addEventListener('change', () => {
        document.getElementById('filterForm').submit();
    });
});

document.querySelector('select[name="sort"]').addEventListener('change', () => {
    document.getElementById('filterForm').submit();
});
</script>
