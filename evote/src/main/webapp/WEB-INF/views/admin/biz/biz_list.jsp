<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">
//<![CDATA[
 	$(document).ready(function(){
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
 	
 	
 	

//]]>
</script>
</head>
<body>
<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp"/>
	<!-- //header -->
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li>사업현황</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
		<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">사업현황</h3>	
	
					<div class="mainContent">
						<form id="form" name="form" method="post" class="searchTb">
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="businesT" summary="" >
									<tbody>
										<tr>
											<th scope="row" class="bln">년도</th>
											<td class="businesT_state" width="10px" >
												<select name="search_year" id = "search_year" title="년도 선택하기" style="width:120px;">
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
													<option value="TITLE" >제목</option>
													<option value="CONTENTS">내용</option>
												</select>
												<input type="text" id = "search_string" name="search_string" style="width:160px;" class="it"/>
												<a href="javascript:searchData();" class="btn_blue">검색</a>
											</td>
										</tr>
									</tbody>
								</table>	
							</fieldset>
						</form>
						<div class="ResultBox">
								<p>총 <fmt:formatNumber value="${pagingHelper.totalCnt}" pattern="#,###"/>건이 검색되었습니다.</p>
						</div>
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
										<a href="/admin/biz/biz_view/${item.biz_seq}"   class="title"><c:out value="${item.biz_name}"/></a>
										<p class="price">소요예산 <fmt:formatNumber pattern="#,###" value="${item.budget}" type="number"/> <span class="priceUnit">천원</span></p>
										<p class="click">
											<a href="#" class="ok on">${item.sympathyCnt}</a>
										</p>
									</div>
									<div class="right">
											<c:if test="${item.fileSeq != null}">
										<p><img src="/file-download/${item.fileSeq}"  style="width: 120px; height: 105px ;"></p>
										</c:if>
									</div>
									
								</li>
								</c:forEach> 
							</ul>
								
						</div>
						</c:if>
										<c:if test="${empty businessList}">
										<h3 align="center" style="font-size:large; ;">목록이없습니다</h3>
										</c:if>	
								
							
						<div class="btnbox_BL1">
							<a href="/admin/biz/biz_writeForm">실행사업 등록하기</a>
						</div>
						
						<!-- paging -->
						<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
							<jsp:param name="formId" value="form"/>
							<jsp:param name="action" value="/admin/biz/biz_list"/>
						</jsp:include>	
						<!-- //paging -->	
					</div>
				</div>
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
<!-- //footer -->
</body>
</html>
