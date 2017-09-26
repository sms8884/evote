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
	$(document).ready(function(){
		if("${userInfo.termsAgreeYn}" == "Y") {
			$("#tmpTermsAgreeYn").addClass("on");
		}
	});
	
	function modifyTerms() {
		
		if ($("#termsAgreeYn").val() == "Y") {
			$("#termsAgreeYn").val("N");
		} else {
			$("#termsAgreeYn").val("Y");
		}
		
        $.ajax({
            type: 'POST',
            url: '/member/terms-agree',
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

	function modifyUserInfo() {
		$("#form").attr("action", "/member/modify");
		$("#form").attr("method", "POST");
		$("#form").submit();
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
	        $.ajax({
	            type: 'PUT',
	            url: '/member/modify-passwd-proc',
				data: JSON.stringify({
	            	"oldPass": $("#oldPass").val(),
	            	"newPass": $("#newPass1").val()
				}),
				contentType: "application/json; charset=utf-8",
	            success: function (data) {
	            	if(data.result == true) {
	            		alert("수정 되었습니다.");
		        		$('.fade, .layer_block').fadeOut(function(){
		        			$('.fade').remove();
		        		});
	            	} else {
	            		alert(data.message);
	            	}
	            	clearPw();
	            },
	            error: function (jqXHR, textStatus, errorThrown) {
	                console.log(errorThrown);
	                console.log(textStatus);
	            }
	        });
	        
		}
	}
	
	function clearPw() {
		$("#oldPass").val("");
		$("#newPass1").val("");
		$("#newPass2").val("");
	}
	
	$(function() {
		$('.more2').each(function(){
			$(this).find('>a').on('click',function(){
				if ($(this).hasClass('on')){
					$(this).find('img').attr('src','${siteImgPath}/etc/m_memMorebtn.png');
					$(this).removeClass('on').next('ul').hide();
				}else{
					$(this).find('img').attr('src','${siteImgPath}/etc/m_memMorebtn_on.png');
					$(this).addClass('on').next('ul').show();
				}
				return false;
			})
		});
		
		$('.infoChk').find('.chk').on('click',function(){
			if ($(this).hasClass('on')){
				$(this).removeClass('on');
			}else{
				$(this).addClass('on');
			}
			return false;
		});
	});
//]]>
</script>

</head>
<body>

<div id="header" class="etc">
	<h2>내 정보 조회</h2>
	<a href="/index" class="topBtInfo"><img src="${siteImgPath}/common/topBt_on.png" alt=""/></a>
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>
</div>

<div class="wrap">

	<div class="mInfo">
		<p class="infoTit infoTit2" style="position:relative">회원정보
			<div class="more2">
				<a href="#"><img src="${siteImgPath}/etc/m_memMorebtn.png" alt=""/></a>
				<ul class="">
					<li><a href="#?w=300" class="layer" rel="layerPop3" >회원 탈퇴하기</a></li>
				</ul>
			</div>
		</p>

		<c:if test="${userInfo.hasRole('USER')}">
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
		</c:if>
		
		<p class="infoBt">
			
			<c:if test="${isApp}">
				<a href="app://setting" class="infoChangeBt bookBg layer" rel="layerPop" >푸시설정</a>
			</c:if>
			
			<a href="#?w=300" class="infoChangeBt bookBg layer" rel="layerPop" >정보수정</a>
			
			<a href="#?w=300" class="pwChangeBt bookBg layer"  rel="layerPop2" >비밀번호 변경</a>
		</p>

		<p class="infoTit">기본정보</p>
		<div class="infoTb">
			<table cellpadding="0" cellspacing="0" class="" summary="" >
				<colgroup>
					<col width="90"/><col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">지역</th>
						<td>
							<c:out value="${userInfo.sidoNm}"/>&nbsp;
							<c:out value="${userInfo.sggNm}"/>&nbsp;
							<c:out value="${userInfo.emdNm}"/>
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
						<td>
							<c:choose>
								<c:when test="${not empty userInfo.phone and fn:length(userInfo.phone.value) gt 6}">
									<c:out value="${fn:substring(userInfo.phone.decValue, 0, 3)}-${fn:substring(userInfo.phone.decValue, 3, 7)}-****"/>
								</c:when>
								<c:otherwise>
									<c:out value="${userInfo.phone.decValue}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<p class="infoBt">
			<a href="/logout" class="loginBt">로그아웃</a>
			<a href="javascript:history.back(-1);" class="closeBtw">닫기</a>
		</p>

		<div class="infoChk">
			<p>
				<a href="#" class="chk" id="tmpTermsAgreeYn" onclick="modifyTerms(); return false;">문자 수신 동의</a>
				<!-- <a href="#" class="more">전체보기</a> -->
				<input type="hidden" id="termsAgreeYn" value="${userInfo.termsAgreeYn}" />
			</p>

			<div class="chkScr">
				<p class="tit">개인정보 수집ㆍ이용 동의 <span>(선택동의)</span></p>
				<div class="cont">
					<c:out value="${fn:replace(termsPrivacy3.termsCont, crcn, br)}" escapeXml="false"/>
				</div>
			</div>
		</div>
		<div class="layer_block layerPop">
			<p class="layerTit">
				<strong>비밀번호확인</strong>
				<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
			</p>
			<div class="layerCont">
				<form id="form" method="post">
				<input type="password" class="it" id="userPw" name="userPw" placeholder="비밀번호를 입력해주세요" style="width:99%; height:40px; margin:10px 0; "/>
				<p class="bt">
					<a href="#" class="cancel layerClose">취소</a>
					<a href="#" class="ok" onclick="modifyUserInfo(); return false;"><span>확인</span></a>
				</p>
				</form>
			</div>
		</div>

		<div class="layer_block layerPop2">
			<p class="layerTit">
				<strong>비밀번호변경</strong>
				<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
			</p>
			<div class="layerCont">
				<p style="text-align:center; font-size:15px; font-weight:bold; line-height:1.8; ">현재 비밀번호를 입력하고<br/>변경할 비밀번호를 등록해주세요</p>
				<input type="password" class="it" placeholder="현재 비밀번호" maxlength="16" id="oldPass" name="oldPass" style="width:99%; height:40px; margin:10px 0 0 0; border-bottom:none; "/>
				<input type="password" class="it" placeholder="새 비밀번호" maxlength="16" id="newPass1" name="newPass" style="width:99%; height:40px; border-bottom:none;"/>
				<input type="password" class="it" placeholder="새 비밀번호확인" maxlength="16" id="newPass2" name="newPass2" style="width:99%; height:40px; margin:0 0 10px 0; "/>
				<p class="bt">
					<a href="#" onclick="clearPw(); return false;" class="cancel layerClose">취소</a>
					<a href="#" onclick="modifyPw(); return false;" class="ok"><span>확인</span></a>
				</p>
			</div>
		</div>
 
		<div class="layer_block layerPop3">
			<p class="layerTit">
				<strong>탈퇴 안내</strong>
				<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
			</p>
			<div class="layerCont">
				<p style="text-align:center; font-size:15px; font-weight:bold; line-height:1.8; ">회원 탈퇴는 PC웹에서만 가능합니다.</p>
				<p class="bt">
					<a href="#" class="loginBt">확인</a>
				</p>
			</div>
		</div>

	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>
