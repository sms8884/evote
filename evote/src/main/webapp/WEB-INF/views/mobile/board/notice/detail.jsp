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
	<jsp:include page="/WEB-INF/views/mobile/board/board-breadcrumb.jsp"/>
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
				<tr>
					<th scope="row" colspan="2">내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(boardPost.cont, crcn, '<br/>')}" escapeXml="false"/>
							<c:if test="${board.imageUseYn eq 'Y'}">
								<c:if test="${not empty boardPost.imageList}">
									<c:forEach items="${boardPost.imageList}" var="list">
										<p class="img"><img src="/file-download/${list.fileSeq}" style="max-width: 100%;"/></p>
									</c:forEach>
								</c:if>
							</c:if>
						</div>
					</td>
				</tr>
				
				<c:if test="${board.attachUseYn eq 'Y'}">
					<tr>
						<th scope="row">첨부파일</th>
						<td>
							<c:if test="${not empty boardPost.attachList}">
								<c:forEach items="${boardPost.attachList}" var="list">
									<a href="/file-download/${list.fileSeq}"><c:out value="${list.fileSrcNm}"/></a>

								</c:forEach>
							</c:if>
						</td>
					</tr>
				</c:if>
				
			</tbody>
		</table>
		
		<a href="#" onclick="list(); return false;" class="listBt">목록보기</a>
	</div>

	<div class="boardnp">
		<p>
			<c:if test="${not empty prevPost}">
				<a href="#" onclick="detail('${prevPost.postSeq}'); return false;" class="prev">
					<strong>이전글</strong>
					<span><c:out value="${prevPost.title}"/></span>
				</a>
			</c:if>
			
			<c:if test="${not empty nextPost}">
			
				<a href="#" onclick="detail('${nextPost.postSeq}'); return false;" class="next">
					<strong>다음글</strong>
					<span><c:out value="${nextPost.title}"/></span>
				</a>
			</c:if>
		</p>
	</div>

	<jsp:include page="/WEB-INF/views/mobile/board/board-search-form.jsp" />
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
	
</div>

</body>
</html>