<%@ page contentType="text/html; charset=utf-8" %>

<div id="header">
	<div class="top">
		<h1 class="logo"><a href="/index"><spring:message code="default.front.title" /></a></h1>
		<p class="user">
		
		<c:choose>
			<c:when test="${empty sessionScope._accountInfo}">
				<a href="/login">로그인</a>
				<a href="/member/join">회원가입</a>
			</c:when>
			<c:when test="${_accountInfo.hasRole('USER')}">
				<a href="/member/info"><c:out value="${_accountInfo.nickname}"/>님</a>
				<a href="/logout">로그아웃</a>
			</c:when>
<%-- 
			<c:when test="${userType eq 'PHONE'}">
				<a href="/member/info">내정보</a>
				<a href="/logout">로그아웃</a>
			</c:when>
--%>			
			<c:when test="${userType eq 'PROPOSAL'}">
				<a href="/logout">방문객 로그아웃</a>	
			</c:when>
			<c:when test="${userType eq 'QNA'}">
				<a href="/logout">방문객 로그아웃</a>	
			</c:when>
			<c:when test="${userType eq 'VOTE'}">
				<a href="/logout">방문객 로그아웃</a>	
			</c:when>
		</c:choose>
		
		</p>
	</div>
	
	<c:choose>
		<c:when test="${not empty gnbList}">
			<ul class="gnb">
				<c:forEach items="${gnbList}" var="list" varStatus="status">
		
					<c:if test="${status.first}">
						<li class="gnb${list.dpOrd}"><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a>
							<ul class="gnbSub">
					</c:if>
						
					<c:if test="${list.level eq 1 and status.index gt 0}">
							</ul>
						</li>
						<li class="gnb${list.dpOrd}"><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a>
							<ul class="gnbSub">
					</c:if>
					
					<c:if test="${list.level eq 2}">
						<li><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a></li>
					</c:if>
		
					<c:if test="${status.last}">
							</ul>
						</li>
					</c:if>
					
				</c:forEach>
			</ul>
		</c:when>
		<c:otherwise>
			<ul class="gnb">
				<li class="gnb1"><a href="/proposal/intro">주민참여 예산제</a>
					<ul class="gnbSub">
						<li><a href="/proposal/intro">소개</a></li>
						<li><a href="/proposal/plan">운영계획</a></li>
						<li><a href="/proposal/guide">정책제안</a></li>
						<li><a href="/biz/biz_list">사업현황</a></li>
					</ul>
				</li>
				<li class="gnb2"><a href="#">주민참여 위원회</a>
					<ul class="gnbSub">
						<li><a href="/cmit/part">위원회 역할</a></li>
						<li><a href="/board/cmit/list">위원회 활동</a></li>
						<li><a href="/cmit/cmit_contest_req">위원 공모</a></li>
					</ul>
				</li>
				<li class="gnb3"><a href="/notice/list">주민 알림</a>
					<ul class="gnbSub">
						<li><a href="/board/notice/list">공지사항</a></li>
						<li><a href="/board/gallery/list">갤러리</a></li>
						<li><a href="/board/data/list">자료실</a></li>
						<li><a href="/board/qna/list">문의하기</a></li>
					</ul>
				</li>
			</ul>
		</c:otherwise>
	</c:choose>
	<p class="gnbSubBg"></p>
</div>