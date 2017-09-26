<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<script src="${commonJsPath}/evote-phone-auth.js" language="javascript" type="text/javascript"></script>

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<style type="text/css">
.idinquiry1 {
    font-size: 15px;
    color: black;
    padding: 30px 0 0 0;
    text-align: center;
    line-height: 140%;
    
}
.idinquiry2 {
    font-size: 20px;
    color: black;
    padding: 20px 0;
    text-align: center;
    line-height: 140%;
    font-weight: bold;
}
</style>

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		
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
		});
		
		$("#userNm").focus();

		$.phoneAuth({
			authRequestUrl:'/inquiry/userid-req',
			authCheckUrl:'/inquiry/userid-auth-check',
			appendData:[
				{'appendFieldId':'userNm','validationMsg':'이름을 입력해주세요'}
			],
			callbackEvent:function(data) {
        		$('#layer_userid').text(data.email);
        		$('#div_idinquiry1').hide();
        		$('#div_idinquiry2').show();
			}
		});

	});

//]]>
</script>
</head>
<body>

<div id="header" class="etc">
	<a href="#" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>아이디/비밀번호 찾기</h2>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>

</div>

<div class="wrap">
	<ul class="loginTab">
		<li><a id="login1" href="/inquiry/userid" class="on">아이디 찾기</a></li>
		<li><a id="login2" href="/inquiry/userpw">비밀번호 찾기</a></li>
	</ul>

	<div id="div_idinquiry1">

		<div class="member4step">
	
			<div class="memb">
				<p class="login1">
					<input type="text" class="it " id="userNm" name="userNm" placeholder="이름을 입력해주세요" maxlength="15"/>
				</p>
			</div>
		</div>
		
		<div class="phoneArea">
			<div class="login" style="padding-top: 10px;">
				<p class="login2">
					<span><input type="text" class="it " id="phoneNumber" name="phoneNumber" placeholder="휴대전화번호를 입력하세요" maxlength="15"/></span>
					<a id="btn_request" href="#" class="bt1">인증번호요청</a>
				</p>
				<p class="login2" id="tmp-phone-code" style="display:none;">
					<span><input type="text" class="it " id="phone-code" name="phone-code" placeholder="인증번호를 입력하세요"/></span>
					<a id="btn_auth" href="#" class="bt2">인증확인</a>
				</p>
				<input type="hidden" id="phone-key" name="phoneKey"/>
				<p class="time" id="limit_time_txt" style="display:none;"></p>
			</div>
		</div>
	
	</div>

	<div id="div_idinquiry2" style="display: none;">
		<div class="member4step">
			<p class=idinquiry1>회원님의 아이디를 확인해주세요.</p>
			<p id="layer_userid" class="idinquiry2"></p>
		</div>
	</div>
		
	
	
</div>
<!-- footer -->
<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
