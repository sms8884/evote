<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 2, d3:0});
		$('.subTab1').show();
		$('.subTab2').hide();

		$('.tabTitle1').on('click',function(){
			if($(this).hasClass('tabon')== false){
				$('.tabTitle2').removeClass('tabon');
				$(this).addClass('tabon');
				$('.subTab1').show();
				$('.subTab2').hide();
			}
		});
		
		$('.tabTitle2').on('click',function(){
			if($(this).hasClass('tabon')== false){
				$('.tabTitle1').removeClass('tabon');
				$(this).addClass('tabon');
				$('.subTab2').show();
				$('.subTab1').hide();
			}
		});
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
		<span>주민참여예산제</span>
		<span>운영계획</span>
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
			<h3 class="contentTit">주민참여예산제 운영계획</h3>

			<div class="contents">
				
				<div class="contentSub1">
					<h4 class="info2h4">2016년 주민참여예산제 운영계획</h4>
					
					<form method="post" action="" class="searchTb infotable2">
						<fieldset id="" class="">
							<table cellpadding="0" cellspacing="0" class="" summary="" >
								<caption></caption>
								<colgroup>
									<col width="119px"/>
									<col width="119px"/>
									<col width="*"/>
								</colgroup>
								<thead>
									<tr>
										<th scope="row">단계</th>
										<th scope="row">일정</th>
										<th scope="row">주요내용</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th scope="row" class="bln">평가환류</th>
										<td>2월</td>
										<td>
											<dl>
												<dt>평가보고회 개최</dt>
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
										<td>2~4월</td>
										<td>
											<dl>
												<dt>주민참여위원 모집·교육·위촉</dt>
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
										<td>3~4월</td>
										<td>
											<dl>
												<dt>찾아가는 참여예산학교 운영</dt>
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
										<th scope="row" class="bln" rowspan="3">주민의견 수렴</th>
										<td>3~7월</td>
										<td>
											<dl>
												<dt>지역회의 상시운영(주민제안사업 발굴)</dt>
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
										<td>4~7월</td>
										<td>
											<dl>
												<dt>市 참여예산제안사업 신청 및 참가</dt>
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
										<td>상시</td>
										<td>
											<dl>
												<dt>분과위원회 운영</dt>
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
										<td>8월</td>
										<td>
											<dl>
												<dt>주민제안사업 검토</dt>
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
										<td rowspan="3">9월</td>
										<td>
											<dl>
												<dt>주민투표 실시</dt>
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
												<dt>동 주민총회 개최</dt>
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
												<dt>참여예산한마당 주민총회</dt>
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
										<td>9월</td>
										<td>
											<dl>
												<dt>예산편성 협의</dt>
												<dd>
													<ul>
														<li>제안자, 추진부서, 분과위원 예산편성을 위한 협의</li>
													</ul>
												</dd>
											</dl>
										</td>
									</tr>
									<tr>
										<td>10월</td>
										<td>
											<dl>
												<dt>2017 예산편성 관련 분과위 집중 운영</dt>
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
										<td>11월</td>
										<td>
											<dl>
												<dt>2017 예산안 제출</dt>
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
						</fieldset>
					</form>

				</div><!--contentSub1-->


				<div class="contentSub2">
					<div class="tabTitleBox">
						<div class="tabTitle1 tabon"></div>
						<div class="tabTitle2"></div>
					</div>
					<div class="subTab1">
						<div class="tab1box1">
							<div class="orboxWh box1step1">
								추진시기
							</div>
							<div class="whboxOr box1step2">
								주민의견 수렴 단계
							</div>
							<div class="whboxOr box1step3">
								위원회 심의 단계
							</div>
							<div class="whboxOr box1step4">
								예산안 반영 단계
							</div>
						</div>
						<div class="tab1box2" >
							<div class="orboxWh box2step1">
								區 정책사업
							</div>
							<div class="whboxOr box2step2">
								<p class="titlebold">주민참여제안사업 신청·분류</p>
								<p class="titlenormal">(주민참여예산위원회)</p>
							</div>
							<div class="whboxOr box2step3">
								<p class="titlebold">사업 구체화 및 타당성 검토</p>
								<p class="titlenormal">(제안자, 분과위원, 사업부서 검토)</p>
							</div>
							<div class="whboxOr box2step4">
								<p class="titlebold">심사위원 구성 및 사전 심사</p>
								<p class="titlenormal">(15명 이내, 주민참여위원, 지역위원장, 공무원)</p>
								<ul class="contentsUlList">
									<li>제안자 설명 및 부서검토, 자료 검토 등 심사</li>
									<li>주민투표대상사업 선정</li>
									<li>주민투표 실시(주민) 전자투표+현장투표</li>
								</ul>
							</div>
							<div class="whboxOr box2step5">
								<p class="titlebold">참여예산주민총회<span class="titlenormal">(한마당총회, 청소년총회)</span></p>
								<p class="titlebold">참여예산사업 확정<span class="titlenormal">(16억 원 범위 내)</span></p>
							</div>
							<div class="whboxOr box2step6">
								<p class="titlebold">2017 예산안에 참여예산사업 반영</p>
							</div>
							<div class="whboxOr box2step7">
								<p class="titlebold">2017 예산안 구의회 제출 및 심의 확정</p>
							</div>							
						</div>
					</div><!--subtab1-->

					<div class="subTab2">
						<div class="tab2box1">
							<div class="orboxWh box1step1">
								추진시기
							</div>
							<div class="whboxOr box1step2">
								주민의견 수렴 단계
							</div>
							<div class="whboxOr box1step3">
								위원회 심의 단계
							</div>
							<div class="whboxOr box1step4">
								예산안 반영 단계
							</div>
						</div>
						<div class="tab2box2">
							<div class="orboxWh box2step1">
								洞 지역사업
							</div>
							<div class="whboxOr box2step2">
								<p class="titlebold">동 지역사업 제안·발굴</p>
								<p class="titlenormal">(洞 지역회의)</p>
							</div>
							<div class="whboxOr box2step3">
								<p class="titlebold">사업 구체화 및 타당성 검토</p>
								<p class="titlenormal">(사업부서)</p>
							</div>
							<div class="whboxOr box2step4">
								<p class="titlebold">지역사업 선정 제출</p>
								<p class="titlenormal">(洞 지역회의, 동별 실링액 내에서)</p>
							</div>
							<div class="whboxOr box2step5">
								<p class="titlebold">참여예산주민총회<span class="titlenormal">(한마당총회, 청소년총회)</span></p>
									<p class="titlebold">참여예산사업 확정<span class="titlenormal">(16억 원 범위 내)</span></p>
									
									<ul class="contentsUlList">
										<li>區 정책사업 순위 결정 및 참여예산사업 확정 (청소년사업  현장투표결과 포함 확정)</li>
										<li>洞  지역사업 6억 원 범위 내 확정</li>
									</ul>
							</div>
							<div class="whboxOr box2step6">
								<p class="titlebold">2017 예산안에 참여예산사업 반영</p>
							</div>
							<div class="whboxOr box2step7">
								<p class="titlebold">2017 예산안 구의회 제출 및 심의 확정</p>
							</div>							

						</div>
					</div><!--subtab2-->
				</div><!--contentSub2-->

				

			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
