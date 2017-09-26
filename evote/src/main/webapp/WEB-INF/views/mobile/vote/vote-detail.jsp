<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<style type="text/css">
.vote_btn_finish a {background:#00ce3d;}
.vote_btn_finish a span	{color:#fff;background:url(${siteImgPath}/vote/vote_ico.gif) 0 2px no-repeat;background-size:17px 17px}
</style>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

 <form id="form" name="form" method="post">	
		<input type="hidden" id="vote_seq" name="vote_seq" value="${voteItemInfo.vote_seq}">
		<input type="hidden" id="tab_menu" name="tab_menu" value="${tab_menu}">
		<input type="hidden" id ="search_realm_cd" name="search_realm_cd" value="${params.search_realm_cd}">
		<input type="hidden" id="biz_seq" name="biz_seq" value="${voteItemInfo.biz_seq}">
		<input type="hidden" id="search_order" name="search_order" value="${params.search_order}">
		<input type="hidden" id="event" name="event" value="">
	</form>


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
					<div class="Vtop">
						<c:if test="${!empty voteItemInfo.pre_biz_seq}">
							<a href="#" class="left" onClick="javascript:goPreVoteItem('${voteItemInfo.pre_biz_seq}');"><img src="${siteImgPath}/common/btn_prev3.gif" alt="이전글 보기"  width="6px" />이전글</a>
						</c:if>
						<c:if test="${!empty voteItemInfo.next_biz_seq}">
							<a href="#" class="right col_b" onClick="javascript:goNextVoteItem('${voteItemInfo.next_biz_seq}');">다음글 <img src="${siteImgPath}/common/btn_next3.gif" alt="다음글보기"  width="6px" /></a>
						</c:if>			
					</div>
					<div class="titleBox <c:if test="${voteItemInfo.select_yn eq 'Y'}">active</c:if>">
						<c:if test="${voteItemInfo.select_yn eq 'Y'}">
						<div class="sel_top">
							<span>선택완료</span>
						</div>
						</c:if>
						<p class="tit">${voteItemInfo.biz_nm}</p>
						<p class="won"><span>소요예산 ${voteItemInfo.budget}</span></p>
						<c:if test="${voteInfo.result_dp_yn eq 'Y'}"> <!-- 투표 수치 표시 -->
						<div class="graphWrap">
							<span class="graph"><em style="width:${voteItemInfo.biz_per}%"></em></span>
							<strong class="num"><fmt:formatNumber value="${voteItemInfo.biz_voter}" pattern="#,###" />표 <span>(<fmt:formatNumber value="${voteItemInfo.biz_per}" pattern="#,##0.0"/>%)</span></strong>
						</div>
						</c:if>
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
				<c:if test="${params.finish_yn eq 'N'}">
					<c:if test="${voteItemInfo.select_yn eq 'N'}">	
						<c:if test="${voteRealm.choice_cnt > voteRealm.sel_cnt}"> <!-- 분야별 사용자 선택개수와 사용자가 선택한 개수비교 -->
							<a href="#" class="btn_sel" id="btn_select"><span>선택하기</span></a>
						</c:if>						
					</c:if>
					<c:if test="${voteItemInfo.select_yn eq 'Y'}">	
						<a href="#" class="btn_sel" id="btn_unselect"><span>선택해제하기</span></a>					
					</c:if>				
				</c:if>					
					<a href="#" class="btn_reset" onClick="javascript:goVoteList();">목록보기</a>
				</div>	
			</div>
			
			<div class="boardnp">
				<p>
				<c:if test="${!empty voteItemInfo.pre_biz_seq}">
					<a href="#" class="prev" onClick="javascript:goPreVoteItem('${voteItemInfo.pre_biz_seq}');">
						<strong>이전글</strong>
						<span>${voteItemInfo.pre_biz_nm}</span>
					</a>
					</c:if>
					<c:if test="${!empty voteItemInfo.next_biz_seq}">
					<a href="#" class="next" onClick="javascript:goNextVoteItem('${voteItemInfo.next_biz_seq}');">
						<strong>다음글</strong>
						<span>${voteItemInfo.next_biz_nm}</span>
					</a>
					</c:if>
				</p>
			</div>
			<div class="vote_btn">
				<a href="#" class="" onClick="javascript:goVotefinishPage();"><span>투표완료 화면으로 이동</span></a>
			</div>
		</div> <!-- end contents -->
	</div> <!-- containerWrap -->

<!-- footer -->
<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
<!-- //footer -->
</div>

<script langauge="javascript" type="text/javascript">

$(document).ready(function(){	
	//선택버튼클릭	
	$("#btn_select").on("click", function(e) {
		e.preventDefault();
		$("#btn_select").attr('disabled',true);
		$("#event").val("add");
		$('#form').attr('action', "/vote/savetemp").submit();		
	});
	
	//선택해제버튼클릭
	$("#btn_unselect").on("click", function(e) {
		e.preventDefault();	
		$("#btn_unselect").attr('disabled',true);
		$("#event").val("del");	
		$('#form').attr('action', "/vote/savetemp").submit();
	});	
});

// 리스트
function goVoteList(){
	var tab_menu = $("#tab_menu").val();	
	if(tab_menu == 1){
		$('#form').attr('action', "/vote/vote-choice-list").submit();
	}else{
		$('#form').attr('action', "/vote/vote-list").submit();
	}
}

//이전버튼
function goPreVoteItem(seq){
	$("#biz_seq").val(seq);
	$('#form').attr('action', "/vote/vote-detail").submit();		
}

//다음버튼
function goNextVoteItem(seq){
	$("#biz_seq").val(seq);
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
