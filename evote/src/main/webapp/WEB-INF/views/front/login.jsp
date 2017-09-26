<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0 });
		$('#userPw').on('keypress', function(e) {
			if (e.which == 13) {
				emailLogin();
			}
		});
	});

	function emailLogin() {
		var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		if( $("#email").val() == "" ) {
			// 이메일을 입력해주세요
			alert('<spring:message code="message.login.email.001"/>');
			$("#email").focus();
			return;
		} else {
	        if(!regEmail.test($("#email").val())) {
	        	// 잘못된 이메일 주소 입니다. 이메일 주소를 확인한 다음 다시 입력해 주세요.
	        	alert('<spring:message code="message.login.email.004"/>');
	            $("#email").val("");
	            $("#email").focus();
	            return false;
	        }
		}
		if( $("#userPw").val() == "" ) {
			// 비밀번호를 입력해주세요
			alert('<spring:message code="message.login.email.002"/>');
			$("#userPw").focus();
			return;
		}
		
		$("#emailLoginForm").attr("action", "/email-login-proc");
		$("#emailLoginForm").attr("method", "POST");
		$("#emailLoginForm").submit();
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
		<span>로그인</span>
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
			<h3 class="contentTit">로그인</h3>

			<div class="contents paddingnone">
<%--  			
				<ul class="loginTab">
					<li><a id="login1" href="javascript:loginType(1);" class="on">회원 로그인</a></li>
					<li><a id="login2" href="javascript:loginType(2);">휴대폰번호 로그인</a></li>
				</ul>
--%>
				<div class="memberlogin">
					<form id="emailLoginForm" method="post">
						<fieldset id="" class="">
							<p><input type="text" class="it id" id="email" name="email" placeholder="이메일 주소를 입력하세요" tabindex="1"/></p>
							<p><input type="password" class="it pw" id="userPw" name="userPw" placeholder="비밀번호를 입력하세요" tabindex="2"/></p>
							<a href="javascript:emailLogin();" class="loginBt" tabindex="2">로그인</a>
						</fieldset> 
					</form>
				</div>
<%-- 				
				<div class="memberlogin2" style="display:none;">
					<p style="font-size: 17px; color: red; margin: -40px 0 20px 0">'휴대폰번호'로 로그인하시기 위해서는 회원가입이 필요합니다.</p>
					<form id="phoneLoginForm" method="post" action="">
						<input type="hidden" id="phone-key" name="phoneKey"/>
						<fieldset id="" class="">
							<p><span><input type="text" class="it" id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span><a id="btn_request" href="javascript:reqPhoneAuth();" class="pn">인증번호 요청</a></p>
							<p id="tmp-phone-code" style="display:none;"><span><input type="text" class="it" id="phone-code" name="phoneAuthCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span><a href="javascript:checkPhoneAuth();" class="an">인증 확인</a></p>
							<span class="time" id="limit_time_txt" style="display:none;"></span>
							<a href="#" class="loginBt" style="display:none;">로그인</a>
						</fieldset> 
					</form>
				</div>
--%>
				<p class="loginMbt">
					<a href="/inquiry/userid" class="loginMbt1 layer" rel="loginMbtLayer">아이디 찾기</a>
					<a href="/inquiry/userpw" class="loginMbt2 layer" rel="loginMbtLayer">비밀번호 찾기</a>
					<a href="/member/join" class="loginMbt3">회원가입</a>
				</p>
<%-- 
				<div class="loginMbtLayer layer_block">
					<p class="tit">아이디/비밀번호 찾기</p>
					<div class="loginMbtLayerCon">
						<p class="txt1">아이디/비밀번호 찾기는 다음으로 문의해주세요</p>
						<p class="txt2">02-351-6475</p>
						<a href="#" class="bt layerClose2"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
				</div>
 --%>				
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
