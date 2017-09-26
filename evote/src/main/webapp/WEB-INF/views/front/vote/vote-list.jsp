<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<style type="text/css">
.vote_btn_finish a {background:#00ce3d;}
.vote_btn_finish a span	{color:#fff;background:url(${siteImgPath}/vote/vote_ico.gif) 0 0 no-repeat;}
</style>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<form id="form" name="form" method="post">	
	<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}">
	<input type="hidden" id="biz_seq" name="biz_seq">
	<input type="hidden" id="tab_menu" name="tab_menu" value="${tab_menu}">
	<input type="hidden" id="search_realm_cd" name="search_realm_cd" value="${params.search_realm_cd}">
	<input type="hidden" id="search_order" name="search_order" value="${params.search_order}">	
</form>

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
			<h3 class="contentTit">투표참여</h3>
				
			<!-- 투표 top -->
			<jsp:include page="/WEB-INF/views/front/vote/vote-top.jsp"/>
			<!-- //투표 top -->

			<div class="contents">							
				<c:if test="${voteInfo.vote_type eq 'PART'}"><!-- 분야별 투표일때 분야 탭 표시-->
					<!-- 투표 카테고리 TAB -->
					<jsp:include page="/WEB-INF/views/front/vote/vote-part-tab.jsp"/>
					<!-- //투표 카테고리 TAB -->
				</c:if>
				
				<div class="votelist">
					<c:if test="${voteInfo.result_dp_yn eq 'Y'}">
					<div class="sort"><!-- 투표 수치 표시 -->
						<p>
							<a href="#" <c:if test="${params.search_order eq 'dp_ord'}">class="on"</c:if> onClick="javascript:goOrdVoteList('dp_ord'); return false;">연번순</a>
							<a href="#" <c:if test="${params.search_order eq 'biz_per'}">class="on"</c:if> onClick="javascript:goOrdVoteList('biz_per'); return false;">득표순</a>
						</p>						
					</div>
					</c:if>
					<div class="infoBox">
						<c:if test="${voteInfo.vote_type eq 'ALL'}"> <!-- 일괄투표 -->
							<p class="txtR">※ ${voteTabCnt.vital_cnt}개의 사업을 선택한 후에 투표를 완료할 수 있습니다.</p>
						</c:if>	
						<c:if test="${voteInfo.vote_type eq 'PART'}">
							<p class="txtR">※ 각 분야별로 표시된 개수만큼의 사업을 선택한 후에 투표를 완료해주세요</p>
							<c:if test="${params.ageGroup eq 'YOUNG'}">
								<!-- 청소년이면 해당 문구 출력 -->
								<p class="txtR">※ ‘청소년’ 분야는 필수 분야이며, 이외의 분야는 선택적으로 투표할 수 있습니다</p>
							</c:if>
						</c:if>
					</div>
					
					<div class="votelist_sel">					
						<c:if test="${!empty voteItemList}">
							<c:forEach var="item" items="${voteItemList}" varStatus="status" >	
							<div class="voteBox <c:if test="${item.select_yn eq 'Y'}">sel</c:if>">
								<div class="cont<c:if test="${empty item.image_fileSeq}">NoImg</c:if>">
									<strong class="s_txt">연번 ${item.dp_ord}</strong>
									<p class="tit"><a href="#" class="chk <c:if test="${item.select_yn eq 'Y'}">on</c:if>" onClick="javascript:goVoteDetail('${item.biz_seq}'); return false;">${item.biz_nm}</a></p>
									<p class="won"><span>${item.budget}</span></p>
									<c:if test="${voteInfo.result_dp_yn eq 'Y'}"> <!-- 투표 수치 표시 -->
									<div class="graphWrap">
										<span class="graph"><em style="width:${item.biz_per}%"></em></span>
										<strong class="num"><fmt:formatNumber value="${item.biz_voter}" pattern="#,###" />표 <span>(<fmt:formatNumber value="${item.biz_per}" pattern="#,##0.0"/>%)</span></strong>
									</div>
									</c:if>
								</div>
								 <c:if test="${!empty item.image_fileSeq}">
									<div class="img"><!-- 이미지 있으면  -->	
										<img src="<c:url value="/file-download/${item.image_fileSeq}" />" alt="" style="width:217px; height:149px;"/>
									</div>
								</c:if>
							</div>
							</c:forEach>
						</c:if>
						<c:if test="${voteInfo.result_dp_yn eq 'N'}"> <!-- 투표 수치 미표시 -->
							<c:if test="${params.finish_yn eq 'Y'}"> <!-- 투표 참여완료  -->							
								<div class="vote_info"> <strong>투표결과는 투표마감 후 공개됩니다</strong> </div>
							</c:if>
						</c:if>
						<c:if test="${params.finish_yn ne 'Y'}">  <!-- 투표 참여 전  -->				
							<div class="vote_btn"> <a href="#" class="" onClick="javascript:goVotefinishPage(); return false;"><span>투표완료 화면으로 이동</span></a> </div>
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

<script language="javascript" type="text/javascript">

//투표 리스트 (득표순,연번순)
function goOrdVoteList(ord){	
	$("#search_order").val(ord);
	$("#form").attr('action', "/vote/vote-list").submit();		
}

//투표 상세 화면
function goVoteDetail(biz_seq){
	$("#biz_seq").val(biz_seq);
	$('#form').attr('action', "/vote/vote-detail").submit();		
}


//투표 완료 화면으로 이동
function goVotefinishPage(){
	var finish= '${btn_finish}';
	var vital_cnt ='${voteTabCnt.vital_cnt}';
	var choice_cnt = '${voteTabCnt.user_choice_cnt}';
	if(finish == 'true'){
		if(choice_cnt >= vital_cnt){			
			$("#tab_menu").val(1);	
			$('#form').attr('action', "/vote/vote-choice-list").submit();	
		}else{
			var vote_type="${voteInfo.vote_type}";
			if(vote_type == 'ALL'){
				//n개의 사업을 선택한 후에 투표를 완료할 수 있습니다.
				alert('<spring:message code="message.vote.003" arguments="'+vital_cnt+'" />');
			}else{
				//각 분야별로 표시된 개수만큼의 사업을 선택한 후에 투표를 완료할 수 있습니다
				alert('<spring:message code="message.vote.004" />');
			}	
		}
	}else{
		var vote_type="${voteInfo.vote_type}";
		if(vote_type == 'ALL'){
			//n개의 사업을 선택한 후에 투표를 완료할 수 있습니다.
			alert('<spring:message code="message.vote.003" arguments="'+vital_cnt+'" />');
		}else{
			//각 분야별로 표시된 개수만큼의 사업을 선택한 후에 투표를 완료할 수 있습니다
			alert('<spring:message code="message.vote.004" />');
		}
	}
}

$(function() {
	var vital_cnt ='${voteTabCnt.vital_cnt}';
	var choice_cnt = '${voteTabCnt.user_choice_cnt}';
	if('${btn_finish}' && choice_cnt >= vital_cnt) {
		$(".vote_btn").addClass("vote_btn_finish");
	}
});


</script>

</body>
</html>
