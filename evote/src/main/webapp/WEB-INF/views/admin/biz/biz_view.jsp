<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->
<script language="javascript" type="text/javascript">
//<![CDATA[
 	$(document).ready(function(){
 		/* var search_status = '${params.search_status}';
 		if(search_status != ''){
 			$("#search_status > option[value="+search_status+"]").attr("selected", "true");	
 		} */
 		
 		setProgress();
 		
	});
 	/*  진행률에따른 progressBar 설정 */
 	function setProgress(){
 		var tmpProgress = ${bizItem.progress};
 		var progress = tmpProgress/100*400
 		$("#progressBar").width(progress)
 		
 	}
 	function remove(biz_seq){
 		if (confirm("삭제 하시겠습니까?")){
 			  
 			location.href="/admin/biz/biz_remove/" + biz_seq;
 			
 			}
 	}
 	
//]]>
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
				<li>사업현황</li>
				<li>사업현황 상세</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				<div class="content">
					<h3 class="contentTit">사업현황 상세보기</h3>	
					<div class="mainContent">
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
								<p class="priceImg"><img src="${siteImgPath}/common/won_bg.gif" alt=""></p>
								<p class="priceTxt">소요예산 <fmt:formatNumber pattern="#,###" value="${bizItem.budget}" type="number"/> <span class="priceUnit">천원</span></p>
							</div>
							<div class="businessPer">
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
													<img src="/file-download/${list.fileSeq}" alt="" width="300" height="200"/>
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
						<div class="btnbox_BL2">
							<a href="/admin/biz/biz_list" class="btn_blue">목록보기</a>
							<a href="/admin/biz/biz_modify/${bizItem.biz_seq}" class="btn_reset">수정하기</a>
							<a href="#" onclick="javascript:remove(${bizItem.biz_seq}); return false;" class="btn_blue" style="margin-right: 648px; margin-top: -48px">삭제하기</a>
						</div>
						<div class="btnC bNone">
							<a href="#" class="heartNomal"  rel="" style="font-size:medium; margin-left:109px"><c:out value = "${bizItem.sympathyCnt}"/></a>
						</div>
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
