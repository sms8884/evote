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
		$('.gnb').topmenu({ d1: 1, d2: 4});
		setSelectDate();
		var search_status = '${params.search_status}';
 		var search_year = '${params.search_year}';
 		var search_gubun = '${params.search_gubun}';
 		var search_string = '${params.search_string}';
 		
 		if(search_status != ''){
 			$("#search_status > option[value="+search_status+"]").attr("selected", "true");	
 		}
 		if(search_year != ''){
 			$("#search_year > option[value="+search_year+"]").attr("selected", "true");	
 		}
 		if(search_gubun != ''){
 			$("#search_gubun > option[value="+search_gubun+"]").attr("selected", "true");	
 		}
 		if(search_string != ''){
 			$("#search_string").val(search_string);	
 		}
	});
	
 	//검색
 	function searchData(){
 		$('#form').attr('action', "/admin/vote/vote_list");
 		gotoPage(1);
 	}
 	
 	/* 2012 년부터 현재 년도 +1년까지 셀렉트박스 생성 */
 	function setSelectDate(){
 		var today = new Date();
 		var year = today.getFullYear();
		var standard  = year - 2012;
 		for(var i = 0 ; i<=standard ; i++){
			if( i==0 ){
				var tmp2 =	"<option value='"+(year+1)+"'>"+(year+1)+"</option>";				
				$("#search_year").append(tmp2);
			}
			var tmp = "<option value='"+(year-i)+"'>"+(year-i)+"</option>";
			$("#search_year").append(tmp);
 		}
 	}
 	/*/// 셀렉트 박스생성 END */

	function detail(seq) {
		$("#form").attr("action", "/biz/biz_view/" + seq);
		$("#form").attr("method", "POST");
		$("#form").submit();
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
		<span>사업현황</span>
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
			<h3 class="contentTit">사업현황</h3>
			
			<div class="contents">
				<form id='form' name='form' method="post"  class="searchTb">
					<fieldset id="" class="">
						<table cellpadding="0" cellspacing="0" class="businesT" summary="" >
							<tbody>
								<tr>
									<th scope="row" class="bln">년도</th>
									<td class="businesT_state" width="10px" >
										<select name="search_year" id="search_year" title="년도 선택하기" style="width:120px;">
											<option value="" selected="selected">전체</option>
										</select>
									</td>
									<th scope="row" class="bln">상태</th>
									<td class="businesT_state" >
										<select name="search_status" id = "search_status" title="구분 선택하기" style="width:120px;">
											<option value="" selected="selected">전체</option>
											<option value="실행중">실행중</option>
											<option value="완료">완료</option>
										</select>
									</td>
								</tr>
								<tr >
								<th  scope="row" class="bln" >검색</th>
									<td class="businesT_search" width="500px"  colspan="4">
										<select name="search_gubun" id="search_gubun" title="구분 선택하기" style="width:120px;">
											<option value="" selected="selected">선택</option>
											<option value="TITLE" selected="selected">제목</option>
											<option value="CONTENTS">내용</option>
										</select>
										<input type="text" id="search_string" name="search_string" style="width:160px;" class="it"/>
										<a href="javascript:searchData();" class="btn_blue">검색</a>
									</td>
								</tr>
							</tbody>
						</table>	
					</fieldset>
				</form>
				
				<c:if test="${pagingHelper.totalCnt > 0}">
				<div class="ResultBox">
					<p>총 <fmt:formatNumber value="${pagingHelper.totalCnt}" pattern="#,###"/>건이 검색되었습니다.</p>
				</div>
				</c:if>
				
				<c:if test="${!empty businessList}">
					<div class="business">
						<ul class="businessList">
						
						<c:forEach var="item" items="${businessList}" varStatus="status" >
							<li class="businessList1">
								<div class="left">
									<c:if test="${item.state eq '실행중'}">
										<p class="businessI">실행중</p>
									</c:if>
									<c:if test="${item.state eq '완료'}">
										<p class="businessE">완료</p>
									</c:if>
									
									<a href="#" onclick="detail(${item.biz_seq}); return false;" class="title"><c:out value="${item.biz_name}"/></a>
									<p class="price">소요예산 <fmt:formatNumber pattern="#,###" value="${item.budget}" type="number"/> <span class="priceUnit">천원</span></p>
									<p class="click">
										<a href="#" class="ok on">${item.sympathyCnt}</a>
									</p>
								</div>
								<div class="right">
									<c:if test="${item.fileSeq != null}">
										<p><img src="/file-download/${item.fileSeq}"  style="width: 120px; height: 105px ;"></p>
									</c:if>
									<p></p>
								</div>
								
							</li>
						</c:forEach> 
						
						</ul>
							
					</div>
				</c:if>
				
				<c:if test="${empty businessList}">
					<h3 align="center" style="font-size:large; ;">목록이없습니다</h3>
				</c:if>	
								
				<!-- paging -->
				<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
					<jsp:param name="formId" value="form"/>
					<jsp:param name="action" value="/biz/biz_list"/>
				</jsp:include>	
				<!-- //paging -->	
						
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
