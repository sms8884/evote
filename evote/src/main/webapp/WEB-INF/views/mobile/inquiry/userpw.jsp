<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		
		$('.topBt').on('click',function(){
			if ($(this).hasClass('on')){
				$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_off'))
				$(this).removeClass('on').next('.topMenu').hide();
				$('.wrap').unwrap('.fade');
			}else{
				$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_off','_on'))
				$(this).addClass('on').next('.topMenu').show();
				$('.wrap').unwrap('.fade');
				$('.wrap').wrap('<div class="fade" style="width:100%; height:100%; background:#000; opacity:0.6; z-index:99;"></div>');
			}
		});
		
		$("#email").focus();
		
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

<div id="header" class="etc">
	<a href="#" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>아이디/비밀번호 찾기</h2>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>

</div>

<div class="wrap">
	<ul class="loginTab">
		<li><a id="login1" href="/inquiry/userid">아이디 찾기</a></li>
		<li><a id="login2" href="/inquiry/userpw" class="on">비밀번호 찾기</a></li>
	</ul>

	<div id="div_pwinquiry1">

		<div class="member4step">
	
			<div class="memb">
				<p class="login1">
					<input type="text" class="it " id="email" name="email" placeholder="이메일 주소를 입력하세요"/>
				</p>
			</div>
		</div>
		
		<div class="phoneArea">
			<div class="login" style="padding-top: 10px;">
				<p class="login2">
					<span><input type="text" class="it " id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" maxlength="15"/></span>
					<a id="btn_request" href="#" class="bt1">인증번호요청</a>
				</p>
				<p class="login2" id="tmp-phone-code" style="display:none;">
					<span><input type="text" class="it " id="phone-code" name="phone-code" placeholder="인증번호를 입력하세요"/></span>
					<a id="btn_auth" href="#" class="bt2">인증확인</a>
				</p>
				<input type="hidden" id="phone-key" name="phoneKey"/>
				<p class="time" id="limit_time_txt" style="display:none;"></p>
			</div>
		</div>
	
	</div>

	<div id="div_pwinquiry2" style="display: none;">
		<div class="member3step">
			<div class="memb">
				<p class="tit">비밀번호 재설정</p>
				<p class="login1 login1bn">
					<input type="password" class="it " placeholder="비밀번호를 입력하세요(6~16자)" maxlength="16" id="pass1"//>
				</p>
				<p class="login1">
					<input type="password" class="it " placeholder="비밀번호를 재입력하세요" maxlength="16" id="pass2"/>
				</p>
				<a href="#" class="next" onclick="resetUserpw(); return false;">등록</a>
			</div>
		</div>
		
	</div>
		
	
</div>
 <!-- footer -->
<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
<!-- //footer -->
	
</body>
</html>
