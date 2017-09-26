<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ page import="java.io.*" %>
<%@ page isErrorPage="true" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<style type="text/css">
<!--
.Errorcontainer{border:1px solid #F7F7F7;
	width:99%;
	min-height: 430px;
	background:#F7F7F7;
	margin:0;
	display:block;
}
.errorTxt{
	width:auto; 
	color:#404040;
	margin:180px auto 0 auto;
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
	margin-bottom: 10px;
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
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">


	<div class="Errorcontainer">
		
		<div class="errorTxt">
			
			<div class="error_font20">
				시스템 오류가 발생 했습니다.
			</div>
			<div class="error_font15">
				<a href='/'>메인페이지로 이동</a>
			</div>
	
		</div>
	</div> 
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
	
</div>

</body>
</html>