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

<div id="header" class="header2">
	<h1 class="logo" style="background: none;"><a href="#">예시보기</a></h1>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_on.png" alt=""/></a>
</div>
<script language="javascript" type="text/javascript">
//<![CDATA[
	$('.topBt').on('click',function(){
		var mtype = $.cookie('mtype');
		if(mtype == "app") {
			history.back(-1); 
		} else {
			window.close();
		}
	})
//]]>
</script>

<div class="wrap">

	<div class="boardView">
		<p class="viewTop">
			<strong>'내 나이가 어때서'(소외된 경로시설을 찾아가는 어르신 행복학교)</strong>
			<span>사회적약자 배려</span>
		</p>

		<p class="pageView">조회수 1,500</p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">등록자</th>
					<td>김OO</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td>2015-09-04</td>
				</tr>
				<tr>
					<th scope="row">처리상태</th>
					<td>검토 중</td>
				</tr>
				<tr>
					<th scope="row">소요사업비</th>
					<td>23,000천원</td>
				</tr>
				<tr>
					<th scope="row">사업기간</th>
					<td>2016.03 ~ 2016.11</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">사업위치</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							소외된 은평구 경로시설 14곳
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">제안취지</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							○ 고령화가 점차 심화되고 노인 인구가 늘어나고 있는 것에 비해 해당 연령층이 참여할 수 있는 지역 프로그램 부재
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
○ 수혜대상-65세 이상 어르신<br/>
○ 사업내용<br/>
- 집과 가까운 곳에서 어르신들이 참여할 수 있는 프로그램 진행<br/>
- 미술, 음악, 동작, 웃음, 심리치료의 기본이론을 바탕으로 마음나누기, 우리들의 콘서트, 강연 100℃, 쿠킹 클래스 등 어르신들이 함께 참여할 수 있는 프로그램을 매회 약 2시간 활동 진행<br/>
- 약 14곳의 경로시설에서 각 4~5회 진행 예정<br/>
○ 추진주체<br/>
- 4050 길찾기센터(길찾기 활동가 약 15명)<br/> 
○ 협력자(개인, 단체 등)<br/>
- 은평구청, 은평구평생학습관, 역촌동주민센터, 은평 관내 경로시설
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">기대효과</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
○ 마음나누기 프로그램을 통해 어르신 각자의 상황과 성격을 이해하는 길잡이 역할을 함<br/>
○ 다양한 프로그램 참여를 통해 가족과 소통하고 구성원 사이의 친밀감을 유지할 수 있도록 가교 역할을 함<br/>
○ 새로운 학습과 경험을 통해 배우는 즐거움과 성취감을 느끼도록 함<br/>
○ 삶의 의욕을 고취시켜 어르신들이 우울증 등에 빠지지 않도록 하고, 어르신들의 치매예방과 건강에 도움을 줌
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

</div>

</body>
</html>
