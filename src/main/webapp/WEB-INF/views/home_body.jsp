<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ===== HERO BANNER - Vinabook Style ===== -->
<div class="hero-banner">
    <div class="container">
        <h1 class="hero-title">📚 BOOKSTORE ONLINE</h1>
        <p class="hero-text">
            Khám phá hàng ngàn đầu sách chất lượng - Giao hàng nhanh - Giá tốt nhất thị trường!
        </p>
        <a class="btn btn-lg" style="background: white; color: var(--brand); font-weight: 700;"
           href="${pageContext.request.contextPath}/books">
            Khám phá ngay →
        </a>
    </div>
</div>

<!-- ===== CATEGORIES ===== -->
<div class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Danh mục sách</h2>
        </div>
        
        <div class="category-grid">
            <a href="${pageContext.request.contextPath}/books?category=van-hoc" class="category-card">
                <div class="category-icon">📖</div>
                <div class="category-name">Văn học</div>
            </a>
            <a href="${pageContext.request.contextPath}/books?category=kinh-te" class="category-card">
                <div class="category-icon">💼</div>
                <div class="category-name">Kinh tế</div>
            </a>
            <a href="${pageContext.request.contextPath}/books?category=tam-ly-ky-nang-song" class="category-card">
                <div class="category-icon">🧠</div>
                <div class="category-name">Tâm lý - Kỹ năng</div>
            </a>
            <a href="${pageContext.request.contextPath}/books?category=thieu-nhi" class="category-card">
                <div class="category-icon">👶</div>
                <div class="category-name">Thiếu nhi</div>
            </a>
            <a href="${pageContext.request.contextPath}/books?category=khoa-hoc-cong-nghe" class="category-card">
                <div class="category-icon">🔬</div>
                <div class="category-name">Khoa học - Công nghệ</div>
            </a>
            <a href="${pageContext.request.contextPath}/books" class="category-card">
                <div class="category-icon">📚</div>
                <div class="category-name">Tất cả sách</div>
            </a>
        </div>
    </div>
</div>

<!-- ===== BOOK LIST ===== -->
<div class="section" style="background: var(--bg-light); margin: 0 -100vw; padding-left: 100vw; padding-right: 100vw;">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Sách mới nhất</h2>
        </div>

        <div class="grid grid--4">
            <c:forEach var="b" items="${books}">
                <div class="card">
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
                        <p class="card-text text-muted">${b.author}</p>
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

        <!-- ===== VIEW ALL BUTTON ===== -->
        <div class="text-center" style="margin-top: 60px;">
            <a href="${pageContext.request.contextPath}/books" class="btn btn-lg btn-primary" style="padding: 15px 50px; font-size: 18px;">
                Xem tất cả sách →
            </a>
        </div>
    </div>
</div>

