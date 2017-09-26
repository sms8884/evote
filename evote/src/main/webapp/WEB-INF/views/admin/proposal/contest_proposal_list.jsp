<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<script langauge="javascript">
$(document).ready(function(){
	$( "#start_date, #end_date" ).datepicker({
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
	$('#form').attr('action', "/admin/proposal/contest_proposal_list");
	gotoPage(1);
}

//상세보기
function fnMoveDetail(propSeq){
	$('#propSeq').val(propSeq);
	$('#listUrl').val( "/admin/proposal/contest_proposal_list"); //디테일 화면에 상세보기에서 리스트로 갈 페이지
	$('#form').attr('action', "/admin/proposal/proposal_detail").submit();
}

//상단 [전체], [상시], [공모] 리스트 
function fnMovePsType(psSearchType){
	// N : 상시, Y : 공모
    $('#isPs').val(psSearchType);
    $('#form').attr('action', "/admin/proposal/contest_proposal_list");
    gotoPage(1);
}

//정렬
function sortList(sort){
	$("#sortItem").val(sort);
	$('#form').attr('action', "/admin/proposal/contest_proposal_list").submit();		
}

//엑셀다운로드
function downloadExcel(){
	$('#form').attr('action', "/admin/proposal/exceldownload").submit();
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
				<li class="subNavHome"><a href="/"><img src="${siteImgPath}/common/home.png" alt="home"/></a></li>				
				<li><a href="/admin/proposal/contest_list">공모관리</a></li>
				<li><a href="#">공모제안리스트</a></li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			
				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<!--leftmenu-->

				<div class="content">
					<h3 class="contentTit">
						<c:if test="${contest.status eq 'START'}"><img src="${siteImgPath}/content/ing.png" alt="진행중"/></c:if>
						<c:if test="${contest.status eq 'WAIT'}"><img src="${siteImgPath}/content/ready.png" alt="준비"/></c:if>
						<c:if test="${contest.status eq 'END'}"><img src="${siteImgPath}/content/end.png" alt="종료"/></c:if> ${contest.title}
					</h3>
					
					<div class="mainContent">	
					<!-- form에 클래스가 걸려 있어서 form위치 이동하면 안됨 -->	
						<form  name="form" id="form" class="searchTb" method="post" >	
							<input type="hidden" name="sortItem" id="sortItem" value="<c:out value="${param.sortItem}" />" />
						    <input type="hidden" name="isPs" id="isPs" value="Y" />
						    <input type="hidden" name="propSeq" id="propSeq" value="${param.propSeq}" />
						    <input type="hidden" name="psSeq" id="psSeq" value="${param.psSeq}"/> 
						    <input type="hidden" name="listUrl" id="listUrl" value="<c:out value="${param.listUrl}"/>" />
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">기간</th>
											<td>
												<label for="start_date" class="hidden">시작기간 입력하기</label>
												<input type="text" class="it wid125" id="start_date" name="startDate" value="<c:out value="${param.startDate}" />" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_sd" alt="시작기간 선택"/> ~
												<label for="end_date" class="hidden">종료기간 입력하기</label>
												<input type="text" class="it wid125" id="end_date" name="endDate" value="<c:out value="${param.endDate}" />" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_ed" alt="종료기간 선택"/>
											</td>
											<th scope="row">구분</th>
											<td>												
												  <select title="구분" class="wid100" name="status" id="status">
							                            <option value="" selected="selected">전체</option>
							                            <c:forEach items="${codeList }" var="item" >
							                                <option value="<c:out value="${item.cdId }" />"><c:out value="${item.cdNm }" /></option>
							                            </c:forEach>
							                        </select>
											</td>
										</tr>
										<tr>
											<th scope="row" class="bln">검색</th>
											<td colspan="3">
												<select title="검색" class="wid141">
													<option value="">== 검색 조건 ==</option>
													<option value="title" <c:if test ="${param.searchColumn eq 'title'}">selected="selected"</c:if> >제목</option>
													<option value="name" <c:if test ="${param.searchColumn eq 'name'}">selected="selected"</c:if>>작성자</option>
												</select>
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" class="it wid461" title="" value="${param.searchKeyword}" name="con"/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:fnSearch();" class="btn_blue">검색</a>
								</div>
							</fieldset>
							</form>
						<!--등록기간,상태 검색바 없음-->
						
						<div class="sort">
							<p>
								<a href="javascript:sortList('');" <c:if test="${param.sortItem == '' || empty param.sortItem}">class="on" </c:if> >최근순</a>
								<a href="javascript:sortList('1');" <c:if test="${param.sortItem == 1}">class="on" </c:if>>공감순</a>
								<a href="javascript:sortList('2');" <c:if test="${param.sortItem == 2}">class="on" </c:if>>조회순</a>
							</p>
							
							<p class="sResult">총 <fmt:formatNumber value="${pagingHelper.totalCnt }" pattern="#,###"/>건이 검색되었습니다<span class="excel" onClick="javascript:downloadExcel();">엑셀다운로드 <img src="${siteImgPath}/content/excel.png" alt="엑셀다운로드"/></span></p>

						</div>

						<div class="offer">
							<ul class="">
								<c:if test="${!empty proposalList}">
							    <c:forEach items="${proposalList }" var="item" varStatus="status" >								    
								<li <c:if test ="${(status.index+1) mod 2 == 0}"> class="fR" </c:if>>
									<a href="javascript:fnMoveDetail('${item.propSeq }')" class="title">
										<span class="confrimTxt">[<c:forEach items="${codeList }" var="codeItem" ><c:if test ="${codeItem.cdId eq item.status}"><c:out value="${codeItem.cdNm}" /></c:if></c:forEach>]</span>
										<c:out value="${item.bizNm }" />
									</a>
									<p class="date">
									<fmt:formatDate pattern="yyyy.MM.dd" value="${item.regDate}" /> | 조회수 <fmt:formatNumber value="${item.readCnt}" pattern="#,###"/></p>
									<p class="who">작성자: ${item.reqNm.decValue}</p>
									<p class="click">
										<a class="ok on"><fmt:formatNumber value="${item.symCnt}" pattern="#,###"/></a>
										<a class="reply"><fmt:formatNumber value="${item.commentCnt}" pattern="#,###"/></a>
									</p>
								</li>
								</c:forEach>
							</c:if>	
							<c:if test="${empty proposalList}">
							<li>조회된 데이터가 없습니다.</li>
							</c:if>
							</ul>
						</div>

						<!-- paging -->
						<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
							<jsp:param name="formId" value="form"/>
							<jsp:param name="action" value="/admin/proposal/contest_proposal_list"/>
						</jsp:include>	
						<!-- //paging -->		

					</div><!--mainContent-->
				</div><!--content-->
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer --> 
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	<!-- //footer -->
	

</body>
</html>