<%@ page contentType="text/html; charset=utf-8" %>
	
	<div class="topMenu">
	
		<c:if test="${not empty sessionScope._accountInfo and (userType eq 'EMAIL' or userType eq 'CMIT')}">
			<p class="user">
				<span class="img">
					<img src="${siteImgPath}/common/userImg.png" alt="" class="userImg"/>
					<img src="${siteImgPath}/common/userBg.png" alt="" class="userBg"/>
				</span>
				<span class="name">
					<a href="/member/info"><strong>${sessionScope._accountInfo.nickname}</strong></a>
					<a href="#">${sessionScope._accountInfo.email.decValue}</a>
				</span>
			</p>
		</c:if>
		
		<ul class="">
			<li><a href="/proposal/intro" class="topM1"><span>주민참여예산제</span></a></li>
			<li><a href="/cmit/part" class="topM2"><span>주민참여위원회</span></a></li>
			<li><a href="/board/notice/list" class="topM3"><span>주민알림</span></a></li>
		</ul>
		<a href="/proposal/write" class="topMbt1 bookBg"><span>내 정책 제안하기</span></a>

		<c:choose>
			<c:when test="${empty sessionScope._accountInfo}">
				<a href="/login" class="topMbt2">로그인</a>
			</c:when>
			<c:otherwise>
				<a href="/logout" class="topMbt2">로그아웃</a>
				<a href="/member/info" class="topMbt3">설정</a>
			</c:otherwise>
		</c:choose>
		
	</div>