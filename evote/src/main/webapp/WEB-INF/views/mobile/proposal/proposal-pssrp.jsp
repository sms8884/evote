<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

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
				<p class="pTit2"><c:out value="${pssrp.title}"/></p>
				<a href="/proposal/sample" target="_blank" class="btn">예시보기</a>
			</div>
			<div class="boardWrite">
				<table cellpadding="0" cellspacing="0" class="infoCostTable02" summary="신청기간, 신청대상, 신청분야, 신청방법, 사업선정방법을 알 수 있는 표입니다." >
					<colgroup>
						<col width="80"/>
						<col width="*"/>
					</colgroup>
					<thead>
						<tr>
							<th colspan="3" class="b_none">추진개요</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">운영규모</th>
							<td>
								<c:out value="${pssrp.opScale}"/>
							</td>
						</tr>
						<tr>
							<th scope="row" rowspan="3">일반사업</th>
							<td>
								<p class="tex-m">사업범위</p>
								<c:out value="${pssrp.gnrScope}"/>
							</td>
						</tr>
						<tr>
							<td>
								<p class="tex-m">전체규모</p>
								<c:out value="${pssrp.gnrScale}"/>
							</td>
						</tr>
						<tr>
							<td>
								<p class="tex-m">사업비기준</p>
								<c:out value="${pssrp.gnrStd}"/>
							</td>
						</tr>
						<tr>
							<th scope="row" rowspan="3">목적사업</th>
							<td>
								<p class="tex-m">사업범위</p>
								<c:out value="${pssrp.trgScope}"/>
							</td>
						</tr>
						<tr>
							<td>
								<p class="tex-m">전체규모</p>
								<c:out value="${pssrp.trgScale}"/>
							</td>
						</tr>
						<tr>
							<td>
								<p class="tex-m">사업비기준</p>
								<c:out value="${pssrp.trgStd}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">신청기간</th>
							<td>
								<fmt:formatDate pattern="yyyy.MM.dd.(E)" value="${pssrp.startDate}"/> ~ <fmt:formatDate pattern="yyyy.MM.dd.(E)" value="${pssrp.endDate}"/>
							</td>
						</tr>
						<tr>
							<th scope="row">신청대상</th>
							<td>
								<c:out value="${pssrp.reqDest}"/>
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2" class="b_none">
								<div class="top">
									신청분야
									<c:if test="${not empty pssrp.reqRealmFile}">
										<a href="#">사업주제목록</a>
									</c:if>
								</div>
							</th>
						</tr>
						<tr>
							<td  colspan="2" class="b_none">
								<c:out value="${pssrp.reqRealm}"/>
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2" class="b_none">
								<div class="top">
									신청방법
									<c:if test="${not empty pssrp.reqMethodFile}">
										<a href="#">신청서다운로드</a>
									</c:if>
								</div>
							</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								<p><c:out value="${pssrp.reqMethod}"/></p>
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2" class="b_none">부적격 사업</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								<c:out value="${pssrp.ineligibleBiz}"/>
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2" class="b_none">사업선정방법</th>
						</tr>
						<tr>
							<td colspan="2" class="b_none">
								<c:out value="${pssrp.bizScale}"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="boardWrite">
				<table cellpadding="0" cellspacing="0" class="infoCostTable02" summary="운영규모, 제안분야, 제안자, 소요예산을 알 수 있는 표입니다." >
					<caption>주민참여예산제 지방 보조사업 선정에 대한 사항 규정 알아보기</caption>
					<colgroup>
						<col width="*"/>
					</colgroup>
					<thead>
						<tr>
							<th class="b_none">주민참여예산제 지방보조사업 선정에 대한 사항 규정</th>
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
			
			<div class="btnC">
				<a href="#" class="question"><span>보조금집행기준</span></a>
			</div>
			<div class="pTit2Wrap">
				<p class="pTit2">추진흐름도 및 일정</p>
			</div>
			<div class="imgChangeBox">
			<c:if test="${not empty pssrp.imageMobileFile}">
				<img src="/file-download/${pssrp.imageMobileFile.fileSeq}" style="max-width: 100%;"/>
			</c:if>
			</div>

			<div class="btnC">
				<a href="" class="btn_blue"><span class="my">내 제안 등록하기</span></a>
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