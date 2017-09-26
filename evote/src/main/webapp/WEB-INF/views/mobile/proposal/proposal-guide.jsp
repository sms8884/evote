<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		<c:if test="${proposalLoginYn eq 'Y'}">
		openLoginLayer();
		</c:if>		
	});
	
	function openLoginLayer() {
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 300 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
	}
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
		<span>주민참여예산제</span>
		<span>소개</span>
	</div>
	<div class="containerWrap">
		<div class="contents">
			
			<div class="pInfoBox">
				<p>우리 지역에 필요한 정책을 <br/>자유롭게 제안할 수 있습니다.</p>
			</div>
			<div class="pTit2Wrap">
				<p class="pTit2">주민참여예산 상시제안</p>
				<a href="/proposal/sample" target="_blank" class="btn">예시보기</a>
			</div>
			<div class="boardWrite">
				<table cellpadding="0" cellspacing="0" class="infoCostTable02" summary="신청기간, 신청대상, 신청분야, 신청방법, 사업선정방법을 알 수 있는 표입니다." >
					<colgroup>
						<col width="80"/>
						<col width="*"/>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">신청기간</th>
							<td>상시</td>
						</tr>
						<tr>
							<th scope="row" colspan="2">신청대상</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								은평구민 누구나(구 소재 사업장 및 기관 포함)
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2">
								<div class="top">신청분야<a href="${resourcePath}/file/160706앱자료(내정책제안하기)_첨부2_0713.hwp">사업주제목록</a></div>
							</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								6개 분야 - 지역경제, 공동체문화,사회적 약자 배려,시민 참여, 주민생활 향상, 청소년·청년
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2">
								<div class="top">신청방법<a href="${resourcePath}/file/160706앱자료(내정책제안하기)_첨부1_0712.hwp">신청서다운로드</a></div>
							</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								은평구민 누구나(구 소재 사업장 및 기관 포함)
							</td>
						</tr>

						<tr>
							<th scope="row" colspan="2">
								<div class="top">부적격 사업</div>
							</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								<ul>
									<li>특정단체(개인)만의 지원을 전체로 요구한 사업, 사업추진방식이 위탁이 포함된 사업, 사업당 초 운영비 등의 지원을 전제로 제안한 계속사업</li>
									<li>이미 설치 중인 시, 구의 공공도서관, 복지관 등 시설 운영비 증액사업</li>
									<li>단년도 사업이 아니거나 국시비매칭 사업, 단순시설 설치사업(CCTV, 도로보수 등)</li>
									<li>사업체가 특정제품 판매를 목적으로 제안된 사업 </li>
									<li>임대보증금 지원 사업 및 재산성 물품을 구입하는 사업 등</li>
								</ul>
							</td>
						</tr>
						
						
						
						<tr>
							<th scope="row" colspan="2" class="b_none">사업선정방법</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								<ul class="">
									<li>사업부서 법령 적합 여부 등 검토, 분과위원회 검토(제안자와 구체화 추진)</li>
									<li>평가단 심사(평가표), 모바일 및 현장투표, 주민한마당총회(최종 결정)</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="btnC">
				<a href="/proposal/write" class="btn_blue"><span class="my">내 제안 등록하기</span></a>
			</div>
			
			<div class="pTit2Wrap">
				<p class="pTit2">정책제안 함께 생각하기</p><a href="/proposal/list" class="more">더보기</a>
			</div>

			<div class="board">
				<ul class="">
				<c:forEach items="${proposalList}" var="list">
					<li><a href="/proposal/detail/${list.propSeq}"><c:out value="${list.bizNm}"/></a></li>
				</c:forEach>
				</ul>
			</div>
			
			<div id="loginLayer" class="layer_block layerPop">
				<p class="layerTit">
					<strong>로그인</strong>
					<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
				</p>
				<div class="layerCont">
					<p style="margin: 10px 0 10px 0; text-align: center;"><strong><spring:message code="message.proposal.018"/></strong></p>
					<p class="bt">
						<a href="/proposal/auth-phone" class="ok" style="float:none;"><span>휴대폰인증</span></a>
						<a href="/login" class="ok" style="float:none;"><span>로그인</span></a>
					</p>
				</div>
			</div>

		</div>
		
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>
		
</body>
</html>