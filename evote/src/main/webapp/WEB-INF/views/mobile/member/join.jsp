<%-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
           
	$(function() {
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
	});
           

//]]>
function goBack(){
	window.history.back();
}
</script>

</head>
<body>

<div id="header" class="etc">
	<a href="javascript:goBack();" class="backBt"><img src="${siteImgPath}/common/topBack.png" alt=""/></a>
	<h2>회원가입</h2>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>
</div>


<div class="wrap">
		<div class="memberBox">
			<div class="memberTitle">
				휴대폰번호로 가입한 경우<br> 로그인 시 휴대폰인증이 필요합니다. <br><a href="/member/join-email" class="blueUnder">이메일로 회원가입</a> 시 추가적인 인증없이<br>로그인을 통해 참여예산 정책제안을 사용할 수 있습니다.
			</div>
			<div class="memberSelBox">
				<ul class="memberSel">
					<li>
						<strong class="pb">휴대폰번호로 가입</strong>
						<input type="button" class="ip bluebtn" id="" value="가입하기" name="" onclick="location.href='/member/join-phone'"/>
					</li>
					<li>
						<strong class="eb">이메일로 가입</strong>
						<input type="button" class="ip bluebtn" id="" value="가입하기" name="" onclick="location.href='/member/join-email'"/>
					</li>
				</ul>
			</div>	
		</div>
	
	

<a href="#topFixBt" class="topFixBt"><img src="${siteImgPath}/common/topBt.png" alt=""/></a>

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
</div>
</body>
</html>
 --%>