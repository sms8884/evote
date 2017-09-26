<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<title><spring:message code="default.front.title" /></title>

<!--[if lt IE 9]>
<script src="${commonJsPath}/jquery-1.12.4.min.js"></script>
<![endif]-->
<!--[if gte IE 9]>
<script src="${commonJsPath}/jquery-2.2.4.min.js"></script>
<![endif]-->
<!--[if !IE]> -->
<script src="${commonJsPath}/jquery-2.2.4.min.js"></script>
<!-- <![endif]-->

<!-- script library -->
<!-- jquery placeholder -->
<script src="${resourcePath}/library/placeholder/jquery.placeholder.min.js"></script>
<!-- jquery 쿠키 -->
<script src="${resourcePath}/library/cookie/jquery.cookie.js"></script>
<!-- jquery UI  -->
<script src="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${resourcePath}/library/jquery-ui-1.11.4.custom/jquery-ui.min.css"/>

<link href="${commonCssPath}/base.css" type="text/css" rel="stylesheet"  />

<!-- favicon -->
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
<link rel="icon" href="/favicon.ico" type="image/x-icon" />

<style type="text/css">
<!--

.popupAreaWrap{padding:10px;}
.popupArea{border:3px solid #000; border-radius:10px; width:495px;}
.popupArea h1{font-size:28px; padding:25px; line-height:25px; font-weight:normal;}

.subTitle{padding:25px 0; border-top:1px solid #e7e7e7; border-bottom:3px solid #000; font-size:30px; line-height:43px; text-align:center; font-weight:bold;}

.pu_contentBox{padding:10px 25px;}
.pu_table{width:100%; overflow:hidden;}
.pu_table tr{border-bottom:1px solid #e7e7e7;}
.pu_table tr:last-child{border-bottom:none; }
.pu_table tr th{font-size:20px; font-weight:bold; line-height:1.5; padding:18px 0; text-align:left;}
.pu_table tr td{font-size:20px; padding:18px 0; }
.pu_table tr.bottomImg{border:none;}
.pu_table tr.tbImgArea{}
.pu_table tr.tbImgArea th{padding:0;}
.pu_table tr.tbImgArea th img{width:100%; margin:5px 0;}

.vote_result{text-align:center; margin:20px 0;}
.vote_result a{background:#1278e1; width:100%; height:54px; text-align:center; display:inline-block; padding-top:23px; }
.vote_result a span{color:#fff;font-size:24px;display:inline-block;padding:3px 0 0;}
.vote_result a.ing span{padding:3px 0 0 40px;}

.popContet{display:inline-block; width:495px;}
.pp_right input[type="checkbox"]{width:20px;height:20px; margin-right:5px;}
.pp_right{float:right; font-size:14px; font-weight:bold; line-height:1.7; padding-top:10px}

//-->
</style>

<script language="javascript" type="text/javascript">
//<![CDATA[

	$(function() {
		$(".pp_right > label").on("click", function(e) {
			e.preventDefault();
			$.cookie("_p${bpSeq}", "done", { expires : 7, path : '/'});
			window.close();
		});
	});
 
//]]>
</script>
</head>
<body>

<c:choose>
	<c:when test='${bannerPop.dest eq "P"}'>
		<c:set var="destText1" value="진행중인 공모"/>
		<c:set var="destText2" value="공모기간"/>
		<c:set var="destText3" value="공모 신청하기"/>
	</c:when>
	<c:otherwise>
		<c:set var="destText1" value="진행중인 투표"/>
		<c:set var="destText2" value="투표기간"/>
		<c:set var="destText3" value="투표 참여하기"/>
	</c:otherwise>
</c:choose>

<div class="popupAreaWrap">
	<div class="popupArea">
		<h1 id="destText1"><c:out value="${destText1}"/></h1>
		
		<div class="subTitle" id="destTitle">
			<c:out value="${fn:replace(bannerPop.destTitle, crcn, br)}" escapeXml="false"/>
		</div>
		
		<div class="pu_contentBox">
			<table class="pu_table">
				<colgroup>
					<col style="width:25%"/>
					<col style="width:75%"/>
				</colgroup>
				<tbody>
					<tr>
						<th id="destText2"><c:out value="${destText2}"/></th>
						<td id="destDate">
							<fmt:formatDate value="${bannerPop.destStartDate}" pattern="yyyy.MM.dd"/>
							~
							<fmt:formatDate value="${bannerPop.destEndDate}" pattern="yyyy.MM.dd"/>
						</td>
					</tr>
					<tr class="tbImgArea">
						<th colspan="2">
							<img src="/file-download/${bannerPop.webImageList[0].fileSeq}" id="destImage" alt="팝업이미지" width="444px" height="279px"/>
						</th>
						<td></td>
					</tr>
				</tbody>
			</table>
			<div class="vote_result">
				<a href="#" ><span id="destText3"><c:out value="${destText3}"/></span></a>
			</div>
		</div>
	</div>
	<div class="popContet">
		<div class="pp_right">
			<label><input type="checkbox"/>일주일간 보지 않기</label>
		</div>
	</div>
</div>

</body>
</html>
