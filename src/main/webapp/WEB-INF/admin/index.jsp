<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div style="margin-bottom: 32px;">
  <h3 style="margin: 0 0 8px; font-size: 1.75rem; font-weight: 700; color: #1e293b;">Thống kê doanh thu</h3>
  <p style="margin: 0; color: #64748b; font-size: 0.95rem;">Báo cáo chi tiết về doanh thu và đơn hàng của hệ thống</p>
</div>

<!-- Revenue Stats Cards -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 32px;">
  
  <!-- Doanh thu hôm nay -->
  <div style="background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
      <div>
        <div style="font-size: 0.875rem; color: #64748b; margin-bottom: 8px; font-weight: 500;">Doanh thu hôm nay</div>
        <div style="font-size: 2rem; font-weight: 700; color: #1e293b; line-height: 1;">${todayRevenue}</div>
        <div style="font-size: 0.75rem; color: #10b981; margin-top: 4px; font-weight: 500;">+${todayOrders} đơn hàng</div>
      </div>
      <div style="width: 56px; height: 56px; border-radius: 50%; background: #dcfce7; display: flex; align-items: center; justify-content: center;">
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="#10b981" viewBox="0 0 16 16">
          <path d="M4 10.781c.148 1.667 1.513 2.85 3.591 3.003V15h1.043v-1.216c2.27-.179 3.678-1.438 3.678-3.3 0-1.59-.947-2.51-2.956-3.028l-.722-.187V3.467c1.122.11 1.879.714 2.07 1.616h1.47c-.166-1.6-1.54-2.748-3.54-2.875V1H7.591v1.233c-1.939.23-3.27 1.472-3.27 3.156 0 1.454.966 2.483 2.661 2.917l.61.162v4.031c-1.149-.17-1.94-.8-2.131-1.718H4zm3.391-3.836c-1.043-.263-1.6-.825-1.6-1.616 0-.944.704-1.641 1.8-1.828v3.495l-.2-.05zm1.591 1.872c1.287.323 1.852.859 1.852 1.769 0 1.097-.826 1.828-2.2 1.939V8.73l.348.086z"/>
        </svg>
      </div>
    </div>
  </div>
  
  <!-- Doanh thu tháng này -->
  <div style="background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
      <div>
        <div style="font-size: 0.875rem; color: #64748b; margin-bottom: 8px; font-weight: 500;">Doanh thu tháng này</div>
        <div style="font-size: 2rem; font-weight: 700; color: #1e293b; line-height: 1;">${monthRevenue}</div>
        <div style="font-size: 0.75rem; color: #10b981; margin-top: 4px; font-weight: 500;">30 ngày gần đây</div>
      </div>
      <div style="width: 56px; height: 56px; border-radius: 50%; background: #dbeafe; display: flex; align-items: center; justify-content: center;">
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="#3b82f6" viewBox="0 0 16 16">
          <path fill-rule="evenodd" d="M1 11.5a.5.5 0 0 0 .5.5h11.793l-3.147 3.146a.5.5 0 0 0 .708.708l4-4a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 11H1.5a.5.5 0 0 0-.5.5zm14-7a.5.5 0 0 1-.5.5H2.707l3.147 3.146a.5.5 0 1 1-.708.708l-4-4a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 4H14.5a.5.5 0 0 1 .5.5z"/>
        </svg>
      </div>
    </div>
  </div>
  
  <!-- Đơn hàng hôm nay -->
  <div style="background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
      <div>
        <div style="font-size: 0.875rem; color: #64748b; margin-bottom: 8px; font-weight: 500;">Đơn hàng hôm nay</div>
        <div style="font-size: 2rem; font-weight: 700; color: #1e293b; line-height: 1;">${todayOrders}</div>
        <div style="font-size: 0.75rem; color: #64748b; margin-top: 4px; font-weight: 500;">Tổng số sách: ${totalBooks}</div>
      </div>
      <div style="width: 56px; height: 56px; border-radius: 50%; background: #fed7aa; display: flex; align-items: center; justify-content: center;">
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="#f97316" viewBox="0 0 16 16">
          <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l1.313 7h8.17l1.313-7H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
        </svg>
      </div>
    </div>
  </div>
  
  <!-- Giá trị trung bình -->
  <div style="background: white; border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border: 1px solid #e5e7eb;">
    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
      <div>
        <div style="font-size: 0.875rem; color: #64748b; margin-bottom: 8px; font-weight: 500;">Giá trị TB/đơn</div>
        <div style="font-size: 2rem; font-weight: 700; color: #1e293b; line-height: 1;">${avgOrderValue}</div>
        <div style="font-size: 0.75rem; color: #64748b; margin-top: 4px; font-weight: 500;">Danh mục: ${totalCategories}</div>
      </div>
      <div style="width: 56px; height: 56px; border-radius: 50%; background: #e9d5ff; display: flex; align-items: center; justify-content: center;">
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="#a855f7" viewBox="0 0 16 16">
          <path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1H1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
          <path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V5zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2H3z"/>
        </svg>
      </div>
    </div>
  </div>
  
</div>

