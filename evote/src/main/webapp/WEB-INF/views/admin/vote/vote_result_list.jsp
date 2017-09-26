<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<style>  
.mytable { border-collapse:collapse; }  
.mytable th, .mytable td { border:1px solid black; }
</style>
<script langauge="javascript">
$(document).ready(function(){

});

//엑셀다운로드
function downloadExcel(){
	$('#form').attr('action', "/admin/vote/exceldownload").submit();		
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
				<li><a href="/admin/vote/vote_list">투표</a></li>			
				<li>투표대상사업관리</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<div class="content">
					<h3 class="contentTit">${voteInfo.title} > 투표결과</h3>
					
					<div class="mainContent">	
						<form id="form" name="form" method="post" class="searchTb">
						<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}"/>
						<input type="hidden" id="gubun" name="gubun" value="voteResult"/>						
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">투표제목</th>
											<td>${voteInfo.title}</td>
											<th scope="row" class="bln">상태</th>
											<td>
												<c:if test="${voteInfo.status eq 'END'}">투표종료</c:if>
												<c:if test="${voteInfo.status eq 'START'}">진행중</c:if>
												<c:if test="${voteInfo.status eq 'WAIT'}">대기</c:if>
												(${nowDate}기준)												
											</td>
										</tr>
										<tr>
											<th scope="row" class="bln">투표기간</th>
											<td colspan="3">
												<fmt:parseDate value="${voteInfo.start_date}" var="dateFmt" pattern="yyyyMMddHH"/>
												<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/> ~
												<fmt:parseDate value="${voteInfo.end_date}" var="dateFmt" pattern="yyyyMMddHH"/>
												<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/>	
											</td>
										</tr>
										<tr>
											<th scope="row" class="bln">투표자 총수</th>
											<td colspan="3">
												<fmt:formatNumber value="${voteInfo.voter_count }" pattern="#,###" />명
											</td>
										</tr>
									</tbody>
								</table>							
								<div class="btnC">
									<a href="javascript:downloadExcel();" class="btn_blue">엑셀저장</a>
									<a href="/admin/vote/vote_list" class="btn_reset">목록보기</a>
								</div>
							</fieldset>
						</form>
					
						<div class="boardView voteBoard">
							<table cellpadding="0" cellspacing="0" class="tbL" summary="공모관리의 선택, 번호, 제목, 공모기간, 등록일을 알 수 있는 표입니다." >
								<caption>투표관리</caption>
								<colgroup>
									<col width="10%"/>
									<col width="30%"/>
									<col width="10%"/>
									<col width="10%"/>
									<col width="10%"/>
									<col width="10%"/>
									<col width="10%"/>
								</colgroup>
								<thead>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">모바일</th>
									<th scope="col">웹</th>
									<th scope="col">전체 득표수</th>
									<th scope="col">백분율</th>
									<th scope="col">예산액</th>								
								</thead>
								<tbody>
									<c:if test="${!empty resultList}">
										<c:forEach var="item" items="${resultList}" varStatus="status" >
											<tr>
												<td><fmt:formatNumber value="${status.index+1}" pattern="#,###" /></td>
												<td>${item.biz_nm}</td>
												<td><fmt:formatNumber value="${item.mobile}" pattern="#,###" /> </td>
												<td><fmt:formatNumber value="${item.pc}" pattern="#,###" /> </td>
												<td><fmt:formatNumber value="${item.total}" pattern="#,###" /></td>
												<td><fmt:formatNumber value="${item.per}" pattern="#,##0.0"/></td>
												<td>${item.budget}</td>
											</tr>
											</c:forEach>
										</c:if>
									<c:if test="${empty resultList}">
										<tr>
											<td colspan="7" align="center">목록이 없습니다.</td>
										</tr>
									</c:if>		
								</tbody>
							</table>
						</div>
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