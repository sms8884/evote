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
		var birthDateTmp = '${cmitContestReq.memInfo.birthDate}';
		var birthMonth = birthDateTmp.substring(0,2);
		var birthDay = birthDateTmp.substring(2,4);
		var birthDate= '${cmitContestReq.memInfo.birthYear}' + '.' + birthMonth +'.' + birthDay+'.' ;
		$("#birth").text(birthDate);
	});
	
	function remove(reqSeq){
		if(confirm("삭제하시겠습니까?")){
			location.href = "/cmit/cmit_contest_reqRemove/"+reqSeq;
		}
	}
	
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
	<div class="containerWrap">
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="cmit"/>
		</jsp:include>
		<!-- //LNB -->	
		<div class="contentsWrap">
			<h3 class="contentTit">주민참여위원공모 신청상세</h3>
			<div class="contents">
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="제안사업 상세보기 - 등록자, 등록일, 조회수, 처리상태, 소요사업비, 사업기간, 사업위치, 제안취지, 내용, 기대효과, 사진, 신청서 등록 정보를 보는 화면입니다." >
						<caption>제안사업 상세보기</caption>
						<colgroup>
							<col width="15%"/>
							<col width="35"/>
							<col width="15%"/>
							<col width="35%"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">신청인</th>
								<td><c:out value="${cmitContestReq.memInfo.userNm.decValue}"/></td>
								<th scope="row">휴대폰번호</th>
								<td><c:out value="${cmitContestReq.memInfo.phone.decValue}"/></td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td><c:out value="${cmitContestReq.memInfo.email.decValue}"/></td>
								<th scope="row">연락처</th>
								<td><c:out value="${cmitContestReq.phone}"/></td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td colspan="3"><c:out value="${cmitContestReq.addr1}"/>&nbsp;<c:out value="${cmitContestReq.addr2}"/></td>
							</tr>
							<tr>
								<th scope="row">생년월일</th>
								<td id="birth"></td>
								<th scope="row">직업</th>
								<td><c:out value="${cmitContestReq.job}"/></td>
							</tr>
							<tr>
								<th scope="row">성별</th>
								<td colspan="3">
									<c:if test="${cmitContestReq.memInfo.gender eq 'M'}">남자</c:if>
									<c:if test="${cmitContestReq.memInfo.gender eq 'F'}">여자</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">희망분과</th>
								<td colspan="3">
									<c:out value="${cmitContestReq.subCmit1}"/>
									<c:if test="${cmitContestReq.subCmit2 == null}"></c:if>
									<c:if test="${not empty cmitContestReq.subCmit2 }">(<c:out value="${cmitContestReq.subCmit2}"/>)</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">자기소개서</th>
								<td colspan="3"><c:out value="${fn:replace(cmitContestReq.intro, crcn, br)}" escapeXml="false"/></td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
								<td colspan="3">
									<c:if test="${not empty cmitContestReq.attachFile}">
										<p style="padding: 3px;"><a href="/file-download/${cmitContestReq.attachFile.fileSeq}"><c:out value="${cmitContestReq.attachFile.fileSrcNm}"/></a></p>
									</c:if>
									<c:if test="${not empty cmitContestReq.imageFile}">
										<p style="padding: 3px;"><a href="/file-download/${cmitContestReq.imageFile.fileSeq}"><c:out value="${cmitContestReq.imageFile.fileSrcNm}"/></a></p>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="Ct_btnBx" style="width: 100%">
					<a href="#" class="delete" onclick = "remove(${cmitContestReq.req_seq})" >삭제</a>
					<a href="#" class="list" onclick = "javascript:history.back()" style="float: right;">목록</a>
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
