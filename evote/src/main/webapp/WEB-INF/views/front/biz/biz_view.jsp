<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<style type="text/css">
a.heartLock { 
	padding:19px 84px; border:3px solid #ec4849; background:url(${siteImgPath}/sub1/ok_on.gif) 54px 50% no-repeat; display: inline-block;
}
</style>

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 4});
		setProgress()
		if('${bizItem.state}'=='완료'){
			$("#progressBox").css("display","none");
		}
		/* 공감선택여부 */
		var sympathy = '${bizItem.sympathy}'
		if(sympathy != "" && sympathy != null){
			$("#sympathy").removeClass('heart').addClass('heartLock');
		}else{
			$("#sympathy").removeClass('heartLock').addClass('heart');
		}
		/*//공감선택여부 */
		
	});
	
	function setProgress(){
 		var tmpProgress = ${bizItem.progress};
 		var progress = tmpProgress/100*400
 		$("#progressBar").width(progress)
 		
 	}
	function sympathy(bizSeq){
		var moveUrl = '';
		if('${sessionScope._accountInfo}' ==''){
			alert("공감 하시려면 로그인을 해주세요")
		}else{
			if($('#sympathy').hasClass('heartLock') === true){
				moveUrl = '/biz/remove_sympathy/'
				$("#sympathy").removeClass('heartLock').addClass('heart');
			}else{
				moveUrl = '/biz/add_sympathy/'
				$("#sympathy").removeClass('heart').addClass('heartLock');
			}
			
			$.ajax({
	 			url: moveUrl+bizSeq
	 			,type:'POST'
	 			,dataType:"json"
	 			,success: function(data){
	 				$("#sympathy").text(data);
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
	
	function list() {
		$("#searchForm").attr("action", "/biz/biz_list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();
	}
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>주민참여예산제</span>
		<span>사업현황</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="proposal"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">사업현황</h3>
			<div class="contents">
				<div class="businessNotice">
					<c:if test="${bizItem.state eq '실행중'}">
						<p class="businessI">실행중</p>
					</c:if>
					<c:if test="${bizItem.state eq '완료'}">
						<p class="businessE">완료</p>
					</c:if>
					<!--사업명  -->
						<p class="businessNt"><c:out value="${bizItem.biz_name}"/></p>
					<!--//사업명  -->
					<!--소요예산및 진행상황  -->
						<div class="price">
							<p class="priceImg"><img src="${siteImgPath}/vote/won_bg.gif" alt=""></p>
							<p class="priceTxt">소요예산 <fmt:formatNumber pattern="#,###" value="${bizItem.budget}" type="number"/> <span class="priceUnit">천원</span></p>
						</div>
						<div class="businessPer" id="progressBox">
							<p class="businessPer_back"></p>
							<p class="businessPer_front" id="progressBar" ></p>
							<p class="businessPer_txt"><c:out value="${bizItem.progress}"/>%</p>
							
						</div>
					<!--//소요예산및 진행상황  -->
				</div>
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="제안사업 상세보기 - 등록자, 등록일, 조회수, 처리상태, 소요사업비, 사업기간, 사업위치, 제안취지, 내용, 기대효과, 사진, 신청서 등록 정보를 보는 화면입니다." >
						<caption>사업현황 상세보기</caption>
						<colgroup>
							<col width="15%"/>
							<col width="60%"/>
						</colgroup>
						<tbody>
						<!-- 첨부파일 -->
							<tr>
								<th scope="row">첨부파일</th>
								<c:if test="${not empty bizItem.attachList}">
								<c:forEach items = "${bizItem.attachList}" var="list">
									<td colspan="5"><a href="/file-download/${list.fileSeq}"><c:out value="${list.fileSrcNm}"/></a></td>
								</c:forEach>
								</c:if>
								<c:if test="${empty bizItem.attachList}">
								<td colspan="5"><a href="#">파일없음</a></td>
								</c:if>
							</tr>
						<!-- //첨부파일 -->
							<tr>
								<th scope="row">사업개요</th>
								<td colspan="5">
									<c:out value="${fn:replace(bizItem.summary, crcn, br)}" escapeXml="false"/>
								</td>
							</tr>
							<!-- 추진계획 -->
							<tr>
								<th scope="row">추진계획</th>
								<td colspan="5">
									<c:out value="${fn:replace(bizItem.plan, crcn, br)}" escapeXml="false"/>
									<p style="margin-top:10px;">
									
									<c:if test="${not empty bizItem.imageList}">
										<c:forEach items="${bizItem.imageList}" var="list">
											<img src="/file-download/${list.fileSeq}" alt="" style="max-width: 600px;"/>
										</c:forEach>
									</c:if>
										
									</p>
								</td>
							</tr>
							<!-- //추진계획 -->
							<tr>
								<th scope="row">추진실적</th>
								<td colspan="5">
									<c:out value="${fn:replace(bizItem.result, crcn, br)}" escapeXml="false"/>
								</td>
							</tr>
							<tr>
								<th scope="row">향후일정</th>
								<td colspan="5">
									<c:out value="${fn:replace(bizItem.schedule, crcn, br)}" escapeXml="false"/>
								</td>
							</tr>
							<tr>
								<th scope="row">추진부서</th>
								<td colspan="5"><c:out value = "${bizItem.dept}"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="tbBot">
					<div class="snsTr" >
						<!-- sns -->
						<script language="javascript" type="text/javascript">
							var sh_title = "은평구 사업현황";
					   		var sh_url = location.href;			
						</script>
						<jsp:include page="/WEB-INF/views/common/sns.jsp"/>
						<!-- //sns -->
						<div class="btnFr">
							<a href="#" onclick="list(); return false;" class="btn_reset">목록보기</a>
						</div>
					</div>
				</div>
				<div class="btnC bNone">
					<a id="sympathy" href="#" onclick="sympathy(${bizItem.biz_seq}); return false;" class="heart"  rel="loginMbtLayer"><c:out value = "${bizItem.sympathyCnt}"/></a>
				</div>
		
			</div>

			
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
