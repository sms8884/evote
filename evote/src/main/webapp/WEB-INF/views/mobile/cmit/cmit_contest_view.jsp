<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">

//<![CDATA[
$(document).ready(function(){
	var birthDateTmp = '${cmitContestReq.memInfo.birthDate}';
	var birthMonth = birthDateTmp.substring(0,2);
	var birthDay = birthDateTmp.substring(2,4);
	var birthDate= '${cmitContestReq.memInfo.birthYear}' + '.' + birthMonth +'.' + birthDay+'.' ;
	$("#birth").text(birthDate);
	
});

//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">

	<div class="location">
		<img src="${siteImgPath}/common/locaHome.png" alt=""/>
		<span>주민참여위원회</span>
		<span>위원공모</span>
		<span>신청내역 상세보기</span>
	</div>

	<p class="budgetTit">주민참여위원공모 신청내역</p>

	<div class="boardView">
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/>
				<col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">신청인</th>
					<td><c:out value="${cmitContestReq.memInfo.userNm.decValue}"/></td>
				</tr>
				<tr>
					<th scope="row">휴대폰번호</th>
					<td><c:out value="${cmitContestReq.memInfo.phone.decValue}"/></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><c:out value="${cmitContestReq.memInfo.email.decValue}"/></td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td><c:out value="${cmitContestReq.phone}"/></td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td colspan="3">
						<c:out value="${cmitContestReq.addr1}"/>&nbsp;
						<c:out value="${cmitContestReq.addr2}"/>
					 </td>
				</tr>
				<tr>
					<th scope="row">직업</th>
					<td>${cmitContestReq.job}</td>
				</tr>
				<tr>
					<th scope="row">성별</th>
					<td>
						<c:if test="${cmitContestReq.memInfo.gender eq 'M'}">남자</c:if>
						<c:if test="${cmitContestReq.memInfo.gender eq 'F'}">여자</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">희망분과</th>
					<td>
						<c:out value="${cmitContestReq.subCmit1}"/>
						<c:if test="${cmitContestReq.subCmit2 == null}"></c:if>
						<c:if test="${not empty cmitContestReq.subCmit2 }">(${cmitContestReq.subCmit2})</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">자기소개서</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(cmitContestReq.intro, crcn, br)}" escapeXml="false"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td>	
						<c:if test="${not empty cmitContestReq.attachFile}">
							<a href="/file-download/${cmitContestReq.attachFile.fileSeq}"><c:out value="${cmitContestReq.attachFile.fileSrcNm}"/></a>
						</c:if>
						<c:if test="${not empty cmitContestReq.imageFile}">
							<a href="/file-download/${cmitContestReq.imageFile.fileSeq}"><c:out value="${cmitContestReq.imageFile.fileSrcNm}"/></a>
						</c:if>
					</td>
				</tr>
			</tbody>
		</table>
		<a href="javascript:history.back()" class="listBt">목록보기</a>
	</div>
<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer --></div>
</body>
</html>
