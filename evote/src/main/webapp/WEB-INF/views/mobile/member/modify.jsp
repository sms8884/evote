<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />   

<script language="javascript" type="text/javascript">

	$(function() {

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

	function modifyInfo() {
		if(confirm("수정 하시겠습니까?")) {
			$("#form").attr("action", "/member/modify-proc");
			$("#form").attr("method", "POST");
			$("#form").submit();
		}
	}
	
</script>

</head>
<body>

<div id="header" class="etc">
	<h2>내 정보 조회</h2>
	<a href="javascript:history.back(-1);" class="topBtInfo"><img src="${siteImgPath}/common/topBt_on.png" alt=""/></a>
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


<div class="wrap">

	<div class="mInfo">
		<p class="infoTit infoTit2">회원정보 
		<div class="">
			<img src="" alt=""/>	
		</div>
		</p>
		<div class="infoTb">
			<table cellpadding="0" cellspacing="0" class="" summary="" >
				<colgroup>
					<col width="90"/><col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">닉네임</th>
						<td><c:out value="${userInfo.nickname}"/></td>
					</tr>
					<tr>
						<th scope="row">로그인 아이디</th>
						<td><c:out value="${userInfo.email.decValue}"/></td>
					</tr>
					<c:if test="${userInfo.userType eq 'CMIT'}">
						<tr>
							<th scope="row">회원권한</th>
							<td>주민참여위원</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		
		<form id="form">
		
			<p class="infoTit">기본정보</p>
			<div class="infoTb">
				<table cellpadding="0" cellspacing="0" class="" summary="" >
					<colgroup>
						<col width="90"/><col width="*"/>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">지역</th>
							<td>서울시 은평구 
								<span class="infospan">
									<select id="regionCd" name="regionCd">
										<c:forEach var="list" items="${emdList}">
											<option value="<c:out value="${list.regionCd}"/>"><c:out value="${list.emdNm}"/></option>
										</c:forEach>
									</select>
									<script>$("#regionCd").val("${userInfo.regionCd}");</script>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">생년/성별</th>
							<td>
								<c:out value="${userInfo.birthYear}"/>년생/
								<c:if test="${userInfo.gender eq 'M'}">남성</c:if>
								<c:if test="${userInfo.gender eq 'F'}">여성</c:if>
							</td>
						</tr>
						
						<tr>
							<th scope="row">휴대폰번호</th>
							<td id="tmpPhone" class="tdBox">
								<span>
								<c:choose>
									<c:when test="${not empty userInfo.phone.decValue and fn:length(userInfo.phone.decValue) gt 6}">
										<c:out value="${fn:substring(userInfo.phone.decValue, 0, 3)}-${fn:substring(userInfo.phone.decValue, 3, 7)}-****"/>
									</c:when>
									<c:otherwise>
										<c:out value="${userInfo.phone.decValue}"/>
									</c:otherwise>
								</c:choose>
								</span>
								<a href="#" class="bt1" onclick="$('#divPhoneAuth').show(); return false;">수정</a>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		
			<div class="loginArea" id="divPhoneAuth" style="display: none;">
				<input type="hidden" id="phone-key" name="phoneKey"/>
				<p class="login2">
					<span><input type="text" class="it " id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요"/></span>
					<a href="#" class="bt1" id="btn_request">인증번호 요청</a>
				</p>
				<p class="login2" id="tmp-phone-code" style="display:none;">
					<span><input type="text" class="it " id="phone-code" name="phoneCode" placeholder="인증번호를 입력하세요"/></span>
					<a href="#" class="bt2" id="btn_auth">인증확인</a>
				</p>
				<p class="time" id="limit_time_txt" style="display:none;"></p>
			</div>
		
		</form>
		
		<p class="infoBt">
			<a href="#" class="loginBt" onclick="modifyInfo(); return false;">저장</a>
			<a href="javascript:history.back(-1);" class="closeBtw">닫기</a>
		</p>	
	
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>
