<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 3, d3:1});
	});
	
	function fn_step2() {
		if($("#ck_terms1").hasClass("on") && $("#ck_terms2").hasClass("on")) {
			$("#div-auth-step1").hide();
			$("#div-auth-step2").show();
		} else {
			// 필수 항목에 동의해야 진행할 수 있습니다
			alert('<spring:message code="message.member.join.001" />');
		}
	}
	
	//=========================================================================
	// AUTH STEP 2
	//=========================================================================
	
	var authLimitTime = "<spring:eval expression='@system[\'sms.auth.limit.time\']' />";
	var isTimeOut = false;
	var timer;
	
	function fn_timerStart() {
		clearInterval(timer);
		var counter = authLimitTime;
		var dpTime = "";
		$("#limit_time_txt").html(fn_getTimeString(counter));
		timer = setInterval(function () {
			$("#limit_time_txt").html(fn_getTimeString(counter-1));
			if(counter <= 0) {
				clearInterval(timer);
				// 시간초과
				$("#limit_time_txt").html('<spring:message code="message.login.phone.005" />');
				isTimeOut = true;
			}
			counter--;
		}, 1000);
	}

	function fn_reqPhoneAuth(){
		
		if( $("#birthMonth").val() == "" ) {
			// 생년월일을 입력해주세요
			alert('<spring:message code="message.member.join.006"/>');
			$("#birthMonth").focus();
			return;
		}
		if( $("#birthDate").val() == "" ) {
			// 생년월일을 입력해주세요
			alert('<spring:message code="message.member.join.006"/>');
			$("#birthDate").focus();
			return;
		}
		
		var birthdate = $("#birthYear").val() + $("#birthMonth").val() + $("#birthDate").val();
		var phoneNumber = $("#phoneNumber").val();
	    var numCheck = /^[0-9]*$/;

		if(!fn_checkAge()) {
			// 만 14세 미만은 이용이 제한됩니다
			alert('<spring:message code="message.member.join.018"/>');
			return;
		}
		
	    if(phoneNumber == ""){
	    	// 휴대전화번호를 입력해주세요
	    	alert('<spring:message code="message.member.join.005"/>');
	        $('#phoneNumber').focus();
	    }else if(!numCheck.test(phoneNumber)){
	    	// 잘못된 휴대폰번호입니다. 휴대폰번호를 확인한 다음 다시 입력해주세요.
	    	alert('<spring:message code="message.member.join.024"/>');
	    	$('#phoneNumber').val("");
	        $('#phoneNumber').focus();
	    }else {
	        $.ajax({
	            type: 'POST',
	            url: '/proposal/phone-auth-req',
	            dataType: 'json',
	            data: {"birthdate":birthdate,"phoneNumber":phoneNumber},
	            success: function (data) {
	            	if(data != undefined) {
	                	if(data.result == "Y") {
	                		fn_timerStart();
	                		isTimeOut = false;
	                		$("#phoneCode").val("");
	                		// 인증번호가 발송되었습니다.
	                		alert('<spring:message code="message.member.join.019"/>');
							$("#hidePhoneCode").show();
							//$("#btn_next").show();
							
	                		$("#limit_time_txt").show();
	                		// 인증번호 재요청
	                		$("#btn_request").text('<spring:message code="message.login.phone.007"/>');
	                		$("#phoneKey").val(data.key);
	                		
	                		$("#phoneNumber").prop("disabled", true);
	                	    $("#birthYear").prop("disabled", true);
	                		$("#birthMonth").prop("disabled", true);
	                		$("#birthDate").prop("disabled", true);
	                		
	                	} else if(data.result == "N") {
	                		alert(data.message);
	                	}
	            	}
	            },
	            error: function (jqXHR, textStatus, errorThrown) {
	                console.log(errorThrown);
	                console.log(textStatus);
	            }
	        });
	    }
	}

	function fn_checkPhoneAuth(){
		
		if(isTimeOut) {
    		// 인증 시간이 초과되었습니다.\n인증 번호를 다시 요청해주세요..
    		alert('<spring:message code="message.login.phone.009"/>');
			clearInterval(timer);
			return;
		}
		
		var phone = $("#phoneNumber").val();
		var code = $("#phoneCode").val();
		var key = $("#phoneKey").val();
			
		if(code == "") {
			// 인증번호를 입력해주세요
			alert('<spring:message code="message.member.join.023"/>');
			return;
		}
		
	    $.ajax({
	    	type: 'POST',
	        url: '/proposal/phone-auth-check',
	        dataType: 'json',
	        data: {"phone":phone,"code":code,"key":key},  
	        success: function (data) {
	        	if(data.result == true) {
	        		// 인증되었습니다.
	        		alert('<spring:message code="message.login.phone.008"/>');
	        		clearInterval(timer);
	        		location.href = "/proposal/write";
	        	} else {
	        		// 잘못된 인증번호입니다. 인증번호를 확인한 다음 다시 입력해주세요.
	        		alert('<spring:message code="message.member.join.002"/>');
	        		$("#phoneCode").val("");
	        	}
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	            console.log(errorThrown);
	            console.log(textStatus);
	        }
	    });
		
	}

	function fn_checkAge() {
		
	    var todayYear = parseInt(new Date().getFullYear()); 
	    var todayMonth = parseInt(new Date().getMonth() + 1);
	    var todayDate = parseInt(new Date().getDate());

	    var birthYear = parseInt($("#birthYear").val());
		var birthMonth = parseInt($("#birthMonth").val());
		var birthDate = parseInt($("#birthDate").val());
		
	    var age;
	    
	    if((todayMonth > birthMonth) || (todayMonth == birthMonth & todayDate >= birthDate)) {
	    	age = todayYear - birthYear + 1;
	    } else{ 
			age = todayYear - birthYear; 
	    }
	    
	    if((age-1) < 14) {
			return false;
	    } else {
			return true;
	    }

	}

	function fn_getTimeString(seconds) {
		var timeString = Math.floor(seconds/60);
		timeString = timeString + "분 ";
		if ( (seconds%60) < 10 ) { 
			timeString = timeString + "0";
		}
		timeString = timeString + (seconds%60);
		timeString = timeString + "초";
		return timeString;
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
		<span>주민참여예산제</span>
		<span>정책제안</span>
		<span>제안사업</span>
		<span>정책제안 등록하기</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="proposal"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">정책제안 등록하기</h3>

			<div id="div-auth-step1" class="contents paddingnone">
				<img src="${siteImgPath}/etc/stepNojoin.png" alt="개인정보 수집,이용 동의 > 휴대폰인증 중 1단계 개인정보 수집,이용 동의"/>
				<div class="step1">
					<p class="tit">이용약관 및 개인정보 수집ㆍ이용 동의</p>
					<p class="allChk">
						<a href="#" class="chk">전체동의</a>
						<span>이용약관(필수), 개인정보 수집ㆍ이용(필수), 개인정보 수집ㆍ이용(선택)에 모두 동의합니다.</span>
					</p>

					<ul class="">
						<li>
							<a href="#" class="chk" id="ck_terms1">이용약관 동의<span>(필수)</span></a>
							<!-- <a href="#?=460" class="more loginMbt1 layer" rel="loginMbtLayer">전체보기</a> -->
							<a href="#" class="more" onclick="openTermsLayer(1); return false;">전체보기</a>
						</li>
						<li>
							<a href="#" class="chk" id="ck_terms2">개인정보 수집ㆍ이용 동의<span>(필수)</span></a>
							<!-- <a href="#?=460" class="more loginMbt1 layer" rel="loginMbtLayer">전체보기</a> -->
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
					<!-- 					
					<div class="agreeBox">
						<a href="#" class="btAgree"><span>동의합니다</span></a>동의시 클라스"agree"추가
						<a href="#" class="btNotAgree"><span>동의하지않습니다</span></a>
					</div>
					-->
					<a href="#" class="next" onclick="fn_step2(); return false;">다음</a>
					
					<div class="loginMbtLayer layer_block">
						<p class="tit">이용약관</p>
						<div class="loginMbtLayerCon">
							<p class="txt1"></p>
							<p class="txt2"></p>
							<a href="#" class="bt layerClose2"><span>확인</span></a>
							<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
						</div>
					</div>
				</div>
			</div>
			
			<!-- join step 2 -->
			<div id="div-auth-step2" class="contents paddingnone" style="display: none;">
				<img src="${siteImgPath}/etc/stepNojoin2.png" alt="개인정보 수집,이용 동의 > 휴대폰인증 중 2단계 휴대폰인증"/>
				<div class="step2">
					<p class="tit">휴대폰 인증</p>
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
								<p><span><input type="text" class="it" id="phoneNumber" name="phoneNumber" title="" placeholder="휴대전화번호를 입력하세요" maxlength="15"/></span><a id="btn_request" href="javascript:fn_reqPhoneAuth();" class="pn">인증번호 요청</a></p>
								<p id="hidePhoneCode" style="display:none;"><span><input type="text" class="it" title="" id="phoneCode" name="phoneCode" placeholder="인증번호를 입력하세요"/></span><a href="javascript:fn_checkPhoneAuth();" class="an">인증 확인</a></p>
								<span class="time" id="limit_time_txt" style="display:none;"></span>
								<input type="hidden" name="phoneKey" id="phoneKey"/>
							</div>
						</fieldset>

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

