<%@ page contentType="text/html; charset=utf-8" %>

<div class="ad_headerWrap">
	<div class="ad_header">
		<div class="logoBox">
			<h1>
				<a href="#">
					<img src="${siteImgPath}/common/w-logo.png" alt="은평구로고"/>
					<span class="logoTxt">은평구 참여예산 정책제안</span>
					<span class="logoTxt2">관리자</span>
				</a>
			</h1>
		</div>

		<div class="userInfoBox">
			<c:if test="${not empty sessionScope._adminInfo}">
			<ul class="userInfoUl">			
				<li class="userInfoLi1"><a href="#">${sessionScope._adminInfo.mgrNm.decValue}님</a></li>
				<li class="userInfoLi2"><a href="/admin/logout">로그아웃</a></li>
			</ul>
			</c:if>
		</div>
		
	</div>
</div>