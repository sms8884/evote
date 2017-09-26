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
		//$("#email").focus();
		
		$.phoneAuth({
			authRequestUrl:'/inquiry/userpw-req',
			authCheckUrl:'/inquiry/userpw-auth-check',
			appendData:[
				{'appendFieldId':'email','validationMsg':'이메일을 입력해주세요'}
			],
			callbackEvent:function(data) {
        		$("#div_pwinquiry1").hide();
        		$("#div_pwinquiry2").show();
			}
		});
		
	});
	
	function resetUserpw() {
		
		var phone = $("#phoneNumber").val();
		var email = $("#email").val();
		var code = $("#phone-code").val();
		var key = $("#phone-key").val();
		
		var pass1 = $("#pass1").val();
		var pass2 = $("#pass2").val();
		
		if (pass1 == "") {
			// 비밀번호를 입력해주세요
			alert('<spring:message code="message.member.join.009"/>');
			return false;
		} else if (pass1.length < 6) {
			// 6~16자의 비밀번호를 입력하세요
			alert('<spring:message code="message.member.join.010"/>');
			return false;
		} else if (pass1 != pass2) {
			// 비밀번호가 일치하지 않습니다
			alert('<spring:message code="message.member.join.011"/>');
			return false;
		}
		
	    $.ajax({
	    	type: 'POST',
	        url: '/inquiry/reset-userpw',
	        dataType: 'json',
	        data: {
	        	"phone":phone,
	        	"email":email,
	        	"code":code,
	        	"key":key,
	        	"userPw":pass1
	        },
	        success: function (data) {
	        	if(data.result == true) {
	        		alert('비밀번호가 재설정 되었습니다.');
	        		location.href = data.loginUrl;
	        	} else {
	        		alert('비밀번호 재설정에 실패했습니다.');
	        	}
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	            console.log(errorThrown);
	            console.log(textStatus);
	        }
	    });
		
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
					<li><a id="login1" href="/inquiry/userid">아이디 찾기</a></li>
					<li><a id="login2" href="/inquiry/userpw" class="on">비밀번호 찾기</a></li>
				</ul>

				<div class="memberlogin2" id="div_pwinquiry1">
					<form id="phoneLoginForm" method="post" action="">
						<input type="hidden" id="phone-key" name="phoneKey"/>
						<fieldset id="" class="">
							<p><span><input type="text" class="it" id="email" name="email" placeholder="이메일 주소를 입력하세요" tabindex="1"/></span></p>
							<p><span><input type="text" class="it" id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span><a id="btn_request" href="#" class="pn">인증번호 요청</a></p>
							<p id="tmp-phone-code" style="display:none;"><span><input type="text" class="it" id="phone-code" name="phoneAuthCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span><a id="btn_auth" href="#" class="an">인증 확인</a></p>
							<span class="time" id="limit_time_txt" style="display:none;"></span>
						</fieldset> 
					</form>
				</div>
				
				<div class="step3" id="div_pwinquiry2" style="display: none;">
					<p class="tit">비밀번호 재설정</p>
					<fieldset id="" class="">
						<div class="password">
							<p><input type="password" class="it" title="" placeholder="비밀번호를 입력하세요(6~16자)" maxlength="16" id="pass1"/></p>
							<p><input type="password" class="it" title="" placeholder="비밀번호를 재입력하세요" maxlength="16" id="pass2"/></p>
						</div>
					</fieldset>

					<a href="#" class="next" onclick="resetUserpw(); return false;">등록</a>
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
