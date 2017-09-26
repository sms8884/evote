<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.tabTitleBox').find('>div>a').on('click',function(){
			$('.subTab1').hide()
			$('.subTab2').hide()
			$('.subTab'+($(this).parent().index()+1)).show();
			$('.tabTitleBox').find('>div').removeClass('tabon')
			$(this).parent().addClass('tabon');
			return false;
		})
		$('.subTab1').show();
		$('.subTab2').hide();
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
		<span>주민참여예산제</span>
		<span>운영계획</span>
	</div>
	<div class="containerWrap">
		<div class="contents">
				<div class="contentSub1">
					<table cellpadding="0" cellspacing="0" class="infoCostTable02" summary="" >
						<colgroup>
							<col width="20%"/>
							<col width="*"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="row">단계</th>
								<th scope="row">주요내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row" class="bln">평가환류</th>
								<td>
									<dl>
										<dt><span class="month">2월</span>평가보고회 개최</dt>
										<dd>
											<ul>
												<li>전년도 운영성과 보고 및 운영 문제점 토론 등</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<th scope="row" class="bln" rowspan="2">준비</th>
								<td>
									<dl>
										<dt><span class="month">2~4월</span>주민참여위원 모집·교육·위촉</dt>
										<dd>
											<ul>
												<li>공개모집:  2월 중</li>
												<li>선정방법:  제출서류 심사</li>
												<li>교육실시:  3~4월(찾아가는 참여예산학교)</li>
												<li>위원위촉:  20명 ※ 위촉:  4월</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">3~4월</span>찾아가는 참여예산학교 운영</dt>
										<dd>
											<ul>
												<li>대 상:  리더교육 수료자 및 희망주민 등</li>
												<li class="nobg">
													<dl>
														<dt>교육내용</dt>
														<dd>- 회의진행 기법, 지역탐색(동네한바퀴)</dd>
														<dd>- 제안사업 작성기법, 회의진행 실습 등</dd>
													</dl>
												</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<th scope="row" class="bln" rowspan="3">주민의견 <br/>수렴</th>
								<td>
									<dl>
										<dt><span class="month">3~7월</span>지역회의 상시운영(주민제안사업 발굴)</dt>
										<dd>
											<ul>
												<li>지역문제 해결을 위한 주민들의 다양한 의견 수렴</li>
												<li>주민제안사업 발굴·작성 및 토론 등</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">4~7월</span>市 참여예산제안사업 신청 및 참가</dt>
										<dd>
											<ul>
												<li>제안사업 발굴·신청 등</li>
												<li>참여예산 한마당 참가</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">상시</span>분과위원회 운영</dt>
										<dd>
											<ul>
												<li>분과위별 소관부서 사업 검토 등</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<th scope="row" class="bln" rowspan="4">제안 사업<br/>검토 및 선정</th>
								<td>
									<dl>
										<dt><span class="month">8월</span>주민제안사업 검토</dt>
										<dd>
											<ul>
												<li>제안사업 소관부서 검토</li>
												<li>제안사업 구체화를 위한 아카데미 개최</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">9월</span>주민투표 실시</dt>
										<dd>
											<ul>
												<li>동 지역회의 및 주민참여시민위원회 1차 심사를 통하여 주민투표 대상 사업 선정</li>
												<li>동 지역사업 현장투표</li>
												<li>구 정책사업 모바일·인터넷투표</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">9월</span>동 주민총회 개최</dt>
										<dd>
											<ul>
												<li>동 주민총회(동 지역사업) 개최 선정</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">9월</span>참여예산한마당 주민총회</dt>
										<dd>
											<ul>
												<li>참여예산위원 및 지역회의별 선거인단이 참석하는 총회 개최, 투표를 통한 사업 우선순위 결정</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<th scope="row" class="bln" rowspan="3">예산편성 제출</th>
								<td>
									<dl>
										<dt><span class="month">9월</span>예산편성 협의</dt>
										<dd>
											<ul>
												<li>제안자, 추진부서, 분과위원 예산편성을 위한 협의</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">10월</span>2017 예산편성 관련 분과위 집중 운영</dt>
										<dd>
											<ul>
												<li class="nobg">
													<dl>
														<dt>분과위별 소관부서 사업 및 예산안 검토·조정</dt>
														<dd>- 사업 설명 및 예산안에 대한 분과위 의견 청취</dd>
													</dl>
												</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
							<tr>
								<td>
									<dl>
										<dt><span class="month">11월</span>2017 예산안 제출</dt>
										<dd>
											<ul>
												<li>은평구→은평구의회</li>
											</ul>
										</dd>
									</dl>
								</td>
							</tr>
						</tbody>
					</table>
				</div><!--contentSub1-->
				<div class="contentSub2">
					<div class="tabTitleBox">
						<div class="tabTitle1 tabon"><a href="#">區 정책사업</a></div>
						<div class="tabTitle2"><a href="#">洞 지역사업</a></div>
					</div>
					<div class="subTab1">
						<img src="${siteImgPath}/sub1/tab1box2.gif" alt=""/>
					</div><!--subtab1-->
					<div class="subTab2">
						<img src="${siteImgPath}/sub1/tab1box1.gif"  alt=""/>
					</div><!--subtab2-->
				</div><!--contentSub2-->
			</div>
		</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->

</div>

</body>
</html>
