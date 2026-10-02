<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Success/Error Messages -->
<c:if test="${param.success == 'added_to_wishlist'}">
    <div class="alert alert-success" style="margin: 20px auto; max-width: 1200px;">
        ✅ Đã thêm vào danh sách yêu thích!
    </div>
</c:if>
<c:if test="${param.success == 'removed_from_wishlist'}">
    <div class="alert alert-success" style="margin: 20px auto; max-width: 1200px;">
        ✅ Đã xóa khỏi danh sách yêu thích!
    </div>
</c:if>

<!-- Breadcrumb -->
<nav class="book-detail-breadcrumb">
    <div class="container">
        <a href="${pageContext.request.contextPath}/" class="breadcrumb-link">
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/>
            </svg>
            Trang chủ
        </a>
        <span class="breadcrumb-separator">›</span>
        <a href="${pageContext.request.contextPath}/books" class="breadcrumb-link">Sách</a>
        <span class="breadcrumb-separator">›</span>
        <span class="breadcrumb-current">${book.title}</span>
    </div>
</nav>

<!-- Main Content -->
<div class="book-detail-container">
    <div class="container">
        <div class="book-detail-wrapper">
            <!-- Image Section -->
            <div class="book-detail-image-section">
                <div class="book-image-wrapper">
                    <c:choose>
                        <c:when test="${not empty book.coverUrl}">
                            <img src="${book.coverUrl}" alt="${book.title}" class="book-main-image">
                        </c:when>
                        <c:otherwise>
                            <div class="book-image-placeholder">
                                <svg width="120" height="120" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
                                </svg>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Info Section -->
            <div class="book-detail-info-section">
                <h1 class="book-detail-title">${book.title}</h1>
                
                <div class="book-detail-meta">
                    <div class="book-meta-item">
                        <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                            <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
                        </svg>
                        <span class="book-meta-label">Tác giả:</span>
                        <span class="book-meta-value">${book.author}</span>
                    </div>
                </div>

                <!-- Price Card -->
                <div class="book-price-card">
                    <div class="price-section">
                        <div class="price-label">Giá bán</div>
                        <div class="price-main">
                            <fmt:formatNumber value="${book.finalPrice}" type="number" pattern="#,###"/>₫
                        </div>
                        <c:if test="${book.discountPercent > 0}">
                            <div class="price-discount-info">
                                <span class="discount-badge">-${book.discountPercent}%</span>
                                <span class="price-original">
                                    <fmt:formatNumber value="${book.price}" type="number" pattern="#,###"/>₫
                                </span>
                            </div>
                        </c:if>
                    </div>

                    <div class="stock-section">
                        <c:choose>
                            <c:when test="${book.stock > 0}">
                                <div class="stock-badge stock-available">
                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                        <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                                    </svg>
                                    Còn hàng (${book.stock} cuốn)
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="stock-badge stock-out">
                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                        <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                    </svg>
                                    Tạm hết hàng
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Quantity & Add to Cart -->
                    <c:if test="${book.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="add-to-cart-form">
                            <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                            <input type="hidden" name="id" value="${book.id}">
                            
                            <div class="quantity-selector">
                                <label class="quantity-label">Số lượng</label>
                                <div class="quantity-input-group">
                                    <button type="button" class="quantity-btn" onclick="decreaseQuantity()">
                                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M4 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 4 8z"/>
                                        </svg>
                                    </button>
                                    <input type="number" name="quantity" value="1" min="1" max="${book.stock}" class="quantity-input" id="quantityInput" data-max="${book.stock}">
                                    <button type="button" class="quantity-btn" onclick="increaseQuantity()">
                                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="btn-add-to-cart">
                                <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                                    <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l1.313 7h8.17l1.313-7H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                                </svg>
                                Thêm vào giỏ hàng
                            </button>
                        </form>

                        <!-- Add to Wishlist Button -->
                        <c:if test="${sessionScope.me != null}">
                            <c:choose>
                                <c:when test="${isInWishlist}">
                                    <form action="${pageContext.request.contextPath}/wishlist" method="post" style="margin-top: 12px;">
                                        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="bookId" value="${book.id}">
                                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/book?id=${book.id}">
                                        <button type="submit" class="btn-in-wishlist">
                                            <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
                                            </svg>
                                            Đã thêm vào yêu thích
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/wishlist" method="post" style="margin-top: 12px;">
                                        <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="bookId" value="${book.id}">
                                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/book?id=${book.id}">
                                        <button type="submit" class="btn-add-to-wishlist">
                                            <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                                <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
                                            </svg>
                                            Thêm vào yêu thích
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:if>
                </div>

                <!-- Features -->
                <div class="book-features">
                    <div class="feature-item">
                        <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M0 3.5A1.5 1.5 0 0 1 1.5 2h9A1.5 1.5 0 0 1 12 3.5V5h1.02a1.5 1.5 0 0 1 1.17.563l1.481 1.85a1.5 1.5 0 0 1 .329.938V10.5a1.5 1.5 0 0 1-1.5 1.5H14a2 2 0 1 1-4 0H5a2 2 0 1 1-3.998-.085A1.5 1.5 0 0 1 0 10.5v-7zm1.294 7.456A1.999 1.999 0 0 1 4.732 11h5.536a2.01 2.01 0 0 1 .732-.732V3.5a.5.5 0 0 0-.5-.5h-9a.5.5 0 0 0-.5.5v7a.5.5 0 0 0 .294.456zM12 10a2 2 0 0 1 1.732 1h.768a.5.5 0 0 0 .5-.5V8.35a.5.5 0 0 0-.11-.312l-1.48-1.85A.5.5 0 0 0 13.02 6H12v4zm-9 1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm9 0a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
                        </svg>
                        <div class="feature-text">
                            <div class="feature-title">Giao hàng nhanh</div>
                            <div class="feature-desc">Toàn quốc 2-5 ngày</div>
                        </div>
                    </div>
                    <div class="feature-item">
                        <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M1.5 1a.5.5 0 0 0-.5.5v3a.5.5 0 0 1-1 0v-3A1.5 1.5 0 0 1 1.5 0h3a.5.5 0 0 1 0 1h-3zM11 .5a.5.5 0 0 1 .5-.5h3A1.5 1.5 0 0 1 16 1.5v3a.5.5 0 0 1-1 0v-3a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 1-.5-.5zM.5 11a.5.5 0 0 1 .5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 1 0 1h-3A1.5 1.5 0 0 1 0 14.5v-3a.5.5 0 0 1 .5-.5zm15 0a.5.5 0 0 1 .5.5v3a1.5 1.5 0 0 1-1.5 1.5h-3a.5.5 0 0 1 0-1h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 1 .5-.5z"/>
                            <path d="M3 4.5a.5.5 0 0 1 1 0v7a.5.5 0 0 1-1 0v-7zm2 0a.5.5 0 0 1 1 0v7a.5.5 0 0 1-1 0v-7zm2 0a.5.5 0 0 1 1 0v7a.5.5 0 0 1-1 0v-7zm2 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-7zm3 0a.5.5 0 0 1 1 0v7a.5.5 0 0 1-1 0v-7z"/>
                        </svg>
                        <div class="feature-text">
                            <div class="feature-title">Thanh toán COD</div>
                            <div class="feature-desc">Nhận hàng rồi thanh toán</div>
                        </div>
                    </div>
                    <div class="feature-item">
                        <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"/>
                            <path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"/>
                        </svg>
                        <div class="feature-text">
                            <div class="feature-title">Đổi trả miễn phí</div>
                            <div class="feature-desc">Trong vòng 7 ngày</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Description Section -->
        <c:if test="${not empty book.description}">
            <div class="book-description-section">
                <h2 class="description-title">
                    <svg width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                        <path d="M3 4h10v1H3V4zm0 3h10v1H3V7zm0 3h10v1H3v-1z"/>
                    </svg>
                    Mô tả sản phẩm
                </h2>
                <div class="description-content">
                    ${book.description}
                </div>
            </div>
        </c:if>

        <!-- Reviews Section -->
        <div class="reviews-section">
            <div class="reviews-header">
                <h2 class="reviews-title">
                    ⭐ Đánh giá từ khách hàng
                </h2>
                <div class="reviews-stats">
                    <span><strong>${book.averageRating > 0 ? book.averageRating : 0}</strong>/5</span>
                    <span>•</span>
                    <span><strong>${book.reviewCount}</strong> đánh giá</span>
                </div>
            </div>

            <!-- Review Form (Only for logged in users who haven't reviewed yet) -->
            <c:if test="${sessionScope.me != null}">
                <c:choose>
                    <c:when test="${userReview != null}">
                        <div class="alert alert-success">
                            Bạn đã đánh giá sách này. Bạn có thể chỉnh sửa hoặc xóa đánh giá của mình bên dưới.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="review-form">
                            <h3>✍️ Viết đánh giá của bạn</h3>
                            
                            <c:if test="${param.success == 'review_added'}">
                                <div class="alert alert-success">Đánh giá của bạn đã được thêm!</div>
                            </c:if>
                            <c:if test="${param.error != null}">
                                <div class="alert alert-error">
                                    <c:choose>
                                        <c:when test="${param.error == 'missing_fields'}">Vui lòng điền đầy đủ thông tin</c:when>
                                        <c:when test="${param.error == 'invalid_rating'}">Rating không hợp lệ</c:when>
                                        <c:when test="${param.error == 'empty_fields'}">Vui lòng điền đầy đủ nội dung</c:when>
                                        <c:otherwise>Có lỗi xảy ra: ${param.error}</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/review" method="post">
                                <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                <input type="hidden" name="bookId" value="${book.id}">
                                
                                <div class="form-group">
                                    <label>Đánh giá của bạn <span style="color: red;">*</span></label>
                                    <div class="rating-input">
                                        <input type="radio" id="star5" name="rating" value="5" required>
                                        <label for="star5" title="5 sao - Tuyệt vời">⭐</label>
                                        <input type="radio" id="star4" name="rating" value="4">
                                        <label for="star4" title="4 sao - Rất tốt">⭐</label>
                                        <input type="radio" id="star3" name="rating" value="3">
                                        <label for="star3" title="3 sao - Bình thường">⭐</label>
                                        <input type="radio" id="star2" name="rating" value="2">
                                        <label for="star2" title="2 sao - Không tốt">⭐</label>
                                        <input type="radio" id="star1" name="rating" value="1">
                                        <label for="star1" title="1 sao - Tệ">⭐</label>
                                    </div>
                                    <div class="rating-text" id="ratingText"></div>
                                </div>

                                <div class="form-group">
                                    <label for="reviewTitle">Tiêu đề <span style="color: red;">*</span></label>
                                    <input type="text" id="reviewTitle" name="reviewTitle" 
                                           placeholder="Tóm tắt ngắn gọn về sách" required>
                                </div>

                                <div class="form-group">
                                    <label for="reviewText">Nội dung đánh giá <span style="color: red;">*</span></label>
                                    <textarea id="reviewText" name="reviewText" 
                                              placeholder="Chia sẻ cảm nhận của bạn về cuốn sách..." required></textarea>
                                </div>

                                <button type="submit" class="btn-submit-review">Gửi đánh giá</button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <c:if test="${sessionScope.me == null}">
                <div class="alert alert-error">
                    <a href="${pageContext.request.contextPath}/login" style="color: #721c24; text-decoration: underline;">Đăng nhập</a> 
                    để viết đánh giá cho sách này.
                </div>
            </c:if>

            <!-- Reviews List -->
            <c:if test="${param.success == 'review_updated'}">
                <div class="alert alert-success">Đánh giá của bạn đã được cập nhật!</div>
            </c:if>
            <c:if test="${param.success == 'review_deleted'}">
                <div class="alert alert-success">Đánh giá đã được xóa!</div>
            </c:if>

            <div class="reviews-list">
                <c:choose>
                    <c:when test="${empty reviews}">
                        <p style="text-align: center; color: #6c757d; padding: 40px 0;">
                            Chưa có đánh giá nào cho sách này. Hãy là người đầu tiên đánh giá!
                        </p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="review-user">
                                        <div class="review-avatar">
                                            ${review.userName.substring(0,1).toUpperCase()}
                                        </div>
                                        <div class="review-user-info">
                                            <h4>${review.userName}</h4>
                                            <div class="review-date">
                                                <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-rating">${review.starsDisplay}</div>
                                </div>
                                
                                <c:if test="${not empty review.reviewTitle}">
                                    <div class="review-title">${review.reviewTitle}</div>
                                </c:if>
                                
                                <div class="review-text">${review.reviewText}</div>

                                <c:if test="${sessionScope.me != null && sessionScope.me.id == review.userId}">
                                    <div class="review-actions">
                                        <form action="${pageContext.request.contextPath}/review" method="post" style="display: inline;">
                                            <jsp:include page="/WEB-INF/views/_csrf.jsp" />
                                            <input type="hidden" name="bookId" value="${book.id}">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="btn-delete-review" 
                                                    onclick="return confirm('Bạn có chắc muốn xóa đánh giá này?')">
                                                🗑️ Xóa đánh giá
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<style>
/* Breadcrumb */
.book-detail-breadcrumb {
    background: #f8f9fa;
    padding: 16px 0;
    margin-bottom: 32px;
    border-bottom: 1px solid #e9ecef;
}

.book-detail-breadcrumb .container {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
}

.breadcrumb-link {
    color: #6c757d;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 6px;
    transition: color 0.2s;
}

.breadcrumb-link:hover {
    color: #dc3545;
}

.breadcrumb-separator {
    color: #adb5bd;
    user-select: none;
}

.breadcrumb-current {
    color: #212529;
    font-weight: 500;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    max-width: 400px;
}

/* Main Container */
.book-detail-container {
    padding: 32px 0 64px;
}

.book-detail-wrapper {
    display: grid;
    grid-template-columns: 400px 1fr;
    gap: 48px;
    margin-bottom: 48px;
}

@media (max-width: 992px) {
    .book-detail-wrapper {
        grid-template-columns: 1fr;
        gap: 32px;
    }
}

/* Image Section */
.book-image-wrapper {
    position: sticky;
    top: 100px;
}

.book-main-image {
    width: 100%;
    height: auto;
    border-radius: 12px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.15);
    transition: transform 0.3s ease;
}

