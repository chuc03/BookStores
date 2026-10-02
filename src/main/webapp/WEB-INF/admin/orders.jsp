<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Quản lý đơn hàng");
  request.setAttribute("body", "/WEB-INF/admin/orders_body.jsp");
%>
<jsp:include page="/WEB-INF/views/_layout.jsp" />
