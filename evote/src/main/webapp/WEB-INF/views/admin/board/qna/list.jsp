<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script src="${siteJsPath}/board-list.js?n=1" language="javascript" type="text/javascript"></script>

<script language="javascript" type="text/javascript">

$(document).ready(function() {
	initSearchParam();
	$('#tmpText').on('keypress', function(e) {
		if(e.keyCode == 13){
			e.preventDefault();
			searchPost();
		}
	});
});

function initSearchParam() {
	$("#tmpText").val("${searchParam.searchText}");
	if("${searchParam.searchCategoryCd}" != "") {
		$("#tmpCategoryCd").val("${searchParam.searchCategoryCd}");
	}
	if("${searchParam.searchTarget}" != "") {
		$("#tmpTarget").val("${searchParam.searchTarget}");
	}
	if("${searchParam.searchReplyYn}" != "") {
		$("#tmpReplyYn").val("${searchParam.searchReplyYn}");
	}
}

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
				<li>문의하기</li>
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
						<form method="post" action="" class="searchTb">
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption><c:out value="${board.boardTitle}"/></caption>
									<colgroup>
										<col width="105"/>
										<col width="280"/>
										<col width="105"/>
										<col width="280"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">답변상태</th>
											<td>
												<select id="tmpReplyYn" title="답변상태" style="width:127px;">
													<option value="" selected="selected">전체</option>
													<option value="Y">답변등록</option>
													<option value="N">답변미등록</option>

												</select>
											</td>
											
											<c:if test="${board.cateUseYn eq 'Y'}">
												<th scope="row">구분</th>
												<td>
													<select id="tmpCategoryCd" title="구분" class="wid100">
														<option value="">전체</option>
														<c:forEach items="${boardCategoryList}" var="list">
															<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
														</c:forEach>
													</select>
												</td>
											</c:if>
											
										</tr>
										<tr>
											<th scope="row" class="bln">검색</th>
											<td colspan="3">
												<select id="tmpTarget" title="검색" style="width:127px;">
													<option value="TITLE">제목</option>
													<option value="CONT">내용</option>
												</select>
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" class="it wid350" id="tmpText"/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="#" class="btn_blue" onclick="searchPost(); return false;">검색</a>
								</div>
							</fieldset>
						</form>
						<div class="boardList">
							<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
								<caption>문의하기</caption>
								<colgroup>
									<col width="10%"/>
									<col width="*"/>
									<col width="15%"/>
									<col width="15%"/>
									<col width="20%"/>
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
										<th scope="col">문의자</th>
										<th scope="col">답변</th>
										<th scope="col">등록일</th>
									</tr>
								</thead>
								<tbody>
								
									<c:forEach items="${boardPostList}" var="list" varStatus="status">
									
										<tr>
											<td><strong><c:out value="${pagingHelper.startRowDesc - status.index}" /></strong></td>
											<td class="tL">
												<c:if test="${list.hideYn eq 'Y'}">
													<p style="font-size: 13px; color:#aaa;">숨김 처리된 글입니다.</p>
												</c:if>
												<c:if test="${list.secYn eq 'Y'}"><img src="${siteImgPath}/common/writePw.png" />&nbsp;</c:if>
												<a href="javascript:detail('${list.postSeq}');" title=""><c:out value="${list.title}"/></a>
											</td>
											<td>
												<c:choose>
													<c:when test="${list.regUser lt 0}"><c:out value="${list.regUserNm.decValue}"/></c:when>
													<c:otherwise><c:out value="${list.append1}"/></c:otherwise>
												</c:choose>
											</td>
											<td>
												<c:choose>
													<c:when test="${list.append4 eq 'Y'}">등록</c:when>
													<c:otherwise>미등록</c:otherwise>
												</c:choose>
											</td>
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" /></td>
										</tr>
									
									</c:forEach>
									
								</tbody>
							</table>
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
