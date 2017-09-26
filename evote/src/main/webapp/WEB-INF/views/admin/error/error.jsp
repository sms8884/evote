<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ page import="java.io.*" %>
<%@ page isErrorPage="true" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<style type="text/css">
<!--
.Errorcontainer{border:1px solid #F7F7F7;
	width:99%;
	min-height:791px;
	background:#F7F7F7;
	margin:0;
	display:block;
}
.errorTxt{
	width:780px; 
	color:#404040;
	margin:230px auto 0 auto;
	text-align:center;
	line-height:1.7;
}
.error_font30{
	font-size:30px;
	font-weight:bold;
}
.error_font20{
	font-size:20px;
	font-weight:bold;
}
.error_font15{
	font-size:15px;
	font-weight:bold;
}
//-->
</style>

</head>
<body>
	
<!-- header -->
<jsp:include page="/WEB-INF/views/admin/common/header.jsp"/>
<!-- //header -->
		
<div class="Errorcontainer">
	
	<div class="errorTxt">
		
		<div class="error_font30">
			시스템 오류가 발생 했습니다.
		</div>
		<div class="error_font20">
			<a href='/'>메인페이지로 이동</a>
		</div>

	</div>
</div> 

<!-- footer -->
<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
<!-- //footer -->
	
</body>
</html>
