<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">
	<div class="location">
		<img src="${siteImgPath}/common/locaHome.png" alt=""/>
		<span>주민참여위원회</span>
		<span>위원회역할</span>
	</div>
	<div class="containerWrap">
		<div class="contents">
			<div class="pTit2Wrap">
				<p class="pTit2">조직구성</p>	
			</div>
			<div class="budgetImgBox">
				<img src="${siteImgPath}/sub2/budgetInfo.png" alt=""/>
			</div>
			<div class="pTit2Wrap">
				<p class="pTit2">기능</p>	
			</div>
			<div class="boardWrite budget">
				<table cellpadding="0" cellspacing="0" class="infoCostTable02" summary="신청기간, 신청대상, 신청분야, 신청방법, 사업선정방법을 알 수 있는 표입니다." >
					<colgroup>
						<col width="80"/>
						<col width="*"/>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">참여예산<br/>시민위원회</th>
							<td>
								<ul class="">
									<li>예산편성에 관한 주민의견 수렴</li>
									<li>주요 사업계획 수립 및 집행과정에 대한 의견제시</li>
									<li>분과위원회, 지역회의, 주민총회 등 개최</li>
								</ul>
							</td>
						</tr>
						<tr>
							<th scope="row">참여예산<br/>지역회의</th>
							<td>
								<ul class="">
									<li>예산위원, 주민자치위원, 지역주민 10명 이상 참석으로 성립</li>
									<li>지역의제 설정 등 지역문제 해결을 위한 주민들의 다양한 의견 수렴</li>
									<li>지역의제 추진을 위한 예산 관련사항 논의 및 제안 등</li>
								</ul>
							</td>
						</tr>
						<tr>
							<th scope="row">분과위원회</th>
							<td>
								<ul class="">
									<li>총 10개 분과로 상시 운영하며 주민 주도성 강화</li>
									<li>소관부서 주요 사업계획 수립 시 사전 검토 및 의견 제시</li>
									<li>업무분야별 사업제안 및 건의사항, 정보공유 등</li>
									<li>소관부서별 예산(안) 협의·조정 ⇒ 필요 시 사업 현장방문</li>
								</ul>
							</td>
						</tr>
						
						
					</tbody>
				</table>
			</div>

		

		</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
	
</div>

</body>
</html>
