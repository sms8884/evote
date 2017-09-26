<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/eh.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
           
           function moveDetail(psSeq){
        	   $("#ps_seq").val(psSeq);
        	   $('#form').attr('action', "/admin/cmit/cmit_contest_reqList");
        	   $("form").submit();
           }
           
//]]>
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
				<li>주민참여위원 공모</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<!--leftmenu-->
					<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
			<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">주민참여위원 공모</h3>
					
					<div class="cmitBtnBox">
						<input type="button" onclick="javascript:location.href='/admin/cmit/cmit_contest_writeForm'" class="committee_btn" id="cmitWrite" value="위원 공모 등록하기" name="cmitWrite"/>
					</div>
					
					
					<div class="mainContent">	
						<form id="form" name="form" method="post" class="searchTb">
						<div class="boardList comitteeTable">
							<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
								<caption>공지사항</caption>
								<colgroup>
									<col width="10%"/>
									<col width="*"/>
									<col width="15%"/>
									<col width="7%"/>
									<col width="23%"/>
									<col width="6%"/>
									<col width="12%"/>
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
										<th scope="col">신청서양식</th>
										<th scope="col">등록자</th>
										<th scope="col">모집기간</th>
										<th scope="col">신청자</th>
										<th scope="col">등록일</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach var="item" items="${cmitContestList}" varStatus="status" >
									<tr>
										<td><strong>${pagingHelper.startRowDesc-status.index}</strong></td>
										<td class="tL"><a href="/admin/cmit/cmit_contest_modify/${item.ps_seq}" title="">${item.title}</a></td>
											<c:if test="${not empty item.fileNm}">
											<td ><c:out value="${item.fileNm}"/></td>
											</c:if>
											<c:if test="${item.fileNm == null}">
											<td >파일없음</td>
											</c:if>
											
										<td>${item.userNm}</td>
										<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${item.start_date}"/> 
										~<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${item.end_date}"/></td>
										<td><a href="javascript:moveDetail(${item.ps_seq});">${item.cmitPssrpReqCnt}</a></td>
										<td><fmt:formatDate pattern="yyyy-MM-dd" value="${item.reg_date}"/></td>
									</tr>
								</c:forEach>
				
								</tbody>
							</table>
						</div>
								<input type="hidden" name = "ps_seq" id="ps_seq" value="" />
						</form>
					
						<!-- paging -->
						<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
							<jsp:param name="formId" value="form"/>
							<jsp:param name="action" value="/admin/cmit/cmit_contest_list"/>
						</jsp:include>	
						<!-- //paging -->		
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
