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
				$("#tmpPhone").text($("#phoneNumber").val());
				$("#divPhoneAuth").hide();
				$("#phoneNumber").attr("disabled", false);
			}
		});

	});
	
	function memberInfo() {
		location.href = "/member/info";
	}
	
	function modifyInfo() {
		if(confirm("수정 하시겠습니까?")) {
			$("#form").attr("action", "/member/modify-proc");
			$("#form").attr("method", "POST");
			$("#form").submit();
		}
	}
	
	function modifyPasswd() {
		
        $.ajax({
            type: 'POST',
            url: '/member/modify-passwd',
            dataType: 'json',
            data: {"termsAgreeYn": $("#termsAgreeYn").val() },
            success: function (data) {
            	if(data.result == true) {
            		if($("#termsAgreeYn").val() == "Y") {
            			alert("선택동의 처리되었습니다.");
            		} else {
            			alert("선택동의 해제 처리되었습니다.");
            		}
            	}
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log(errorThrown);
                console.log(textStatus);
            }
        });
	}
/* 	
	function withdrawal() {
		alert('탈퇴 되었습니다.');
	}
 */
	function openLoginLayer() {
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 460 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
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
				<div class="memberInfo">
					<p class="mITitle">회원 정보</p>
					<dl class="mIDl">
						<dt>이름</dt>
						<dd><c:out value="${userInfo.userNm.decValue}"/></dd>
						<dt>닉네임</dt>
						<dd><c:out value="${userInfo.nickname}"/></dd>
						<dt>로그인 아이디</dt>
						<dd><c:out value="${userInfo.email.decValue}"/></dd>
						<c:if test="${userInfo.userType eq 'CMIT'}">
							<dt>회원권한</dt>
							<dd>주민참여위원</dd>
						</c:if>
					</dl>
					
					<form id="form">
					
						<dl class="mIDl2">
							<dt>지역</dt>
							<p class="area2">
								<span>서울시 은평구</span>
								<select id="regionCd" name="regionCd">
									<c:forEach var="list" items="${emdList}">
										<option value="<c:out value="${list.regionCd}"/>"><c:out value="${list.emdNm}"/></option>
									</c:forEach>
								</select>
								<script>$("#regionCd").val("${userInfo.regionCd}");</script>
							</p>
							<dt>생년/성별</dt>
							<dd>
								<c:out value="${userInfo.birthYear}"/>년생/
								<c:if test="${userInfo.gender eq 'M'}">남성</c:if>
								<c:if test="${userInfo.gender eq 'F'}">여성</c:if>
							</dd>
							<dt>휴대폰번호</dt>
							<dd id="tmpPhone">
								<c:choose>
									<c:when test="${not empty userInfo.phone.decValue and fn:length(userInfo.phone.decValue) gt 6}">
										<c:out value="${fn:substring(userInfo.phone.decValue, 0, 3)}-${fn:substring(userInfo.phone.decValue, 3, 7)}-****"/>
									</c:when>
									<c:otherwise>
										<c:out value="${userInfo.phone.decValue}"/>
									</c:otherwise>
								</c:choose>
								<a href="#" class="btn_reset" onclick="$('#divPhoneAuth').show(); return false;" style="margin-left:50px;">수정</a>
							</dd>
							
							<div class="certi2" id="divPhoneAuth" style="display: none;">
								<input type="hidden" id="phone-key" name="phoneKey"/>
								<fieldset id="" class="">
									<p><span><input type="text" class="it" id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span><a id="btn_request" href="#" class="pn">인증번호 요청</a></p>
									<p id="tmp-phone-code" style="display:none;"><span><input type="text" class="it" id="phone-code" name="phoneCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span><a id="btn_auth" href="#" class="an">인증 확인</a></p>
									<span class="time" id="limit_time_txt" style="display:none;"></span>
								</fieldset>
							</div>
							
						</dl>
					
					</form>
					
				</div>
					<div class="btnBox_info">
					<a href="#" title="" class="btn_gray">취소</a>
					<a href="#" onclick="modifyInfo(); return false;" title="" class="btn_blue">저장</a>
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
