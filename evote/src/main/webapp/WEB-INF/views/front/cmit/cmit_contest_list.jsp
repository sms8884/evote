<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->
<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 2, d2: 3});
	});
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>주민참여위원회</span>
		<span>주민참여위원공모</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap" >
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="cmit"/>
		</jsp:include>
		<!-- //LNB -->	
		<div class="contentsWrap">
		
			<h3 class="contentTit">주민참여위원공모 신청내역</h3>
			<div class="contents"  style="height:600px;">
				<div class="boardList">
					<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
						<caption>공지사항</caption>
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
								<th scope="col">신청자</th>
								<th scope="col">희망분과</th>
								<th scope="col">신청일</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${cmitReqList}" varStatus="status" >
							<tr>
								<td><strong>${status.count}</strong></td>
								<td class="tL"><a href="/cmit/cmit_contest_reqView/${item.req_seq}" title="">${item.title}</a></td>
								<td>${item.userNm }</td>
								<td>${item.subCmit1}<br/><span> 
								<c:if test="${item.subCmit2 == null}"></c:if>
								<c:if test="${not empty item.subCmit2 }">(${item.subCmit2})</c:if>
								 </span></td>
								<td> ${item.reg_date}</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
					<p class="Ct_app">
						<span class="red2">※ 위원공모 신청 정보는 주민 참여위원 해촉기간까지 보관됩니다.</span>
					</p>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
