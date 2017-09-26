<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
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
	
	function fileDownload(fileSeq) {
		location.href = "/file-download/" + fileSeq;
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
					<p class="pTit2"><c:out value="${pssrp.title}"/></p>
				</div>
				
				<div class="pInfoBox">
					우리 지역에 필요한 정책을 자유롭게 제안할 수 있습니다.
				</div>
				<div class="boardWrite boardgongmo">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="신청기간, 신청대상, 신청분야, 신청방법, 사업선정방법을 알 수 있는 표입니다." >
						<caption>주민참여예산 상시제안 알아보기</caption>
						<colgroup>
							<col width="17%"/>
							<col width="17%"/>
							<col width="*"/>
						</colgroup>
						<thead>
							<tr>
								<th colspan="3" style="border-right:none;">추진개요</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row">운영규모</th>
								<td colspan="2">
									<c:out value="${pssrp.opScale}"/>
								</td>
							</tr>
							<tr>
								<th scope="row" rowspan="3">일반사업</th>
								<td class="tex-m">사업범위</td>
								<td>
									<c:out value="${pssrp.gnrScope}"/>
								</td>
							</tr>
							<tr>
								<td class="tex-m">전체규모</th>
								<td>
									<c:out value="${pssrp.gnrScale}"/>
								</td>
							</tr>
							<tr>
								<td class="tex-m">사업비기준</th>
								<td>
									<c:out value="${pssrp.gnrStd}"/>
								</td>
							</tr>
							<tr>
								<th scope="row" rowspan="3">목적사업</th>
								<td class="tex-m">사업범위</td>
								<td>
									<c:out value="${pssrp.trgScope}"/>
								</td>
							</tr>
							<tr>
								<td class="tex-m">전체규모</th>
								<td>
									<c:out value="${pssrp.trgScale}"/>
								</td>
							</tr>
							<tr>
								<td class="tex-m">사업비기준</th>
								<td>
									<c:out value="${pssrp.trgStd}"/>
								</td>
							</tr>
							<tr>
								<th scope="row">신청기간</th>
								<td colspan="2">
									<fmt:formatDate pattern="yyyy.MM.dd.(E)" value="${pssrp.startDate}"/> ~ <fmt:formatDate pattern="yyyy.MM.dd.(E)" value="${pssrp.endDate}"/>
								</td>
							</tr>
							<tr>
								<th scope="row">신청대상</th>
								<td colspan="2">
									<c:out value="${pssrp.reqDest}"/>
								</td>
							</tr>
							<tr>
								<th scope="row">신청분야</th>
								<td colspan="2">
									<c:out value="${pssrp.reqRealm}"/>
									<c:if test="${not empty pssrp.reqRealmFile}">
										<button class="bluebox" style="top: 12px; right: 5px;" onclick="fileDownload('${pssrp.reqRealmFile.fileSeq}'); return false;">사업주제 목록</button>
									</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">신청방법</th>
								<td colspan="2">
									<c:out value="${pssrp.reqMethod}"/>
									<c:if test="${not empty pssrp.reqMethodFile}">
										<button class="whitebox2" style="right: 5px;" onclick="fileDownload('${pssrp.reqMethodFile.fileSeq}'); return false;">신청서 다운로드</button>
									</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">부적격 사업</th>
								<td colspan="2">
									<c:out value="${pssrp.ineligibleBiz}"/>
								</td>
							</tr>
							<tr>
								<th scope="row">사업선정방법</th>
								<td colspan="2">
									<c:out value="${pssrp.bizScale}"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="boardWrite boardgongmo">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="운영규모, 제안분야, 제안자, 소요예산을 알 수 있는 표입니다." >
						<caption>주민참여예산제 지방 보조사업 선정에 대한 사항 규정 알아보기</caption>
						<colgroup>
							<col width="*"/>
						</colgroup>
						<thead>
							<tr>
								<th style="border-right:none;">주민참여예산제 지방보조사업 선정에 대한 사항 규정</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<c:out value="${pssrp.regulation}"/>
								</td>
							</tr>
						</tbody>
						
					</table>
				</div>
				
				<div class="btnC2">
					<button class="question" onclick="etcFileDownload(4); return false;">보조금집행기준</button>
				</div>
				
				<div class="line" style="width:100%; border-top:1px solid #e6e6e6; margin:10px 0 30px 0; "></div>
				
				<div class="pTit2Wrap">
					<p class="pTit2">추진흐름도 및 일정</p>
				</div>
				
				<div class="imgChangeBox">
				<c:if test="${not empty pssrp.imagePcFile}">
					<img src="/file-download/${pssrp.imagePcFile.fileSeq}" style="max-width: 100%;"/>
				</c:if>
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
