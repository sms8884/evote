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

		$.phoneAuth({
			authRequestUrl:'/member/phone-auth-req',
			authCheckUrl:'/member/phone-auth-check',
			callbackEvent:function(data) {
				alert("OKOK");
        		//$('#layer_userid').text(data.email);
        		//$('#div_idinquiry1').hide();
        		//$('#div_idinquiry2').show();
			}
		});

	});
	
	function memberInfo() {
		location.href = "/member/info";
	}
	
	function modifyPw() {
		
		var oldPass = $("#oldPass").val();
		var newPass1 = $("#newPass1").val();
		var newPass2 = $("#newPass2").val();
		
		if (oldPass == "") {
			// 현재 비밀번호를 입력해주세요
			alert('<spring:message code="message.member.info.008"/>');
			$("#oldPass").focus();
			return false;
		} else if (newPass1 == "") {
			// 새 비밀번호를 입력해주세요
			alert('<spring:message code="message.member.info.010"/>');
			$("#newPass1").focus();
			return false;
		} else if (newPass1.length < 6) {
			// 6~16자의 비밀번호를 입력하세요
			alert('<spring:message code="message.member.info.011"/>');
			$("#newPass1").focus();
			return false;
		} else if (newPass1 != newPass2) {
			// 새 비밀번호가 일치하지 않습니다
			alert('<spring:message code="message.member.info.012"/>');
			$("#newPass1").focus();
			return false;
		}
		
		if(confirm("수정 하시겠습니까?")) {
			$("#form").attr("action", "/member/modify-passwd-proc");
			$("#form").attr("method", "POST");
			$("#form").submit();
		}
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
			<h3 class="contentTit">내 정보 조회</h3>
			<div class="contents paddingnone">			
				<div class="memberInfo">
					<p class="mITitle">비밀번호 변경</p>
					<form id="form">
						<div class="certi3">
							<strong>현재 비밀번호를 입력하고 변경할 비밀번호를 등록해주세요</strong>
							<p><span><input type="password" class="it" title="" placeholder="현재 비밀번호" maxlength="16" id="oldPass" name="oldPass"/></span></p>
							<p><span><input type="password" class="it" title="" placeholder="새 비밀번호" maxlength="16" id="newPass1" name="newPass"/></span></p>
							<p><span><input type="password" class="it" title="" placeholder="새 비밀번호 확인" maxlength="16" id="newPass2" name="newPass2"/></span></p>
						</div>
					</form>
				</div>
					<div class="btnBox_info2">
					<a href="#" onclick="memberInfo(); return false;" title="" class="btn_gray">취소</a>
					<a href="#" onclick="modifyPw(); return false;" title="" class="btn_blue">확인</a>
				</div>
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
