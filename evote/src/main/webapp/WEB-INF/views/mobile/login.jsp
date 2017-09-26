<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
           
	$(function() {
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
<%--	
	function phoneLogin() {
		$('#phoneNumber').removeAttr("disabled");
		$("#phoneLoginForm").attr("action", "/phone-login-proc");
		$("#phoneLoginForm").attr("method", "POST");
		$("#phoneLoginForm").submit();
	}
	
	var authLimitTime = "<spring:eval expression='@system[\'sms.auth.limit.time\']' />";
	
	var isTimeOut = false;
	var timer;

	function timer_start() {
		clearInterval(timer);
		var counter = authLimitTime;
		var dpTime = "";
		$("#limit_time_txt").html(getTimeString(counter));
		timer = setInterval(function () {
			$("#limit_time_txt").html(getTimeString(counter-1));
			if(counter <= 0) {
				clearInterval(timer);
				// 시간초과
				$("#limit_time_txt").html('<spring:message code="message.login.phone.005"/>');
				isTimeOut = true;
			}
			counter--;
		}, 1000);
	}

	function reqPhoneAuth(){
		
		var phoneNumber = $("#phoneNumber").val();
		var numCheck = /^[0-9]*$/;
		
	    if(phoneNumber == ""){
	    	// 휴대전화번호를 입력해주세요
	        alert('<spring:message code="message.common.header.002" arguments="휴대전화번호를"/> ');
	        $('#phoneNumber').focus();
	    }else if(!numCheck.test(phoneNumber)){
	    	// 숫자만 입력해주세요
	        alert('<spring:message code="message.common.header.002" arguments="숫자만"/> ');
	        $('#phoneNumber').val("");
	        $('#phoneNumber').focus();
	    }else {
	        $.ajax({
	            type: 'POST',
	            url: '/phone-auth-req',
	            dataType: 'json',
	            data: {"phoneNumber":phoneNumber},
	            success: function (data) {
	            	if(data != undefined) {
	                	if(data.result == "Y") {
	                		timer_start();
	                		isTimeOut = false;
	                		$("#phone-code").val("");
	                		// 인증번호가 발송되었습니다.
	                		alert('<spring:message code="message.login.phone.006"/>');
							$("#tmp-phone-code").show();
							//$("#btn_next").show();
							
	                		$("#limit_time_txt").show();
	                		// 인증번호 재요청
	                		$("#btn_request").text('<spring:message code="message.login.phone.007"/>');
	                		$("#phone-key").val(data.key);
	                		
	                		$("#phoneNumber").prop("disabled", true);
	                	    $("#birthYear").prop("disabled", true);
	                		$("#birthMonth").prop("disabled", true);
	                		$("#birthDate").prop("disabled", true);
	                		
	                	} else if(data.result == "N") {
	                		alert(data.message);
	                	}
	            	}
	            },
	            error: function (jqXHR, textStatus, errorThrown) {
	                console.log(errorThrown);
	                console.log(textStatus);
	            }
	        });
	    }
	}

	function checkPhoneAuth(){
		
		if(isTimeOut) {
			// 인증 시간이 초과되었습니다.\n인증 번호를 다시 요청해주세요..
			alert('<spring:message code="message.login.phone.009"/>');
			clearInterval(timer);
			return;
		}
		
		var phone = $("#phoneNumber").val();
		var code = $("#phone-code").val();
		var key = $("#phone-key").val();
			
		if(code == "") {
			// 인증을 받지 않았습니다. 인증번호를 입력하고 인증확인을 선택해주세요.
			alert('<spring:message code="message.login.phone.002"/>');
			return;
		}
		
	    $.ajax({
	    	type: 'POST',
	        url: '/phone-auth-check',
	        dataType: 'json',
	        data: {"phone":phone,"code":code,"key":key},  
	        success: function (data) {
	        	if(data.result == true) {
	        		// 인증되었습니다.
	        		alert('<spring:message code="message.login.phone.008"/>');
	        		clearInterval(timer);
	        		phoneLogin();
	        	} else {
	        		// 잘못된 인증번호입니다. 인증번호를 확인한 다음 다시 입력해주세요.
	        		alert('<spring:message code="message.login.phone.001"/>');
	        		$("#phone-code").val("");
	        	}
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	            console.log(errorThrown);
	            console.log(textStatus);
	        }
	    });
		
	}
	
	function getTimeString(seconds) {
		var timeString = Math.floor(seconds/60);
		timeString = timeString + "분 ";
		if ( (seconds%60) < 10 ) { 
			timeString = timeString + "0";
		}
		timeString = timeString + (seconds%60);
		timeString = timeString + "초";
		return "남은시간: " + timeString;
	}
--%>
//]]>
</script>

</head>
<body>

<div id="header" class="etc">
	<a href="#" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>로그인</h2>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>

</div>

<div class="wrap">

	<div id="divEmailLogin" class="loginArea">
		<form id="emailLoginForm" method="post">
			<p class="login1">
				<input type="text" class="it id" id="email" name="email" placeholder="이메일 주소를 입력하세요"/>
			</p>
			<p class="login1">
				<input type="password" class="it pw" id="userPw" name="userPw" placeholder="비밀번호를 입력하세요"/>
			</p>
		</form>
	</div>
	
	<a id="btnEmailLogin" href="javascript:emailLogin();" class="loginBt">로그인</a>
	
	<div class="memberArea">
		<ul class="">
			<li><a href="/inquiry/userid" class="mbg1">아이디 찾기</a></li>
			<li><a href="/inquiry/userpw" class="mbg2">비밀번호 찾기</a></li>
			<li><a href="/member/join" class="mbg3">회원가입</a></li>
		</ul>
	</div>

	<div id="loginLayer" class="layer_block layerPop">
		<p class="layerTit">
			<strong>아이디/비밀번호 찾기</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
	</div>


	
</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->

</body>
</html>