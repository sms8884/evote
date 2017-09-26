<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<style type="text/css">
<!--
.titleTab{margin:5px 0;}
.ttabList{overflow:hidden;}
.ttabList li{float:left; padding:20px 0 20px 20px;}
.ttabList li:after{content:"|"; padding-left:20px;}
.ttabList li:last-child:after{content:none; padding-left:20px;}
.ttabList li a{font-size:14px;}
.blueT a{color:#1277DF; font-weight:bold}
.blackboldT a{font-weight:bold}
//-->
</style>
				
<script type="text/javascript">

	function goVoteDetail(biz_seq){
		$("#biz_seq").val(biz_seq);	
		$('#form').attr('action', "/vote/vote-result-detail").submit();		
	}

	function realmVoteResultList(realm_cd) {
		$("#realm_cd").val(realm_cd);
		$("#resultForm").attr("action", "/vote/vote-result");
		$("#resultForm").attr("method", "POST");
		$("#resultForm").submit();
	}

</script>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header --> 

<form id="resultForm" name="resultForm" method="post">	
<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}">
<input type="hidden" id="realm_cd" name="realm_cd">
</form>

<form id="form" name="form" method="post" target="_blank">	
<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}">
<input type="hidden" id="biz_seq" name="biz_seq">
</form>

<div class="location">
	<p>
		<a href="/"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<a href="/vote/vote-main"><span>투표</span></a>
		<span>투표결과</span>
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
			<h3 class="contentTit">투표결과</h3>

			<!-- 투표 top -->
			<jsp:include page="/WEB-INF/views/front/vote/vote-top.jsp"/>
			<!-- //투표 top -->

			<div class="contents">
				<div class="vote_end">
					<p class="endTxt1">
						<span>
							<span>투표 참여대상</span>
							<strong>${voteInfo.target_text}</strong>
						</span>
					</p>
					<p class="endTxt2">
						<span>총 투표 참여자 수</span>
						<strong><fmt:formatNumber value="${voteInfo.voter_count}" groupingUsed="true" /></strong>
					</p>
					<!-- 
					<span>문의:은평구청 희망마을담당관 02-351-6475</span>
					 -->
				</div>
				<div class="votelist">
					<div class="infoBox">
						<p class="txtR"><c:out value="${fn:replace(voteInfo.vote_result, crcn, br)}" escapeXml="false"/></p>
					</div>
					<div class="votelist_sel votelist_sel2">
					<c:if test="${!empty voteResultList}">
					
						<!-- 분야별 투표일때 분야 탭 표시-->
						<c:if test="${voteInfo.vote_type eq 'PART'}">
						
							<c:if test="${not empty voteRealmList}">
							
								<div class="titleTab">
									<ul class="ttabList">
										<c:forEach var="list" items="${voteRealmList}" varStatus="status">
											<c:set var="listClass">
												<c:if test="${currRealmCd eq list.realmCd}">blueT</c:if>
											</c:set>
											<li class="${listClass}"><a href="#" onclick="realmVoteResultList('${list.realmCd}'); return false;"><c:out value="${list.realmNm}"/></a></li>
										</c:forEach>
									</ul>
								</div>
							
							</c:if>
<%-- 				
							<ul class="">
								<c:if test="${not empty voteRealmList}">
									<c:forEach var="list" items="${voteRealmList}" varStatus="status">
										
										<li> 
											<a href="#" onClick="javascript:realmVoteResultList('${list.realmCd}'); return false;">
											<span style="color:#343434; width:auto; height:auto; font-weight: bold;">
												${list.realmNm}
											</span>
											</a>
										</li>
										
									</c:forEach>
								</c:if>
							</ul>
 --%>							
							
						</c:if>




						<c:forEach var="item" items="${voteResultList}" varStatus="status" >
						<div class="voteBox <c:if test="${item.select_yn eq 'Y'}">sel</c:if>">
							<div class="cont<c:if test="${empty item.image_fileSeq}">NoImg</c:if>">													
								<p class="rank <c:if test="${item.prank <= 3}">rank${item.prank}</c:if>">${item.prank}위</p>
								<strong class="s_txt">연번 ${item.dp_ord}</strong>
								<p class="tit"><a href="#" class="chk <c:if test="${item.select_yn eq 'Y'}">on</c:if>" onClick="javascript:goVoteDetail('${item.biz_seq}'); return false;">${item.biz_nm}</a></p>
								<p class="won"><span>${item.budget}</span><c:if test="${voteInfo.vote_type eq 'PART'}"><!-- 분야 --><a class="btnG" style="width: auto; height: auto; padding: 4px 6px 4px 6px;">${item.realm_name}</a></c:if></p>
								<div class="graphWrap">
										<span class="graph"><em style="width:${item.biz_per}%"></em></span>
										<strong class="num"><fmt:formatNumber value="${item.biz_voter}" pattern="#,###" />표 <span>(<fmt:formatNumber value="${item.biz_per}" pattern="#,##0.0"/>%)</span></strong>
								</div>
							</div>
							 <c:if test="${!empty item.image_fileSeq}">
								<div class="img"><!-- 이미지 있으면  -->	
									<img src="<c:url value="/file-download/${item.image_fileSeq}" />" alt="" style="width:217px; height:149px;"/>
								</div>
							</c:if>							
						</div>
						</c:forEach>

					</c:if>
					</div>
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
