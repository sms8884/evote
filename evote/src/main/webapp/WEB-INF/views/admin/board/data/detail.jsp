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
							$("#pushTD").text(data.pushSendDate);
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
				<li>자료실</li>
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
								<table cellpadding="0" cellspacing="0" class="tbR" summary="" >
									<caption><c:out value="${board.boardTitle}"/></caption>
									<colgroup>
										<col width="100px"/>
										<col width="300px"/>
										<col width="120px"/>
										<col width="*"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">구분</th>
											<td>
												<c:choose>
													<c:when test="${board.cateUseYn eq 'Y'}"><c:out value="${boardPost.categoryNm}"/></c:when>
													<c:otherwise>자료실</c:otherwise>
												</c:choose>
											</td>
											<th scope="row">푸시발송일시</th>
											<td id="pushTD">
												<c:choose>
													<c:when test="${boardPost.pushSendYn eq 'Y'}">
														<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${boardPost.pushSendDate}" />
													</c:when>
													<c:otherwise>
														<a href="#" onclick="sendPush('${boardPost.postSeq}'); return false;" class="push_btn" style="float:left;">푸시발송</a>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
										<tr>
											<th scope="row">제목</th>
											<td><c:out value="${boardPost.title}"/></td>
											<th scope="row">등록일</th>
											<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${boardPost.regDate}" /></td>
										</tr>
										<tr>
											<th scope="row">등록자</th>
											<td><c:out value="${boardPost.regUserNm.decValue}"/></td>
											<th scope="row">조회수</th>
											<td><c:out value="${boardPost.readCnt}"/></td>
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
										
										<tr class="Rcon">
											<th scope="row">내용</th>
											<td colspan="3"><c:out value="${fn:replace(boardPost.cont, entermark, '<br/>')}" escapeXml="false"/></td>
										</tr>
										<tr class="R_post" >
											<th scope="row">게시</th>
											<td colspan="3">
												<c:choose>
													<c:when test="${boardPost.dpYn eq 'Y'}">
														<input type="radio" class="" title="" value="" name="circle" id="select1" disabled="disabled" checked="checked"><label for="select1">게시</label>
														<input type="radio" class="" title="" value="" name="circle" id="select2" disabled="disabled"><label for="select2">미게시</label>
													</c:when>
													<c:otherwise>
														<input type="radio" class="" title="" value="" name="circle" id="select1" disabled="disabled"><label for="select1">게시</label>
														<input type="radio" class="" title="" value="" name="circle" id="select2" disabled="disabled" checked="checked"><label for="select2">미게시</label>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</tbody>
								</table>
					
						<div class="btnbox_RL1">
							<a href="#" onclick="remove('${boardPost.postSeq}'); return false;" class="btn_gray">삭제</a>
							<a href="#" onclick="modify('${boardPost.postSeq}'); return false;" class="btn_blue">수정</a>
							<a href="#" onclick="list(); return false;" class="btn_reset">목록</a>
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

				</div>	
			</div><!--contentWrap-->
		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
