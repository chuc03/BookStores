<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  // Ensure CSRF token exists in session
  if (session.getAttribute("csrfToken") == null) {
    session.setAttribute("csrfToken", vn.bookstore.util.CsrfUtil.generateToken());
  }
  String csrfToken = (String) session.getAttribute("csrfToken");
%>
<c:if test="${not empty sessionScope.csrfToken}">
  <meta name="csrf-token" content="${sessionScope.csrfToken}" />
  <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}" />
</c:if>
