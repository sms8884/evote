<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

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

</script>

</head>
<body>

<div id="header" class="etc">
	<a href="#" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>정책제안 등록하기</h2>
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
				<form method="post" action="">
					<p class="login2">
						<span><input type="text" class="it " id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" ngth="15"/></span>
						<a href="javascript:fn_reqPhoneAuth();" class="bt1">인증번호요청</a>
					</p>
					<p class="login2" id="hidePhoneCode" style="display:none;">
						<span><input type="text" class="it " id="phoneCode" name="phoneCode" placeholder="인증번호를 입력하세요"/></span>
						<a href="javascript:fn_checkPhoneAuth();" class="bt2">인증확인</a>
					</p>
				</form>
				<p class="time" id="limit_time_txt" style="display:none;"></p>
				<input type="hidden" name="phoneKey" id="phoneKey"/>
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