<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="vi_VN"/>

<h3 class="admin-title">Thống kê doanh số</h3>

<div class="admin-card p-3">
  <p class="small text-muted">Dữ liệu: theo ngày, 30 ngày gần nhất.</p>

  <table class="table table-striped">
    <thead>
      <tr>
        <th>Ngày</th>
        <th>Số đơn</th>
        <th>Doanh thu</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="s" items="${stats}">
        <tr>
          <td>${s.date}</td>
          <td>${s.orderCount}</td>
          <td><fmt:formatNumber value="${s.totalAmount}" type="currency"/></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
