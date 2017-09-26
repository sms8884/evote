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
			
				<jsp:include page="/WEB-INF/views/front/board/board-search.jsp" />
				
				<c:if test="${not empty searchParam}">
				<p class="caption">총 <c:out value="${pagingHelper.totalCnt}"/>건이 검색되었습니다.</p>
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
							</li>
						</c:forEach>
					</ul>
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
