<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<style>

</style>

</head>
<body>
 <form id="form" name="form" method="post">	
	<input type="hidden" id="vote_seq" name="vote_seq" value="${voteItemInfo.vote_seq}">
	<input type="hidden" id="biz_seq" name="biz_seq" value="${voteItemInfo.biz_seq}">
</form>


<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->
<div class="wrap">

	<div class="location">
		<a href="/"><img src="${siteImgPath}/common/locaHome.png" alt=""/></a>
		<a href="/vote/vote-main"><span>투표</span></a>
		<span>투표참여</span>
	</div>
	
	<div id="container" class="container">
		<div class="containerWrap">
			<!-- 투표 top -->
			<jsp:include page="/WEB-INF/views/mobile/vote/vote-top.jsp"/>
			<!-- //투표 top -->

			<div class="contents">
				<c:if test="${voteInfo.vote_type eq 'PART'}"><!-- 분야별 투표일때 분야 탭 표시-->
					<!-- 투표 카테고리 TAB -->
					<jsp:include page="/WEB-INF/views/mobile/vote/vote-part-tab.jsp"/>
					<!-- //투표 카테고리 TAB -->
				</c:if>
				<div class="votelist">
					<div class="titleBox <c:if test="${voteItemInfo.select_yn eq 'Y'}">active</c:if>">
						<c:if test="${voteItemInfo.select_yn eq 'Y'}">
						<div class="sel_top">
							<span>선택완료</span>
						</div>
						</c:if>
						<p class="tit">${voteItemInfo.biz_nm}</p>
						<p class="won"><span>소요예산 ${voteItemInfo.budget}</span></p>
						<div class="graphWrap">
							<span class="graph"><em style="width:20%"></em></span>
							<strong class="num"><fmt:formatNumber value="${voteItemInfo.biz_voter}" pattern="#,###" />표 <span>(<fmt:formatNumber value="${voteItemInfo.biz_per}" pattern="#,##0.0"/>%)</span></strong>
						</div>
					</div>
				</div>	
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="사업 상세보기" >
						<caption>사업 상세보기</caption>
						<colgroup>
							<col width="90"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">사업기간</th>
								<td><fmt:parseDate value="${voteItemInfo.start_date}" var="dateFmt" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${dateFmt}"  pattern="yyyy. MM. dd"/> ~
										<fmt:parseDate value="${voteItemInfo.end_date}" var="dateFmt" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${dateFmt}"  pattern="yyyy. MM. dd"/>
								</td>
							</tr>
							<tr>
								<th scope="row">위치</th>
								<td>${voteItemInfo.location}</td>
							</tr>
							<tr>
								<th scope="row" class="bTit" colspan="2">내용</th>
							</tr>
							<tr>
								<td colspan="2" class="bCon">
									<div>
										<p>${fn:replace(voteItemInfo.biz_cont, entermark,"<br/>")}</p>
										<c:if test="${!empty image_file}">
											<c:forEach items="${image_file}" var="image" varStatus="status">
												<a href="/file-download/${image.fileSeq }">
												<img src="<c:url value="/file-download/${image.fileSeq}" />"  alt="" />
												</a>
											</c:forEach>		
										</c:if>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
								<td>
								<c:if test="${!empty attach_file}">
									<c:forEach items="${attach_file}" var="attach" varStatus="status">
										<a href="/file-download/${attach.fileSeq}"><c:out value="${attach.fileSrcNm }" /></a>
									</c:forEach>
								</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row" class="bTit" colspan="2">기대효과</th>
							</tr>
							<tr>
								<td colspan="2" class="bCon">
									<div>${fn:replace(voteItemInfo.necessity,entermark,"<br/>")}</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>				
				<div class="btnR">				
					<a href="#" class="btn_reset" onClick="javascript:goResultVoteList();">목록보기</a>
				</div>	
			</div>		
		
		</div> <!-- end contents -->
	</div> <!-- containerWrap -->

<!-- footer -->
<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
<!-- //footer -->
</div>
<script langauge="javascript" type="text/javascript">

$(document).ready(function(){	

});

// 리스트
function goResultVoteList(){
	$('#form').attr('action', "/vote/vote-result").submit();
}

</script>



</body>
</html>
