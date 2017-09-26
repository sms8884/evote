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
		$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0 });
	});
	
	function visitorLogin() {
		
		$("#tmpBirthYear").val($("#birthYear").val());
		$("#tmpBirthMonth").val($("#birthMonth").val());
		$("#tmpBirthDate").val($("#birthDate").val());
		$("#tmpPhoneNumber").val($("#phoneNumber").val());
		$("#tmpPhoneCode").val($("#phone-code").val());
		$("#tmpPhoneKey").val($("#phone-key").val());
		$("#tmpRegionCd").val($("#regionCd").val());
		
		$("#visitorForm").attr("action", "/vote/visitor/login-proc");
		$("#visitorForm").attr("method", "POST");
		$("#visitorForm").submit();
	}
	
	function fn_step2() {
		if($("#ck_terms1").hasClass("on") && $("#ck_terms2").hasClass("on")) {
			$("#div-join-step1").hide();
			$("#div-join-step2").show();
			$("#div-join-step3").hide();
			$("#div-join-step4").hide();
		} else {
			// 필수 항목에 동의해야 진행할 수 있습니다
			alert('<spring:message code="message.member.join.001" />');
		}
	}
	
	function fn_step3() {
		$("#div-join-step1").hide();
		$("#div-join-step2").hide();
		$("#div-join-step3").show();
		$("#div-join-step4").hide();
	}
	
	$(function() {

		$.phoneAuth({
			authRequestUrl:'/member/phone-auth-req',
			authCheckUrl:'/member/phone-auth-check',
			appendBirthdate:true,
			appendData:[
				{'appendFieldId':'birthMonth','validationMsg':'<spring:message code="message.member.join.006"/>'},
				{'appendFieldId':'birthDate','validationMsg':'<spring:message code="message.member.join.006"/>'}
			],
			callbackEvent:function(data) {
				$("#btn_next").show();
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
		<a href="/"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<a href="/vote/vote-main"><span>투표</span></a>
		<span>투표참여</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
	
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="vote"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">휴대폰 인증</h3>

			<!-- join step 1 -->
			<div id="div-join-step1" class="contents paddingnone">
				<img src="${siteImgPath}/etc/stepPhone1.png" alt="약관동의 > 휴대폰인증 > 기본정보등록 중 1단계 약관동의"/>
				<div class="step1">
					<p class="tit">이용약관 및 개인정보 수집ㆍ이용 동의</p>
					<p class="allChk">
						<a href="#" class="chk">전체동의</a>
						<span>이용약관(필수), 개인정보 수집ㆍ이용(필수)에 모두 동의합니다.</span>
					</p>

					<ul class="">
						<li>
							<a href="#" class="chk" id="ck_terms1">이용약관 동의<span>(필수)</span></a>
							<a href="#" class="more" onclick="openTermsLayer(1); return false;">전체보기</a>
						</li>
						<li>
							<a href="#" class="chk" id="ck_terms2">개인정보 수집, 이용 동의<span>(필수)</span></a>
							<a href="#" class="more" onclick="openTermsLayer(2); return false;">전체보기</a>
						</li>
					</ul>

					<script language="javascript" type="text/javascript">
					//<![CDATA[
						$('.allChk').find('.chk').on('click',function(){
							if ($(this).hasClass('on')){
								$(this).removeClass('on');
								$('.step1').find('ul').find('.chk').each(function(){
									$(this).removeClass('on');
								})
							}else{
								$(this).addClass('on');
								$('.step1').find('ul').find('.chk').each(function(){
									$(this).addClass('on');
								})
							}
								return false;
						})
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
			<div id="div-join-step2" class="contents paddingnone" style="display: none;">
				<img src="${siteImgPath}/etc/stepPhone2.png" alt="약관동의 > 휴대폰인증 > 기본정보등록 중 2단계 휴대폰인증"/>
				<div class="step2">
					<p class="tit">휴대폰 인증</p>

						<fieldset id="" class="">
							<p class="birth">
								<strong>생년월일</strong>
								<select id="birthYear" name="birthYear" title="" style="width:176px; margin:0;"></select>
								<select id="birthMonth" name="birthMonth" title="" style="width:124px;"></select>
								<select id="birthDate" name="birthDate" style="width:124px;"></select>
								<span>※만 14세 미만은 투표에 참여할 수 없습니다.</span>
							</p>
							<div class="certi">
								<strong>휴대폰 번호</strong>
								
								<input type="hidden" id="phone-key" name="phoneKey"/>
								<fieldset id="" class="">
									<p>
										<span><input type="text" class="it" id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" tabindex="1"/></span>
										<a id="btn_request" href="#" class="pn">인증번호 요청</a>
									</p>
									<p id="tmp-phone-code" style="display:none;">
										<span><input type="text" class="it" id="phone-code" name="phoneCode" placeholder="인증번호를 입력하세요" tabindex="2"/></span>
										<a id="btn_auth" href="#" class="an">인증 확인</a>
									</p>
									<span class="time" id="limit_time_txt" style="display:none;"></span>
								</fieldset>
								
							</div>
						</fieldset>

					<a id="btn_next" href="#" class="next" onclick="fn_step3(); return false;" style="display:none;">다음</a>
				</div>
			</div>

			<!-- join step 3 -->
			<div id="div-join-step3" class="contents paddingnone" style="display:none">
				<img src="${siteImgPath}/etc/stepPhone3.png" alt="약관동의 > 휴대폰인증 > 기본정보등록 중 3단계 기본정보등록"/>
				<div class="step3">
					<p class="tit">기본정보등록
						<span>투표 참여를 위한 기본정보를 등록해 주세요.</span>
					</p>

						<fieldset id="" class="">
							<div class="area">
								<strong>지역</strong>
								<p>
									<span><c:out value="${sidoNm}"/>&nbsp;<c:out value="${sggNm}"/></span>
									<select id="regionCd" name="regionCd">
										<option value="">동 선택</option>
										<c:forEach var="list" items="${emdList}">
											<option value="<c:out value="${list.regionCd}"/>"><c:out value="${list.emdNm}"/></option>
										</c:forEach>
									</select>
								</p>
							</div>
							<div class="gender">
								<strong>성별</strong>
								<ul class="">
									<li><a id="gender_M" href="#" class="on">남성</a></li>
									<li><a id="gender_F" href="#">여성</a></li>
								</ul>
							</div>
							<script language="javascript" type="text/javascript">
							//<![CDATA[
								$('.gender').find('a').each(function(){
									$(this).on('click',function(){
										$('.gender').find('a').removeClass('on');
										$(this).addClass('on');
										$("#gender").val($(this).attr("id").replace("gender_", ""));
										return false;
									})
								})
							//]]>
							</script>
						</fieldset>

					<a href="#" class="memberEnd" onclick="visitorLogin(); return false;">비회원 투표참여</a>
				</div>
			</div>
			
			<form id="visitorForm" name="visitorForm">
				<input type="hidden" name="birthYear" id="tmpBirthYear"/>
				<input type="hidden" name="birthMonth" id="tmpBirthMonth"/>
				<input type="hidden" name="birthDate" id="tmpBirthDate"/>
				<input type="hidden" name="phoneNumber" id="tmpPhoneNumber"/>
				<input type="hidden" name="phoneCode" id="tmpPhoneCode"/>
				<input type="hidden" name="phoneKey" id="tmpPhoneKey"/>
				<input type="hidden" name="regionCd" id="tmpRegionCd"/>
				<input type="hidden" name="gender" id="gender" value="M"/>
			</form>
		
		</div>
		
	</div>
</div>

<jsp:include page="/WEB-INF/views/front/member/join-terms.jsp"/>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>