<!-- Charts Section -->
<div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 32px;">
  
  <!-- Revenue Chart -->
  <div class="admin-card">
    <h4 style="margin: 0 0 20px; font-size: 1.25rem; font-weight: 600; color: #1e293b;">Biểu đồ doanh thu 7 ngày gần đây</h4>
    <div style="height: 300px; display: flex; align-items: flex-end; justify-content: space-around; gap: 12px; padding: 20px 0;">
      <c:forEach var="day" items="${chartData}">
        <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
          <c:set var="maxHeight" value="270" />
          <c:set var="barHeight" value="${day.revenue > 0 ? (day.revenue / 60000000.0 * maxHeight) : 10}" />
          <c:choose>
            <c:when test="${day.isToday}">
              <div style="background: linear-gradient(180deg, #10b981, #059669); width: 100%; height: ${barHeight}px; min-height: 10px; border-radius: 8px 8px 0 0; position: relative;">
                <div style="position: absolute; top: -25px; left: 50%; transform: translateX(-50%); font-size: 0.875rem; font-weight: 600; color: #10b981; white-space: nowrap;">
                  <fmt:formatNumber value="${day.revenue / 1000000.0}" pattern="#.#" />M
                </div>
              </div>
              <div style="margin-top: 8px; font-size: 0.875rem; color: #10b981; font-weight: 600;">${day.dayName}</div>
            </c:when>
            <c:otherwise>
              <div style="background: linear-gradient(180deg, #3b82f6, #2563eb); width: 100%; height: ${barHeight}px; min-height: 10px; border-radius: 8px 8px 0 0; position: relative;">
                <div style="position: absolute; top: -25px; left: 50%; transform: translateX(-50%); font-size: 0.875rem; font-weight: 600; color: #1e293b; white-space: nowrap;">
                  <fmt:formatNumber value="${day.revenue / 1000000.0}" pattern="#.#" />M
                </div>
              </div>
              <div style="margin-top: 8px; font-size: 0.875rem; color: #64748b; font-weight: 500;">${day.dayName}</div>
            </c:otherwise>
          </c:choose>
        </div>
      </c:forEach>
    </div>
  </div>
  
  <!-- Top Products -->
  <div class="admin-card">
    <h4 style="margin: 0 0 20px; font-size: 1.25rem; font-weight: 600; color: #1e293b;">Sách bán chạy</h4>
    <div style="display: flex; flex-direction: column; gap: 16px;">
      <c:choose>
        <c:when test="${not empty bestSellingBooks}">
          <c:forEach var="book" items="${bestSellingBooks}" varStatus="status">
            <c:set var="rank" value="${status.index + 1}" />
            <c:choose>
              <c:when test="${rank == 1}">
                <c:set var="bgColor" value="linear-gradient(135deg, #3b82f6, #2563eb)" />
              </c:when>
              <c:when test="${rank == 2}">
                <c:set var="bgColor" value="linear-gradient(135deg, #10b981, #059669)" />
              </c:when>
              <c:when test="${rank == 3}">
                <c:set var="bgColor" value="linear-gradient(135deg, #f59e0b, #d97706)" />
              </c:when>
              <c:otherwise>
                <c:set var="bgColor" value="#e5e7eb" />
              </c:otherwise>
            </c:choose>
            
            <div style="display: flex; align-items: center; gap: 12px; padding-bottom: 12px; ${rank < 4 ? 'border-bottom: 1px solid #f1f5f9;' : ''}">
              <div style="width: 40px; height: 40px; background: ${bgColor}; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: ${rank <= 3 ? 'white' : '#64748b'}; font-weight: 700; font-size: 1.125rem;">${rank}</div>
              <div style="flex: 1;">
                <div style="font-size: 0.875rem; font-weight: 600; color: #1e293b; margin-bottom: 2px;">${book.title}</div>
                <div style="font-size: 0.75rem; color: #64748b;">${book.totalSold} bán</div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div style="text-align: center; color: #64748b; padding: 40px;">
            Chưa có dữ liệu bán hàng
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
  
</div>

<!-- Revenue Table -->
<div class="admin-card">
  <h4 style="margin: 0 0 20px; font-size: 1.25rem; font-weight: 600; color: #1e293b;">Chi tiết đơn hàng gần đây</h4>
  <div class="table-responsive">
    <table class="table">
      <thead>
        <tr>
          <th>Mã đơn</th>
          <th>Tên khách hàng</th>
          <th>Thanh toán</th>
          <th>Tổng tiền</th>
          <th>Trạng thái</th>
          <th>Ngày tạo</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="order" items="${recentOrders}">
          <tr>
            <td style="font-weight: 600;">#${order.orderId}</td>
            <td>${order.customerName}</td>
            <td>
              <c:choose>
                <c:when test="${order.paymentMethod == 'COD'}">Tiền mặt</c:when>
                <c:otherwise>Chuyển khoản</c:otherwise>
              </c:choose>
            </td>
            <td style="font-weight: 700; color: #3b82f6;">
              <fmt:formatNumber value="${order.totalAmount}" type="number" pattern="#,###" /> đ
            </td>
            <td>
              <c:choose>
                <c:when test="${order.orderStatus == 'NEW'}">
                  <span style="background: #dbeafe; color: #1e40af; padding: 4px 12px; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">Mới</span>
                </c:when>
                <c:when test="${order.orderStatus == 'CONFIRMED'}">
                  <span style="background: #dcfce7; color: #166534; padding: 4px 12px; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">Đã xác nhận</span>
                </c:when>
                <c:when test="${order.orderStatus == 'SHIPPING'}">
                  <span style="background: #fed7aa; color: #9a3412; padding: 4px 12px; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">Đang giao</span>
                </c:when>
                <c:when test="${order.orderStatus == 'DELIVERED'}">
                  <span style="background: #dcfce7; color: #166534; padding: 4px 12px; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">Đã giao</span>
                </c:when>
                <c:otherwise>
                  <span style="background: #fee2e2; color: #991b1b; padding: 4px 12px; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">Đã hủy</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty recentOrders}">
          <tr>
            <td colspan="6" style="text-align: center; color: #64748b; padding: 40px;">Chưa có đơn hàng nào</td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>