.book-main-image:hover {
    transform: scale(1.02);
}

.book-image-placeholder {
    width: 100%;
    aspect-ratio: 3/4;
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #adb5bd;
}

/* Info Section */
.book-detail-title {
    font-size: 32px;
    font-weight: 700;
    color: #212529;
    line-height: 1.3;
    margin-bottom: 16px;
}

.book-detail-meta {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-bottom: 24px;
    padding-bottom: 24px;
    border-bottom: 1px solid #e9ecef;
}

.book-meta-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 15px;
    color: #6c757d;
}

.book-meta-item svg {
    flex-shrink: 0;
}

.book-meta-label {
    font-weight: 400;
}

.book-meta-value {
    font-weight: 600;
    color: #212529;
}

/* Price Card */
.book-price-card {
    background: white;
    border: 2px solid #e9ecef;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.price-section {
    padding-bottom: 20px;
    border-bottom: 1px dashed #dee2e6;
    margin-bottom: 20px;
}

.price-label {
    font-size: 14px;
    color: #6c757d;
    margin-bottom: 8px;
}

.price-main {
    font-size: 36px;
    font-weight: 700;
    color: #dc3545;
    line-height: 1;
    margin-bottom: 12px;
}

.price-discount-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.discount-badge {
    background: #dc3545;
    color: white;
    padding: 4px 12px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 600;
}

