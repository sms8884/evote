<%@ page contentType="text/html; charset=utf-8" %>
<title><spring:message code="default.front.title" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta property="og:image" content="${commonImgPath}/logo_meta.png">
<!--[if lt IE 9]>
<script src="${commonJsPath}/jquery-1.12.4.min.js"></script>
<![endif]-->
<!--[if gte IE 9]>
<script src="${commonJsPath}/jquery-2.2.4.min.js"></script>
<![endif]-->
<!--[if !IE]> -->
<script src="${commonJsPath}/jquery-2.2.4.min.js"></script>
<!-- <![endif]-->

<script src="${commonJsPath}/jquery.slides.min.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/ellipsis.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/common.js" language="javascript" type="text/javascript"></script>
<!-- sns js -->
<script src='//developers.kakao.com/sdk/js/kakao.min.js'></script>
<script src="${commonJsPath}/sns.js" language="javascript" type="text/javascript"></script>
<script src="${commonJsPath}/evote-file.js?n=1" language="javascript" type="text/javascript"></script>

<!-- script library -->
<!-- jquery placeholder -->
<script src="${resourcePath}/library/placeholder/jquery.placeholder.min.js"></script>
<!-- jquery 쿠키 -->
<script src="${resourcePath}/library/cookie/jquery.cookie.js"></script>
<!-- jquery UI  -->
<script src="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.css"/>

<link href="${siteCssPath}/content.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<!-- site script -->
<script src="${siteJsPath}/front.js" language="javascript" type="text/javascript"></script>

<!-- favicon -->
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
<link rel="icon" href="/favicon.ico" type="image/x-icon" />

<script language="javascript" type="text/javascript">
function preparing() {
	// 준비중입니다
	alert('<spring:message code="message.common.header.001"/>');
}
$(function() {
	$("input, textarea").placeholder();
});
</script>


