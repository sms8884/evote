<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0 });
	});
	
	function withdrawal() {
		$("#form").attr("action", "/member/withdrawal-proc");
		$("#form").attr("method", "POST");
		$("#form").submit();
	}
	
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>회원정보</span>
		<span>내 정보 조회</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<div class="lnb">
			<h2 class="lnbTit">회원정보</h2>
			<ul class="">
				<li><a href="/member/info">내 정보 조회</a></li>
			</ul>
		</div>
		
		<div class="contentsWrap">
			<h3 class="contentTit">내 정보 조회</h3>

			<div class="contents paddingnone">

				<form id="form">
				<div class="step3">
					<p class="tit">탈퇴안내</p>
					
					<p>불라불라 불라불라</p>
					
					<input type="checkbox"/> 안내사항을 불라불라....
					
					<button onclick="withdrawal(); return false;">탈퇴</button>
					<button onclick="memberInfo(); return false;">취소</button>
					
				</div>
				</form>		
				
			</div>
		</div>
		
	</div>
</div>

<jsp:include page="/WEB-INF/views/front/member/join-terms.jsp"/>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
