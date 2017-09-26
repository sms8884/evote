<%@ page contentType="text/html; charset=utf-8" %>

<div id="header" class="header2">
	<h1 class="logo"><a href="/"><spring:message code="default.mobile.title" /></a></h1>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>
</div>
<script language="javascript" type="text/javascript">
//<![CDATA[
	$('.topBt').on('click',function(){
		if ($(this).hasClass('on')){
			$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_off'))
			$(this).removeClass('on').next('.topMenu').hide();
			$('.fade').remove();
		}else{
			$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_off','_on'))
			$(this).addClass('on').next('.topMenu').show();
			$('.fade').remove();
			$('.wrap').append('<div class="fade" style="width:100%; height:100%; background:#000; opacity:0.6; z-index:99; position:absolute; top:0; left:0;"></div>');
		}
	})
//]]>
</script>