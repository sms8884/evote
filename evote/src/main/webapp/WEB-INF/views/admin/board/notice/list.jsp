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
				<li>공지사항</li>
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
							<jsp:param name="searchFormType" value="1"/>
						</jsp:include>
						<!-- //search box -->
						
						<c:if test="${not empty pagingHelper}">
						<p class="caption">총 <c:out value="${pagingHelper.totalCnt}"/>건이 검색되었습니다.</p>
						</c:if>
						
						<div class="boardList">
							<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
								<caption><c:out value="${board.boardTitle}"/></caption>
								<colgroup>
									<col width="15%"/>
									<c:if test="${board.cateUseYn eq 'Y'}">
									<col width="15%"/>
									</c:if>
									<col width="*"/>
									<col width="10%"/>
									<col width="10%"/>
									<col width="20%"/>
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<c:if test="${board.cateUseYn eq 'Y'}">
										<th>구분</th>
										</c:if>
										<th>제목</th>
										<th>게시</th>
										<th>등록자</th>
										<th>등록일</th>
									</tr>
								</thead>
								<tbody>
									
									<c:forEach items="${boardTopList}" var="list">
									<tr>
										<td><strong><img src="${siteImgPath}/common/board_icon1.gif" alt="중요"/></strong></td>
										<c:if test="${board.cateUseYn eq 'Y'}">
										<td><strong><c:out value="${list.categoryNm}"/></strong></td>
										</c:if>
										<td class="tL"><strong><a href="javascript:detail('${list.postSeq}');"><c:out value="${list.title}"/></a></strong></td>
										<td>
											<c:if test="${list.dpYn eq 'Y'}">게시</c:if>
											<c:if test="${list.dpYn eq 'N'}">미게시</c:if>
										</td>
										<td><c:out value="${list.regUserNm.decValue}"/></td>
										<td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" /></td>
									</tr>
									</c:forEach>
									
									<c:forEach items="${boardPostList}" var="list" varStatus="status">
									<tr>
										<td><c:out value="${pagingHelper.startRowDesc - status.index}" /></td>
										<c:if test="${board.cateUseYn eq 'Y'}">
										<td><c:out value="${list.categoryNm}"/></td>
										</c:if>
										<td class="tL"><a href="javascript:detail('${list.postSeq}');"><c:out value="${list.title}"/></a></td>
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
							<div class="btnR">
								<a href="#" onclick="writeForm(); return false;" class="btn_blue">등록</a>
							</div>
						</div>
		
						<jsp:include page="/WEB-INF/views/admin/board/board-paging.jsp">
							<jsp:param name="formId" value="searchForm"/>
							<jsp:param name="action" value="/admin/board/${board.boardName}/list"/>
						</jsp:include>
						
						<jsp:include page="/WEB-INF/views/admin/board/board-search-form.jsp" />
						
					</div><!-- mainContent -->
				</div><!--content-->
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
