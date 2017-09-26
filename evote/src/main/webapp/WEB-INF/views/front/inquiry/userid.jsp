<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		$('.gnb').topmenu({ d1: 0, d2: 2, d3: 0 });
		
		$.phoneAuth({
			authRequestUrl:'/inquiry/userid-req',
			authCheckUrl:'/inquiry/userid-auth-check',
			appendData:[
				{'appendFieldId':'userNm','validationMsg':'이름을 입력해주세요'}
			],
			callbackEvent:function(data) {
        		$('#layer_userid').text(data.email.decValue);
        		$('#div_idinquiry1').hide();
        		$('#div_idinquiry2').show();
			}
		});
		
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
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>아이디/비밀번호 찾기</span>
	</p>
</div>
 
<div id="container" class="container">
	<div class="containerWrap">
		<div class="lnb">
			<h2 class="lnbTit">로그인</h2>
			<ul class="">
				<li><a href="/login">로그인</a></li>
				<li><a href="/inquiry/userid">아이디/비밀번호 찾기</a></li>
			</ul>
		</div>
		
		<div class="contentsWrap">
			<h3 class="contentTit">아이디/비밀번호 찾기</h3>

			<div class="contents paddingnone">
				<ul class="loginTab">
					<li><a id="login1" href="/inquiry/userid" class="on">아이디 찾기</a></li>
					<li><a id="login2" href="/inquiry/userpw">비밀번호 찾기</a></li>
				</ul>

				<div class="memberlogin2" id="div_idinquiry1">
					
					<form id="phoneLoginForm" method="post" action="">
						<input type="hidden" id="phone-key" name="phoneKey"/>
						<fieldset id="" class="">
							<p><span><input type="text" class="it" id="userNm" name="userNm" placeholder="이름을 입력하세요" tabindex="1"/></span></p>
							<p><span><input type="text" class="it" id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span><a id="btn_request" href="#" class="pn">인증번호 요청</a></p>
							<p id="tmp-phone-code" style="display:none;"><span><input type="text" class="it" id="phone-code" name="phoneAuthCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span><a id="btn_auth" href="#" class="an">인증 확인</a></p>
							<span class="time" id="limit_time_txt" style="display:none;"></span>
						</fieldset>
					</form>
					
				</div>

				<div class="step3" id="div_idinquiry2" style="display: none;">
					<p class="tit" style="margin: 50px 0 -30px 0">회원님의 아이디를 확인해주세요.</p>
					<div class="loginMbtLayerCon">
						<p id="layer_userid" class="txt2"></p>
					</div>
				</div>
				
				<p class="loginMbt">

				</p>

			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