.price-original {
    font-size: 18px;
    color: #adb5bd;
    text-decoration: line-through;
}

/* Stock Section */
.stock-section {
    margin-bottom: 20px;
}

.stock-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
}

.stock-available {
    background: #d4edda;
    color: #155724;
}

.stock-out {
    background: #f8d7da;
    color: #721c24;
}

/* Quantity Selector */
.quantity-selector {
    margin-bottom: 16px;
}

.quantity-label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #495057;
    margin-bottom: 8px;
}

.quantity-input-group {
    display: flex;
    align-items: center;
    gap: 0;
    border: 2px solid #dee2e6;
    border-radius: 8px;
    overflow: hidden;
    width: fit-content;
}

.quantity-btn {
    background: white;
    border: none;
    padding: 10px 16px;
    cursor: pointer;
    color: #495057;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.quantity-btn:hover {
    background: #f8f9fa;
    color: #dc3545;
}

.quantity-btn:active {
    background: #e9ecef;
}

.quantity-input {
    border: none;
    border-left: 1px solid #dee2e6;
    border-right: 1px solid #dee2e6;
    width: 80px;
    text-align: center;
    font-size: 16px;
    font-weight: 600;
    padding: 10px;
    color: #212529;
}

.quantity-input:focus {
    outline: none;
}

