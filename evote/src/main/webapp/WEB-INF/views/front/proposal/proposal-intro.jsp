<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 1, d3:0});
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
		<span>소개</span>
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
			<h3 class="contentTit">주민참여예산제 소개</h3>

			<div class="contents paddingnone">
				
				<div class="introBox">
					<p>
						<span class="introbold">주민참여예산제는</span>
						<span>
							예산편성 과정에 주민들을 직접 참여시켜 지역에 필요한<br/>
							예산에 대한 의견을 수렴하고 이를 검토·조정하는 것으로서,<br/>
							행정의 투명성을 확보하고 주민들의 참여와<br/>
							그에 따른 적절한 권한 부여로<br/>
							참여민주주의를 강화하는 제도입니다.
						</span>
					</p>
				</div>

				<div class="introInfoBox">
					<div class="infoBox1">
						<h4 class="infoh4">근거</h4>
						<ol class="infoBox1Ol">
							<li>지방재정법 제39조(지방예산 편성 과정에 주민참여)</li>
							<li>지방재정법 시행령 제46조(지방예산 편성 과정에 주민 참여절차)</li>
							<li>서울특별시 은평구 주민참여 기본조례</li>
							<li>서울특별시 은평구 주민참여위원회 운영조례</li>
						</ol>
					</div>
					<div class="infoBox2">
						<h4 class="infoh4">그간 추진사항</h4>
						<ol class="infoBox2Ol">
							<li>주민참여준비위원회 구성 및 운영: 2010년 8월</li>
							<li>참여예산학교 운영: 2010년 9월~현재</li>
							<li>은평구 주민참여 기본조례 제정(서울시 최초): 2010년 12월</li>
							<li>은평구 주민참여위원회 운영조례 제정: 2011년 8월</li>
							<li>제1기 주민참여위원회 위원 위촉: 2011년 9월</li>
							<li>전국 최초 참여예산주민총회 개최: 2011년 11월</li>
							<li>구정 주요업무계획 시 참여예산위원회 협의 의무화: 2012년 3월</li>
							<li>시 참여예산 총회, 자치구 중 최대 예산(40억 원) 확보: 2012년 7월</li>
							<li>전국 최초 참여예산 모바일투표 도입: 2012년 9월</li>
							<li>전국지자체예산효율화발표대회 대통령상 수상: 2012년 12월</li>
							<li>관급공사 시행 시 주민참여 의무화 실시: 2013년 1월</li>
							<li>국가재정연구포럼, 주민참여예산제 우수사례 소개: 2013년 4월</li>
							<li>2013대한민국미래경영대상 지방자치부문 대상: 2013년 5월</li>
							<li>주민참여예산백서 발간: 2013년 7월</li>
							<li>UN 공공행정 부문 본선 진출: 2014년 2월</li>
							<li>은평형란츠게마인데 청소년총회 개최: 2015년 10월</li>
						</ol>
					</div>
					
					<div class="infoBox3">
						<h4 class="infoh4">예산규모</h4>
						<span>(단위:천원)</span>
						
						<form method="post" action="" class="searchTb infotable">
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="infoCostTable" summary="예산규모">
									<caption>시,구,연도별 예산 규모를 알 수 있는 표입니다.</caption>
									<colgroup>
										<col width="*"/>
										<col width="151"/>
										<col width="151"/>
										<col width="151"/>
										<col width="151"/>
									</colgroup>
									<thead>
										<tr>
											<th scope="row"  rowspan="2">연도</th>	
											<th scope="row" colspan="2">시</th>	
											<th scope="row" colspan="2">구</th>	
										</tr>
										<tr>
											<th scope="row">사업수</th>	
											<th scope="row">금액(천원)</th>	
											<th scope="row">사업수</th>	
											<th scope="row">금액(천원)</th>	
										</tr>
									</thead>
									<tbody>
										<tr>
											<th scope="col" class="bln">2012</th>
											<td>-</td>
											<td>-</td>
											<td>19</td>
											<td>818,860</td>
										</tr>
										<tr>
											<th scope="col" class="bln">2013</th>
											<td>6</td>
											<td>4,072,000</td>
											<td>17</td>
											<td>1,088,800</td>
										</tr>
										<tr>
											<th scope="col" class="bln">2014</th>
											<td>7</td>
											<td>2,370,000</td>
											<td>23</td>
											<td>1,076,400</td>
										</tr>
										<tr>
											<th scope="col" class="bln">2015</th>
											<td>9</td>
											<td>1,263,000</td>
											<td>22</td>
											<td>989,800</td>
										</tr>
										<tr>
											<th scope="col" class="bln">2016</th>
											<td>12</td>
											<td>1,350,000</td>
											<td>51</td>
											<td>1,201,107</td>
										</tr>
									</tbody>
								</table>
							</fieldset>
						</form>
	
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