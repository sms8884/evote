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
		$('.gnb').topmenu({ d1: 3, d2: 1});
		initSearchParam();
		gfnSetPeriodDatePicker("startDate", "endDate");
		$('#tmpText').on('keypress', function(e) {
			if(e.keyCode == 13){
				e.preventDefault();
				searchPost();
			}
		});
	});
	
	function initSearchParam() {
		$("#startDate").val("${searchParam.searchStartDate}");
		$("#endDate").val("${searchParam.searchEndDate}");
		$("#tmpText").val("${searchParam.searchText}");

		if("${searchParam.searchCategoryCd}" != "") {
			$("#tmpCategoryCd").val("${searchParam.searchCategoryCd}");
		}
		
		if("${searchParam.searchTarget}" != "") {
			$("#tmpTarget").val("${searchParam.searchTarget}");
		}	
	}

	function searchPost() {
		$("#searchStartDate").val($("#startDate").val());
		$("#searchEndDate").val($("#endDate").val());
		$("#searchCategoryCd").val($("#tmpCategoryCd").val());
		$("#searchTarget").val($("#tmpTarget").val());
		$("#searchText").val($("#tmpText").val());
		gotoPage(1);
	}

	function searchReset() {
		$("#startDate").val("");
		$("#endDate").val("");
		$("#tmpCategoryCd").val("");
		$("#tmpTarget").val("TITLE");
		$("#tmpText").val("");
	}

	function detail(seq) {
		$("#searchForm").attr("action", "/board/${board.boardName}/" + seq);
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
<jsp:include page="/WEB-INF/views/front/board/board-breadcrumb.jsp"/>
<!-- //board-breadcrumb -->

<div id="container" class="container">
	<div class="containerWrap">
		
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="notice"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit"><c:out value="${board.boardTitle}"/></h3>

			<div class="contents">
				
				<jsp:include page="/WEB-INF/views/front/board/board-search.jsp" />
				
				<c:if test="${not empty searchParam}">
				<p class="caption">총 <c:out value="${pagingHelper.totalCnt}"/>건이 검색되었습니다.</p>
				</c:if>
				
				
				<div class="boardList">
					<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
						<caption>공지사항</caption>
						<colgroup>
							<col width="15%"/>
							<c:if test="${board.cateUseYn eq 'Y'}">
							<col width="15%"/>
							</c:if>
							<col width="*"/>
							<col width="10%"/>
							<col width="20%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<c:if test="${board.cateUseYn eq 'Y'}">
								<th scope="col">구분</th>
								</c:if>
								<th scope="col">제목</th>
								<th scope="col">조회수</th>
								<th scope="col">등록일</th>
							</tr>
						</thead>
						<tbody>
						
							<c:if test="${board.topUseYn eq 'Y'}">
								<c:forEach items="${boardTopList}" var="list">
								<tr>
									<td><strong><img src="${siteImgPath}/common/board_icon1.gif" alt="중요"/></strong></td>
									<c:if test="${board.cateUseYn eq 'Y'}">
									<td><strong><c:out value="${list.categoryNm}"/></strong></td>
									</c:if>
									<td class="tL" style="max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><strong><a href="javascript:detail('${list.boardSeq}');"><c:out value="${list.title}"/></a></strong></td>
									<td><c:out value="${list.readCnt}"/></td>
									<td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" /></td>
								</tr>
								</c:forEach>
							</c:if>
													
							<c:forEach items="${boardPostList}" var="list" varStatus="status">
							<tr>
								<td><c:out value="${pagingHelper.startRowDesc - status.index}" /></td>
								<c:if test="${board.cateUseYn eq 'Y'}">
								<td><c:out value="${list.categoryNm}"/></td>
								</c:if>
								<td class="tL" style="max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><a href="javascript:detail('${list.postSeq}');"><c:out value="${list.title}"/></a></td>
								<td><c:out value="${list.readCnt}"/></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" /></td>
							</tr>
							</c:forEach>
							
						</tbody>
					</table>
				</div>

				<jsp:include page="/WEB-INF/views/front/board/board-search-form.jsp" />
				
				<jsp:include page="/WEB-INF/views/front/board/board-paging.jsp">
					<jsp:param name="formId" value="searchForm"/>
					<jsp:param name="action" value="/board/${board.boardName}/list"/>
				</jsp:include>

			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
