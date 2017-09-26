<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<script langauge="javascript">
//검색
function fnSearch(){
	$('#form').attr('action', "/admin/proposal/proposal_review_list");
	gotoPage(1);
}
//상세보기
function fnMoveDetail(propSeq){
	$('#propSeq').val(propSeq);
	$('#listUrl').val("/admin/proposal/proposal_review_list"); //디테일 화면에 상세보기에서 리스트로 갈 페이지
	$('#form').attr('action', "/admin/proposal/proposal_detail").submit();
}

//상단 [전체], [상시], [공모] 리스트 
function fnMovePsType(psSearchType){
	// N : 상시, Y : 공모
    $('#isPs').val(psSearchType);
    $('#form').attr('action', "/admin/proposal/proposal_review_list");
    gotoPage(1);

}

//정렬
function sortList(sort){
	$("#sortItem").val(sort);
	$('#form').attr('action', "/admin/proposal/proposal_review_list");
	gotoPage(1);
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
				<li class="subNavHome"><a href="#"><img src="${siteImgPath}/common/home.png" alt="home"/></a></li>
				<li><a href="#">제안</a></li>
				<li><a href="#">검토완료</a></li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">			
				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<!--leftmenu-->
				<div class="content">
					<h3 class="contentTit">제안목록</h3>					
					<ul class="conTab">
						<li><a href="javascript:fnMovePsType('')"<c:if test="${param.isPs eq '' || empty param.isPs}">class="on" </c:if>>전체</a></li>
						<li><a href="javascript:fnMovePsType('N')"<c:if test="${param.isPs eq 'N'}">class="on" </c:if> >상시</a></li>
						<li><a href="javascript:fnMovePsType('Y')"<c:if test="${param.isPs eq 'Y'}">class="on" </c:if>>공모</a></li>
					</ul>
					<div class="mainContent">		
					<!-- form에 클래스가 걸려 있어서 form위치 이동하면 안됨 -->	
						<form  name="form" id="form" class="searchTb" method="post" >	
							<input type="hidden" name="sortItem" id="sortItem"value="<c:out value="${param.sortItem}" />" />
						    <input type="hidden" name="isPs" id="isPs" value="<c:out value="${param.isPs}" />" />
						    <input type="hidden" name="listUrl" id="listUrl"/>
						    <input type="hidden" name="propSeq" id="propSeq" />						 
						    									
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/><col width="105"/><col width="151"/>					
									</colgroup>
									<tbody>		
										<tr>
											<th scope="row" class="bln">검색</th>
											<td>
												<select title="검색"  id="searchColumn" name="searchColumn">
													<option value="">== 검색 조건 ==</option>
													<option value="title" <c:if test ="${param.searchColumn eq 'title'}">selected="selected"</c:if> >제목</option>
													<option value="name" <c:if test ="${param.searchColumn eq 'name'}">selected="selected"</c:if>>작성자</option>
												</select>
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" class="it" id="searchKeyword" name="searchKeyword" title="" value="${param.searchKeyword}"/>
											</td>
											<th scope="row">구분</th>
											<td>				
												<!-- 적합 부적합 prop_audit DB에 있음 해당 테이블 조인 필요  -->								
												<select title="구분" class="wid141" name="reviewResult" id="reviewResult">							                            
													<option value="" >전체</option>							                            
													<option value="Y" <c:if test="${param.reviewResult eq 'Y'}"> selected="selected" </c:if>>적합</option>
													<option value="N" <c:if test="${param.reviewResult eq 'N'}"> selected="selected" </c:if>>부적합</option>		
												</select>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:fnSearch();" class="btn_blue">검색</a>
								</div>
							</fieldset>
						</form>
						<div class="sort">
							<p>	
								<a href="javascript:sortList('');" <c:if test="${param.sortItem == '' || empty param.sortItem}">class="on" </c:if> >최근순</a>
								<a href="javascript:sortList('1');" <c:if test="${param.sortItem == 1}">class="on" </c:if>>공감순</a>
								<a href="javascript:sortList('2');" <c:if test="${param.sortItem == 2}">class="on" </c:if>>조회순</a>
							</p>
							<p class="sResult">총 <fmt:formatNumber value="${pagingHelper.totalCnt }" pattern="#,###"/>건이 검색되었습니다</p>
						</div>

						<div class="offer">
							<ul class="">
							<c:if test="${!empty proposalList}">
							    <c:forEach items="${proposalList }" var="item" varStatus="status" >								    
								<li <c:if test ="${(status.index+1) mod 2 == 0}"> class="fR" </c:if>>
									<a href="javascript:fnMoveDetail('${item.propSeq }')" class="title"><c:out value="${item.bizNm }" /></a>
									<p class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${item.regDate}" /> | 조회수 <fmt:formatNumber value="${item.readCnt}" pattern="#,###"/></p>
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
							<jsp:param name="action" value="/admin/proposal/proposal_review_list"/>
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