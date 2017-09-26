<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<script src="${siteJsPath}/jquery.tablednd.js" language="javascript" type="text/javascript" charset="utf-8"></script>

<style>  
</style>
<script langauge="javascript">
$(document).ready(function(){
	//상태 검색값 선택되게
	var search_status = '${params.search_status}';
	if(search_status != ''){
		$("#search_status > option[value="+search_status+"]").attr("selected", "true");	
	}
});

//분야 등록
function reg_realm() {
	$("#vote_type").val('PART');
	$('#form').attr('action', "/admin/vote/vote_reg_form").submit();
}

//일괄 등록
function reg_bunch() {
	$("#vote_type").val('ALL');
	$('#form').attr('action', "/admin/vote/vote_reg_form").submit();		
}

//검색
function searchData(){
	$('#form').attr('action', "/admin/vote/vote_list");
	gotoPage(1);
}

//분야 설정
function setRealm(id){
	$("#vote_seq").val(id);
	$('#form').attr('action', "/admin/vote/vote_realm").submit();		
}

//사업제안 리스트
function goVoteItem(id){
	$("#vote_seq").val(id);
	$('#form').attr('action', "/admin/vote/vote_item_list").submit();		
}

//투표수정
function modifyVote(id){
	$("#vote_seq").val(id);
	$('#form').attr('action', "/admin/vote/vote_mod_form").submit();		
}

//강제 종료하기
function endVote(id){
//진행 중인 투표를 종료 처리하면 종료일자가 현재 시각으로 설정되며 투표가 즉시 종료됩니다. 계속하시겠습니까?	
	if(confirm('<spring:message code="message.admin.vote.001"/>')) {
		$("#vote_seq").val(id);
		$("#event_type").val('END');
		$('#form').attr('action', "/admin/vote/endVote").submit();	
	}	
}

//투표삭제
function deleteVote(id){
//투표를 삭제할 경우 투표에 등록된 사업도 삭제되어 복구할 수 없습니다. 계속하시겠습니까?
	if(confirm('<spring:message code="message.admin.vote.002"/>')) {
		$("#vote_seq").val(id);
		$("#event_type").val('DEL');	
		$('#form').attr('action', "/admin/vote/endVote").submit();		
	}
}

//투표결과
function resultVote(id){
	$("#vote_seq").val(id);
	$('#form').attr('action', "/admin/vote/vote_result_list").submit();		
}

//엑셀다운로드
function downloadExcel(id){
	$("#vote_seq").val(id);
	$('#form').attr('action', "/admin/vote/exceldownload").submit();
}

$(function() {
	
	if("${params.search_status}" == "END") {
		$("#btnVoteOrder").hide();
		$("#btnVoteList").text("진행중인 투표보기").on("click", function() {
			$("#search_status").val("START");
			gotoPage(1);
		});
	} else {
		$(".paging").hide();
		$("#btnVoteList").text("종료된 투표보기").on("click", function() {
			$("#search_status").val("END");
			gotoPage(1);
		});
		$("#voteTable").tableDnD({
			onDragClass: "dragRow"
		});
		$("#btnVoteOrder").on("click", function(e) {
			e.preventDefault();
			var itemList = [];
			$("#voteTable").find("tr").find("td:first").each(function(idx) {
				var vote_seq = $(this).text();
				var dp_ord = idx + 1;
				var voteItem = {'vote_seq':vote_seq,'dp_ord':dp_ord};
				itemList.push(voteItem);
			});
			
			$.ajax({
				type : "POST",
				url : "/admin/vote/modify-vote-master-order",
				data: JSON.stringify(itemList),
				contentType: "application/json; charset=utf-8",
				success : function(data) {
					if(data == true) {
						location.reload();
					}
				},
				error : function(error) {
					console.log(error);
				}
			});

		});
	}
	
});


</script>
</head>
<body>

	<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
	<!-- //header -->
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li><a href="/admin/vote/vote_list">투표</a></li>
				<li>투표관리</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<!--leftmenu-->
				<div class="content">
					<h3 class="contentTit">투표목록</h3>
					
					<div class="mainContent">	
						<form id="form" name="form" method="post" class="searchTb">
						<input type="hidden" id="vote_seq" name="vote_seq"/>
						<input type="hidden" id="vote_type" name="vote_type"/>
						<input type="hidden" id="event_type" name="event_type"/>
						<input type="hidden" id="gubun" name="gubun" value="voterResult"/>
						<input type="hidden" id="search_status" name="search_status" value="${params.search_status}" />
<%-- 
							<fieldset id="" class="">
							
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">검색</th>
											<td colspan="3">
												<select id="search_status" name="search_status" title="검색" class="wid141">
													<option value="">==  상태  ==</option>
													<option value="WAIT">준비</option>
													<option value="START">진행</option>
													<option value="END">종료</option>
												</select>
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" id="seach_string" name="seach_string" value="${param.seach_string}" class="it wid461" title=""/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:searchData();" class="btn_blue">검색</a>
								</div>
							</fieldset>
