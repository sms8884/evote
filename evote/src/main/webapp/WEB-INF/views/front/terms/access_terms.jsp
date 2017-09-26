<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
 <head>
	<meta charset="UTF-8">
	<meta name="Generator" content="EditPlus®">
	<meta name="Author" content="">
	<meta name="Keywords" content="">
	<meta name="Description" content="">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
	<title><spring:message code="default.front.title" /></title>
	
	<script src="https://code.jquery.com/jquery-1.8.3.min.js"></script>
	<script src="${resourcePath}/library/cookie/jquery.cookie.js"></script>
	
	<script language="javascript" type="text/javascript">//20160706추가 스크립트추가
	 //<![CDATA[
		$(document).ready(function(){
			resizeDiv();
			$(window).on("resize", function(){
				resizeDiv();
			});	 
		});

		function resizeDiv(){
			var _height = Math.floor($(window).height() * 0.6);
			$(".termsList1").height(_height);
		}	
		
		function popupClose() {
			var mtype = $.cookie('mtype');
			if(mtype == "app") {
				history.back(-1); 
			} else {
				window.close();
			}
		}
	 //]]>
	 </script>
 </head>
 
 <body>
<style type="text/css">
<!--



.termsList1{
	width:100%;
	max-height:600px;
	margin:0 auto;
	padding:20px 0;
	text-align:left;
	line-height:1.7;
	overflow-y:scroll;
}

.terms1Box{
	width: 80%;
	height:100%;
	position: absolute;
	z-index:560;
	padding:0 10%;
	overflow:hidden;
	background-color: white;
	text-align: center;
	transition: All 0.2s ease;
	-webkit-transition: All 0.2s ease;
	-moz-transition: All 0.2s ease;
	-o-transition: All 0.2s ease;
}

.termsList1 dt{
	font-weight:bold;
}

.terms1_closeBtn{
	width: 23px;
	height: 23px;
	position: absolute;
	right:25px;
	top: 20px;
	background-image: url("${siteImgPath}/common/closebtn2.png");
	background-size:100%;
	background-repeat: no-repeat;
	background-position: center;
	cursor: pointer;
	z-index:180;
}

.terms1Title{
	font-size:30px;
	font-weight:bold;
	line-height:30px;
	padding:50px 0;
	text-align:center;
	border-bottom:1px solid #e4e4e4;
	margin: 0;
}

//-->
</style>


<div class="terms1Box">
		<div>
			<div class="terms1_closeBtn" onclick="popupClose();"></div>
			
			<div class="terms1_tabwrap">
				<p class="terms1Title"><c:out value="${terms.termsTitle}"/></p>
				
				<div class="termsList1">
					<c:out value="${fn:replace(terms.termsCont, entermark, '<br/>')}" escapeXml="false"/>	
				</div>

			</div>
		</div>
</div>	

  
</body>
</html>
