<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<style>

</style>

</head>
<body>
 <form id="form" name="form" method="post">	
	<input type="hidden" id="vote_seq" name="vote_seq" value="${voteItemInfo.vote_seq}">
	<input type="hidden" id="biz_seq" name="biz_seq" value="${voteItemInfo.biz_seq}">
</form>


<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="/"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<a href="/vote/vote-main"><span>투표</span></a>
		<span>투표참여</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">

		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="vote"/>
		</jsp:include>
		<!-- //LNB -->
		
			<div class="contentsWrap">
			<h3 class="contentTit">사업상세</h3>

			<div class="contents">
				
				<div class="votelist">
					<div class="titleBox <c:if test="${voteItemInfo.select_yn eq 'Y'}">active</c:if>">
						<c:if test="${voteItemInfo.select_yn eq 'Y'}">
						<div class="sel_top">
							<span>선택완료</span>
						</div>
						</c:if>
						<strong class="s_txt">연번 ${voteItemInfo.dp_ord}</strong>
						<p class="tit">${voteItemInfo.biz_nm}</p>
						<p class="won"><span>${voteItemInfo.budget}</span></p>
						<div class="graphWrap">
							<span class="graph"><em style="width:${voteItemInfo.biz_per}%"></em></span>
							<strong class="num"><fmt:formatNumber value="${voteItemInfo.biz_voter}" pattern="#,###" />표 <span>(<fmt:formatNumber value="${voteItemInfo.biz_per}" pattern="#,##0.0"/>%)</span></strong>
						</div>
					</div>	
				</div>
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="사업 상세보기" >
						<caption>사업 상세보기</caption>
						<colgroup>
							<col width="15%"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">사업기간</th>
								<td> <fmt:parseDate value="${voteItemInfo.start_date}" var="dateFmt" pattern="yyyyMMdd"/>
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
								<th scope="row">내용</th>
								<td>
									<div class="bCon">
										<p>${fn:replace(voteItemInfo.biz_cont, entermark,"<br/>")}	</p>										
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
									<c:forEach items="${attach_file}" var="attach" varStatus="status">
										<a href="/file-download/${attach.fileSeq}"><c:out value="${attach.fileSrcNm }" /></a>
									</c:forEach>
								</td>
							</tr>
							<tr>
								<th scope="row">기대효과</th>
								<td>${fn:replace(voteItemInfo.necessity,entermark,"<br/>")}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btnR">
					<a href="#" class="btn_reset" onClick="javascript:goResultVoteList(); return false;">목록보기</a>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

<script langauge="javascript" type="text/javascript">

$(document).ready(function(){	
	$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0});
});

// 리스트
function goResultVoteList(){
	$('#form').attr('action', "/vote/vote-result").submit();
}

</script>



</body>
</html>
