<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">

function list() {
	$("#searchForm").attr("action", "/admin/board/${board.boardName}/list");
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

function modify(postSeq) {
	$("#searchForm").attr("action", "/admin/board/${board.boardName}/modify/" + postSeq);
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

function detail(postSeq) {
	$("#searchForm").attr("action", "/admin/board/${board.boardName}/" + postSeq);
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

function remove(postSeq) {
	// 삭제하시겠습니까?
	if(confirm('<spring:message code="message.admin.notice.002" />')) {
		$("#searchForm").attr("action", "/admin/board/${board.boardName}/remove/" + postSeq);
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();
	}
}

<c:if test="${board.pushUseYn eq 'Y' and boardPost.pushSendYn ne 'Y'}">
	function sendPush(postSeq) {
	<c:choose>
		<c:when test="${boardPost.dpYn eq 'Y'}">
		if(confirm('<spring:message code="message.admin.notice.001" arguments="${boardPushDestCount}"/>')) {
			$.ajax({
				type : "POST",
				url : "/admin/board/${board.boardName}/send-gcm/" + postSeq ,			
				success : function(data) {
					if(data.result == true) {
						$("#pushTD").text("푸시발송일시: " + data.pushSendDate);
					} else {
						alert("푸시 발송 오류");
					}
					
				},
				error : function(error) {
					console.log('<spring:message code="message.admin.vote.020"/>');
				}
			});
		}
		</c:when>
		<c:otherwise>
			alert("게시 상태가 미게시일 경우 푸시 발송을 할 수 없습니다.");
		</c:otherwise>
	</c:choose>
	}
</c:if>

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
				<!--leftmenu-->

				<div class="content">
					<h3 class="contentTit"><c:out value="${board.boardTitle}"/></h3>
					<div class="mainContent" style="width:100%;">
						<div class="boardView">
							<table cellpadding="0" cellspacing="0" class="tbL" summary="공지사항 상세보기 - 구분, 조회수, 제목, 등록일, 내용, 첨부파일의 정보를 제공합니다." >
								<caption><c:out value="${board.boardTitle}"/></caption>
								<colgroup>
									<col width="15%"/>
									<col width="*"/>
									<col width="15%"/>
									<col width="15%"/>
								</colgroup>
								<tbody>
									
									<c:if test="${board.pushUseYn eq 'Y'}">
									<tr>
										<th scope="row">푸시 알림</th>
										<td colspan="3" id="pushTD">
											<c:choose>
												<c:when test="${boardPost.pushSendYn eq 'Y'}">
													푸시발송일시: <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${boardPost.pushSendDate}" />
												</c:when>
												<c:otherwise>
													<a href="#" onclick="sendPush('${boardPost.postSeq}'); return false;" class="push_btn" style="float:left;">푸시발송</a>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									</c:if>
									
									<tr>
										<th scope="row">구분</th>
										<td colspan="2"><c:out value="${boardPost.categoryNm}"/></td>
										<td class="pdn c">
											<c:choose>
												<c:when test="${boardPost.topYn eq 'Y'}">
													<label class="chkboxLb"><input type="checkbox" class="chkbox" checked="checked" disabled="disabled"/> 상단고정</label>
												</c:when>
												<c:otherwise>
													<label class="chkboxLb"><input type="checkbox" class="chkbox" disabled="disabled"/> 상단고정</label>
												</c:otherwise>
											</c:choose>
											
										</td>
									</tr>
									<tr>
										<th scope="row">제목</th>
										<td colspan="3"><c:out value="${boardPost.title}"/></td>
									</tr>
									<tr>
										<th scope="row">내용</th>
										<td colspan="3">
											<div class="bCon" style="max-width: 100%;">

												<c:choose>
													<c:when test="${board.editorUseYn eq 'Y'}">
														<c:out value="${boardPost.cont}" escapeXml="false"/>
													</c:when>
													<c:otherwise>
														<p><c:out value="${fn:replace(boardPost.cont, crcn, br)}" escapeXml="false"/></p>
														<c:if test="${board.imageUseYn eq 'Y'}">
															<c:if test="${not empty boardPost.imageList}">
																<c:forEach items="${boardPost.imageList}" var="list">
																	<p><img src="/file-download/${list.fileSeq}" style="max-width: 600px;"/></p>
																</c:forEach>
															</c:if>
														</c:if>
													</c:otherwise>
												</c:choose>
												
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
									
									<tr>
										<th scope="row">게시</th>
										<td colspan="3" class="radChk">
											<c:choose>
												<c:when test="${boardPost.dpYn eq 'Y'}">
													<input type="radio" class="noticeR1" id="noticeR1" disabled="disabled" checked="checked"/><label for="noticeR1">게시</label>
													<input type="radio" class="noticeR2" id="noticeR2" disabled="disabled"/><label for="noticeR2">미게시</label>
												</c:when>
												<c:otherwise>
													<input type="radio" class="noticeR1" id="noticeR1" disabled="disabled"/> 게시
													<input type="radio" class="noticeR2" id="noticeR2" disabled="disabled" checked="checked"/> 미게시
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btnR">
							<a href="#" onclick="remove('${boardPost.postSeq}'); return false;" class="btn_blue" style="float:left;">삭제하기</a>
							<a href="#" onclick="modify('${boardPost.postSeq}'); return false;" class="btn_blue">수정하기</a>
							<a href="#" onclick="list(); return false;" class="btn_reset">목록보기</a>
						</div>
					</div>

					<div class="boardVlist">
						<c:if test="${not empty prevPost}">
						<dl class="left">
							<dt><a href="javascript:detail('${prevPost.postSeq}');"><img src="${siteImgPath}/common/btn_prev3.gif" alt="이전글 보기"/>이전글</a></dt>
							<dd>
								<a href="javascript:detail('${prevPost.postSeq}');"><c:out value="${prevPost.title}"/></a>
								<span><fmt:formatDate pattern="yyyy-MM-dd" value="${prevPost.regDate}" /></span>
							</dd>
						</dl>
						</c:if>
						<c:if test="${not empty nextPost}">
						<dl class="right">
							<dt><a href="javascript:detail('${nextPost.postSeq}');">다음글 <img src="${siteImgPath}/common/btn_next3.gif" alt="다음글보기"/></a></dt>
							<dd>
								<a href="javascript:detail('${nextPost.postSeq}');"><c:out value="${nextPost.title}"/></a>
								<span><fmt:formatDate pattern="yyyy-MM-dd" value="${nextPost.regDate}" /></span>
							</dd>
						</dl>
						</c:if>
					</div>
					
					<jsp:include page="/WEB-INF/views/admin/board/board-search-form.jsp" />
					
				</div><!--content-->
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
