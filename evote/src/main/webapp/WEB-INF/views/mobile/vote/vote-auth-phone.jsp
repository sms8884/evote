<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<script language="javascript" type="text/javascript">

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

</script>

</head>
<body>

<div id="header" class="etc">
	<a href="#" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>투표 참여하기</h2>
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


<div class="wrap">

	<div id="div-join-step1">
		
		<p class="memberTit">약관동의</p>
		<ul class="memberStep memberStep2">
			<li class="step1 on"><span><span>약관동의</span></span></li>
			<li class="step2"><span><span>휴대폰인증</span></span></li>
			<li class="step4"><span><span>기본정보등록</span></span></li>
		</ul>
	
		<p class="allChk">
			<a href="#" class="chk">전체동의</a>
			<span>이용약관(필수), 개인정보 수집ㆍ이용(필수)에 모두 동의합니다.</span>
		</p>
	
		<ul class="chkArea">
			<li>
				<a href="#" class="chk" id="ck_terms1">이용약관 동의<span>(필수)</span></a>
				<a href="#" class="more " onclick="openTermsLayer(1); return false;">전체보기</a>
			</li>
			<li>
				<a href="#" class="chk" id="ck_terms2">개인정보 수집ㆍ이용 동의<span>(필수)</span></a>
				<a href="#" class="more " onclick="openTermsLayer(2); return false;">전체보기</a>
			</li>
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
		</div>
	
	</div>

	
	<div id="div-join-step2" style="display: none;">
	
		<p class="memberTit">휴대폰인증</p>
		<ul class="memberStep memberStep2">
			<li class="step1"><span><span>약관동의</span></span></li>
			<li class="step2 on"><span><span>휴대폰인증</span></span></li>
			<li class="step4"><span><span>기본정보등록</span></span></li>
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
					<span><input type="text" class="it " id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" ngth="15"/></span>
					<a id="btn_request" href="#" class="bt1">인증번호요청</a>
				</p>
				<p class="login2" id="tmp-phone-code" style="display:none;">
					<span><input type="text" class="it " id="phone-code" name="phoneCode" placeholder="인증번호를 입력하세요"/></span>
					<a id="btn_auth" href="#" class="bt2">인증확인</a>
				</p>
				<p class="time" id="limit_time_txt" style="display:none;"></p>
				<input type="hidden" id="phone-key" name="phoneKey"/>
			</div>
			
		</div>

		<div class="memeberNext">
			<a id="btn_next" href="#" class="next" onclick="fn_step3(); return false;" style="display: none;">다음</a>
		</div>		
		
	</div>

	<div id="div-join-step3" style="display:none">
	
		<p class="memberTit">기본정보등록</p>
		<ul class="memberStep memberStep2">
			<li class="step1"><span><span>약관동의</span></span></li>
			<li class="step2"><span><span>휴대폰인증</span></span></li>
			<li class="step4 on"><span><span>기본정보등록</span></span></li>
		</ul>
	
		<div class="member4step">
			<p class="txt">투표 참여를 위한 기본정보를 등록해주세요.</p>
			<div class="memb">
				<p class="tit">지역</p>
				<p class="area">
					<span><c:out value="${sidoNm}"/>&nbsp;<c:out value="${sggNm}"/></span>
					<select id="regionCd" name="regionCd">
						<option value="">동 선택</option>
						<c:forEach var="list" items="${emdList}">
							<option value="<c:out value="${list.regionCd}"/>"><c:out value="${list.emdNm}"/></option>
						</c:forEach>
					</select>
				</p>
			</div>
			<div class="memb">
				<p class="tit">성별</p>
				<p class="gender">
					<a id="gender_M" href="#" class="on"><span>남자</span></a>
					<a id="gender_F" href="#"><span>여자</span></a>
				</p>
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
		
				<a href="#" class="loginBt loginBt2" onclick="visitorLogin(); return false;">비회원 투표참여</a>
	
			</div>
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
			
	<jsp:include page="/WEB-INF/views/mobile/member/join-terms.jsp"/>

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>