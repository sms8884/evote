<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ page import="java.io.*" %>
<%@ page isErrorPage="true" %>
<c:choose>
	<c:when test="${__adminSiteYn eq 'Y'}">
		<jsp:include page="/WEB-INF/views/admin/error/404.jsp"/>
	</c:when>
	<c:when test="${currentDevice.normal}">
		<jsp:include page="/WEB-INF/views/front/error/404.jsp"/>
	</c:when>
	<c:when test="${currentDevice.mobile}">
		<jsp:include page="/WEB-INF/views/mobile/error/404.jsp"/>
	</c:when>
	<c:when test="${currentDevice.tablet}">
		<jsp:include page="/WEB-INF/views/mobile/error/404.jsp"/>
	</c:when>
	<c:otherwise>
		<jsp:include page="/WEB-INF/views/front/error/404.jsp"/>
	</c:otherwise>
</c:choose>