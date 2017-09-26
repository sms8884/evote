<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script src="${siteJsPath}/board-list.js" language="javascript" type="text/javascript"></script>

<script language="javascript" type="text/javascript">

$(document).ready(function() {
	initSearchParam();
	gfnSetPeriodDatePicker("startDate", "endDate");
	$('#tmpText').on('keypress', function(e) {
		if(e.keyCode == 13){
			e.preventDefault();
			searchPost();
		}
	});
});

var __BOARD_NAME = '<c:out value="${board.boardName}" />';

</script>

</head>
<body>
	
	<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp"/>
	<!-- //header -->
		
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li>주민알림</li>
				<li>자료실</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			
				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit"><c:out value="${board.boardTitle}"/></h3>
					
					<div class="mainContent">	
						
						<!-- search box -->
						<jsp:include page="/WEB-INF/views/admin/board/board-search-box.jsp">
							<jsp:param name="searchFormType" value="2"/>
						</jsp:include>
						<!-- //search box -->
						
						<div class="ResultBox">
							<c:if test="${not empty searchParam}">
								<p class="caption">총 <c:out value="${pagingHelper.totalCnt}"/>건이 검색되었습니다.</p>
							</c:if>
						</div>
						
						<div class="boardList">
							<table cellpadding="0" cellspacing="0" class="tbC" summary="" >
								<caption><c:out value="${board.boardTitle}"/></caption>
								<colgroup>
									<col width="10%"/>
									<c:if test="${board.cateUseYn eq 'Y'}">
									<col width="15%"/>
									</c:if>
									<col width="*"/>
									<col width="15%"/>
									<col width="15%"/>
									<col width="20%"/>
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<c:if test="${board.cateUseYn eq 'Y'}">
										<th>구분</th>
										</c:if>
										<th scope="col">제목</th>
										<th scope="col">게시</th>
										<th scope="col">등록자</th>
										<th scope="col">등록일</th>
									</tr>
								</thead>
								<tbody>
									
									<c:forEach items="${boardPostList}" var="list" varStatus="status">
										<tr>
											<td><strong><c:out value="${pagingHelper.startRowDesc - status.index}" /></strong></td>
											<c:if test="${board.cateUseYn eq 'Y'}">
											<td><c:out value="${list.categoryNm}"/></td>
											</c:if>
											<td class="tL"><a href="javascript:detail('${list.postSeq}');" title=""><c:out value="${list.title}"/></a></td>
											<td>
												<c:if test="${list.dpYn eq 'Y'}">게시</c:if>
												<c:if test="${list.dpYn eq 'N'}">미게시</c:if>
											</td>
											<td><c:out value="${list.regUserNm.decValue}"/></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" /></td>
										</tr>
									</c:forEach>
									
								</tbody>
							</table>
						</div>
						<div class="btnbox_GL">
							<a href="#" onclick="writeForm(); return false;" class="btn_gray">등록</a>
						</div>
						
						<jsp:include page="/WEB-INF/views/admin/board/board-paging.jsp">
							<jsp:param name="formId" value="searchForm"/>
							<jsp:param name="action" value="/admin/board/${board.boardName}/list"/>
						</jsp:include>
					
						<jsp:include page="/WEB-INF/views/admin/board/board-search-form.jsp" />
							
					</div>
				</div>

			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
