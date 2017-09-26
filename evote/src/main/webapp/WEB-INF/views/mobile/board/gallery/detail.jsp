<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	function list() {
		$("#searchForm").attr("action", "/board/${board.boardName}/list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function detail(seq) {
		$("#searchForm").attr("action", "/board/${board.boardName}/" + seq);
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

</script>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">

	<!-- board-breadcrumb -->
	<c:choose>
		<c:when test="${board.boardName eq 'cmit'}">
			<div class="location">
				<img src="${siteImgPath}/common/locaHome.png" alt=""/>
				<span>주민참여위원회</span>
				<span><c:out value="${board.boardTitle}"/></span>
			</div>		
		</c:when>
		<c:otherwise>
			<jsp:include page="/WEB-INF/views/mobile/board/board-breadcrumb.jsp"/>
		</c:otherwise>
	</c:choose>
	<!-- //board-breadcrumb -->

	<div class="boardView">
		<p class="viewTop">
			<strong><c:out value="${boardPost.title}"/></strong>
			<c:if test="${board.cateUseYn eq 'Y'}">
				<span><c:out value="${boardPost.categoryNm}"/></span>
			</c:if>
			<c:if test="${board.cateUseYn ne 'Y'}">
				<span><c:out value="${board.boardTitle}"/></span>
			</c:if>
		</p>

		<p class="pageView">조회수 <c:out value="${boardPost.readCnt}"/></p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">등록일</th>
					<td><fmt:formatDate value="${boardPost.regDate}" pattern="yyyy-MM-dd"/></td>
				</tr>
			</tbody>
		</table>
		<div class="galImgBox">
			<p class="img">
				<c:if test="${not empty boardPost.imageList}">
					<c:forEach items="${boardPost.imageList}" var="list">
						<img src="/file-download/${list.fileSeq}" style="max-width: 100%;"/>
					</c:forEach>
				</c:if>
			</p>
			<c:out value="${fn:replace(boardPost.cont, crcn, '<br/>')}" escapeXml="false"/>
		</div>

		<a href="#" onclick="list(); return false;" class="listBt">목록보기</a>
	</div>

	<jsp:include page="/WEB-INF/views/mobile/board/board-search-form.jsp" />
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->

</body>
</html>