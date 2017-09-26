<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<script language="javascript" type="text/javascript">

	function fn_step2() {
		if($("#ck_terms1").hasClass("on") && $("#ck_terms2").hasClass("on")) {
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

</script>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

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

	<div id="div-auth-step1">
	
		<p class="memberTit">약관동의</p>
		<ul class="memberStep memberStep3">
			<li class="step1 on"><span><span>개인정보 수집·이용 동의</span></span></li>
			<li class="step2"><span><span>휴대폰인증</span></span></li>
		</ul>
	
		<p class="allChk">
			<a href="#" class="chk">전체동의</a>
			<span>이용약관(필수), 개인정보 수집ㆍ이용(필수)에 모두 동의합니다.</span>
		</p>
	
		<ul class="chkArea">
			<li>
				<a href="#" class="chk" id="ck_terms1">이용약관 동의<span>(필수)</span></a>
				<a href="#" class="more loginMbt1" onclick="openTermsLayer(1); return false;">전체보기</a>
			</li>
			<li>
				<a href="#" class="chk" id="ck_terms2">개인정보 수집ㆍ이용 동의<span>(필수)</span></a>
				<a href="#" class="more loginMbt1" onclick="openTermsLayer(2); return false;">전체보기</a>
			</li>
<!-- 			
			<li>
				<a href="#" class="chk">개인정보 수집ㆍ이용 동의<span>(선택)</span></a>
				<a href="#?=460" class="more loginMbt1 layer" rel="loginMbtLayer">전체보기</a>
			</li>
 -->			
		</ul>
	
		<script language="javascript" type="text/javascript">
		//<![CDATA[
			$('.allChk').find('.chk').on('click',function(){
				if ($(this).hasClass('on')){
					$(this).removeClass('on');
					$('.allChk').next('ul').find('.chk').each(function(){
						$(this).removeClass('on');
					})
				}else{
					$(this).addClass('on');
					$('.allChk').next('ul').find('.chk').each(function(){
						$(this).addClass('on');
					})
				}
					return false;
			})
			$('.allChk').next('ul').find('.chk').on('click',function(){
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
	
		<div class="memeberNext">
			<a href="#" class="next" onclick="fn_step2(); return false;">다음</a>
			<!-- <a href="#" class="phoneMember">휴대폰번호로 가입</a> -->
		</div>
	
	</div>

	
	<div id="div-auth-step2" style="display: none;">
	
		<p class="memberTit">휴대폰인증</p>
		<ul class="memberStep memberStep3">
			<li class="step1"><span><span>약관동의</span></span></li>
			<li class="step2 on"><span><span>휴대폰인증</span></span></li>
		</ul>
	
		<div class="phoneArea">
			<p class="tit">생년월일</p>
			<div class="birth">
				<p class="sel">
					<select id="birthYear" name="birthYear" class="sel1"></select>
					<select id="birthMonth" name="birthMonth" class="sel2"></select>
					<select id="birthDate" name="birthDate" class="sel3"></select>
				</p>
				<p class="point">만 14세미만은 가입할 수 없습니다.</p>
			</div>
			<div class="login">
				<p class="login2">
					<span><input type="text" class="it " id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span>
					<a id="btn_request" href="#" class="bt1">인증번호요청</a>
				</p>
				<p id="tmp-phone-code" class="login2" style="display:none;">
					<span><input type="text" class="it " id="phone-code" name="phoneCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span>
					<a id="btn_auth" href="#" class="bt2">인증확인</a>
				</p>
				<p class="time" id="limit_time_txt" style="display:none;"></p>
				<input type="hidden" id="phone-key" name="phoneKey"/>
			</div>
		</div>
		
	</div>
	
	<jsp:include page="/WEB-INF/views/mobile/member/join-terms.jsp"/>

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>