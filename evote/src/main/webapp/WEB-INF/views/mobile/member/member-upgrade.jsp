<%-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
</head>
<body>

<div id="header" class="etc">
	<a href="#" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>회원가입</h2>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>
</div>

<script language="javascript" type="text/javascript">
//<![CDATA[
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
	})
//]]>
</script>

<script language="javascript" type="text/javascript">

function fn_memberUpgrade() {
	
	if($("#userName").val() == "") {
		// 이름을 입력해주세요.
		alert('<spring:message code="message.common.header.002" arguments="이름을"/>');
		$("#userName").focus();
		return;
	} else if($("#userName").val().length < 2) {
		// 이름은 한글로 2~15자 까지 입력할 수 있습니다
		alert('<spring:message code="message.member.join.012"/>');
		$("#userName").focus();
		return;
	}

	if($("#nickname").val() == "") {
		// 닉네임을 입력해주세요.
		alert('<spring:message code="message.common.header.002" arguments="닉네임을"/>');
		$("#nickname").focus();
		return;
	} else if($("#nickname").val().length < 2) {
		// 닉네임은 한글로 2~15자 까지 입력할 수 있습니다
		alert('<spring:message code="message.member.join.013"/>');
		$("#nickname").focus();
		return;
	} else if(!chkNickname) {
		// 닉네임 중복 체크를 해주세요.
		alert('<spring:message code="message.member.join.017"/>');
		return false;
	}
	
	// 등록하시겠습니까?
	if(confirm('<spring:message code="message.common.header.004"/>')) {
		fn_setJoinInfo();
		$("#joinForm").attr("action", "/member/upgrade-proc");
		$("#joinForm").attr("method", "POST");
		$("#joinForm").submit();		
	}
	
}

function fn_setJoinInfo() {
	$("#tmpUserEmail").val($("#email").val());
	$("#tmpUserPass").val($("#pass1").val());
	$("#tmpUserName").val($("#userName").val());
	$("#tmpNickname").val($("#nickname").val());
}

function fn_step4() {
	if(fn_step3Check()) {
		$("#div-join-step3").hide();
		$("#div-join-step4").show();
	}
}

//=========================================================================
// JOIN STEP 3
//=========================================================================
	
var chkEmail = false;

function fn_checkEmail() {
	var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	if( $("#email").val() == "" ) {
		// 이메일 주소를 입력해주세요
		alert('<spring:message code="message.common.header.002" arguments="이메일 주소를"/>');
		$("#email").focus();
		return;
	} else {
        if(!regEmail.test($("#email").val())) {
        	// 잘못된 이메일 주소 입니다. 이메일 주소를 확인한 다음 다시 입력해 주세요.
        	alert('<spring:message code="message.login.email.004"/>');
            $("#email").focus();
            return false;
        }
	}
	$.ajax({
		type : "POST",
		url : "/member/check-email",
		data : {
			"email" : $("#email").val()
		},
		success : function(data) {
			if (data == true) {
				// 사용가능한 이메일입니다.
				alert('<spring:message code="message.member.join.020"/>');
				chkEmail = true;
			} else {
				// 이미 등록된 이메일입니다
				alert('<spring:message code="message.member.join.008"/>');
				$("#email").val("");
				$("#email").focus();
			}
		},
		error : function(error) {
			console.log(error);
		}
	});
}

function fn_changeEmail() {
	chkEmail = false;
}

function fn_step3Check() {

	var email = $("#email").val();
	var pass1 = $("#pass1").val();
	var pass2 = $("#pass2").val();
	
	if (email == ""){
		// 이메일을 입력해주세요
		alert('<spring:message code="message.common.header.002" arguments="이메일을"/>');
		return false;
	} else if (pass1 == "") {
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
	} else if (!chkEmail) {
		// 닉네임 중복 체크를 해주세요.
		alert('<spring:message code="message.member.join.021"/>');
		return false;
	} else {
		return true;
	}
}

//=========================================================================
// JOIN STEP 4
//=========================================================================

var chkNickname = false;
	
function fn_checkNickname() {
	
	if($("#nickname").val() == "") {
		// 닉네임을 입력해주세요
		alert('<spring:message code="message.common.header.002" arguments="닉네임을"/>');
		$("#nickname").focus();
		return;
	} else if($("#nickname").val().length < 2) {
		// 닉네임은 한글로 2~15자 까지 입력할 수 있습니다
		alert('<spring:message code="message.member.join.013"/>');
		$("#nickname").focus();
		return;
	}
	
	$.ajax({
		type : "POST",
		url : "/member/check-nickname",
		data : {
			"nickname" : $("#nickname").val()
		},
		success : function(data) {
			if (data == true) {
				// 사용가능한 닉네임입니다.
				alert('<spring:message code="message.member.join.022"/>');
				chkNickname = true;
			} else {
				// 이미 사용중인 닉네임입니다
				alert('<spring:message code="message.member.join.014"/>');
				$("#nickname").val("");
				$("#nickname").focus();
			}
		},
		error : function(error) {
			console.log(error);
		}
	});
}