/* Add to Cart Button */
.btn-add-to-cart {
    width: 100%;
    background: #dc3545;
    color: white;
    border: none;
    padding: 16px 24px;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-add-to-cart:hover {
    background: #c82333;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
}

.btn-add-to-cart:active {
    transform: translateY(0);
}

/* Wishlist Buttons */
.btn-add-to-wishlist, .btn-in-wishlist {
    width: 100%;
    border: 2px solid #dc3545;
    background: white;
    color: #dc3545;
    padding: 14px 24px;
    border-radius: 8px;
    font-size: 15px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-add-to-wishlist:hover {
    background: #fff5f5;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.2);
}

.btn-in-wishlist {
    background: #dc3545;
    color: white;
}

.btn-in-wishlist:hover {
    background: #c82333;
    border-color: #c82333;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
}

/* Features */
.book-features {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
}

@media (max-width: 768px) {
    .book-features {
        grid-template-columns: 1fr;
    }
}

.feature-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 16px;
    background: #f8f9fa;
    border-radius: 8px;
    border: 1px solid #e9ecef;
}

.feature-item svg {
    color: #dc3545;
    flex-shrink: 0;
    margin-top: 2px;
}

.feature-text {
    flex: 1;
}

.feature-title {
    font-size: 14px;
    font-weight: 600;
    color: #212529;
    margin-bottom: 2px;
}

.feature-desc {
    font-size: 13px;
    color: #6c757d;
}

/* Description Section */
.book-description-section {
    background: white;
    border: 1px solid #e9ecef;
    border-radius: 12px;
    padding: 32px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.description-title {
    font-size: 24px;
    font-weight: 700;
    color: #212529;
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 2px solid #dc3545;
    display: flex;
    align-items: center;
    gap: 10px;
}

.description-title svg {
    color: #dc3545;
}

.description-content {
    font-size: 15px;
    line-height: 1.8;
    color: #495057;
    white-space: pre-wrap;
}

/* Reviews Section */
.reviews-section {
    background: white;
    border-radius: 12px;
    padding: 30px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    margin-top: 30px;
}

.reviews-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 2px solid #dc3545;
}

.reviews-title {
    font-size: 24px;
    font-weight: 700;
    color: #212529;
    display: flex;
    align-items: center;
    gap: 10px;
}

.reviews-stats {
    display: flex;
    align-items: center;
    gap: 15px;
    font-size: 14px;
    color: #6c757d;
}

.review-form {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 30px;
}

.review-form h3 {
    font-size: 18px;
    margin-bottom: 15px;
    color: #212529;
}

.form-group {
    margin-bottom: 15px;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: 600;
    color: #495057;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    box-sizing: border-box;
}

.form-group textarea {
    min-height: 100px;
    resize: vertical;
}

.rating-input {
    display: flex;
    gap: 5px;
    flex-direction: row-reverse;
    justify-content: flex-end;
}

.rating-input input[type="radio"] {
    display: none;
}

.rating-input label {
    font-size: 32px;
    cursor: pointer;
    color: #ddd;
    transition: all 0.2s ease;
    filter: grayscale(100%);
}

.rating-input label:hover {
    transform: scale(1.2);
    filter: grayscale(0%);
}

.rating-input input[type="radio"]:checked ~ label,
.rating-input label:hover,
.rating-input label:hover ~ label {
    color: #ffc107;
    filter: grayscale(0%);
}

.rating-text {
    margin-top: 8px;
    font-size: 14px;
    font-weight: 600;
    color: #ffc107;
    min-height: 20px;
}

.btn-submit-review {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: white;
    border: none;
    padding: 12px 30px;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-submit-review:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
}

.reviews-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.review-item {
    border: 1px solid #e9ecef;
    padding: 20px;
    border-radius: 8px;
    transition: all 0.3s;
}

.review-item:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.review-header {
    display: flex;
    justify-content: space-between;
    align-items: start;
    margin-bottom: 12px;
}

.review-user {
    display: flex;
    align-items: center;
    gap: 12px;
}

.review-avatar {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    background: linear-gradient(135deg, #dc3545, #ff6b35);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 18px;
}

.review-user-info h4 {
    margin: 0;
    font-size: 16px;
    color: #212529;
}

.review-date {
    font-size: 13px;
    color: #6c757d;
}

.review-rating {
    font-size: 18px;
}

.review-title {
    font-size: 16px;
    font-weight: 600;
    color: #212529;
    margin-bottom: 8px;
}

.review-text {
    font-size: 14px;
    line-height: 1.6;
    color: #495057;
}

.review-actions {
    margin-top: 12px;
    display: flex;
    gap: 10px;
}

.btn-delete-review {
    background: #dc3545;
    color: white;
    border: none;
    padding: 6px 15px;
    border-radius: 4px;
    font-size: 13px;
    cursor: pointer;
}

.alert {
    padding: 12px 20px;
    border-radius: 6px;
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
</style>

<script>
function increaseQuantity() {
    const input = document.getElementById('quantityInput');
    const max = parseInt(input.getAttribute('data-max')) || parseInt(input.max);
    const currentValue = parseInt(input.value) || 1;
    if (currentValue < max) {
        input.value = currentValue + 1;
    }
}

function decreaseQuantity() {
    const input = document.getElementById('quantityInput');
    const currentValue = parseInt(input.value) || 1;
    if (currentValue > 1) {
        input.value = currentValue - 1;
    }
}

// Prevent manual input of invalid values
document.addEventListener('DOMContentLoaded', function() {
    const quantityInput = document.getElementById('quantityInput');
    if (quantityInput) {
        quantityInput.addEventListener('change', function() {
            const max = parseInt(this.getAttribute('max'));
            const min = parseInt(this.getAttribute('min')) || 1;
            let value = parseInt(this.value) || min;
            
            if (value < min) value = min;
            if (value > max) value = max;
            
            this.value = value;
        });
    }

    // Rating stars interaction
    const ratingLabels = document.querySelectorAll('.rating-input label');
    const ratingText = document.getElementById('ratingText');
    const ratingTexts = {
        '5': '⭐⭐⭐⭐⭐ Tuyệt vời!',
        '4': '⭐⭐⭐⭐ Rất tốt',
        '3': '⭐⭐⭐ Bình thường',
        '2': '⭐⭐ Không tốt',
        '1': '⭐ Tệ'
    };

    ratingLabels.forEach(label => {
        label.addEventListener('mouseenter', function() {
            const value = this.getAttribute('for').replace('star', '');
            if (ratingText) {
                ratingText.textContent = ratingTexts[value] || '';
            }
        });

        label.addEventListener('click', function() {
            const value = this.getAttribute('for').replace('star', '');
            if (ratingText) {
                ratingText.textContent = ratingTexts[value] || '';
            }
        });
    });

    const ratingContainer = document.querySelector('.rating-input');
    if (ratingContainer) {
        ratingContainer.addEventListener('mouseleave', function() {
            const checkedInput = document.querySelector('.rating-input input[type="radio"]:checked');
            if (checkedInput && ratingText) {
                const value = checkedInput.value;
                ratingText.textContent = ratingTexts[value] || '';
            } else if (ratingText) {
                ratingText.textContent = '';
            }
        });
    }
});
</script>