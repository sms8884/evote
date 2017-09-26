<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 3, d2: 4});
	});
	
	function fn_step2() {
		if($("#ck_terms2").hasClass("on")) {
			$("#div-auth-step1").hide();
			$("#div-auth-step2").show();
		} else {
			// 필수 항목에 동의해야 진행할 수 있습니다
			alert('<spring:message code="message.member.join.001" />');
		}
	}
	
	$(function() {

		$.phoneAuth({
			authRequestUrl:'/board/${boardName}/auth-req',
			authCheckUrl:'/board/${boardName}/auth-check',
			appendBirthdate:true,
			appendData:[
				{'appendFieldId':'birthMonth','validationMsg':'<spring:message code="message.member.join.006"/>'},
				{'appendFieldId':'birthDate','validationMsg':'<spring:message code="message.member.join.006"/>'}
			],
			callbackEvent:function(data) {
				location.href = data.redirectUrl;
			}
		});
		
	});
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
		<span>주민알림</span>
		<span>문의하기</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="notice"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">문의하기</h3>

			<div id="div-auth-step1" class="contents paddingnone">
				<img src="${siteImgPath}/etc/stepNojoin.png" alt="개인정보 수집,이용 동의 > 휴대폰인증 중 1단계 개인정보 수집,이용 동의"/>
				<div class="step1">
					<p class="tit">개인정보 수집ㆍ이용 동의</p>

					<ul class="">
						<li>
							<a href="#" class="chk" id="ck_terms2">개인정보 수집ㆍ이용 동의<span>(필수)</span></a>
							<a href="#" class="more" onclick="openTermsLayer(2); return false;">전체보기</a>
						</li>
					</ul>

					<script language="javascript" type="text/javascript">
					//<![CDATA[
						$('.step1').find('ul').find('.chk').on('click',function(){
							if ($(this).hasClass('on')){
								$(this).removeClass('on');
								$('.allChk').find('.chk').removeClass('on');
							}else{
								$(this).addClass('on');
							}
							return false;
						})
					//]]>
					</script>

					<a href="#" class="next" onclick="fn_step2(); return false;">다음</a>

				</div>
			</div>
			
			<!-- join step 2 -->
			<div id="div-auth-step2" class="contents paddingnone" style="display: none;">
				<img src="${siteImgPath}/etc/stepNojoin2.png" alt="개인정보 수집,이용 동의 > 휴대폰인증 중 2단계 휴대폰인증"/>
				<div class="step2">
					<p class="tit">휴대폰 인증</p>
						
					<form name="form" id="form">
					
						<fieldset id="" class="">
							<p class="birth">
								<strong>생년월일</strong>
								<select id="birthYear" name="birthYear" title="" style="width:176px; margin:0;"></select>
								<select id="birthMonth" name="birthMonth" title="" style="width:124px;"></select>
								<select id="birthDate" name="birthDate" style="width:124px;"></select>
								<span>※만 14세 미만은 가입할 수 없습니다.</span>
							</p>
							<div class="certi">
								<strong>휴대폰 번호</strong>
	
								<input type="hidden" id="phone-key" name="phoneKey"/>
								<fieldset id="" class="">
									<p><span><input type="text" class="it" id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span><a id="btn_request" href="#" class="pn">인증번호 요청</a></p>
									<p id="tmp-phone-code" style="display:none;"><span><input type="text" class="it" id="phone-code" name="phoneCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span><a id="btn_auth" href="#" class="an">인증 확인</a></p>
									<span class="time" id="limit_time_txt" style="display:none;"></span>
								</fieldset>
								
							</div>
						</fieldset>
					
					</form>
					
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
