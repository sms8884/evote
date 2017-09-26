<%@ page contentType="text/html; charset=utf-8" %>

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<c:if test="${not empty breadcrumbList}">
			<c:forEach items="${breadcrumbList}" var="list">
				<span><c:out value="${list.menuNm}"/></span>
			</c:forEach>
		</c:if>
	</p>
</div>