<%@ page session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% 
	pageContext.setAttribute("entermark","\n");
	pageContext.setAttribute("cr", "\r"); //Space
	pageContext.setAttribute("cn", "\n"); //Enter
	pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
	pageContext.setAttribute("br", "<br/>"); 
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="resourcePath" value="/resources" />

<c:choose>
	<c:when test="${__adminSiteYn eq 'Y'}">
		<c:set var="sitePath"><spring:message code="default.admin.resource.path" /></c:set>
	</c:when>
	<c:when test="${currentDevice.normal}">
		<c:set var="sitePath"><spring:message code="default.front.resource.path" /></c:set>
	</c:when>
	<c:when test="${currentDevice.mobile}">
		<c:set var="sitePath"><spring:message code="default.mobile.resource.path" /></c:set>
	</c:when>
	<c:when test="${currentDevice.tablet}">
		<c:set var="sitePath"><spring:message code="default.mobile.resource.path" /></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="sitePath"><spring:message code="default.front.resource.path" /></c:set>
	</c:otherwise>
</c:choose>

<c:set var="commonCssPath" value="${resourcePath}/css" />
<c:set var="commonImgPath" value="${resourcePath}/img" />
<c:set var="commonJsPath" value="${resourcePath}/js" />
<c:set var="ckeditorPath" value="${resourcePath}/ckeditor" />

<c:set var="siteCssPath" value="${resourcePath}/${sitePath}/css" />
<c:set var="siteImgPath" value="${resourcePath}/${sitePath}/img" />
<c:set var="siteJsPath" value="${resourcePath}/${sitePath}/js" />