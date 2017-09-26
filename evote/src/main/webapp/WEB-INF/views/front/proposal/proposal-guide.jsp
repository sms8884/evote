<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 3, d3:0});
		
		<c:if test="${proposalLoginYn eq 'Y'}">
		openLoginLayer();
		</c:if>		
	});
	
	function openLoginLayer() {
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 460 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
	}

	function etcFileDownload(fileSeq) {
		location.href = "/file-download/etc/" + fileSeq;
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
		<span>주민참여예산제</span>
		<span>정책제안</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">

		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="proposal"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">주민참여예산 정책제안</h3>

			<div class="contents">
				<div class="pTit2Wrap">
					<p class="pTit2">주민참여예산 상시제안</p><div class="whitebox ptit2next"><a href="#" onclick="etcFileDownload(3); return false;">제안양식보기</a></div>
				</div>
				
				<div class="pInfoBox">
					우리 지역에 필요한 정책을 자유롭게 제안할 수 있습니다.
				</div>
				<div class="boardWrite boardShow">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="신청기간, 신청대상, 신청분야, 신청방법, 사업선정방법을 알 수 있는 표입니다." >
						<caption>주민참여예산 상시제안 알아보기</caption>
						<colgroup>
							<col width="16%"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">신청기간</th>
								<td>
									상시
								</td>
							</tr>
							<tr>
								<th scope="row">신청대상</th>
								<td>은평구민 누구나(구 소재 사업장 및 기관 포함)</td>
							</tr>
							<tr>
								<th scope="row">신청분야</th>
								<td>
									6개 분야<br/>- 지역경제, 공동체문화, 사회적 약자 배려, 시민 참여, 주민생활 향상, 청소년·청년
									<div class="whitebox"><a href="#" onclick="etcFileDownload(2); return false;">사업주제목록</a></div>
								</td>
							</tr>
							<tr>
								<th scope="row">신청방법</th>
								<td>온라인, 방문 및 우편 가능
									<div class="whitebox"><a href="#" onclick="etcFileDownload(1); return false;">신청서다운로드</a></div>
								</td>
							</tr>
							<tr>
								<th scope="row">사업범위</th>
								<td>지역 특성을 살리고 구 단위의 통일성 사업 또는 2개 이상 동에 미치는 사업
								</td>
							</tr>
							<tr>
								<th scope="row">부적격 사업</th>
								<td>
									<ul>
										<li>특정단체(개인)만의 지원을 전체로 요구한 사업, 사업추진방식이 위탁이 포함된 사업, 사업당 초 운영비 등의<br/> 
										     지원을 전제로 제안한 계속사업</li>
										<li>이미 설치 중인 시, 구의 공공도서관, 복지관 등 시설 운영비 증액사업</li>
										<li>단년도 사업이 아니거나 국시비매칭 사업, 단순시설 설치사업(CCTV, 도로보수 등)</li>
										<li>사업체가 특정제품 판매를 목적으로 제안된 사업 </li>
										<li>임대보증금 지원 사업 및 재산성 물품을 구입하는 사업 등</li>
									</ul>
								</td>
							</tr>
							<tr>
								<th scope="row">사업 선정방법</th>
								<td>
									<ul>
										<li>사업부서 법령 적합 여부 등 검토, 분과위원회 검토</li>
										<li>서울시 및 은평구 참여예산사업으로 공모 진행 또는 정책사업으로 추진</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="btnC2">
					<a href="/proposal/write" class="btn_blue2img"><img src="${siteImgPath}/ehimg/c3_bluebtn2bg.png" alt="내 제안 등록하기"/>내 제안 등록하기</a>
				</div>
				<div class="pTit2Wrap">
					<p class="pTit2">정책제안 함께 생각하기</p><p class="pTableMore"><a href="/proposal/list"><img src="${siteImgPath}/ehimg/more.png" alt="더보기"/>더보기</a></p>
				</div>
				
				<div class="boardWrite boardInfo2">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="사회적약자 배려, 지역경제 및 시민참여, 청년 및 기타의 내용을 확인 할 수 있는 표입니다." >
						<caption>정책제안 함께 생각하기</caption>
						<colgroup>
							<col width="22%"/>
							<col width="*"/>
							<col width="15%"/>
						</colgroup>
						<tbody>
						<c:forEach items="${proposalList}" var="list">
							<tr>
								<th scope="row"><c:out value="${list.realmNm}"/></th>
								<td onclick="javascript:location.href='/proposal/detail/${list.propSeq}'" style="cursor: pointer;"><c:out value="${list.bizNm}"/></td>
								<td><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			
				<div id="loginLayer" class="loginMbtLayer layer_block">
					<p class="tit">로그인</p>
					<div class="loginMbtLayerCon">
						<p class="txt3"><spring:message code="message.proposal.018"/></p>
						<a href="#" onclick="javascript:location.href='/proposal/auth-phone';" class="btC1 layerClose2"><span>휴대폰인증</span></a>
						<a href="#" onclick="javascript:location.href='/login'" class="btC1 layerClose2"><span>로그인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
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
