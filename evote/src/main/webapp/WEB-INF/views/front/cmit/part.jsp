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
		$('.gnb').topmenu({ d1: 2, d2: 1});
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
		<span>위원회역할</span>
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
			<h3 class="contentTit">위원회역할</h3>
			<div class="contents">
				<p class="commiteeR_title">조직구성</p>
				<p class="commiteeRc"><img src="${siteImgPath}/common/commiteeRc.png" alt=""/></p>
				<p class="commiteeR_title">기능</p>
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="공지사항 상세보기 - 구분, 조회수, 제목, 등록일, 내용, 첨부파일의 정보를 제공합니다." >
						<caption>자료실 상세보기</caption>
						<colgroup>
							<col width="25%"/>
							<col width="*"/>
						</colgroup>
						<tbody class="committeeRf">
							<tr>
								<th >참여예산시민위원회</th>
								<td>
									<li style="list-style-type:square;">예산편성에 관한 주민의견 수렴</li>
									<li style="list-style-type:square;">주요 사업계획 수립 및 집행과정에 대한 의견제시</li>
									<li style="list-style-type:square;">분과위원회, 지역회의, 주민총회 등 개최</li>
								</td>
							</tr>
							<tr>
								<th>참여예산 지역회의</th>
								<td>
									<li style="list-style-type:square;">예산위원, 주민자치위원, 지역주민 10명 이상 참석으로 성립</li>
									<li style="list-style-type:square;">지역의제 설정 등 지역문제 해결을 위한 주민들의 다양한 의견 수렴</li>
									<li style="list-style-type:square;">지역의제 추진을 위한 예산 관련사항 논의 및 제안 등</li>
								</td>
							</tr>
							<tr>
								<th>분과위원회</th>
								<td>
									<li style="list-style-type:square;">총 10개 분과로 상시 운영하며 주민 주도성 강화</li>
									<li style="list-style-type:square;">소관부서 주요 사업계획 수립 시 사전 검토 및 의견제시</li>
									<li style="list-style-type:square;">업무분야별 사업제안 및 건의사항, 정보공유 등</li>
									<li style="list-style-type:square;">소관부서별 예산(안) 협의 조정>필요 시 사업 현장방문</li>
								</td>
							</tr>
						</tbody>
					</table>
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
