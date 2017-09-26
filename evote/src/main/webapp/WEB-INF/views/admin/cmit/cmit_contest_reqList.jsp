<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/eh.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
            	$(document).ready(function(){
 		selectCmit1()
 		var user_stat = '${params.user_stat}';
 		var sub_cmit = '${params.sub_cmit}';
 		var search_condition = '${params.search_condition}';
 		var search_string = '${params.search_string}';
 		if(user_stat != ''){
 			$("#user_stat > option[value="+user_stat+"]").attr("selected", "true");	
 		}
 		if(sub_cmit != ''){
 			$("#subCmit1 > option[value="+sub_cmit+"]").attr("selected", "true");	
 		}
 		if(search_condition != ''){
 			$("#search_condition > option[value="+search_condition+"]").attr("selected", "true");	
 		}
 		if(search_string != ''){
 			$("#search_string").val(search_string);	
 		}
	});
            	
         	/* 분과선택하기  */
     		function selectCmit1(){
     				var list = new Array(); 
     				var cmitStr = '';
     				cmitStr += '<c:forEach var="item" items="${params.subCmit1}" >'+
     					'<option value="'+"${item.cdId}"+'">'+"${item.cdNm}"+'</option>'+'</c:forEach>';
    					$("#subCmit1").append(cmitStr);
         	}
     			
 	  /*//분과선택하기  */
 	
 	  //검색
 	function searchData(){
 		$('#form').attr('action', "/admin/cmit/cmit_contest_reqList");
 		gotoPage(1);
 		 
 	}
 	 
 	function downloadExcel(){
 		$("#form").attr('action', "/admin/cmit/cmit_contest_reqExcel");
 		$("#form").submit();
 	}	  
 	 
 	function reqDetail(reqSeq){
 		location.href = "/admin/cmit/cmit_contest_reqView/"+reqSeq;
 	}
           
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
				<li>주민참여위원 신청서</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<!--leftmenu-->
					<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">
						<c:out value="${cmitPssrp.title}"/>(등록일:<fmt:formatDate value="${cmitPssrp.reg_date}" pattern="yyyy-MM-dd"/>) 
					</h3>
					
					<div class="mainContent">	
						<form method="post" id="form" name="form" action="" class="searchTb">
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">공모기간</th>
											<td colspan="3">
									      <fmt:formatDate pattern="yyyy-MM-dd " value="${cmitPssrp.start_date}"/> 
										~<fmt:formatDate pattern="yyyy-MM-dd " value="${cmitPssrp.end_date}"/>
											</td>
										</tr>
										<tr>
											<th scope="row" class="bln">회원상태</th>
											<td>
												<select id="user_stat" name="user_stat"  style="width:127px;">
													<option value="" selected="selected">전체</option>
													<option value="AVAILABLE">회원</option>
													<option value="WITHDRAWAL">탈퇴</option>
												</select>
											</td>
											<th scope="row" class="bln">희망분과</th>
											<td>
												<select name="subCmit1" id="subCmit1" title="" " style="width:127px;">
													<option value="">전체</option>
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row" class="bln">검색</th>
											<td colspan="3">
												<select id="search_condition"  name="search_condition" title="검색" style="width:127px;">
													<option value="" selected="selected">전체</option>
													<option value="userNm">신청자명</option>
													<option value="phone">휴대폰번호</option>
												</select>
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" id="search_string" class="it wid461" title="" value="" name="search_string"/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:searchData();" class="btn_blue">검색</a>
								</div>
							</fieldset>
							<input type="hidden" name = "ps_seq" id="ps_seq" value="${params.ps_seq}" />
						</form>
					
						<div class="cmBtnBox2">
							<a href="javascript:downloadExcel()" class="btn_gray" >엑셀 다운로드</a>
						</div>
						<div class="boardList comitteeTable">
							<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
								<caption>공지사항</caption>
								<colgroup>
									<col width="9%"/>
									<col width="12%"/>
									<col width="12%"/>
									<col width="25%"/>
									<col width="25%"/>
									<col width="*"/>
								</colgroup>
								<thead>
									<th scope="col">번호</th>
									<th scope="col">신청자</th>
									<th scope="col">회원상태</th>
									<th scope="col">휴대폰번호</th>
									<th scope="col">희망분과</th>
									<th scope="col">신청일</th>
								</thead>
								<tbody>
								<c:forEach var="item" items="${cmitReqList}" varStatus="status" >
									<tr>
										<td>${pagingHelper.startRowDesc-status.index}</td>										
										<td><a href="#" onclick="reqDetail(${item.req_seq})">${item.user_nm} </a></td>
										<td>
											<c:if test="${item.user_stat eq 'AVAILABLE'}">
													회원
											</c:if>
											<c:if test="${item.user_stat eq 'WITHDRAWAL'}">
													탈퇴
											</c:if>
										</td>
										<td>${item.phone }</td>
										<td>
											${item.subCmit1}
									<c:if test="${item.subCmit2 == null}"></c:if><br/>
									<c:if test="${not empty item.subCmit2 }">(${item.subCmit2})</c:if>
										</td>
										<td><fmt:formatDate pattern="yyyy-MM-dd" value="${item.reg_date}" /> </td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						
						<div class="btnboxFr">
							<a href="/admin/cmit/cmit_contest_list" class="btn_reset">목록</a>
						</div>

						<!-- paging -->
						<jsp:include page="/WEB-INF/views/admin/common/paging.jsp">
							<jsp:param name="formId" value="form"/>
							<jsp:param name="action" value="/admin/cmit/cmit_contest_reqList"/>
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
