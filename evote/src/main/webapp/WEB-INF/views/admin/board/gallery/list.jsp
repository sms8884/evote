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
				<li>갤러리</li>
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
						
						<c:if test="${not empty searchParam}">
						<div class="ResultBox">
								<p class="caption">총 <c:out value="${pagingHelper.totalCnt}"/>건이 검색되었습니다.</p>
						</div>
						</c:if>
						
						<div class="gallery_list">
							<ul>
								<c:forEach items="${boardPostList}" var="list" varStatus="status">
									<c:choose>
										<c:when test="${status.index % 2 == 0}"><c:set var="tmpClassName" value=""/></c:when>
										<c:otherwise><c:set var="tmpClassName" value="fR"/></c:otherwise>
									</c:choose>
									<li class="${tmpClassName}">
										<a href="javascript:detail('${list.postSeq}');" title=""><img src="/file-download/${list.thumbnail.fileSeq}" style="width: 352px; height: 205px;"/></a>
										<a href="javascript:detail('${list.postSeq}');" title="" class="title"><c:out value="${list.title}"/></a>
										<p class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" />  | 조회수 <c:out value="${list.readCnt}"/></p>
										<c:if test="${list.dpYn eq 'N'}">
											<p class="N_post">미게시</p>
										</c:if>
									</li>
								</c:forEach>
							</ul>
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
