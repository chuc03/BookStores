<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    request.setAttribute("pageTitle", "Đăng nhập");
    request.setAttribute("body", "/WEB-INF/views/login_body.jsp");
%>

<jsp:include page="/WEB-INF/views/_layout.jsp"/>
