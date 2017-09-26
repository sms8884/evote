<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<script langauge="javascript">
$(document).ready(function(){
	$("#start_date, #end_date").datepicker({
	    dateFormat: 'yy-mm-dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    changeMonth: true,
	    changeYear: true,
	    yearSuffix: '년'
	  });
	
	//날짜버튼 포커스
	$('#img_sd').click(function(event) {
		$('#start_date').datepicker().focus();
	});
	$('#img_ed').click(function(event) {
		$('#end_date').datepicker().focus();
	});
});

//검색
function fnSearch(){
	$('#form').attr('action', "/admin/proposal/contest_list");
	gotoPage(1);
}

//삭제
function fnDelete(){
	var ps_seq = $("input[type=radio][name=circle]:checked").val();
	if(ps_seq == null){
		alert('<spring:message code="message.admin.common.002" arguments="삭제할 공모를"/>' );
		return
	}else{
		var pc = $("#pc_"+ps_seq).val();
		if(pc > 0){
			//제안이 등록된 공모는 삭제하실수 없습니다.
			alert('<spring:message code="message.admin.proposal.011"/>');
			return;
		}else{
			//공모를 삭제하시겠습니까?
			if(confirm('<spring:message code="message.admin.proposal.008"/>')) {
				$("#psSeq").val(ps_seq);
				$("#eventType").val('DEL');
				$('#form').attr('action', "/admin/proposal/endContest").submit();
			}	
		}
	}
}

//강제 종료하기
function fnEnd(id){
//공모를 강제종료하시겠습니까?
	if(confirm('<spring:message code="message.admin.proposal.010"/>')) {
		$("#psSeq").val(id);
		$("#eventType").val('END');
		$('#form').attr('action', "/admin/proposal/endContest").submit();		
	}	
}

//등록
function fnWrite(){
	$("#psSeq").val('');
	$('#form').attr('action', "/admin/proposal/contest_write_form").submit();	
}

//수정
function fnModify(){
	var ps_seq = $("input[type=radio][name=circle]:checked").val();
	if(ps_seq == null){
		alert('<spring:message code="message.admin.common.002" arguments="수정할 공모를"/>' );
		return
	}
	$("#psSeq").val(ps_seq);
	$('#form').attr('action', "/admin/proposal/contest_write_form").submit();	
}

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
				<li>제안</li>
				<li>공모관리</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
			<!--leftmenu-->
				<div class="content">
					<h3 class="contentTit">공모관리</h3>
					
					<div class="mainContent">	
						<!-- form에 클래스가 걸려 있어서 form위치 이동하면 안됨 -->	
						<form  name="form" id="form" class="searchTb" method="post" >	
							<input type="hidden" id="psSeq" name="psSeq"> <!-- 공모제안리스트로 넘겨줄 공모 아이디 또는 공모 view로 갈때 아이디 -->
							<input type="hidden" id="eventType" name="eventType"> <!-- 종료인지 삭제인지여부-->
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">공모기간</th>
											<td>
												<label for="start_date" class="hidden">시작기간 입력하기</label>
												<input type="text" class="it wid125" id="start_date" name="startDate" value="<c:out value="${param.startDate}" />" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_sd" alt="시작기간 선택"/> ~
												<label for="end_date" class="hidden">종료기간 입력하기</label>
												<input type="text" class="it wid125" id="end_date" name="endDate" value="<c:out value="${param.endDate}" />" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_ed" alt="종료기간 선택"/>
											</td>
										</tr>
										<tr>
											<th scope="row" class="bln">제목</th>
											<td colspan="3">
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" class="it wid100" title="" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}"/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:fnSearch();" class="btn_blue">검색</a>
								</div>
							</fieldset>
						
						</form>
						<div class="boardView boradGongmo">
							<table cellpadding="0" cellspacing="0" class="tbL" summary="공모관리의 선택, 번호, 제목, 공모기간, 등록일을 알 수 있는 표입니다." >
								<caption>공모관리</caption>
								<colgroup>
									<col width="9%"/>
									<col width="9%"/>
									<col width="45%"/>
									<col width="23%"/>
									<col width="*"/>
								</colgroup>
								<thead>
									<th scope="col">선택</th>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">공모기간</th>
									<th scope="col">등록일</th>
								</thead>
								<tbody>
								<c:if test="${!empty pssrpList}">
							    <c:forEach items="${pssrpList }" var="item" varStatus="status" >								    
									<tr>
										<td>
											<input type="radio" class="" title="" value="${item.psSeq}" name="circle"/>
											<input type="hidden" id="pc_${item.psSeq}" value="${item.proposalCnt}" />										
										</td>										
										<td><c:out value="${pagingHelper.startRowDesc - status.index}" /></td>										
										<td>
											<c:if test="${item.status eq 'START'}"><img src="${siteImgPath}/content/ing.png" alt="진행중"/></c:if>
											<c:if test="${item.status eq 'WAIT'}"><img src="${siteImgPath}/content/ready.png" alt="준비"/></c:if>
											<c:if test="${item.status eq 'END'}"><img src="${siteImgPath}/content/end.png" alt="종료"/></c:if>
											<span <c:if test="${item.status eq 'START'}">class="ing"</c:if>>
												<c:if test ="${item.proposalCnt > 0}"><a href="/admin/proposal/contest_proposal_list?psSeq=${item.psSeq}">${item.title}</a></c:if>
												<c:if test ="${item.proposalCnt < 1}">${item.title}</c:if>
											</span><c:if test="${item.status eq 'START'}"><a href="javascript:fnEnd('${item.psSeq}');" class="btn_black">종료하기</a></c:if>
										</td>
										<td><fmt:formatDate pattern="yyyy-MM-dd hh" value="${item.startDate}" />시 ~<br/> <fmt:formatDate pattern="yyyy-MM-dd hh" value="${item.endDate}" />시 </td>
										<td><fmt:formatDate pattern="yyyy-MM-dd" value="${item.regDate}" /></td>
									</tr>
								</c:forEach>
								</c:if>								
								</tbody>
							</table>
						</div>
						<div class="btnbox">
							<a href="javascript:fnDelete();" class="btn_gray" >삭제하기</a>
							<a href="javascript:fnModify()" class="btn_reset">수정하기</a>
						</div>
						<div class="btnboxFr">
							<a href="javascript:fnWrite();" class="btn_blue3">공모생성하기</a>
						</div>
						<!-- paging -->
						<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
							<jsp:param name="formId" value="form"/>
							<jsp:param name="action" value="/admin/proposal/contest_list"/>
						</jsp:include>	
						<!-- //paging -->		

					</div>
				</div>


			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer --> 
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	<!-- //footer -->
	

</body>
</html>