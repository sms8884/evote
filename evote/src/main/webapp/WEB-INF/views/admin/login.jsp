<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script type="text/javascript">

$(function(){
	
	$(".loginBt").on("click", login);
	$("#mgrId, #mgrPw").setEnter(login);
	
})

function login() {
	
	if(gfnValidation($("#mgrId"), "<spring:message code="message.common.header.002" arguments="아이디를" />") == false){
		return;
	}
	
	if(gfnValidation($("#mgrPw"), "<spring:message code="message.common.header.002" arguments="비밀번호를" />") == false){
        return;
    }
	
	$("#loginForm").attr("action", "/admin/login-proc");
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
						<form name="loginForm" id="loginForm">
							<fieldset id="" class="">
								<p><input type="text" class="it id" placeholder="아이디를 입력하세요" name="mgrId" id="mgrId"/></p>
								<p><input type="password" class="it pw" placeholder="비밀번호를 입력하세요" name="mgrPw" id="mgrPw"/></p>
								<a href="#" class="loginBt">로그인</a>
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
