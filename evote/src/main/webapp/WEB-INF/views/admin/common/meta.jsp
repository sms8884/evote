<%@ page contentType="text/html;charset=utf-8" language="java"%>
<title><spring:message code="default.admin.title" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv='cache-control' content='no-cache'>
<meta http-equiv='expires' content='0'>
<meta http-equiv='pragma' content='no-cache'>
<script src="${commonJsPath}/angular-1.5.8.min.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/jquery-2.2.4.min.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/common.js" language="javascript" type="text/javascript"></script>
<script src="${commonJsPath}/evote-file.js" language="javascript" type="text/javascript"></script>

<!-- script library -->
<!-- jquery placeholder -->
<script src="${resourcePath}/library/placeholder/jquery.placeholder.min.js"></script>
<!-- jquery 쿠키 -->
<script src="${resourcePath}/library/cookie/jquery.cookie.js"></script>
<!-- jquery UI  -->
<script src="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.css"/>

<script src="${siteJsPath}/admin.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<link href="${siteCssPath}/adContents.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
function preparing() {
	// 준비중입니다
	alert('<spring:message code="message.common.header.001"/>');
}

$(function() {
	$("input, textarea").placeholder();
});
    
</script>