<%@ page contentType="text/html; charset=utf-8" %>
<title><spring:message code="default.mobile.title" /></title>
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="format-detection" content="telephone=no" />
<!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"> -->
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
<meta property="og:image" content="${commonImgPath}/logo_meta.png">

<script src="${commonJsPath}/angular-1.5.8.min.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/jquery-2.2.4.min.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/jquery.slides.min.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/ellipsis.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/jquery.dotdotdot.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<!-- script library -->
<!-- jquery placeholder -->
<script src="${resourcePath}/library/placeholder/jquery.placeholder.min.js"></script>
<!-- jquery 쿠키 -->
<script src="${resourcePath}/library/cookie/jquery.cookie.js"></script>
<!-- jquery UI  -->
<script src="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.css"/>

<link href="${siteCssPath}/main.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/content.css" type="text/css" rel="stylesheet"  />

<c:if test="${fn:contains(header['user-agent'], 'iPhone')}">
<style type="text/css">
input, textarea, button {-webkit-appearance:none; -moz-appearance:none; appearance:none;}
input, textarea, button, select {-webkit-border-radius:0; -moz-border-radius:0; -o-border-radius:0; border-radius:0;}
</style>
</c:if>

<!-- site script -->
<script src="${commonJsPath}/common.js" language="javascript" type="text/javascript"></script>
<script src="${siteJsPath}/front.js" language="javascript" type="text/javascript"></script>
<script src="${siteJsPath}/slick.js" language="javascript" type="text/javascript"></script>

<!-- sns js -->
<script src='//developers.kakao.com/sdk/js/kakao.min.js'></script>
<script src="${commonJsPath}/sns.js" language="javascript" type="text/javascript"></script>

<!-- favicon -->
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
<link rel="icon" href="/favicon.ico" type="image/x-icon" />

<script language="javascript" type="text/javascript">

function preparing() {
	// 준비중입니다
	alert('<spring:message code="message.common.header.001"/>');
}

$(function() {
	$(".backBt").on("click", function() {
		history.back();
	});
});

</script>


