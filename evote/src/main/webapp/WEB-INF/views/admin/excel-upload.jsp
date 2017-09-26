<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script type="text/javascript">

function login() {
	$("#loginForm").attr("action", "/admin/excel-upload");
	$("#loginForm").attr("method", "POST");
	$("#loginForm").submit();
}

</script>

</head>
<body>
	
	<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp"/>
	<!-- //header -->
		
	<div class="containerWrap">

		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li>로그인</li>
			</ul>
		</div>

	

		<div class="container">
			<div class="contentWrap">
				
				<div class="loginWrap">
					<h3 class="admTitle">로그인</h3>

					<div class="memberlogin">
						<form name="loginForm" id="loginForm" enctype="multipart/form-data">
							<fieldset id="" class="">
								<p><input type="file" name="excelFile"/></p>
								<a href="#" onclick="login(); return false;" class="loginBt">로그인</a>
							</fieldset> 
						</form>
					</div>
				</div>
			
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
