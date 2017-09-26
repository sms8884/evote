<%-- 삭제 [2016-09-29]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 0, d2: 0, d3: 0 });
	});
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="/"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>회원가입</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<div class="lnb">
			<h2 class="lnbTit">회원가입</h2>
			<ul class="">
				<li><a href="/member/join-phone">휴대폰번호로 가입</a></li>
				<li><a href="/member/join-email">이메일로 가입</a></li>
			</ul>
		</div>
		
		<div class="contentsWrap">
			<h3 class="contentTit">회원가입</h3>

			<div class="contents paddingnone">
				<p class="memberTxt">
					휴대폰번호로 가입한 경우 로그인 시 휴대폰인증이 필요합니다.<br/><a href="/member/join-email">이메일로 회원가입 </a>시 추가적인 인증없이<br/>로그인을 통해 참여예산 정책제안을 사용할 수 있습니다.
				</p>
				<ul class="memberSel">
					<li>
						<strong class="pb">휴대폰번호로 가입</strong>
						<a href="/member/join-phone">가입하기</a>
					</li>
					<li>
						<strong class="eb">이메일로 가입</strong>
						<a href="/member/join-email">가입하기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
 --%>