<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0 });
	});
	
	function fn_memberJoin() {
		
		if($("#userName").val() == "") {
			// 이름을 입력해주세요.
			alert('<spring:message code="message.common.header.002" arguments="이름을"/>');
			$("#userName").focus();
			return;
		} else if($("#userName").val().length < 2) {
			// 이름은 한글로 2~15자 까지 입력할 수 있습니다
			alert('<spring:message code="message.member.join.012"/>');
			$("#userName").focus();
			return;
		}

		if($("#nickname").val() == "") {
			// 닉네임을 입력해주세요.
			alert('<spring:message code="message.common.header.002" arguments="닉네임을"/>');
			$("#nickname").focus();
			return;
		} else if($("#nickname").val().length < 2) {
			// 닉네임은 한글로 2~15자 까지 입력할 수 있습니다
			alert('<spring:message code="message.member.join.013"/>');
			$("#nickname").focus();
			return;
		} else if(!chkNickname) {
			// 닉네임 중복 체크를 해주세요.
			alert('<spring:message code="message.member.join.017"/>');
			return false;
		}
		
		if( $("#regionCd").val() == "" ) {
			// 동정보를 선택해주세요
			alert('<spring:message code="message.member.join.015"/>');
			$("#regionCd").focus();
			return;
		}
		
		// 등록하시겠습니까?
		if(confirm('<spring:message code="message.common.header.004"/>')) {
			fn_setJoinInfo();
			$("#joinForm").attr("action", "/member/join-email-proc");
			$("#joinForm").attr("method", "POST");
			$("#joinForm").submit();		
		}
		
	}
	
	function fn_setJoinInfo() {
		$("#tmpTerms1").val($("#ck_terms1").hasClass("on") ? "Y" : "N");
		$("#tmpTerms2").val($("#ck_terms2").hasClass("on") ? "Y" : "N");
		$("#tmpTerms3").val($("#ck_terms3").hasClass("on") ? "Y" : "N");
		
		$("#tmpBirthYear").val($("#birthYear").val());
		$("#tmpBirthMonth").val($("#birthMonth").val());
		$("#tmpBirthDate").val($("#birthDate").val());
		$("#tmpPhoneNumber").val($("#phoneNumber").val());
		$("#tmpPhoneCode").val($("#phoneCode").val());
		$("#tmpPhoneKey").val($("#phoneKey").val());
		
		$("#tmpUserEmail").val($("#email").val());
		$("#tmpUserPass").val($("#pass1").val());
		
		$("#tmpUserName").val($("#userName").val());
		$("#tmpNickname").val($("#nickname").val());
		$("#tmpRegionCd").val($("#regionCd").val());
		$("#tmpGender").val($("#gender").val());
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
	
	function fn_step4() {
		if(fn_step3Check()) {
			$("#div-join-step1").hide();
			$("#div-join-step2").hide();
			$("#div-join-step3").hide();
			$("#div-join-step4").show();
		}
	}
	
	//=========================================================================
	// JOIN STEP 2
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
	            url: '/member/phone-auth-req',
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
	        url: '/member/phone-auth-check',
	        dataType: 'json',
	        data: {"phone":phone,"code":code,"key":key},  
	        success: function (data) {
	        	if(data.result == true) {
	        		// 인증되었습니다.
	        		alert('<spring:message code="message.login.phone.008"/>');
	        		clearInterval(timer);
	        		$("#btn_next").show();
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
	

	//=========================================================================
	// JOIN STEP 3
	//=========================================================================
		
	var chkEmail = false;
	
	function fn_checkEmail() {
		var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		if( $("#email").val() == "" ) {
			// 이메일 주소를 입력해주세요
			alert('<spring:message code="message.common.header.002" arguments="이메일 주소를"/>');
			$("#email").focus();
			return;
		} else {
	        if(!regEmail.test($("#email").val())) {
	        	// 잘못된 이메일 주소 입니다. 이메일 주소를 확인한 다음 다시 입력해 주세요.
	        	alert('<spring:message code="message.login.email.004"/>');
	            $("#email").focus();
	            return false;
	        }
		}
		$.ajax({
			type : "POST",
			url : "/member/check-email",
			data : {
				"email" : $("#email").val()
			},
			success : function(data) {
				if (data == true) {
					// 사용가능한 이메일입니다.
					alert('<spring:message code="message.member.join.020"/>');
					chkEmail = true;
				} else {
					// 이미 등록된 이메일입니다
					alert('<spring:message code="message.member.join.008"/>');
					$("#email").val("");
					$("#email").focus();
				}
			},
			error : function(error) {
				console.log(error);
			}
		});
	}
	
	function fn_changeEmail() {
		chkEmail = false;
	}
	
	function fn_step3Check() {
	
		var email = $("#email").val();
		var pass1 = $("#pass1").val();
		var pass2 = $("#pass2").val();
		
		if (email == ""){
			// 이메일을 입력해주세요
			alert('<spring:message code="message.common.header.002" arguments="이메일을"/>');
			return false;
		} else if (pass1 == "") {
			// 비밀번호를 입력해주세요
			alert('<spring:message code="message.member.join.009"/>');
			return false;
		} else if (pass1.length < 6) {
			// 6~16자의 비밀번호를 입력하세요
			alert('<spring:message code="message.member.join.010"/>');
			return false;
		} else if (pass1 != pass2) {
			// 비밀번호가 일치하지 않습니다
			alert('<spring:message code="message.member.join.011"/>');
			return false;
		} else if (!chkEmail) {
			// 닉네임 중복 체크를 해주세요.
			alert('<spring:message code="message.member.join.021"/>');
			return false;
		} else {
			return true;
		}
	}

	//=========================================================================
	// JOIN STEP 4
	//=========================================================================
	
	var chkNickname = false;
		
	function fn_checkNickname() {
		
		if($("#nickname").val() == "") {
			// 닉네임을 입력해주세요
			alert('<spring:message code="message.common.header.002" arguments="닉네임을"/>');
			$("#nickname").focus();
			return;
		} else if($("#nickname").val().length < 2) {
			// 닉네임은 한글로 2~15자 까지 입력할 수 있습니다
			alert('<spring:message code="message.member.join.013"/>');
			$("#nickname").focus();
			return;
		}
		
		$.ajax({
			type : "POST",
			url : "/member/check-nickname",
			data : {
				"nickname" : $("#nickname").val()
			},
			success : function(data) {
				if (data == true) {
					// 사용가능한 닉네임입니다.
					alert('<spring:message code="message.member.join.022"/>');
					chkNickname = true;
				} else {
					// 이미 사용중인 닉네임입니다
					alert('<spring:message code="message.member.join.014"/>');
					$("#nickname").val("");
					$("#nickname").focus();
				}
			},
			error : function(error) {
				console.log(error);
			}
		});
	}
	
	function fn_changeNickname() {
		chkNickname = false;
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
		<span>회원가입</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<div class="lnb">
			<h2 class="lnbTit">회원가입</h2>
			<ul class="">
				<li><a href="/member/join-email">이메일로 가입</a></li>
			</ul>
		</div>
		
		
		<div class="contentsWrap">
			<h3 class="contentTit">이메일로 가입</h3>
						
			<!-- join step 1 -->
			<div id="div-join-step1" class="contents paddingnone">
				<img src="${siteImgPath}/etc/stepMail1.png" alt="약관동의 > 휴대폰인증 > 회원정보등록 > 기본정보등록 중 1단계 약관동의"/>
				<div class="step1">
					<p class="tit">이용약관 및 개인정보 수집ㆍ이용 동의</p>
					<p class="allChk">
						<a href="#" class="chk">전체동의</a>
						<span>이용약관(필수), 개인정보 수집,이용(필수), 개인정보 수집, 이용(선택)에 모두 동의합니다.</span>
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
						<li>
							<a href="#" class="chk" id="ck_terms3">개인정보 수집, 이용 동의<span>(선택)</span></a>
							<a href="#" class="more" onclick="openTermsLayer(3); return false;">전체보기</a>
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
				<img src="${siteImgPath}/etc/stepMail2.png" alt="약관동의 > 휴대폰인증 > 회원정보등록 > 기본정보등록 중 2단계 휴대폰인증"/>
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
							</div>
						</fieldset>

					<a id="btn_next" href="#" class="next" onclick="fn_step3(); return false;">다음</a>
				</div>
			</div>
			
			<!-- join step 3 -->
			<div id="div-join-step3" class="contents paddingnone" style="display: none;">
				<img src="${siteImgPath}/etc/stepMail3.png" alt="약관동의 > 휴대폰인증 > 회원정보등록 > 기본정보등록 중 3단계 회원정보등록"/>
				<div class="step3">
					<p class="tit">회원정보등록
						<span>회원가입 시 추가적인 인증없이 로그인을 통해<br/><strong>참여예산 정책제안</strong>을 사용할 수 있습니다</span>
					</p>

						<fieldset id="" class="">
							<div class="mail">
								<strong>이메일</strong>
								<p><span><input type="text" class="it" id="email" name="email" title="" placeholder="아이디로 사용할 이메일을 입력하세요" onchange="fn_changeEmail();"/></span><a href="#" class="an" onclick="fn_checkEmail(); return false;">중복확인</a></p>
							</div>
							<div class="password">
								<strong>비밀번호</strong>
								<p><input type="password" class="it" title="" placeholder="비밀번호를 입력하세요(6~16자)" maxlength="16" id="pass1"/></p>
								<p><input type="password" class="it" title="" placeholder="비밀번호를 재입력하세요" maxlength="16" id="pass2"/></p>
							</div>
						</fieldset>

					<a href="#" class="next" onclick="fn_step4(); return false;">다음</a>
				</div>
			</div>
			
			<!-- join step 4 -->
			<div id="div-join-step4" class="contents paddingnone" style="display:none;">
				<img src="${siteImgPath}/etc/stepMail4.png" alt="약관동의 > 휴대폰인증 > 회원정보등록 > 기본정보등록 중 4단계 기본정보등록"/>
				<div class="step3">
					<p class="tit">기본정보등록
						<span>기본정보등록 후 이름, 닉네임, 성별은 수정할 수 없습니다.<br/>입력한 정보를 다시 한 번 확인하시고 등록해주세요.</span>
					</p>

						<fieldset id="" class="">
							<div class="name">
								<strong>이름</strong>
								<p><input type="text" class="it" title="" id="userName" name="userName" placeholder="이름을 입력해주세요" maxlength="15"/></p>
							</div>
							<div class="nick">
								<strong>닉네임</strong>
								<p><span><input type="text" class="it" title="" id="nickname" name="nickname"  placeholder="닉네임을 입력해주세요" maxlength="15" onchange="fn_changeNickname();"/></span><a href="#" onclick="fn_checkNickname(); return false;" class="an">중복확인</a></p>
							</div>
							<div class="area">
								<strong>지역</strong>
								<p>
									<span><c:out value="${sidoNm} ${sggNm}"/></span>
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

					<a href="#" class="memberEnd" onclick="fn_memberJoin(); return false;">등록</a>
				</div>
			</div>
			
		</div>
		
		<input type="hidden" name="phoneKey" id="phoneKey"/>
		<input type="hidden" name="gender" id="gender" value="M"/>
		
		<form id="joinForm" name="joinForm">
			<input type="hidden" name="terms1" id="tmpTerms1"/>
			<input type="hidden" name="terms2" id="tmpTerms2"/>
			<input type="hidden" name="terms3" id="tmpTerms3"/>
			<input type="hidden" name="birthYear" id="tmpBirthYear"/>
			<input type="hidden" name="birthMonth" id="tmpBirthMonth"/>
			<input type="hidden" name="birthDate" id="tmpBirthDate"/>
			<input type="hidden" name="phoneNumber" id="tmpPhoneNumber"/>
			<input type="hidden" name="phoneCode" id="tmpPhoneCode"/>
			<input type="hidden" name="phoneKey" id="tmpPhoneKey"/>
			<input type="hidden" name="userEmail" id="tmpUserEmail"/>
			<input type="hidden" name="userPass" id="tmpUserPass"/>
			<input type="hidden" name="userName" id="tmpUserName"/>
			<input type="hidden" name="nickname" id="tmpNickname"/>
			<input type="hidden" name="regionCd" id="tmpRegionCd"/>
			<input type="hidden" name="gender" id="tmpGender"/>
		</form>
		
	</div>
	
</div>

<jsp:include page="/WEB-INF/views/front/member/join-terms.jsp"/>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
