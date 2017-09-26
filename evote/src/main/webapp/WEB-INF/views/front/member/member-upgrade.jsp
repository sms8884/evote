<%-- 삭제 [2016-09-29]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
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
});

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
				<li><a href="">내 정보 조회</a></li>
			</ul>
		</div>
		
		<div class="contentsWrap">
			<h3 class="contentTit">이메일로 가입</h3>

			<div id="div-join-step3" class="contents paddingnone">
				
				<!--20160825추가-->
				<ul class="memberStepNew">
					<li class="step3 on"><span><span>회원정보등록</span></span></li><!--li class에 on만 추가,삭제해주시면됩니다-->
					<li class="step4"><span><span>기본정보등록</span></span></li>
				</ul>			
				<!---->
				
				<div class="step3">
					<p class="tit">회원정보등록
						<span>회원가입 시 추가적인 인증없이 로그인을 통해<br/><strong>참여예산 정책제안</strong>을 사용할 수 있습니다</span>
					</p>

					<form method="post" action="" class="phone">
						<fieldset id="" class="">
							<div class="mail">
								<strong>이메일</strong>
								<p><span><input type="text" class="it" id="email" name="email" title="" placeholder="아이디로 사용할 이메일을 입력하세요" onchange="fn_changeEmail();"/></span><a href="#" class="an" onclick="fn_checkEmail(); return false;">중복확인</a></p>
							</div>
							<div class="password">
								<strong>비밀번호</strong>
								<p><input type="password" class="it" title="" placeholder="비밀번호를 입력하세요(6~16자)" maxlength="16" id="pass1"/></p>
								<p><input type="password" class="it" title="" placeholder="비밀번호를 재입력하세요" maxlength="16" id="pass2"/></p>
							</div>
						</fieldset>
					</form>

					<a href="#" class="next" onclick="fn_step4(); return false;">다음</a>
				</div>
			</div>
			
			<div id="div-join-step4" class="contents paddingnone" style="display:none;">
				
				<!--20160825추가-->
				<ul class="memberStepNew">
					<li class="step3"><span><span>회원정보등록</span></span></li><!--li class에 on만 추가,삭제해주시면됩니다-->
					<li class="step4 on"><span><span>기본정보등록</span></span></li>
				</ul>			
				<!---->
				
				<div class="step3">
					<p class="tit">기본정보등록
						<span>기본정보등록 후 이름, 닉네임, 성별은 수정할 수 없습니다.<br/>입력한 정보를 다시 한 번 확인하시고 등록해주세요.</span>
					</p>

						<fieldset id="" class="">
							<div class="name">
								<strong>이름</strong>
								<p><input type="text" class="it" title="" id="userName" name="userName" placeholder="이름을 입력해주세요" maxlength="15"/></p>
							</div>
							<div class="nick">
								<strong>닉네임</strong>
								<p><span><input type="text" class="it" title="" id="nickname" name="nickname"  placeholder="닉네임을 입력해주세요" maxlength="15" onchange="fn_changeNickname();"/></span><a href="#" onclick="fn_checkNickname(); return false;" class="an">중복확인</a></p>
							</div>
						</fieldset>

					<a href="#" class="memberEnd" onclick="fn_memberUpgrade(); return false;">등록</a>
				</div>
			</div>

			<form id="joinForm" name="joinForm">
				<input type="hidden" name="userEmail" id="tmpUserEmail"/>
				<input type="hidden" name="userPass" id="tmpUserPass"/>
				<input type="hidden" name="userName" id="tmpUserName"/>
				<input type="hidden" name="nickname" id="tmpNickname"/>
			</form>
		
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
--%>