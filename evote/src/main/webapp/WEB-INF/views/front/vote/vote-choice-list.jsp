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
	<input type="hidden" id ="biz_seq" name="biz_seq">
	<input type="hidden" id="tab_menu" name="tab_menu" value="${tab_menu}">
	<input type="hidden" id="search_order" name="search_order" value="${params.search_order}">
	<input type="hidden" id ="search_realm_cd" name="search_realm_cd" value="${params.search_realm_cd}">
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
				<div class="votelist">
				<c:if test="${params.finish_yn ne 'Y'}"><!-- 투표참여전 -->
					<div class="infoBox">
						<p class="txtR">※ 투표 완료하기를 통해 투표에 참여한 후에는 선택한 사업을 변경할 수 없습니다.<br/>&nbsp;&nbsp;&nbsp;&nbsp;선택한 사업을 확인해주세요.</p>
					</div>
				</c:if>	
					<div class="votelist_sel">
						<c:if test="${!empty voterChoiceList}">
							<c:forEach var="item" items="${voterChoiceList}" varStatus="status" >	
							<div class="voteBox sel">
								<div class="cont<c:if test="${empty item.image_fileSeq}">NoImg</c:if>">
									<strong class="s_txt">연번${item.dp_ord}</strong>
									<p class="tit"><a href="#" class="chk on" onClick="javascript:goVoteDetail('${item.biz_seq}'); return false;">${item.biz_nm}</a></p>
									<p class="won"><span>${item.budget}</span><c:if test="${voteInfo.vote_type eq 'PART'}"><!-- 분야 --><span class="btnG">${item.realm_nm}</span></c:if></p>
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
						<div class="vote_btn">
							<a href="#" class="" onClick="javascript:VoteFinish(); return false;"><span>투표완료하기</span></a>
						</div>		
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

//투표 상세 화면
function goVoteDetail(biz_seq){
	$("#biz_seq").val(biz_seq);
	$('#form').attr('action', "/vote/vote-detail").submit();		
}

//투표완료하기 페이지 이동 (선택항목 탭 페이지로 이동)
function VoteFinish(){
	var finish= '${btn_finish}';
	var vital_cnt ='${voteTabCnt.vital_cnt}'; //필수 선택
	var choice_cnt = '${voteTabCnt.user_choice_cnt}'; //사용자 선택
	if(finish == 'true'){
		if(choice_cnt >= vital_cnt){	
			//투표에 참여한 후에는 선택한 사업을 변경할 수 없습니다. \n 투표를 완료하시겠습니까?
			if (confirm('<spring:message code="message.vote.005"/>') == true){   
				$("#tab_menu").val(0);	
				$("#form").attr('action', "/vote/save").submit();
			}else{
				return;
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
};

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
