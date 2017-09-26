<%@ page contentType="text/html; charset=utf-8" %>

<a href="#topFixBt" class="topFixBt" style="z-index: 999;"><img src="${siteImgPath}/common/topBt.png" alt=""/></a>
<script language="javascript" type="text/javascript">
//<![CDATA[
$(document).ready(function(){
	$(window).scroll(function(){
		if($(this).scrollTop()>30){
			$('.topFixBt').fadeIn();
		}else{
			$('.topFixBt').fadeOut();
		}
	});
});
//]]>
</script>

<div class="footerWrap">
	<div class="footsns">
		<span>
			<a href="<spring:message code="default.mobile.homepage.url" />" target="_blank" class="sns1">은평구청 홈페이지</a>
			<a href="<spring:message code="default.mobile.facebook.url" />" target="_blank" class="sns2">페이스북</a>
			<a href="<spring:message code="default.mobile.twiter.url" />" target="_blank" class="sns3">트위터</a>
		</span>
	</div>
	<div class="footLink">
		<span>
			<a href="/terms/personal_terms" target="_blank">개인정보처리방침</a>
			<a href="/terms/access_terms" target="_blank">이용약관</a>
			<a href="http://jahasmart.com" class="point" target="_blank">자하스마트 홈페이지</a>
		</span>
	</div>
	<address>(03384) 서울시 은평구 은평로 195(녹번동)</address>
	<address> 문의전화 : 02-351-6475</address><!--20160826추가-->
	<cite>Copyright ⓒ JAHASMART All rights reserved.</cite>
</div>
