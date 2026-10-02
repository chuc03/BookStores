<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .wishlist-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 20px;
    }
    .wishlist-header {
        background: linear-gradient(135deg, #dc3545, #ff6b35);
        border-radius: 16px;
        padding: 40px;
        margin-bottom: 30px;
        color: white;
        box-shadow: 0 8px 24px rgba(220,53,69,0.15);
    }
    .wishlist-header h1 {
        margin: 0 0 10px 0;
        font-size: 2rem;
        font-weight: 700;
    }
    .wishlist-header p {
        margin: 0;
        opacity: 0.95;
    }
    .alert {
        padding: 12px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    .wishlist-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 24px;
        margin-bottom: 40px;
    }
    .wishlist-item {
        background: white;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        transition: all 0.3s;
        position: relative;
    }
    .wishlist-item:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }
    .book-image {
        width: 100%;
        height: 350px;
        object-fit: cover;
        background: #f8f9fa;
    }
    .book-image-placeholder {
        width: 100%;
        height: 350px;
        background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #6c757d;
    }
    .book-info {
        padding: 20px;
    }
    .book-title {
        font-size: 16px;
        font-weight: 700;
        color: #212529;
        margin-bottom: 8px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .book-author {
        font-size: 14px;
        color: #6c757d;
        margin-bottom: 12px;
    }
    .book-price {
        display: flex;
        align-items: baseline;
        gap: 8px;
        margin-bottom: 12px;
    }
    .final-price {
        font-size: 20px;
        font-weight: 700;
        color: #dc3545;
    }
    .original-price {
        font-size: 14px;
        color: #6c757d;
        text-decoration: line-through;
    }
    .discount-badge {
        background: #dc3545;
        color: white;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
    }
    .book-rating {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        color: #6c757d;
        margin-bottom: 12px;
    }
    .book-actions {
        display: flex;
        gap: 8px;
    }
    .btn {
        flex: 1;
        padding: 10px;
        border: none;
        border-radius: 6px;
        font-weight: 600;
        cursor: pointer;
        text-align: center;
        text-decoration: none;
        transition: all 0.3s;
        font-size: 14px;
    }
    .btn-primary {
        background: linear-gradient(135deg, #dc3545, #c82333);
        color: white;
    }
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
    }
    .btn-secondary {
        background: #6c757d;
        color: white;
    }
    .btn-secondary:hover {
        background: #5a6268;
    }
    .empty-wishlist {
        text-align: center;
        padding: 80px 20px;
        background: white;
        border-radius: 16px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .empty-wishlist svg {
        width: 100px;
        height: 100px;
        color: #dee2e6;
        margin-bottom: 20px;
    }
    .empty-wishlist h3 {
        font-size: 24px;
        color: #495057;
        margin-bottom: 12px;
    }
    .empty-wishlist p {
        color: #6c757d;
        margin-bottom: 24px;
    }
    .empty-wishlist a {
        display: inline-block;
        padding: 12px 30px;
        background: linear-gradient(135deg, #dc3545, #c82333);
        color: white;
        text-decoration: none;
        border-radius: 6px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .empty-wishlist a:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
    }
</style>

<div class="wishlist-container">
    <div class="wishlist-header">
        <h1>❤️ Danh sách yêu thích</h1>
        <p>Quản lý các cuốn sách bạn yêu thích</p>
    </div>

    <c:if test="${param.success == 'added'}">
        <div class="alert alert-success">Đã thêm vào danh sách yêu thích!</div>
    </c:if>
    <c:if test="${param.success == 'removed'}">
        <div class="alert alert-success">Đã xóa khỏi danh sách yêu thích!</div>
    </c:if>
    <c:if test="${param.error != null}">
        <div class="alert alert-error">
            Có lỗi xảy ra: ${param.error}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty wishlistBooks}">
            <div class="empty-wishlist">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                    <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
                </svg>
                <h3>Danh sách yêu thích trống</h3>
                <p>Bạn chưa thêm sách nào vào danh sách yêu thích</p>
                <a href="${pageContext.request.contextPath}/books">
                    Khám phá sách ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="wishlist-grid">
                <c:forEach var="book" items="${wishlistBooks}">
                    <div class="wishlist-item">
                        <a href="${pageContext.request.contextPath}/book?id=${book.id}">
                            <c:choose>
                                <c:when test="${not empty book.coverUrl}">
                                    <img src="${book.coverUrl}" alt="${book.title}" class="book-image">
                                </c:when>
                                <c:otherwise>
                                    <div class="book-image-placeholder">
                                        <svg width="60" height="60" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
                                        </svg>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <div class="book-info">
                            <h3 class="book-title">
                                <a href="${pageContext.request.contextPath}/book?id=${book.id}" style="color: inherit; text-decoration: none;">
                                    ${book.title}
                                </a>
                            </h3>
                            <div class="book-author">${book.author}</div>
                            
                            <c:if test="${book.reviewCount > 0}">
                                <div class="book-rating">
                                    <span>${book.starsDisplay}</span>
                                    <span>(${book.reviewCount})</span>
                                </div>
                            </c:if>

                            <div class="book-price">
                                <span class="final-price">
                                    <fmt:formatNumber value="${book.finalPrice}" type="number" groupingUsed="true"/>₫
                                </span>
                                <c:if test="${book.discountPercent > 0}">
                                    <span class="original-price">
                                        <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/>₫
                                    </span>
                                    <span class="discount-badge">-${book.discountPercent}%</span>
                                </c:if>
                            </div>

                            <div class="book-actions">
                                <form action="${pageContext.request.contextPath}/add-to-cart" method="post" style="flex: 1;">
                                    <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                    <input type="hidden" name="bookId" value="${book.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/wishlist">
                                    <button type="submit" class="btn btn-primary">
                                        🛒 Thêm vào giỏ
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/wishlist" method="post">
                                    <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                    <input type="hidden" name="bookId" value="${book.id}">
                                    <input type="hidden" name="action" value="remove">
                                    <button type="submit" class="btn btn-secondary" onclick="return confirm('Xóa sách này khỏi danh sách yêu thích?')">
                                        🗑️
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