function fn_changeNickname() {
	chkNickname = false;
}
	
	
	
	
$(document).ready(function() {
	
	var date = new Date();
	var year = date.getFullYear();
	var tmpVal;
	
	for(var cnt=(year-14); cnt>(year-100); cnt--) {
		$("#birthYear").append($("<option></option>").attr("value", cnt).text(cnt)); 
	}
	
	$("#birthMonth").append($("<option></option>").attr("value", "").text("월"));
	for(var cnt=0; cnt<12; cnt++) {
		tmpVal = (cnt < 9) ? "0" + (cnt+1) : (cnt+1);
		$("#birthMonth").append($("<option></option>").attr("value", tmpVal).text(tmpVal)); 
	}
	
	$("#birthDate").append($("<option></option>").attr("value", "").text("일"));
	for(var cnt=0; cnt<31; cnt++) {
		tmpVal = (cnt < 9) ? "0" + (cnt+1) : (cnt+1);
		$("#birthDate").append($("<option></option>").attr("value", tmpVal).text(tmpVal)); 
	}
	
	$("#birthYear").val("1970");
	
	$("#btn_next").hide();

	$('#phoneCode').on('keypress', function(e) {
		if (e.which == 13) {
			fn_checkPhoneAuth();
		}
	});

	$('#phoneNumber').on('keypress', function(e) {
		if (e.which == 13) {
			fn_reqPhoneAuth();
		}
	});
	
});


</script>

<div class="wrap">
	<p class="memberTit">회원정보등록</p>
	<ul class="memberStep memberStep3">
		<li class="step3 on"><span><span>회원정보등록</span></span></li>
		<li class="step4"><span><span>기본정보등록</span></span></li>
	</ul>

	<div id="div-join-step3" class="member3step">
		<p class="txt">이메일로 가입 시 추가적인 인증없이 로그인을 통해 참여예산 정책제안을 사용할 수 있습니다</p>

		<div class="memb">
			<p class="tit">이메일</p>
			<p class="login2">
				<span><input type="text" class="it " id="email" name="email" placeholder="아이디로 사용할 이메일을 입력하세요" onchange="fn_changeEmail();"/></span>
				<a href="#" class="bt2" onclick="fn_checkEmail(); return false;">중복확인</a>
			</p>
		</div>
		<div class="memb">
			<p class="tit">비밀번호</p>
			<p class="login1 login1bn">
				<input type="password" class="it " placeholder="비밀번호를 입력하세요(6~16자)" maxlength="16" id="pass1"//>
			</p>
			<p class="login1">
				<input type="password" class="it " placeholder="비밀번호를 재입력하세요" maxlength="16" id="pass2"/>
			</p>
			<a href="#" class="next" onclick="fn_step4(); return false;">다음</a>
		</div>
	</div>
	
	
	<div id="div-join-step4" class="member4step" style="display:none;">
		<p class="txt">투표/설문을 위한 기본정보를 등록해주세요</p>

		<div class="memb">
			<p class="tit">이름</p>
			<p class="login1">
				<input type="text" class="it " id="userName" name="userName" placeholder="이름을 입력해주세요" maxlength="15"/>
			</p>
		</div>
		<div class="memb">
			<p class="tit">닉네임</p>
			<p class="login2">
				<span><input type="text" class="it " id="nickname" name="nickname"  placeholder="닉네임을 입력해주세요" maxlength="15" onchange="fn_changeNickname();"/></span>
				<a href="#" class="bt2" onclick="fn_checkNickname(); return false;">중복확인</a>
			</p>
		</div>

		<div class="memb">
			<a href="#" class="loginBt loginBt2" onclick="fn_memberUpgrade(); return false;">등록</a>
		</div>
	</div>
	

	<form id="joinForm" name="joinForm">
		<input type="hidden" name="userEmail" id="tmpUserEmail"/>
		<input type="hidden" name="userPass" id="tmpUserPass"/>
		<input type="hidden" name="userName" id="tmpUserName"/>
		<input type="hidden" name="nickname" id="tmpNickname"/>
	</form>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>
 --%>