--%>
						</form>

						<div class="ResultBox">
							<a href="#" id="btnVoteList" class="btn_white" style="float: left;">종료된 투표보기</a>
							<a href="#" onclick="reg_bunch(); return false;" class="btn_white"><img src="${siteImgPath}/content/resultBtn1.png" alt="일괄투표등록"/>일괄투표등록</a>
							<a href="#" onclick="reg_realm(); return false;" class="btn_white"><img src="${siteImgPath}/content/resultBtn2.png" alt="일괄투표등록"/>분야별투표등록</a>
							<a href="#" id="btnVoteOrder" class="btn_white">순서저장</a>
							
						</div>
					
						<div class="boardView voteBoard">
							<table id="voteTable" cellpadding="0" cellspacing="0" class="tbL" summary="공모관리의 선택, 번호, 제목, 공모기간, 등록일을 알 수 있는 표입니다." >
								<caption>투표관리</caption>
								<colgroup>
									<col width="0%"/>
									<col width="8%"/>
									<col width="19%"/>
									<col width="15%"/>
									<col width="13%"/>
									<col width="12%"/>
									<col width="10%"/>
									<col width="10%"/>
									<col width="10%"/>
								</colgroup>
								<thead>
									<th style="display: none;">seq</th>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">투표기간</th>
									<th scope="col">투표자</th>
									<th scope="col">분야</th>
									<th scope="col">사업관리</th>
									<th scope="col">투표관리</th>
									<th scope="col">결과</th>
								</thead>
								<tbody>
								<c:if test="${!empty voteList}">
									<c:forEach var="item" items="${voteList}" varStatus="status" >
									<tr>
										<td style="display: none;"><c:out value="${item.vote_seq}" /></td>
										
										<%-- <td><c:out value="${pagingHelper.startRowDesc - status.index}" /></td> --%>
										
										<td style="text-align: center;"><c:out value="${status.index + 1}" /></td>
										
										<td>
											<c:if test="${item.status eq 'START'}"><img src="${siteImgPath}/content/ing.png" alt="진행중"/><br/></c:if>
											<c:if test="${item.status eq 'WAIT'}"><img src="${siteImgPath}/content/ready.png" alt="준비"/><br/></c:if>
											<c:if test="${item.status eq 'END'}"><img src="${siteImgPath}/content/end.png" alt="종료"/><br/></c:if>											
												${item.title}
											<c:if test="${item.status eq 'START'}">
												<a href="javascript:endVote('${item.vote_seq}')" class="btn_black">종료하기</a>
											</c:if>
										</td>
										<td>
											<fmt:parseDate value="${item.start_date}" var="dateFmt" pattern="yyyyMMddHH"/>
											<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/>  ~<br/>
											<fmt:parseDate value="${item.end_date}" var="dateFmt" pattern="yyyyMMddHH"/>
											<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/>											
										</td>
										<td>
											<fmt:formatNumber value="${item.voter_cnt}" pattern="#,###" />명<br/>
											<div class="btn_excel" onclick="javascript:downloadExcel('${item.vote_seq}')" >엑셀다운 <img src="${siteImgPath}/content/excel.png" alt="엑셀다운"/></div>
										</td>
										<td >											
												<c:if test="${item.vote_type eq 'ALL'}">일괄투표</c:if>
												<c:if test="${item.vote_type eq 'PART'}">분야별투표</c:if>										
											<div class="btn_reset2box">
												<input class="btn_reset2" type="button" value="설정" onclick="javascript:setRealm('${item.vote_seq}')" />
											</div>				
										</td>
										<td>${item.bp_cnt}건<br/>
											<div class="btn_reset2box">
												<input class="btn_reset2" type="button" value="관리" onclick="javascript:goVoteItem('${item.vote_seq}')" />
											</div>												
										</td>
										<td>			
											<c:if test="${item.status ne 'START'}">
											<div class="btn_reset2box">											
												<input class="btn_reset2" type="button" value="수정" onclick="javascript:modifyVote('${item.vote_seq}')"/>
											</div>	
											<div class="btn_gray2box">
												<input class="btn_gray2" type="button" value="삭제"  onclick="javascript:deleteVote('${item.vote_seq}')" />
											</div>	
											</c:if>						
										</td>
										<td>
											<div class="btn_blue2box">
												<input class="btn_blue2" type="button" value="보기" onclick="javascript:resultVote('${item.vote_seq}')"/>
											</div>										
										</td>
									</tr>
									</c:forEach>
								</c:if>
								<c:if test="${empty voteList}">
									<tr>
										<td colspan="9" align="center">목록이 없습니다.</td>
									</tr>
								</c:if>			
								</tbody>
							</table>
						</div>
					</div>
					
					<!-- paging -->
					<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
						<jsp:param name="formId" value="form"/>
						<jsp:param name="action" value="/admin/vote/vote_list"/>
					</jsp:include>	
					<!-- //paging -->
							
				</div>
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->
	
	<!-- footer --> 
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	<!-- //footer -->

</body>
</html>