<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

//<![CDATA[
$(document).ready(function(){
	setProgress()
	if('${bizItem.state}'=='완료'){
		$("#progressBox").css("display","none");
	}
	/* 공감선택여부 */
	var sympathy = '${bizItem.sympathy}'
	if(sympathy != "" && sympathy != null){
		$("#sympathy").removeClass('heartNo').addClass('heartLock');
	}else{
		$("#sympathy").removeClass('heartLock').addClass('heartNo');
	}
	/*//공감선택여부 */
	
		snsStyle();
});

	function snsStyle(){
		  $(".sns")
		    .css("padding","5px 18px")
		    .css("width","200px");
	}
function setProgress(){
		var progress = ${bizItem.progress};
		$("#progressBar").width(progress+"%");
	}
	
	
function sympathy(bizSeq){
	var moveUrl = '';
	if('${sessionScope._accountInfo}' ==''){
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 300 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
	}else{
		if($('#sympathy').hasClass('heartLock') === true){
			moveUrl = '/biz/remove_sympathy/'
		}else{
			moveUrl = '/biz/add_sympathy/'
		}
		
		$.ajax({
 			url: moveUrl+bizSeq
 			,type:'POST'
 			,dataType:"json"
 			,success: function(data){
 				$("#sympathyText").text(data);
 				if($('#sympathy').hasClass('heartLock') === true){
 						$("#sympathy").attr("class","heartNo")
 				}else{
 						$("#sympathy").attr("class","heartLock")
 				}
 			}
 			 , error: function(xhr, status, error) {
 	        	if (console && console.log) console.log("error : " + error.message);
 	        }
 		});
	}
	
}
	function facebook(bizSeq){
		var moveUrl = 'http://www.facebook.com/sharer/sharer.php?u=http://ep.e-gov.co.kr/biz/biz_view/'+bizSeq;
		    window.open(moveUrl);
	}
	

//]]>
</script>
</head>
<body>
<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->
<div class="wrap">
	<div class="titlebox">
		제안 사업 현황
	</div>
	<div class="containerWrap">
		<div class="contents pd0">
			
			<div class="boardView">
			
				<div class="titleBox">
						<c:if test="${bizItem.state eq '실행중'}">
							<p class="dudget_ingTxt"><span>실행중</span></p>
						</c:if>
						<c:if test="${bizItem.state eq '완료'}">
		     				<p class="dudget_endTxt"><span>완료사업</span></p>
						</c:if>

					<p class="tit"><c:out value="${bizItem.biz_name}"/></p>
					<p class="won"><span>소요예산 <fmt:formatNumber pattern="#,###" value="${bizItem.budget}" type="number"/> <em>천원</em></span></p>
					<div class="graphWrap">
						<span class="graph"><em id="progressBar" ></em></span>
						<strong class="num"><c:out value="${bizItem.progress}"/>%</strong>
					</div>
				</div>
			
				<table cellpadding="0" cellspacing="0" class="tbL budgetTable" summary="" >
					<colgroup>
						<col width="80"/><col width="*"/>
					</colgroup>
					<tbody>
						<!-- 첨부파일 -->
									<tr>
										<th scope="row">첨부파일</th>
										<c:if test="${not empty bizItem.attachList}">
										<c:forEach items = "${bizItem.attachList}" var="list">
											<td ><a href="/file-download/${list.fileSeq}"><c:out value="${list.fileSrcNm}"/></a></td>
										</c:forEach>
										</c:if>
										<c:if test="${empty bizItem.attachList}">
										<td ><a href="#">파일없음</a></td>
										</c:if>
									</tr>
								<!-- //첨부파일 -->
						<tr>
							<th scope="row">사업개요</th>
							<td>
								<c:out value="${fn:replace(bizItem.summary, crcn, br)}" escapeXml="false"/>
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2">추진계획</th>
						</tr>
						<tr>
							<td colspan="2" class="bln">
								<div class="tbCon">
									<c:out value="${fn:replace(bizItem.plan, crcn, br)}" escapeXml="false"/>
								</div>
								<div class="galImgBox">
									<p class="img">
											<c:if test="${not empty bizItem.imageList}">
												<c:forEach items="${bizItem.imageList}" var="list">
													<img src="/file-download/${list.fileSeq}" alt="" style="max-width: 100%;" />
												</c:forEach>
											</c:if>
									</p>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">추진실적</th>
							<td>
								<c:out value="${fn:replace(bizItem.result, crcn, br)}" escapeXml="false"/>
							</td>
						</tr>
						<tr>
							<th scope="row">추진부서</th>
							<td><c:out value = "${bizItem.dept}"/></td>
						</tr>
						<tr>
							<th scope="row">향후일정</th>
							<td>
								<c:out value="${fn:replace(bizItem.schedule, crcn, br)}" escapeXml="false"/>
							</td>
						</tr>
					</tbody>
				</table>						
				<a href="javascript:history.back();" class="listBt">목록보기</a>

				<a class="" id="sympathy" onclick="sympathy(${bizItem.biz_seq})" ><span id="sympathyText"><c:out value = "${bizItem.sympathyCnt}"/></span></a>

			<!-- sns -->
			<div align="center">
				<script language="javascript" type="text/javascript">
					var sh_title = "은평구 사업현황";
			   		var sh_url = location.href;			
				</script>
				<jsp:include page="/WEB-INF/views/common/sns.jsp">
					<jsp:param name="dest" value="biz"/>
				</jsp:include>
			</div>
			<!-- //sns -->
							
				<!--로그인팝업  -->
				<div id="loginLayer" class="layer_block layerPop">
					<p class="layerTit">
						<strong>로그인</strong>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
					</p>
					<div class="layerCont">
						<p style="margin: 10px 0 10px 0; text-align: center;"><strong><spring:message code="message.proposal.013"/></strong></p>
						<p class="bt">
							<a href="/member/join" class="ok" style="float:none;"><span>회원가입</span></a>
							<a href="/login" class="ok" style="float:none;"><span>로그인</span></a>
						</p>
					</div>
				</div>
				<!--//로그인팝업  -->
				
			</div>
			
		</div>	
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
	
</div>

</body>
</html>
