<%@ page contentType="text/html; charset=utf-8" %>
<c:choose>

	<c:when test="${param.menuName eq 'vote'}">
		<div class="lnb">
			<h2 class="lnbTit">투표</h2>
			<ul class="">
				<li><a href="/vote/vote-main">투표</a></li>
			</ul>
		</div>
	</c:when>
	
	<c:otherwise>
		
		<c:set var="tmpMenuId">
			<c:choose>
				<c:when test="${param.menuName eq 'proposal'}">1</c:when>
				<c:when test="${param.menuName eq 'cmit'}">2</c:when>
				<c:when test="${param.menuName eq 'notice'}">3</c:when>
			</c:choose>
		</c:set>
		
		<c:if test="${not empty gnbList}">
			
			<c:set var="beforeLevel" value="0"/>
			
			<c:forEach items="${gnbList}" var="list" varStatus="status">
				
				<c:if test="${fn:startsWith(list.siblingValue, tmpMenuId)}">
					
					<c:if test="${list.level eq 1}">
						<div class="lnb">
							<h2 class="lnbTit"><c:out value="${list.menuNm}"/></h2>
							<ul class="">
					</c:if>
					
					<c:if test="${list.level eq 2}">
						<c:if test="${beforeLevel eq 2}">
							</li>
						</c:if>
						<c:if test="${beforeLevel eq 3}">
								</ul>
							</li>
						</c:if>
						<li><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a>
					</c:if>
					
					<c:if test="${list.level eq 3}">
						<c:if test="${beforeLevel eq 2}">
							<ul class="lnbSub">
						</c:if>
						<li><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a></li>
					</c:if>
					
					<c:set var="beforeLevel" value="${list.level}"/>
						
				</c:if>
				
				<c:if test="${status.last}">
							</li>
						</ul>
					</div>
				</c:if>
	
			</c:forEach>
			
		</c:if>
	
	</c:otherwise>
	
</c:choose>