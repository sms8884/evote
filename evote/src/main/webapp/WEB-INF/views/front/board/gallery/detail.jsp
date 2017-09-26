<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/content.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		<c:if test="${board.boardName eq 'cmit'}">
		$('.gnb').topmenu({ d1: 2, d2: 2});
		</c:if>
		<c:if test="${board.boardName ne 'cmit'}">
			$('.gnb').topmenu({ d1: 3, d2: 2});
		</c:if>
	});
	
	function list() {
		$("#searchForm").attr("action", "/board/${board.boardName}/list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function detail(postSeq) {
		$("#searchForm").attr("action", "/board/${board.boardName}/" + postSeq);
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<!-- board-breadcrumb -->
<c:choose>
	<c:when test="${board.boardName eq 'cmit'}">
		<div class="location">
			<p>
				<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
				<span>주민참여위원회</span>
				<span><c:out value="${board.boardTitle}"/></span>
			</p>
		</div>		
	</c:when>
	<c:otherwise>
		<jsp:include page="/WEB-INF/views/front/board/board-breadcrumb.jsp"/>
	</c:otherwise>
</c:choose>
<!-- //board-breadcrumb -->

<div id="container" class="container">
	<div class="containerWrap">

		<!-- LNB -->
		<c:choose>
			<c:when test="${board.boardName eq 'cmit'}">
				<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
					<jsp:param name="menuName" value="cmit"/>
				</jsp:include>
			</c:when>
			<c:otherwise>
				<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
					<jsp:param name="menuName" value="notice"/>
				</jsp:include>
			</c:otherwise>
		</c:choose>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit"><c:out value="${board.boardTitle}"/></h3>

			<div class="contents">
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="공지사항 상세보기 - 구분, 조회수, 제목, 등록일, 내용, 첨부파일의 정보를 제공합니다." >
						<caption>공지사항 상세보기</caption>
						<colgroup>
							<col width="100px"/>
							<col width="300px"/>
							<col width="100px"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<c:if test="${board.cateUseYn eq 'Y'}">
								<tr>
									<th scope="row">구분</th>
									<td colspan="3"><c:out value="${boardPost.categoryNm}"/></td>
								</tr>
							</c:if>
						
							<tr>
								<th scope="row">제목</th>
								<td><c:out value="${boardPost.title}"/></td>
								<th scope="row">조회수</th>
								<td><c:out value="${boardPost.readCnt}"/></td>
							</tr>
							<tr>
								<th scope="row">등록자</th>
								<td><c:out value="${boardPost.regUserNm.decValue}"/></td>
								<th scope="row">등록일</th>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${boardPost.regDate}" /></td>
							</tr>
							
							<tr>
								<th scope="row">내용</th>
								<td colspan="3">
									<div class="bCon">
										<c:if test="${board.imageUseYn eq 'Y'}">
											<c:if test="${not empty boardPost.imageList}">
												<c:forEach items="${boardPost.imageList}" var="list">
													<p><img src="/file-download/${list.fileSeq}" style="max-width: 600px;"/></p>
												</c:forEach>
											</c:if>
										</c:if>
										<p><c:out value="${fn:replace(boardPost.cont, entermark, '<br/>')}" escapeXml="false"/></p>
									</div>
								</td>
							</tr>
							
							<c:if test="${board.attachUseYn eq 'Y'}">
								<tr>
									<th scope="row">첨부파일</th>
									<td colspan="3">
										<c:if test="${not empty boardPost.attachList}">
											<c:forEach items="${boardPost.attachList}" var="list">
												<p style="padding: 3px;"><a href="/file-download/${list.fileSeq}"><c:out value="${list.fileSrcNm}"/></a></p>
											</c:forEach>
										</c:if>
									</td>
								</tr>
							</c:if>
							
						</tbody>
					</table>
				</div>
				<div class="btnR">
					<a href="#" class="btn_reset" onclick="list(); return false;">목록보기</a>
				</div>
			</div>


			<div class="boardGlist">
				<p class="boardGlist_btn">
					<c:if test="${not empty prevPost}">
						<a href="javascript:detail('${prevPost.postSeq}');"><img src="${siteImgPath}/common/btn_prev3.gif" alt="이전글 보기"/>이전글</a>
					</c:if>
					<c:if test="${not empty nextPost}">
						<a class="btn_right" href="javascript:detail('${nextPost.postSeq}');">다음글 <img src="${siteImgPath}/common/btn_next3.gif" alt="다음글보기"/></a>
					</c:if>
				</p>
				<c:if test="${not empty prevPost}">
					<dl>
						<dt><c:if test="${not empty prevPost.thumbnail}"><a><img src="/file-download/${prevPost.thumbnail.fileSeq}" alt="" style="width: 93px; height: 61px;"/></a></c:if></dt>
						<dd>				
							<a href="javascript:detail('${prevPost.postSeq}');" class="sf"><c:out value="${prevPost.title}"/></a>
							<span><fmt:formatDate pattern="yyyy-MM-dd" value="${prevPost.regDate}" /></span>				
						</dd>
					</dl>
				</c:if>
				<c:if test="${not empty nextPost}">
					<dl class="btn_right">
						<dt><c:if test="${not empty nextPost.thumbnail}"><a><img src="/file-download/${nextPost.thumbnail.fileSeq}" alt="" style="width: 93px; height: 61px;"/></a></c:if></dt>
						<dd>
							<a href="javascript:detail('${nextPost.postSeq}');" class="sf"><c:out value="${nextPost.title}"/></a>
							<span><fmt:formatDate pattern="yyyy-MM-dd" value="${nextPost.regDate}" /></span>
						</dd>
					</dl>
				</c:if>
			</div>

			<jsp:include page="/WEB-INF/views/front/board/board-search-form.jsp" />
			
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
